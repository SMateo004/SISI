import { ApiProperty } from '@nestjs/swagger';
import { IsEnum, IsString, Length } from 'class-validator';

export enum DevicePlatformDto {
  android = 'android',
  web = 'web',
  ios = 'ios',
}

export class RegisterDeviceDto {
  @ApiProperty({ description: 'Token de FCM del dispositivo' })
  @IsString({ message: 'El token no es válido.' })
  @Length(20, 4096, { message: 'El token no es válido.' })
  token!: string;

  @ApiProperty({ enum: DevicePlatformDto })
  @IsEnum(DevicePlatformDto, { message: 'La plataforma no es válida.' })
  platform!: DevicePlatformDto;
}

export class NotificationDto {
  @ApiProperty({ format: 'uuid' })
  id!: string;

  @ApiProperty({ example: 'offer_new' })
  type!: string;

  @ApiProperty({ example: 'Recibiste una oferta' })
  title!: string;

  @ApiProperty({ example: 'María P. ofrece Bs 180,00. Revísala y elige.' })
  body!: string;

  @ApiProperty({ example: '/solicitudes/…', description: 'Pantalla de la app a abrir' })
  route!: string;

  @ApiProperty({ type: 'object', additionalProperties: true })
  data!: Record<string, unknown>;

  @ApiProperty({ type: String, format: 'date-time', nullable: true })
  readAt!: string | null;

  @ApiProperty({ type: String, format: 'date-time' })
  createdAt!: string;
}

export class NotificationPageDto {
  @ApiProperty({ type: [NotificationDto] })
  items!: NotificationDto[];

  @ApiProperty({ type: String, nullable: true })
  nextCursor!: string | null;
}
