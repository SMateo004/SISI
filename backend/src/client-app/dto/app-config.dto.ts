import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsIn, IsOptional, Matches } from 'class-validator';
import { APP_PLATFORMS } from '../semver';

export class AppConfigQuery {
  @ApiProperty({ enum: APP_PLATFORMS })
  @IsIn(APP_PLATFORMS, { message: 'Plataforma inválida.' })
  platform!: (typeof APP_PLATFORMS)[number];

  @ApiPropertyOptional({ example: '0.9.0', description: 'Versión instalada' })
  @IsOptional()
  @Matches(/^\d+\.\d+\.\d+([+-].*)?$/, { message: 'Versión inválida.' })
  version?: string;
}

export class SupportDto {
  @ApiProperty({ example: '+59170000000' }) whatsapp!: string;
  @ApiProperty({ example: 'https://wa.me/59170000000?text=Hola' }) url!: string;
}

export class LegalVersionDto {
  @ApiProperty({ enum: ['terms', 'privacy'] }) type!: 'terms' | 'privacy';
  @ApiProperty() version!: number;
}

export class AppConfigDto {
  @ApiProperty({ enum: APP_PLATFORMS }) platform!: (typeof APP_PLATFORMS)[number];
  @ApiProperty({ example: '0.9.0' }) minVersion!: string;
  @ApiProperty({ description: 'La versión enviada es menor que la mínima' })
  upgradeRequired!: boolean;
  @ApiProperty({ type: String, nullable: true }) storeUrl!: string | null;
  @ApiProperty({ type: SupportDto, nullable: true }) support!: SupportDto | null;
  @ApiProperty({ type: LegalVersionDto, isArray: true }) legal!: LegalVersionDto[];
}
