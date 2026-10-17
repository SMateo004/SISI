import { HttpStatus, Injectable } from '@nestjs/common';
import { ApiError } from '../common/errors/api-error';

/** Flag de la pasarela automática (fase 2 del negocio, R7.4). Apagado. */
export const PAYMENT_GATEWAY_FLAG = 'payments.gateway';

export interface GatewayCheckout {
  /** URL o datos para que el trabajador pague en la pasarela. */
  checkoutUrl: string;
  /** Id del cobro en la pasarela, para conciliar el webhook. */
  externalId: string;
  expiresAt: string;
}

/**
 * Pasarela de pago automática (R7.4, fase 2 del negocio). Sin implementar: el MVP cobra por
 * QR bancario y el admin registra el pago. Cuando se elija un proveedor, se implementa esta
 * interfaz y su webhook registra el pago con el mismo servicio que usa el admin
 * (idempotente por el id externo).
 */
export interface PaymentGateway {
  createCheckout(input: {
    workerId: string;
    amountBs: string;
    reference: string;
  }): Promise<GatewayCheckout>;
}

export const PAYMENT_GATEWAY = Symbol('PAYMENT_GATEWAY');

@Injectable()
export class NoPaymentGateway implements PaymentGateway {
  createCheckout(): Promise<GatewayCheckout> {
    return Promise.reject(
      new ApiError(
        HttpStatus.SERVICE_UNAVAILABLE,
        'GATEWAY_NOT_AVAILABLE',
        'El pago en línea todavía no está disponible. Paga con el QR.',
      ),
    );
  }
}
