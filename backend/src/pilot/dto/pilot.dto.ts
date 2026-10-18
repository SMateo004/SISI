import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  ArrayMaxSize,
  ArrayMinSize,
  IsArray,
  IsIn,
  IsOptional,
  IsString,
  IsUUID,
  MaxLength,
  MinLength,
} from 'class-validator';

export const INTEREST_ROLES = ['worker', 'employer', 'ambos'] as const;

export class PilotInterestDto {
  @ApiProperty({ example: '70012345' })
  @IsString({ message: 'Escribe tu número de celular.' })
  @MaxLength(20)
  phone!: string;

  @ApiProperty({ enum: INTEREST_ROLES, description: 'Quiere trabajar, contratar o las dos' })
  @IsIn(INTEREST_ROLES, { message: 'Elige si quieres trabajar, contratar o las dos.' })
  role!: (typeof INTEREST_ROLES)[number];

  @ApiPropertyOptional({ description: 'Categoría que le interesa' })
  @IsOptional()
  @IsUUID('all', { message: 'Categoría inválida.' })
  categoryId?: string;

  @ApiPropertyOptional({ example: 'Plan 3000', description: 'Barrio o zona' })
  @IsOptional()
  @IsString()
  @MaxLength(100, { message: 'La zona puede tener hasta 100 letras.' })
  zone?: string;
}

export class AddPilotPhonesDto {
  @ApiProperty({
    type: [String],
    example: ['70012345', '+59171234567'],
    description: 'Números a habilitar (con o sin +591)',
  })
  @IsArray()
  @ArrayMinSize(1, { message: 'Agrega al menos un número.' })
  @ArrayMaxSize(500, { message: 'Hasta 500 números por vez.' })
  @IsString({ each: true })
  phones!: string[];

  @ApiPropertyOptional({ example: 'Trabajadores de la feria del Plan 3000' })
  @IsOptional()
  @IsString()
  @MaxLength(200)
  note?: string;

  @ApiPropertyOptional({ description: 'Ciudad (por defecto, la del piloto)' })
  @IsOptional()
  @IsUUID('all')
  cityId?: string;

  @ApiProperty({ example: 'Primer grupo del piloto' })
  @IsString({ message: 'Escribe el motivo.' })
  @MinLength(5, { message: 'Escribe el motivo (al menos 5 letras).' })
  @MaxLength(300)
  reason!: string;
}

export class RemovePilotPhoneDto {
  @ApiProperty({ example: 'Pidió salir del piloto' })
  @IsString({ message: 'Escribe el motivo.' })
  @MinLength(5, { message: 'Escribe el motivo (al menos 5 letras).' })
  @MaxLength(300)
  reason!: string;
}

export class PilotPhoneDto {
  @ApiProperty() id!: string;
  @ApiProperty({ example: '+59170012345' }) phone!: string;
  @ApiProperty({ type: String, nullable: true }) note!: string | null;
  @ApiProperty({ type: String, format: 'date-time' }) createdAt!: string;
}

export class PilotOverviewDto {
  @ApiProperty() cityId!: string;
  @ApiProperty({ example: 'Santa Cruz de la Sierra' }) cityName!: string;
  @ApiProperty({ description: 'Flag pilot.closed de la ciudad (se cambia en Feature flags)' })
  closed!: boolean;
  @ApiProperty({ type: PilotPhoneDto, isArray: true }) allowlist!: PilotPhoneDto[];
  @ApiProperty() interestCount!: number;
}

export class AddPilotPhonesResultDto {
  @ApiProperty({ type: [String] }) added!: string[];
  @ApiProperty({ type: [String] }) alreadyListed!: string[];
  @ApiProperty({ type: [String] }) invalid!: string[];
}

export class PilotInterestRowDto {
  @ApiProperty() id!: string;
  @ApiProperty() phone!: string;
  @ApiProperty({ enum: INTEREST_ROLES }) role!: string;
  @ApiProperty({ type: String, nullable: true }) categoryName!: string | null;
  @ApiProperty({ type: String, nullable: true }) zone!: string | null;
  @ApiProperty({ type: String, format: 'date-time' }) createdAt!: string;
}
