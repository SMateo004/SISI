import { Injectable } from '@nestjs/common';
import type { User } from '../generated/prisma/client';
import { toUserDto, type UserDto } from './dto/user.dto';

/** Arma el UserDto. La URL firmada de la foto se agrega cuando hay almacenamiento. */
@Injectable()
export class UserPresenter {
  present(user: User): Promise<UserDto> {
    return Promise.resolve(toUserDto(user));
  }
}
