import { Controller, Get, Query } from '@nestjs/common';
import { ApiOkResponse, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Admin } from '../common/admin/admin-permissions';
import { AdminAuditService } from './admin-audit.service';
import { AuditPageDto, AuditQueryDto } from './dto/audit.dto';

@ApiTags('admin')
@Admin('auditoria')
@Controller('admin/audit')
export class AdminAuditController {
  constructor(private readonly audit: AdminAuditService) {}

  @Get()
  @ApiOperation({
    summary: 'Auditoría del panel (ADR-0041)',
    description: 'De la más nueva a la más vieja, 50 por página. Filtros combinables.',
  })
  @ApiOkResponse({ type: AuditPageDto })
  list(@Query() query: AuditQueryDto): Promise<AuditPageDto> {
    return this.audit.list(query);
  }
}
