import { HttpException, type HttpStatus } from '@nestjs/common';
import { ApiProperty } from '@nestjs/swagger';

/** Forma común de los errores de la API: código estable para la app + mensaje en español. */
export class ApiErrorBody {
  @ApiProperty({ example: 400 })
  statusCode!: number;

  @ApiProperty({ example: 'OTP_INVALID', description: 'Código estable para la app' })
  code!: string;

  @ApiProperty({ example: 'Código incorrecto o vencido.' })
  message!: string;
}

export class ApiError extends HttpException {
  constructor(
    status: HttpStatus | number,
    readonly code: string,
    message: string,
    extra: Record<string, unknown> = {},
  ) {
    super({ statusCode: status, code, message, ...extra }, status);
  }
}
