import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export type CheckStatus = 'up' | 'down';

export class HealthCheckDto {
  @ApiProperty({ enum: ['up', 'down'], example: 'up' })
  status!: CheckStatus;

  @ApiPropertyOptional({ description: 'Versión reportada (solo PostGIS)', example: '3.5.2' })
  version?: string;
}

export class HealthChecksDto {
  @ApiProperty({ type: HealthCheckDto })
  database!: HealthCheckDto;

  @ApiProperty({ type: HealthCheckDto })
  postgis!: HealthCheckDto;

  @ApiProperty({ type: HealthCheckDto })
  redis!: HealthCheckDto;
}

export class HealthResponseDto {
  @ApiProperty({ enum: ['ok', 'error'], example: 'ok' })
  status!: 'ok' | 'error';

  @ApiProperty({ type: HealthChecksDto })
  checks!: HealthChecksDto;

  @ApiProperty({ example: '2026-10-13T21:00:00.000Z' })
  timestamp!: string;
}
