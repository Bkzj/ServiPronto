import { createParamDecorator, ExecutionContext } from '@nestjs/common';
import type { AdminRequest } from './admin-auth.guard.js';

export const CurrentAdmin = createParamDecorator((_data: unknown, context: ExecutionContext) => context.switchToHttp().getRequest<AdminRequest>().admin);
