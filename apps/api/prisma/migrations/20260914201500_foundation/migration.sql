CREATE TABLE "runtime_probe" (
    "id" SERIAL NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "runtime_probe_pkey" PRIMARY KEY ("id")
);
