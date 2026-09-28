import { Inject, Injectable } from '@nestjs/common';
import { MODEL_GATEWAY, type ModelGateway, type ModelRequest, type ModelResponse } from '../domain/model-gateway.js';

@Injectable()
export class JorgeOrchestrator {
  constructor(@Inject(MODEL_GATEWAY) private readonly gateway: ModelGateway) {}

  assist(request: ModelRequest): Promise<ModelResponse> {
    return this.gateway.generate(request);
  }
}
