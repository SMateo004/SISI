import { Module } from '@nestjs/common';
import { MeController } from './me.controller';
import { UserPresenter } from './user.presenter';
import { UsersService } from './users.service';

@Module({
  controllers: [MeController],
  providers: [UsersService, UserPresenter],
  exports: [UsersService, UserPresenter],
})
export class UsersModule {}
