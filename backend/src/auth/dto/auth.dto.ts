import { ApiProperty } from '@nestjs/swagger';
import { IsJWT, IsString, Matches, MaxLength, MinLength } from 'class-validator';
import { UserDto } from '../../users/dto/user.dto';

export class RequestOtpDto {
  @ApiProperty({
    example: '70012345',
    description: 'Celular. Sin prefijo se asume Bolivia (+591).',
  })
  @IsString({ message: 'Ingresa tu número de celular.' })
  @MinLength(6, { message: 'Ingresa tu número de celular.' })
  @MaxLength(32, { message: 'El número es demasiado largo.' })
  phone!: string;
}

export class VerifyOtpDto extends RequestOtpDto {
  @ApiProperty({ example: '482913', description: 'Código de 6 dígitos recibido por SMS' })
  @Matches(/^\d{6}$/, { message: 'El código tiene 6 dígitos.' })
  code!: string;
}

export class RefreshTokenDto {
  @ApiProperty({ example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...' })
  @IsJWT({ message: 'La sesión no es válida.' })
  refreshToken!: string;
}

export class OtpRequestedDto {
  @ApiProperty({ example: 300, description: 'Segundos hasta que vence el código' })
  expiresInSec!: number;

  @ApiProperty({ example: 60, description: 'Segundos hasta poder pedir otro código' })
  resendInSec!: number;
}

export class TokensDto {
  @ApiProperty({ example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...' })
  accessToken!: string;

  @ApiProperty({ example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...' })
  refreshToken!: string;

  @ApiProperty({ example: 'Bearer', enum: ['Bearer'] })
  tokenType!: 'Bearer';

  @ApiProperty({ example: 900, description: 'Vida del token de acceso, en segundos' })
  expiresIn!: number;

  @ApiProperty({ example: 2_592_000, description: 'Vida del refresh token, en segundos' })
  refreshExpiresIn!: number;
}

/** Sesión del panel admin (ADR-0040): el refresh va solo en la cookie httpOnly. */
export class AdminSessionDto {
  @ApiProperty({ example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...' })
  accessToken!: string;

  @ApiProperty({ example: 'Bearer', enum: ['Bearer'] })
  tokenType!: 'Bearer';

  @ApiProperty({ example: 600, description: 'Vida del token de acceso, en segundos' })
  expiresIn!: number;

  @ApiProperty({
    type: String,
    format: 'date-time',
    description: 'Fin de la sesión (8 h desde el login); después hay que volver a ingresar',
  })
  sessionExpiresAt!: string;

  @ApiProperty({ type: UserDto })
  user!: UserDto;
}

export class LoginResponseDto extends TokensDto {
  @ApiProperty({ type: UserDto })
  user!: UserDto;

  @ApiProperty({ example: true, description: 'La cuenta se creó en este login' })
  isNewUser!: boolean;
}
