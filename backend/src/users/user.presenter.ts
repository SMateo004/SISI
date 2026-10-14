import { Inject, Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import type { AppConfigService } from '../config/app-config';
import type { User } from '../generated/prisma/client';
import { StorageService } from '../storage/storage.service';
import { toUserDto, type UserDto } from './dto/user.dto';

/** Arma el UserDto con la URL firmada (temporal) de la foto de perfil. */
@Injectable()
export class UserPresenter {
  constructor(
    private readonly storage: StorageService,
    @Inject(ConfigService) private readonly config: AppConfigService,
  ) {}

  async present(user: User): Promise<UserDto> {
    const photoUrl = user.photoKey
      ? await this.storage.presignDownload(
          user.photoKey,
          this.config.get('AVATAR_URL_TTL_SEC', { infer: true }),
        )
      : null;
    return toUserDto(user, photoUrl);
  }
}
