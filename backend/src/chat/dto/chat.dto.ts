import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsInt, IsOptional, IsString, IsUUID, Max, MaxLength, Min } from 'class-validator';

export class SendMessageDto {
  @ApiProperty({ example: 'Llego en 10 minutos.', minLength: 1, maxLength: 1000 })
  @IsString({ message: 'El mensaje no es válido.' })
  @MaxLength(1000, { message: 'El mensaje no puede pasar de 1000 caracteres.' })
  body!: string;
}

export class ChatMessageDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ format: 'uuid' }) jobId!: string;
  @ApiProperty({ format: 'uuid' }) senderId!: string;
  @ApiProperty({ description: 'Lo envié yo' }) mine!: boolean;
  @ApiProperty() body!: string;
  @ApiProperty({
    enum: ['entregado', 'retenido'],
    description: 'retenido = no se entregó (moderación); solo lo ve quien lo envió',
  })
  status!: 'entregado' | 'retenido';
  @ApiProperty({ type: String, format: 'date-time', nullable: true }) readAt!: string | null;
  @ApiProperty({ type: String, format: 'date-time' }) createdAt!: string;
}

export class SentMessageDto extends ChatMessageDto {
  @ApiProperty({
    type: String,
    nullable: true,
    example: 'Tu mensaje no se envió porque no cumple las normas de uso de SISI.',
    description: 'Aviso neutral para quien envió un mensaje retenido',
  })
  notice!: string | null;
}

export class ChatPageDto {
  @ApiProperty({ type: [ChatMessageDto], description: 'Del más reciente al más antiguo' })
  items!: ChatMessageDto[];
  @ApiProperty({ type: String, nullable: true }) nextCursor!: string | null;
  @ApiProperty({ description: 'Se pueden enviar mensajes' }) open!: boolean;
  @ApiProperty({
    type: String,
    format: 'date-time',
    nullable: true,
    description: 'Cuándo pasa a solo lectura (24 h después de terminado o cancelado)',
  })
  closesAt!: string | null;
  @ApiProperty({ description: 'Mensajes de la contraparte sin leer' }) unread!: number;
}

export class ListMessagesQuery {
  @ApiPropertyOptional()
  @IsOptional()
  @IsUUID('all', { message: 'Cursor inválido.' })
  cursor?: string;

  @ApiPropertyOptional({ default: 30, maximum: 100 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit?: number;
}

export class MarkReadDto {
  @ApiProperty({ format: 'uuid', description: 'Último mensaje leído (incluido)' })
  @IsUUID('all', { message: 'Mensaje inválido.' })
  upToId!: string;
}

export class MarkReadResultDto {
  @ApiProperty() updated!: number;
}

export class AdminHeldMessageDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ format: 'uuid' }) jobId!: string;
  @ApiProperty({ format: 'uuid' }) senderId!: string;
  @ApiProperty() body!: string;
  @ApiProperty({ description: 'Términos que coincidieron' }) matches!: unknown;
  @ApiProperty({ type: String, format: 'date-time' }) createdAt!: string;
}

export class AdminHeldMessagePageDto {
  @ApiProperty({ type: AdminHeldMessageDto, isArray: true }) items!: AdminHeldMessageDto[];
  @ApiProperty({ type: String, nullable: true }) nextCursor!: string | null;
}
