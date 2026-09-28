export type ModelCapability = 'text' | 'image' | 'tools';

export type ModelRequest = {
  executionId: string;
  contractVersion: '1';
  messages: ReadonlyArray<{ role: 'system' | 'user' | 'assistant'; text: string }>;
  requiredCapabilities: ReadonlyArray<ModelCapability>;
};

export type ModelResponse =
  | { status: 'completed'; text: string; provider: string; model: string }
  | { status: 'unavailable'; reason: string };

export interface ModelGateway {
  generate(request: ModelRequest): Promise<ModelResponse>;
}

export const MODEL_GATEWAY = Symbol('MODEL_GATEWAY');
