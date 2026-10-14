import { Body, Controller, HttpCode, HttpStatus, Post } from '@nestjs/common';
import {
  ApiAcceptedResponse,
  ApiBadRequestResponse,
  ApiNoContentResponse,
  ApiOkResponse,
  ApiOperation,
  ApiServiceUnavailableResponse,
  ApiTags,
  ApiTooManyRequestsResponse,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { ApiErrorBody } from '../common/errors/api-error';
import { RateLimit } from '../common/rate-limit/rate-limit.decorator';
import { UserPresenter } from '../users/user.presenter';
import { UsersService } from '../users/users.service';
import { Public } from './decorators/auth.decorators';
import {
  LoginResponseDto,
  OtpRequestedDto,
  RefreshTokenDto,
  RequestOtpDto,
  TokensDto,
  VerifyOtpDto,
} from './dto/auth.dto';
import { OtpService } from './otp/otp.service';
import { TokenService } from './tokens/token.service';

@ApiTags('auth')
@Public()
@ApiTooManyRequestsResponse({ type: ApiErrorBody, description: 'Límite de intentos (Retry-After)' })
@Controller('auth')
export class AuthController {
  constructor(
    private readonly otp: OtpService,
    private readonly tokens: TokenService,
    private readonly users: UsersService,
    private readonly presenter: UserPresenter,
  ) {}

  @Post('otp/request')
  @HttpCode(HttpStatus.ACCEPTED)
  @RateLimit('otpRequestIp')
  @ApiOperation({
    summary: 'Envía un código de 6 dígitos al celular',
    description:
      'La respuesta es la misma tenga o no cuenta el número. Límites: 1 código cada 60 s, 5 por hora y 10 por día por número; 20 por hora por IP.',
  })
  @ApiAcceptedResponse({ type: OtpRequestedDto })
  @ApiBadRequestResponse({
    type: ApiErrorBody,
    description: 'PHONE_INVALID, PHONE_NOT_MOBILE o PHONE_COUNTRY_NOT_ALLOWED',
  })
  @ApiServiceUnavailableResponse({ type: ApiErrorBody, description: 'OTP_SEND_FAILED' })
  requestOtp(@Body() dto: RequestOtpDto): Promise<OtpRequestedDto> {
    return this.otp.request(dto.phone);
  }

  @Post('otp/verify')
  @HttpCode(HttpStatus.OK)
  @RateLimit('otpVerifyIp')
  @ApiOperation({
    summary: 'Valida el código e inicia sesión',
    description: 'Crea la cuenta si el número no tenía una (modo employer, R1.2).',
  })
  @ApiOkResponse({ type: LoginResponseDto })
  @ApiBadRequestResponse({ type: ApiErrorBody, description: 'OTP_INVALID u OTP_TOO_MANY_ATTEMPTS' })
  async verifyOtp(@Body() dto: VerifyOtpDto): Promise<LoginResponseDto> {
    const phone = await this.otp.verify(dto.phone, dto.code);
    const { user, isNewUser } = await this.users.findOrCreateVerified(phone);
    const tokens = await this.tokens.issue({ id: user.id, role: user.role });
    return { ...tokens, user: await this.presenter.present(user), isNewUser };
  }

  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  @RateLimit('authIp')
  @ApiOperation({
    summary: 'Renueva la sesión (rota el refresh token)',
    description:
      'Cada refresh se usa una sola vez. Reutilizar uno ya usado revoca todas las sesiones de esa familia.',
  })
  @ApiOkResponse({ type: TokensDto })
  @ApiUnauthorizedResponse({
    type: ApiErrorBody,
    description: 'SESSION_INVALID, SESSION_REUSED, SESSION_REVOKED o SESSION_EXPIRED',
  })
  async refresh(@Body() dto: RefreshTokenDto): Promise<TokensDto> {
    const { subject: _subject, ...tokens } = await this.tokens.rotate(dto.refreshToken);
    return tokens;
  }

  @Post('logout')
  @HttpCode(HttpStatus.NO_CONTENT)
  @RateLimit('authIp')
  @ApiOperation({ summary: 'Cierra la sesión (revoca la familia del refresh token)' })
  @ApiNoContentResponse()
  async logout(@Body() dto: RefreshTokenDto): Promise<void> {
    await this.tokens.revoke(dto.refreshToken);
  }
}
