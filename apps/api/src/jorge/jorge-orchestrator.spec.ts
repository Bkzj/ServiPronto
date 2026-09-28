import { readdirSync, readFileSync } from 'node:fs';
import { extname, join } from 'node:path';
import { describe, expect, it } from 'vitest';
import { JorgeOrchestrator } from './application/jorge-orchestrator.service.js';
import { UnconfiguredModelAdapter } from './infrastructure/adapters/unconfigured-model.adapter.js';

describe('Jorge provider boundary', () => {
  it('reports that no provider is configured without pretending to answer', async () => {
    const result = await new JorgeOrchestrator(new UnconfiguredModelAdapter()).assist({
      executionId: 'test-1', contractVersion: '1', messages: [{ role: 'user', text: 'Necesito ayuda' }], requiredCapabilities: ['text'],
    });
    expect(result).toEqual({ status: 'unavailable', reason: 'No hay un proveedor de IA habilitado para esta operación.' });
  });

  it('keeps provider SDK imports outside the business and orchestration layers', () => {
    const sourceRoot = join(process.cwd(), 'src');
    const files = walk(sourceRoot).filter((file) => extname(file) === '.ts' && !file.endsWith('.spec.ts'));
    const forbiddenImport = /from\s+['"](?:openai|@openai\/|@google\/genai|@anthropic-ai\/sdk)/;
    const violations = files
      .filter((file) => !file.includes(`${join('infrastructure', 'adapters')}`))
      .filter((file) => forbiddenImport.test(readFileSync(file, 'utf8')));
    expect(violations).toEqual([]);
  });
});

function walk(directory: string): string[] {
  return readdirSync(directory, { withFileTypes: true }).flatMap((entry) => {
    const path = join(directory, entry.name);
    return entry.isDirectory() ? walk(path) : [path];
  });
}
