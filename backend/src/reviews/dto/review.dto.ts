import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsIn, IsInt, IsOptional, IsString, IsUUID, Max, MaxLength, Min } from 'class-validator';

export class CreateReviewDto {
  @ApiProperty({ minimum: 1, maximum: 5, example: 5 })
  @Type(() => Number)
  @IsInt({ message: 'Elige de 1 a 5 estrellas.' })
  @Min(1, { message: 'Elige de 1 a 5 estrellas.' })
  @Max(5, { message: 'Elige de 1 a 5 estrellas.' })
  stars!: number;

  @ApiPropertyOptional({ example: 'Muy puntual y prolijo.', maxLength: 500 })
  @IsOptional()
  @IsString()
  @MaxLength(500, { message: 'El comentario no puede pasar de 500 caracteres.' })
  comment?: string;
}

export class MyReviewDto {
  @ApiProperty() stars!: number;
  @ApiProperty({ type: String, nullable: true }) comment!: string | null;
  @ApiProperty({ description: 'El comentario quedó retenido por moderación (no se publica)' })
  commentHeld!: boolean;
  @ApiProperty({ description: 'Ya es visible (calificaron ambos o venció el plazo)' })
  published!: boolean;
}

export class ReceivedReviewDto {
  @ApiProperty() stars!: number;
  @ApiProperty({ type: String, nullable: true }) comment!: string | null;
}

/** Calificaciones del trabajo para una de las partes. La de la contraparte, solo publicada. */
export class JobReviewsDto {
  @ApiProperty({ description: 'Puedo calificar ahora' }) canReview!: boolean;
  @ApiProperty({ type: String, format: 'date-time', nullable: true }) deadline!: string | null;
  @ApiProperty({ type: MyReviewDto, nullable: true }) mine!: MyReviewDto | null;
  @ApiProperty({ type: ReceivedReviewDto, nullable: true }) theirs!: ReceivedReviewDto | null;
}

export class PublicReviewDto {
  @ApiProperty({ format: 'uuid' }) id!: string;
  @ApiProperty() stars!: number;
  @ApiProperty({ type: String, nullable: true }) comment!: string | null;
  @ApiProperty({ example: 'Carla M.' }) reviewerShortName!: string;
  @ApiProperty({ type: String, format: 'date-time' }) publishedAt!: string;
}

export class UserReviewsDto {
  @ApiProperty({ example: '4.80' }) ratingAvg!: string;
  @ApiProperty() ratingCount!: number;
  @ApiProperty({ type: [PublicReviewDto] }) items!: PublicReviewDto[];
  @ApiProperty({ type: String, nullable: true }) nextCursor!: string | null;
}

export class ListUserReviewsQuery {
  @ApiProperty({ enum: ['worker', 'employer'], description: 'Como trabajador o como empleador' })
  @IsIn(['worker', 'employer'], { message: 'El rol no es válido.' })
  role!: 'worker' | 'employer';

  @ApiPropertyOptional()
  @IsOptional()
  @IsUUID('all', { message: 'Cursor inválido.' })
  cursor?: string;
}
