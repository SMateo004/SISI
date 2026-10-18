import { Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtModule } from '@nestjs/jwt';
import type { AppConfigService } from '../config/app-config';
import { PilotModule } from '../pilot/pilot.module';
import { UsersModule } from '../users/users.module';
import { UsersService } from '../users/users.service';
import { AdminAuthController } from './admin-auth.controller';
import { AdminLoginService } from './admin-login.service';
import { AuthController } from './auth.controller';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { RolesGuard } from './guards/roles.guard';
import { OtpHasher } from './otp/otp-hasher';
import { OTP_PROVIDER } from './otp/otp-provider';
import { createOtpProvider } from './otp/otp-provider.factory';
import { OTP_CODE_GENERATOR, OtpService } from './otp/otp.service';
import { OTP_STORE, RedisOtpStore } from './otp/otp.store';
import {
  PrismaRefreshTokenRepository,
  REFRESH_TOKEN_REPOSITORY,
} from './tokens/refresh-token.repository';
import {
  TOKEN_SUBJECT_LOADER,
  type TokenSubjectLoader,
  TokenService,
} from './tokens/token.service';

@Module({
  imports: [
    UsersModule,
    // Piloto cerrado: un número fuera de la lista no recibe código (ADR-0052).
    PilotModule,
    JwtModule.registerAsync({
      inject: [ConfigService],
      useFactory: (config: AppConfigService) => ({
        secret: config.get('JWT_SECRET', { infer: true }),
        signOptions: { algorithm: 'HS256' },
      }),
    }),
  ],
  controllers: [AuthController, AdminAuthController],
  providers: [
    OtpService,
    AdminLoginService,
    TokenService,
    JwtAuthGuard,
    RolesGuard,
    { provide: OTP_STORE, useClass: RedisOtpStore },
    { provide: OTP_CODE_GENERATOR, useValue: () => OtpHasher.generateCode() },
    {
      // Valida al arrancar: production nunca usa la consola (ADR-0011).
      provide: OTP_PROVIDER,
      inject: [ConfigService],
      useFactory: (config: AppConfigService) =>
        createOtpProvider({
          APP_ENV: config.get('APP_ENV', { infer: true }),
          OTP_PROVIDER: config.get('OTP_PROVIDER', { infer: true }),
          OTP_PROVIDER_KEY: config.get('OTP_PROVIDER_KEY', { infer: true }),
          OTP_SENDER: config.get('OTP_SENDER', { infer: true }),
          OTP_TTL_SEC: config.get('OTP_TTL_SEC', { infer: true }),
        }),
    },
    { provide: REFRESH_TOKEN_REPOSITORY, useClass: PrismaRefreshTokenRepository },
    {
      provide: TOKEN_SUBJECT_LOADER,
      inject: [UsersService],
      useFactory:
        (users: UsersService): TokenSubjectLoader =>
        async (userId) => {
          const user = await users.findById(userId);
          return user ? { id: user.id, role: user.role } : null;
        },
    },
  ],
  exports: [TokenService, JwtAuthGuard, RolesGuard, OtpService],
})
export class AuthModule {}
