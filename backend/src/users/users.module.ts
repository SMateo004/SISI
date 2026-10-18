import { Module } from '@nestjs/common';
import { LegalModule } from '../legal/legal.module';
import { MeController } from './me.controller';
import { UserPresenter } from './user.presenter';
import { UsersService } from './users.service';

@Module({
  imports: [LegalModule],
  controllers: [MeController],
  providers: [UsersService, UserPresenter],
  exports: [UsersService, UserPresenter],
})
export class UsersModule {}
