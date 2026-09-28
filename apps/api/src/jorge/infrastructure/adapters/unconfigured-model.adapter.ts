import { Injectable } from '@nestjs/common';
import type { ModelGateway, ModelRequest, ModelResponse } from '../../domain/model-gateway.js';

@Injectable()
export class UnconfiguredModelAdapter implements ModelGateway {
  async generate(_request: ModelRequest): Promise<ModelResponse> {
    return { status: 'unavailable', reason: 'No hay un proveedor de IA habilitado para esta operación.' };
  }
}
