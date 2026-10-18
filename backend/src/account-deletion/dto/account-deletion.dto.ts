import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, Matches, MaxLength } from 'class-validator';

export class DeletionBlockerDto {
  @ApiProperty({
    enum: [
      'ACCOUNT_IS_ADMIN',
      'ACCOUNT_HAS_ACTIVE_JOB',
      'ACCOUNT_HAS_PENDING_PAYMENT',
      'ACCOUNT_HAS_DEBT',
    ],
  })
  code!: string;
  @ApiProperty() message!: string;
  @ApiPropertyOptional({ example: '19.50', description: 'Deuda a pagar (ACCOUNT_HAS_DEBT)' })
  balanceBs?: string;
  @ApiPropertyOptional({ type: String, nullable: true, example: 'SISI-2643-K7M2QX' })
  paymentReference?: string | null;
}

export class DeletionCheckDto {
  @ApiProperty() canDelete!: boolean;
  @ApiProperty({ type: DeletionBlockerDto, isArray: true }) blockers!: DeletionBlockerDto[];
  @ApiProperty({
    type: [String],
    example: ['Tu nombre, teléfono y foto', 'Tus documentos de identidad'],
    description: 'Qué se borra',
  })
  erased!: string[];
  @ApiProperty({
    type: [String],
    description: 'Qué se conserva sin datos personales (obligaciones legales)',
  })
  kept!: string[];
}

export class ConfirmDeletionDto {
  @ApiProperty({ example: '123456', description: 'Código recibido por SMS' })
  @Matches(/^\d{6}$/, { message: 'El código tiene 6 dígitos.' })
  code!: string;
}

export class WebDeletionCodeDto {
  @ApiProperty({ example: '70012345' })
  @IsString({ message: 'Escribe tu número de celular.' })
  @MaxLength(20)
  phone!: string;
}

export class WebDeletionDto extends WebDeletionCodeDto {
  @ApiProperty({ example: '123456' })
  @Matches(/^\d{6}$/, { message: 'El código tiene 6 dígitos.' })
  code!: string;
}
