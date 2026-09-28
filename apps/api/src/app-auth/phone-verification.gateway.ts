export const PHONE_VERIFICATION_GATEWAY = Symbol('PHONE_VERIFICATION_GATEWAY');

export type PhoneVerificationDelivery = {
  phone: string;
  code: string;
  purpose: 'REGISTRATION' | 'SESSION';
  expiresAt: Date;
};

export interface PhoneVerificationGateway {
  deliver(delivery: PhoneVerificationDelivery): Promise<void>;
}
