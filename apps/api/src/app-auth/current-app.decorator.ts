import { createParamDecorator, type ExecutionContext } from '@nestjs/common';
import type { AppRequest } from './app-auth.guard.js';

export const CurrentApp = createParamDecorator((_data: unknown, context: ExecutionContext) =>
  context.switchToHttp().getRequest<AppRequest>().appSession);
