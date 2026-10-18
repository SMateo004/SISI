import { ApiProperty } from '@nestjs/swagger';
import { JobCategoryDto } from './job.dto';

export class AdminJobPartyDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ type: String, nullable: true }) name!: string | null;
  @ApiProperty() phone!: string;
}

export class AdminJobEventDto {
  @ApiProperty({ example: 'FINISH' }) action!: string;
  @ApiProperty() fromStatus!: string;
  @ApiProperty() toStatus!: string;
  @ApiProperty({ enum: ['worker', 'employer', 'system', 'admin'] }) actorRole!: string;
  @ApiProperty({ type: String, nullable: true, format: 'uuid' }) actorId!: string | null;
  @ApiProperty({ type: String, nullable: true }) note!: string | null;
  @ApiProperty({ type: String, format: 'date-time' }) at!: string;
}

export class AdminJobMessageDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ enum: ['worker', 'employer'] }) from!: 'worker' | 'employer';
  @ApiProperty() body!: string;
  @ApiProperty({
    enum: ['entregado', 'retenido', 'descartado'],
    description: 'Retenido o descartado: no le llegó a la contraparte',
  })
  status!: string;
  @ApiProperty({ type: String, format: 'date-time' }) at!: string;
}

export class AdminOfferEventDto {
  @ApiProperty({ enum: ['creada', 'reemplazada', 'retirada', 'aceptada', 'cerrada'] })
  kind!: string;
  @ApiProperty() revision!: number;
  @ApiProperty({ enum: ['accept', 'counter'] }) type!: string;
  @ApiProperty({ example: '150.00' }) amountBs!: string;
  @ApiProperty() etaMin!: number;
  @ApiProperty({ type: String, format: 'date-time' }) at!: string;
}

export class AdminJobOfferDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ type: AdminJobPartyDto }) worker!: AdminJobPartyDto;
  @ApiProperty() status!: string;
  @ApiProperty({ description: 'La que eligió el empleador' }) chosen!: boolean;
  @ApiProperty({ type: AdminOfferEventDto, isArray: true, description: 'Historial (ADR-0042)' })
  history!: AdminOfferEventDto[];
}

/** Todo lo que el admin necesita para resolver una disputa. */
export class AdminJobDetailDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty({ format: 'uuid' }) requestId!: string;
  @ApiProperty() status!: string;
  @ApiProperty({ type: JobCategoryDto }) category!: JobCategoryDto;
  @ApiProperty() description!: string;
  @ApiProperty() address!: string;
  @ApiProperty({ example: '150.00' }) proposedPriceBs!: string;
  @ApiProperty({ example: '170.00' }) finalPriceBs!: string;
  @ApiProperty({ example: '13.00' }) commissionPct!: string;
  @ApiProperty({ type: String, nullable: true, example: '22.10' }) commissionBs!: string | null;
  @ApiProperty({ type: AdminJobPartyDto }) worker!: AdminJobPartyDto;
  @ApiProperty({ type: AdminJobPartyDto }) employer!: AdminJobPartyDto;
  @ApiProperty({ type: String, nullable: true, format: 'date-time' }) disputedAt!: string | null;
  @ApiProperty({ type: String, nullable: true }) disputeNote!: string | null;
  @ApiProperty({ type: AdminJobEventDto, isArray: true, description: 'job_events' })
  timeline!: AdminJobEventDto[];
  @ApiProperty({ type: AdminJobMessageDto, isArray: true, description: 'Todo el chat' })
  chat!: AdminJobMessageDto[];
  @ApiProperty({ type: AdminJobOfferDto, isArray: true }) offers!: AdminJobOfferDto[];
}
