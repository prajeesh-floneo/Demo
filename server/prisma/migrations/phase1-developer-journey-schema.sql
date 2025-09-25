-- Phase 1: Developer Journey Schema Updates
-- Date: September 16, 2025
-- Description: Add Template model, AppStatus enum, remove unnecessary models, simplify App relationships

-- CreateEnum
CREATE TYPE "public"."AppStatus" AS ENUM ('Draft', 'Published', 'Active');

-- DropForeignKey
ALTER TABLE "public"."ProjectInvite" DROP CONSTRAINT "ProjectInvite_projectId_fkey";

-- DropForeignKey
ALTER TABLE "public"."ProjectMember" DROP CONSTRAINT "ProjectMember_projectId_fkey";

-- DropForeignKey
ALTER TABLE "public"."ProjectMember" DROP CONSTRAINT "ProjectMember_userId_fkey";

-- DropForeignKey
ALTER TABLE "public"."RefreshToken" DROP CONSTRAINT "RefreshToken_userId_fkey";

-- AlterTable
ALTER TABLE "public"."App" ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "description" TEXT,
ADD COLUMN     "status" "public"."AppStatus" NOT NULL DEFAULT 'Draft',
ADD COLUMN     "templateId" INTEGER,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "public"."User" ALTER COLUMN "role" SET DEFAULT 'developer',
ALTER COLUMN "verified" SET DEFAULT true;

-- DropTable
DROP TABLE "public"."ProjectInvite";

-- DropTable
DROP TABLE "public"."ProjectMember";

-- DropTable
DROP TABLE "public"."RefreshToken";

-- CreateTable
CREATE TABLE "public"."Template" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "preview_image" TEXT,
    "app_schema" JSONB NOT NULL,
    "category" TEXT NOT NULL DEFAULT 'General',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Template_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "Template_category_idx" ON "public"."Template"("category");

-- CreateIndex
CREATE INDEX "App_userId_idx" ON "public"."App"("userId");

-- CreateIndex
CREATE INDEX "App_status_idx" ON "public"."App"("status");

-- CreateIndex
CREATE INDEX "App_templateId_idx" ON "public"."App"("templateId");

-- AddForeignKey
ALTER TABLE "public"."App" ADD CONSTRAINT "App_templateId_fkey" FOREIGN KEY ("templateId") REFERENCES "public"."Template"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- Verification queries to check the changes
-- SELECT * FROM "public"."Template" LIMIT 5;
-- SELECT id, name, status, templateId FROM "public"."App" LIMIT 5;
-- SELECT id, email, role, verified FROM "public"."User" LIMIT 5;
