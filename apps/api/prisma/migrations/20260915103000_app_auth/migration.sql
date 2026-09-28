CREATE TYPE "AppIdentityStatus" AS ENUM ('PENDING_PHONE_VERIFICATION', 'ACTIVE', 'SUSPENDED');
CREATE TYPE "PhoneVerificationPurpose" AS ENUM ('REGISTRATION', 'SESSION');

CREATE TABLE "app_identities" (
    "id" UUID NOT NULL,
    "email" VARCHAR(254) NOT NULL,
    "password_hash" VARCHAR(255) NOT NULL,
    "phone" VARCHAR(20) NOT NULL,
    "phone_verified_at" TIMESTAMP(3),
    "status" "AppIdentityStatus" NOT NULL DEFAULT 'PENDING_PHONE_VERIFICATION',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "app_identities_pkey" PRIMARY KEY ("id")
);

CREATE TABLE "phone_verification_challenges" (
    "id" UUID NOT NULL,
    "identity_id" UUID NOT NULL,
    "purpose" "PhoneVerificationPurpose" NOT NULL,
    "code_hash" VARCHAR(255) NOT NULL,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "consumed_at" TIMESTAMP(3),
    "attempts" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "phone_verification_challenges_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "app_identities_email_key" ON "app_identities"("email");
CREATE UNIQUE INDEX "app_identities_phone_key" ON "app_identities"("phone");
CREATE INDEX "phone_verification_challenges_identity_id_purpose_expires_at_idx" ON "phone_verification_challenges"("identity_id", "purpose", "expires_at");
ALTER TABLE "phone_verification_challenges" ADD CONSTRAINT "phone_verification_challenges_identity_id_fkey" FOREIGN KEY ("identity_id") REFERENCES "app_identities"("id") ON DELETE CASCADE ON UPDATE CASCADE;
