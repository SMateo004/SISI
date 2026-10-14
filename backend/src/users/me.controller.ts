import { Body, Controller, Get, Inject, Patch, Post, Put } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiForbiddenResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { type AuthenticatedUser, CurrentUser } from '../auth/decorators/auth.decorators';
import { ApiErrorBody } from '../common/errors/api-error';
import type { AppConfigService } from '../config/app-config';
import { ConfirmUploadDto, PresignedUploadDto, UploadRequestDto } from '../storage/dto/upload.dto';
import { StorageService } from '../storage/storage.service';
import {
  assertUploadAllowed,
  assertUploadedObject,
  newObjectKey,
  STORAGE_PREFIX,
  type AllowedImageType,
} from '../storage/upload-policy';
import { UpdateMeDto } from './dto/update-me.dto';
import { UserDto } from './dto/user.dto';
import { UserPresenter } from './user.presenter';
import { UsersService } from './users.service';

@ApiTags('me')
@ApiBearerAuth()
@ApiUnauthorizedResponse({ type: ApiErrorBody, description: 'UNAUTHENTICATED o TOKEN_INVALID' })
@Controller('me')
export class MeController {
  constructor(
    private readonly users: UsersService,
    private readonly presenter: UserPresenter,
    private readonly storage: StorageService,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {}

  @Get()
  @ApiOperation({ summary: 'Mi cuenta' })
  @ApiOkResponse({ type: UserDto })
  async me(@CurrentUser() current: AuthenticatedUser): Promise<UserDto> {
    return this.presenter.present(await this.users.getById(current.id));
  }

  @Patch()
  @ApiOperation({ summary: 'Actualiza mi nombre (la foto se cambia con /me/photo)' })
  @ApiOkResponse({ type: UserDto })
  @ApiBadRequestResponse({ type: ApiErrorBody, description: 'VALIDATION_ERROR' })
  async update(
    @CurrentUser() current: AuthenticatedUser,
    @Body() dto: UpdateMeDto,
  ): Promise<UserDto> {
    const user = await this.users.updateProfile(current.id, { name: dto.name });
    return this.presenter.present(user);
  }

  @Post('photo/upload-url')
  @ApiOperation({
    summary: 'URL prefirmada para subir mi foto de perfil',
    description:
      'Válida 5 minutos. Hacer PUT con el archivo y los headers indicados; luego confirmar con PUT /me/photo.',
  })
  @ApiCreatedResponse({ type: PresignedUploadDto })
  @ApiBadRequestResponse({
    type: ApiErrorBody,
    description: 'UPLOAD_TYPE_NOT_ALLOWED o UPLOAD_TOO_LARGE',
  })
  async photoUploadUrl(
    @CurrentUser() current: AuthenticatedUser,
    @Body() dto: UploadRequestDto,
  ): Promise<PresignedUploadDto> {
    assertUploadAllowed(dto.contentType, dto.sizeBytes, this.maxBytes());
    const key = newObjectKey(
      STORAGE_PREFIX.avatars(current.id),
      dto.contentType as AllowedImageType,
    );
    const upload = await this.storage.presignUpload({
      key,
      contentType: dto.contentType,
      sizeBytes: dto.sizeBytes,
      expiresInSec: this.config.get('UPLOAD_URL_TTL_SEC', { infer: true }),
    });
    const { url, ...rest } = upload;
    return { key, uploadUrl: url, ...rest };
  }

  @Put('photo')
  @ApiOperation({ summary: 'Confirma la foto subida y la deja como foto de perfil' })
  @ApiOkResponse({ type: UserDto })
  @ApiBadRequestResponse({ type: ApiErrorBody, description: 'UPLOAD_NOT_FOUND' })
  @ApiForbiddenResponse({ type: ApiErrorBody, description: 'UPLOAD_KEY_FORBIDDEN' })
  async confirmPhoto(
    @CurrentUser() current: AuthenticatedUser,
    @Body() dto: ConfirmUploadDto,
  ): Promise<UserDto> {
    assertUploadedObject(
      dto.key,
      STORAGE_PREFIX.avatars(current.id),
      dto.key.startsWith(STORAGE_PREFIX.avatars(current.id))
        ? await this.storage.head(dto.key)
        : null,
      this.maxBytes(),
    );
    const previous = (await this.users.getById(current.id)).photoKey;
    const user = await this.users.updateProfile(current.id, { photoKey: dto.key });
    if (previous && previous !== dto.key) await this.storage.delete(previous);
    return this.presenter.present(user);
  }

  private maxBytes(): number {
    return this.config.get('UPLOAD_MAX_BYTES', { infer: true });
  }
}
