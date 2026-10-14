import { SetMetadata } from '@nestjs/common';
import type { RateLimitPolicy } from './rate-limit.policies';

export const RATE_LIMIT_KEY = 'sisi:rate-limit';

/** Aplica una o más políticas de límite por IP al endpoint (ver rate-limit.policies.ts). */
export const RateLimit = (...policies: RateLimitPolicy[]) => SetMetadata(RATE_LIMIT_KEY, policies);
