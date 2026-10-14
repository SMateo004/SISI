import { Body, Controller, Get, Patch } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { type AuthenticatedUser, CurrentUser } from '../auth/decorators/auth.decorators';
import { ApiErrorBody } from '../common/errors/api-error';
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
}
