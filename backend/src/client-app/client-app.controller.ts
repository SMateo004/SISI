import { Controller, Get, Query } from '@nestjs/common';
import { ApiOkResponse, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Public } from '../auth/decorators/auth.decorators';
import { SkipAppVersion } from './app-version.guard';
import { ClientAppService } from './client-app.service';
import { AppConfigDto, AppConfigQuery } from './dto/app-config.dto';

@ApiTags('app')
@Controller('app')
export class ClientAppController {
  constructor(private readonly app: ClientAppService) {}

  @Get('config')
  @Public()
  @SkipAppVersion()
  @ApiOperation({
    summary: 'Configuración de la app al abrirla',
    description:
      'Versión mínima por plataforma (si la instalada es menor, upgradeRequired y la tienda), WhatsApp de soporte y versiones legales vigentes.',
  })
  @ApiOkResponse({ type: AppConfigDto })
  config(@Query() q: AppConfigQuery): Promise<AppConfigDto> {
    return this.app.appConfig(q.platform, q.version);
  }
}
