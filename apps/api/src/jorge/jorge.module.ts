import { Module } from '@nestjs/common';
import { JorgeOrchestrator } from './application/jorge-orchestrator.service.js';
import { MODEL_GATEWAY } from './domain/model-gateway.js';
import { UnconfiguredModelAdapter } from './infrastructure/adapters/unconfigured-model.adapter.js';

@Module({
  providers: [
    JorgeOrchestrator,
    UnconfiguredModelAdapter,
    { provide: MODEL_GATEWAY, useExisting: UnconfiguredModelAdapter },
  ],
  exports: [JorgeOrchestrator, MODEL_GATEWAY],
})
export class JorgeModule {}
