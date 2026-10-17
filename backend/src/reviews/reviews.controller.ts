import { Body, Controller, Get, Param, ParseUUIDPipe, Post, Query } from '@nestjs/common';
import {
  ApiBearerAuth,
  ApiConflictResponse,
  ApiCreatedResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { type AuthenticatedUser, CurrentUser } from '../auth/decorators/auth.decorators';
import { ApiErrorBody } from '../common/errors/api-error';
import {
  CreateReviewDto,
  JobReviewsDto,
  ListUserReviewsQuery,
  UserReviewsDto,
} from './dto/review.dto';
import { ReviewsService } from './reviews.service';

/** Calificaciones (R6.2, ADR-0032). */
@ApiTags('calificaciones')
@ApiBearerAuth()
@ApiUnauthorizedResponse({ type: ApiErrorBody, description: 'UNAUTHENTICATED o TOKEN_INVALID' })
@Controller()
export class ReviewsController {
  constructor(private readonly reviews: ReviewsService) {}

  @Post('jobs/:id/review')
  @ApiOperation({
    summary: 'Calificar a la contraparte (1 a 5 estrellas y comentario opcional)',
    description:
      'Una vez por trabajo, solo terminado y dentro de los 7 días. Es ciega: la contraparte la ve cuando califiquen los dos o venza el plazo. El comentario se modera.',
  })
  @ApiCreatedResponse({ type: JobReviewsDto })
  @ApiNotFoundResponse({ type: ApiErrorBody, description: 'JOB_NOT_FOUND' })
  @ApiConflictResponse({
    type: ApiErrorBody,
    description: 'ALREADY_REVIEWED, REVIEW_NOT_ALLOWED o REVIEW_WINDOW_CLOSED',
  })
  submit(
    @CurrentUser() current: AuthenticatedUser,
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: CreateReviewDto,
  ): Promise<JobReviewsDto> {
    return this.reviews.submit(current.id, id, dto.stars, dto.comment);
  }

  @Get('jobs/:id/reviews')
  @ApiOperation({ summary: 'Calificaciones del trabajo (la mía y, si ya es visible, la recibida)' })
  @ApiOkResponse({ type: JobReviewsDto })
  @ApiNotFoundResponse({ type: ApiErrorBody, description: 'JOB_NOT_FOUND' })
  forJob(
    @CurrentUser() current: AuthenticatedUser,
    @Param('id', ParseUUIDPipe) id: string,
  ): Promise<JobReviewsDto> {
    return this.reviews.forJob(current.id, id);
  }

  @Get('users/:id/reviews')
  @ApiOperation({
    summary: 'Calificaciones publicadas de un usuario',
    description: 'Como trabajador o como empleador, con su promedio.',
  })
  @ApiOkResponse({ type: UserReviewsDto })
  @ApiNotFoundResponse({ type: ApiErrorBody, description: 'USER_NOT_FOUND' })
  forUser(
    @Param('id', ParseUUIDPipe) id: string,
    @Query() q: ListUserReviewsQuery,
  ): Promise<UserReviewsDto> {
    return this.reviews.forUser(id, q.role, q.cursor);
  }
}
