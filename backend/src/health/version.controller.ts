import { Controller, Get, Inject } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ApiOkResponse, ApiOperation, ApiProperty, ApiTags } from '@nestjs/swagger';
import { SkipThrottle } from '@nestjs/throttler';
import { Public } from '../auth/decorators/auth.decorators';
import { releaseInfo } from '../common/release/release';
import type { AppConfigService } from '../config/app-config';

export class VersionDto {
  @ApiProperty({ example: '0.9.0' }) version!: string;
  @ApiProperty({ type: String, nullable: true }) sha!: string | null;
  @ApiProperty({ example: 'production' }) env!: string;
}

/** Qué versión corre (ADR-0046): el workflow de producción espera ver aquí el sha nuevo. */
@ApiTags('health')
@Public()
@SkipThrottle({ global: true })
@Controller('version')
export class VersionController {
  constructor(@Inject(ConfigService) private readonly config: AppConfigService) {}

  @Get()
  @ApiOperation({ summary: 'Versión y commit desplegados' })
  @ApiOkResponse({ type: VersionDto })
  get(): VersionDto {
    const info = releaseInfo(this.config.get('RENDER_GIT_COMMIT', { infer: true }));
    return { ...info, env: this.config.get('APP_ENV', { infer: true }) };
  }
}
