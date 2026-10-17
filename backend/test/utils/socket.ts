import { io, type Socket } from 'socket.io-client';
import {
  type RealtimeEventName,
  RealtimeEvents,
  type RealtimePayloads,
} from '../../src/realtime/realtime.events';
import type { TestApp } from './test-app';

/** Cliente Socket.IO de prueba que guarda lo que recibe y permite esperarlo. */
export interface TestSocket {
  socket: Socket;
  received: { event: string; payload: unknown }[];
  next<E extends RealtimeEventName>(
    event: E,
    match?: (p: RealtimePayloads[E]) => boolean,
    timeoutMs?: number,
  ): Promise<RealtimePayloads[E]>;
  close(): void;
}

const ALL_EVENTS: RealtimeEventName[] = Object.values(RealtimeEvents);

/** Conecta con el token dado; falla con el `code` del servidor si el handshake es rechazado. */
export async function connectSocket(t: TestApp, token: string | undefined): Promise<TestSocket> {
  const socket = io(t.url, {
    auth: token === undefined ? {} : { token },
    transports: ['websocket'],
    reconnection: false,
    forceNew: true,
  });
  const received: { event: string; payload: unknown }[] = [];
  const waiters: (() => void)[] = [];
  for (const event of ALL_EVENTS) {
    socket.on(event, (payload: unknown) => {
      received.push({ event, payload });
      for (const w of waiters.splice(0)) w();
    });
  }

  await new Promise<void>((resolve, reject) => {
    socket.once('connect', () => {
      resolve();
    });
    socket.once('connect_error', (err: Error & { data?: { code?: string } }) => {
      socket.close();
      reject(Object.assign(new Error(err.message), { code: err.data?.code }));
    });
  });

  const next: TestSocket['next'] = (event, match, timeoutMs = 5000) =>
    new Promise((resolve, reject) => {
      const deadline = setTimeout(() => {
        reject(new Error(`No llegó ${event} en ${timeoutMs} ms`));
      }, timeoutMs);
      const check = (): boolean => {
        const found = received.find(
          (r) =>
            r.event === event && (!match || match(r.payload as RealtimePayloads[typeof event])),
        );
        if (!found) return false;
        clearTimeout(deadline);
        received.splice(received.indexOf(found), 1);
        resolve(found.payload as RealtimePayloads[typeof event]);
        return true;
      };
      const wait = (): void => {
        if (!check()) waiters.push(wait);
      };
      wait();
    });

  return { socket, received, next, close: () => socket.close() };
}
