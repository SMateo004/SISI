import { Controller, Get } from '@nestjs/common';
import {
  ApiOkResponse,
  ApiOperation,
  ApiProperty,
  ApiPropertyOptional,
  ApiTags,
} from '@nestjs/swagger';
import { ConsoleOtpFeed } from '../auth/otp/console-otp-feed';
import { Admin } from '../common/admin/admin-permissions';
import { PrismaService } from '../prisma/prisma.service';

export class OtpCodeDto {
  @ApiProperty({ example: '+59170012345' }) phone!: string;
  @ApiProperty({ example: '482913' }) code!: string;
  @ApiProperty({ type: String, format: 'date-time' }) sentAt!: string;
  @ApiProperty({ type: String, format: 'date-time' }) expiresAt!: string;
  @ApiPropertyOptional({ type: String, format: 'date-time', nullable: true }) usedAt!:
    string | null;
  @ApiProperty({ description: 'El número ya tiene cuenta (si no, es un registro nuevo)' })
  accountExists!: boolean;
  @ApiPropertyOptional({ type: String, nullable: true, example: 'María Pérez' }) name!:
    string | null;
  @ApiPropertyOptional({ enum: ['employer', 'worker'], nullable: true })
  activeMode!: 'employer' | 'worker' | null;
}

export class OtpCodesDto {
  @ApiProperty({
    description: 'Solo con OTP_PROVIDER=console y fuera de producción; si no, siempre vacío',
  })
  enabled!: boolean;
  @ApiProperty({ type: [OtpCodeDto] }) items!: OtpCodeDto[];
}

/**
 * Códigos de ingreso enviados mientras no hay SMS (ADR-0056): para probar staging. Con un
 * proveedor real o en producción la lista siempre está vacía (enabled=false).
 */
@ApiTags('admin')
@Admin('usuarios')
@Controller('admin')
export class AdminOtpCodesController {
  constructor(
    private readonly feed: ConsoleOtpFeed,
    private readonly prisma: PrismaService,
  ) {}

  @Get('otp-codes')
  @ApiOperation({
    summary: 'Códigos de ingreso vigentes (solo sin SMS y fuera de producción)',
    description: 'El más reciente primero; cada código queda hasta que vence y se marca al usarse.',
  })
  @ApiOkResponse({ type: OtpCodesDto })
  async list(): Promise<OtpCodesDto> {
    if (!this.feed.enabled) return { enabled: false, items: [] };
    const entries = await this.feed.list();
    const users = await this.prisma.user.findMany({
      where: { phone: { in: entries.map((e) => e.phone) } },
      select: { phone: true, name: true, activeMode: true },
    });
    const byPhone = new Map(users.map((u) => [u.phone, u]));
    return {
      enabled: true,
      items: entries.map((e) => {
        const user = byPhone.get(e.phone);
        return {
          ...e,
          accountExists: user !== undefined,
          name: user?.name ?? null,
          activeMode: user?.activeMode ?? null,
        };
      }),
    };
  }
}
