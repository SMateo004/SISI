import { Body, Controller, HttpCode, HttpStatus, Post } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiNoContentResponse,
  ApiOperation,
  ApiTags,
} from '@nestjs/swagger';
import { Public } from '../auth/decorators/auth.decorators';
import { ApiErrorBody } from '../common/errors/api-error';
import { RateLimit } from '../common/rate-limit/rate-limit.decorator';
import { PilotInterestDto } from './dto/pilot.dto';
import { PilotService } from './pilot.service';

@ApiTags('pilot')
@Controller('pilot')
export class PilotController {
  constructor(private readonly pilot: PilotService) {}

  @Post('interest')
  @Public()
  @HttpCode(HttpStatus.NO_CONTENT)
  @RateLimit('pilotInterestIp')
  @ApiOperation({
    summary: '"Pronto en tu zona": dejar el interés (ADR-0052)',
    description: 'Para quien todavía no puede crear su cuenta en el piloto. Mide la demanda.',
  })
  @ApiNoContentResponse()
  @ApiBadRequestResponse({ type: ApiErrorBody, description: 'PHONE_INVALID o VALIDATION_ERROR' })
  async interest(@Body() dto: PilotInterestDto): Promise<void> {
    await this.pilot.registerInterest(dto);
  }
}
