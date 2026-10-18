import {
  Body,
  Controller,
  Headers,
  HttpCode,
  HttpStatus,
  Inject,
  Post,
  Req,
  Res,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import {
  ApiHeader,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiOperation,
  ApiServiceUnavailableResponse,
  ApiTags,
  ApiTooManyRequestsResponse,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import type { Request, Response } from 'express';
import { ApiError, ApiErrorBody } from '../common/errors/api-error';
import { RateLimit } from '../common/rate-limit/rate-limit.decorator';
import type { AppConfigService } from '../config/app-config';
import { UserPresenter } from '../users/user.presenter';
import { UsersService } from '../users/users.service';
import {
  ADMIN_CSRF_HEADER,
  ADMIN_REFRESH_COOKIE,
  adminCookieOptions,
  readCookie,
} from './admin-cookie';
import { Public } from './decorators/auth.decorators';
import { AdminLoginService } from './admin-login.service';
import { AdminLoginDto, AdminSessionDto } from './dto/auth.dto';
import { type IssuedTokens, type TokenSubject, TokenService } from './tokens/token.service';

const noSession = (): ApiError =>
  new ApiError(
    HttpStatus.UNAUTHORIZED,
    'SESSION_INVALID',
    'Tu sesión del panel terminó. Vuelve a ingresar.',
  );

/**
 * Sesión del panel admin (ADR-0040). El refresh viaja solo en una cookie httpOnly; el token
 * de acceso (10 min) lo guarda el panel en memoria. Se ingresa con el usuario del panel y el
 * código de una app autenticadora, sin teléfono (ADR-0055).
 */
@ApiTags('auth')
@Public()
@ApiTooManyRequestsResponse({ type: ApiErrorBody, description: 'Límite de intentos (Retry-After)' })
@Controller('auth/admin')
export class AdminAuthController {
  private readonly cookiePath: string;

  constructor(
    private readonly adminLogin: AdminLoginService,
    private readonly tokens: TokenService,
    private readonly users: UsersService,
    private readonly presenter: UserPresenter,
    @Inject(ConfigService) config: AppConfigService,
  ) {
    this.cookiePath = config.get('ADMIN_COOKIE_PATH', { infer: true });
  }

  @Post('login')
  @HttpCode(HttpStatus.OK)
  @RateLimit('otpVerifyIp')
  @ApiOperation({
    summary: 'Ingresa al panel con el usuario y el código de la app autenticadora',
    description:
      'Una sola cuenta, sin teléfono (ADR-0055). Cada código sirve una vez. El refresh queda en la cookie httpOnly `sisi_admin_rt`.',
  })
  @ApiOkResponse({ type: AdminSessionDto })
  @ApiUnauthorizedResponse({
    type: ApiErrorBody,
    description: 'ADMIN_LOGIN_INVALID o ADMIN_CODE_USED',
  })
  @ApiServiceUnavailableResponse({ type: ApiErrorBody, description: 'ADMIN_LOGIN_NOT_CONFIGURED' })
  async login(
    @Body() dto: AdminLoginDto,
    @Res({ passthrough: true }) res: Response,
  ): Promise<AdminSessionDto> {
    const subject = await this.adminLogin.login(dto.username, dto.code);
    const tokens = await this.tokens.issue(subject, 'admin');
    return this.respond(res, tokens, subject);
  }

  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  @RateLimit('authIp')
  @ApiHeader({ name: 'X-SISI-Admin', required: true, description: 'Siempre "1" (CSRF)' })
  @ApiOperation({
    summary: 'Renueva el token de acceso del panel con la cookie',
    description: 'Rota el refresh. La sesión no se extiende más allá de 8 h desde el login.',
  })
  @ApiOkResponse({ type: AdminSessionDto })
  @ApiUnauthorizedResponse({ type: ApiErrorBody, description: 'SESSION_*' })
  async refresh(
    @Req() req: Request,
    @Headers(ADMIN_CSRF_HEADER) csrf: string | undefined,
    @Res({ passthrough: true }) res: Response,
  ): Promise<AdminSessionDto> {
    requireCsrfHeader(csrf);
    const token = readCookie(req.headers.cookie, ADMIN_REFRESH_COOKIE);
    if (!token) throw noSession();
    try {
      const { subject, ...tokens } = await this.tokens.rotate(token, 'admin');
      return await this.respond(res, tokens, subject);
    } catch (error) {
      res.clearCookie(ADMIN_REFRESH_COOKIE, adminCookieOptions(this.cookiePath, 0));
      throw error;
    }
  }

  @Post('logout')
  @HttpCode(HttpStatus.NO_CONTENT)
  @RateLimit('authIp')
  @ApiHeader({ name: 'X-SISI-Admin', required: true, description: 'Siempre "1" (CSRF)' })
  @ApiOperation({ summary: 'Cierra la sesión del panel (revoca el refresh y borra la cookie)' })
  @ApiNoContentResponse()
  async logout(
    @Req() req: Request,
    @Headers(ADMIN_CSRF_HEADER) csrf: string | undefined,
    @Res({ passthrough: true }) res: Response,
  ): Promise<void> {
    requireCsrfHeader(csrf);
    const token = readCookie(req.headers.cookie, ADMIN_REFRESH_COOKIE);
    if (token) await this.tokens.revoke(token);
    res.clearCookie(ADMIN_REFRESH_COOKIE, adminCookieOptions(this.cookiePath, 0));
  }

  private async respond(
    res: Response,
    tokens: IssuedTokens,
    subject: TokenSubject,
  ): Promise<AdminSessionDto> {
    res.cookie(
      ADMIN_REFRESH_COOKIE,
      tokens.refreshToken,
      adminCookieOptions(this.cookiePath, tokens.refreshExpiresIn),
    );
    res.setHeader('Cache-Control', 'no-store');
    const user = await this.users.findById(subject.id);
    if (!user) throw noSession();
    return {
      accessToken: tokens.accessToken,
      tokenType: 'Bearer',
      expiresIn: tokens.expiresIn,
      sessionExpiresAt: new Date(Date.now() + tokens.refreshExpiresIn * 1000).toISOString(),
      user: await this.presenter.present(user),
    };
  }
}

function requireCsrfHeader(value: string | undefined): void {
  if (value !== '1') {
    throw new ApiError(
      HttpStatus.FORBIDDEN,
      'CSRF_HEADER_REQUIRED',
      'Falta el header X-SISI-Admin.',
    );
  }
}
