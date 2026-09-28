-- CreateEnum
CREATE TYPE "ProviderAccountStatus" AS ENUM ('INCOMPLETE', 'IN_REVIEW', 'CHANGES_REQUIRED', 'APPROVED', 'REJECTED', 'SUSPENDED');

-- CreateTable
CREATE TABLE "client_accounts" (
    "id" UUID NOT NULL,
    "identity_id" UUID NOT NULL,
    "first_name" VARCHAR(120),
    "last_name" VARCHAR(120),
    "birth_date" DATE,
    "address" JSONB,
    "is_complete" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "client_accounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "provider_accounts" (
    "id" UUID NOT NULL,
    "identity_id" UUID NOT NULL,
    "status" "ProviderAccountStatus" NOT NULL DEFAULT 'INCOMPLETE',
    "first_name" VARCHAR(120),
    "last_name" VARCHAR(120),
    "initial_category_id" UUID,
    "tasks" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "task_clarification" TEXT,
    "modality" VARCHAR(40),
    "coverage" JSONB,
    "availability" TEXT,
    "experience" TEXT,
    "indicative_price" DECIMAL(12,2),
    "hourly_rate" DECIMAL(12,2),
    "declared_credential" TEXT,
    "submitted_at" TIMESTAMP(3),
    "presentation_version" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "provider_accounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "provider_presentations" (
    "id" UUID NOT NULL,
    "provider_id" UUID NOT NULL,
    "version" INTEGER NOT NULL,
    "submitted_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "contact_email" VARCHAR(254) NOT NULL,
    "verified_phone" VARCHAR(20) NOT NULL,
    "first_name" VARCHAR(120) NOT NULL,
    "last_name" VARCHAR(120) NOT NULL,
    "initial_category_id" UUID NOT NULL,
    "category_slug" VARCHAR(120) NOT NULL,
    "category_name" VARCHAR(120) NOT NULL,
    "tasks" TEXT[],
    "task_clarification" TEXT,
    "modality" VARCHAR(40) NOT NULL,
    "coverage" JSONB NOT NULL,
    "availability" TEXT NOT NULL,
    "experience" TEXT NOT NULL,
    "indicative_price" DECIMAL(12,2),
    "hourly_rate" DECIMAL(12,2),
    "declared_credential" TEXT,

    CONSTRAINT "provider_presentations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "provider_review_decisions" (
    "id" UUID NOT NULL,
    "provider_id" UUID NOT NULL,
    "presentation_id" UUID NOT NULL,
    "admin_id" UUID NOT NULL,
    "previous_status" "ProviderAccountStatus" NOT NULL,
    "resulting_status" "ProviderAccountStatus" NOT NULL,
    "reason" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "provider_review_decisions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "service_categories" (
    "id" UUID NOT NULL,
    "name" VARCHAR(120) NOT NULL,
    "slug" VARCHAR(120) NOT NULL,
    "enabled" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "service_categories_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "client_accounts_identity_id_key" ON "client_accounts"("identity_id");

-- CreateIndex
CREATE UNIQUE INDEX "provider_accounts_identity_id_key" ON "provider_accounts"("identity_id");

-- CreateIndex
CREATE INDEX "provider_accounts_status_submitted_at_idx" ON "provider_accounts"("status", "submitted_at");

-- CreateIndex
CREATE UNIQUE INDEX "provider_presentations_provider_id_version_key" ON "provider_presentations"("provider_id", "version");

-- CreateIndex
CREATE UNIQUE INDEX "provider_presentations_id_provider_id_key" ON "provider_presentations"("id", "provider_id");

-- CreateIndex
CREATE INDEX "provider_review_decisions_presentation_id_idx" ON "provider_review_decisions"("presentation_id");

-- CreateIndex
CREATE INDEX "provider_review_decisions_provider_id_created_at_idx" ON "provider_review_decisions"("provider_id", "created_at");

-- CreateIndex
CREATE INDEX "provider_review_decisions_admin_id_created_at_idx" ON "provider_review_decisions"("admin_id", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "service_categories_slug_key" ON "service_categories"("slug");

-- AddForeignKey
ALTER TABLE "client_accounts" ADD CONSTRAINT "client_accounts_identity_id_fkey" FOREIGN KEY ("identity_id") REFERENCES "app_identities"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "provider_accounts" ADD CONSTRAINT "provider_accounts_identity_id_fkey" FOREIGN KEY ("identity_id") REFERENCES "app_identities"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "provider_accounts" ADD CONSTRAINT "provider_accounts_initial_category_id_fkey" FOREIGN KEY ("initial_category_id") REFERENCES "service_categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "provider_presentations" ADD CONSTRAINT "provider_presentations_provider_id_fkey" FOREIGN KEY ("provider_id") REFERENCES "provider_accounts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "provider_presentations" ADD CONSTRAINT "provider_presentations_initial_category_id_fkey" FOREIGN KEY ("initial_category_id") REFERENCES "service_categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "provider_review_decisions" ADD CONSTRAINT "provider_review_decisions_provider_id_fkey" FOREIGN KEY ("provider_id") REFERENCES "provider_accounts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "provider_review_decisions" ADD CONSTRAINT "provider_review_decisions_presentation_id_provider_id_fkey" FOREIGN KEY ("presentation_id", "provider_id") REFERENCES "provider_presentations"("id", "provider_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "provider_review_decisions" ADD CONSTRAINT "provider_review_decisions_admin_id_fkey" FOREIGN KEY ("admin_id") REFERENCES "admin_accounts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
