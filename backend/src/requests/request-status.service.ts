import { HttpStatus, Injectable } from '@nestjs/common';
import { ApiError } from '../common/errors/api-error';
import type { Prisma } from '../generated/prisma/client';
import { PrismaService } from '../prisma/prisma.service';
import { nextRequestStatus, type RequestEvent, type RequestStatus } from './request-status.machine';

export interface RequestTransition {
  from: RequestStatus;
  to: RequestStatus;
}

/**
 * Único punto que cambia service_requests.status (ADR-0019). Valida con la máquina de
 * estados, actualiza con control de concurrencia y deja el evento en el historial.
 * Con `tx`, participa en la transacción de quien llama, que escribe ahí mismo sus
 * eventos en el outbox (ADR-0022).
 */
@Injectable()
export class RequestStatusService {
  constructor(private readonly prisma: PrismaService) {}

  async apply(
    requestId: string,
    event: RequestEvent,
    actorId: string | null,
    extra: { data?: Prisma.ServiceRequestUncheckedUpdateManyInput; reason?: string } = {},
    tx?: Prisma.TransactionClient,
  ): Promise<RequestTransition> {
    if (tx) return this.applyIn(tx, requestId, event, actorId, extra);
    return this.prisma.$transaction((t) => this.applyIn(t, requestId, event, actorId, extra));
  }

  private async applyIn(
    tx: Prisma.TransactionClient,
    requestId: string,
    event: RequestEvent,
    actorId: string | null,
    extra: { data?: Prisma.ServiceRequestUncheckedUpdateManyInput; reason?: string },
  ): Promise<RequestTransition> {
    const current = await tx.serviceRequest.findUnique({
      where: { id: requestId },
      select: { status: true },
    });
    if (!current) {
      throw new ApiError(HttpStatus.NOT_FOUND, 'REQUEST_NOT_FOUND', 'La solicitud no existe.');
    }
    const to = nextRequestStatus(current.status, event);
    const { count } = await tx.serviceRequest.updateMany({
      where: { id: requestId, status: current.status },
      data: { ...extra.data, status: to },
    });
    if (count === 0) {
      throw new ApiError(
        HttpStatus.CONFLICT,
        'REQUEST_STATUS_CHANGED',
        'La solicitud cambió mientras se procesaba. Intenta de nuevo.',
      );
    }
    await tx.serviceRequestEvent.create({
      data: {
        requestId,
        event,
        fromStatus: current.status,
        toStatus: to,
        reason: extra.reason,
        actorId,
      },
    });
    return { from: current.status, to };
  }
}
