-- CreateEnum
CREATE TYPE "public"."FieldType" AS ENUM ('text', 'number', 'date');

-- CreateEnum
CREATE TYPE "public"."IssueSeverity" AS ENUM ('severe', 'mild', 'low');

-- CreateEnum
CREATE TYPE "public"."IssueStatus" AS ENUM ('open', 'resolved');

-- CreateEnum
CREATE TYPE "public"."AppStatus" AS ENUM ('Draft', 'Published', 'Active');

-- CreateEnum
CREATE TYPE "public"."ElementType" AS ENUM ('TEXT_FIELD', 'TEXT_AREA', 'DROPDOWN', 'CHECKBOX', 'RADIO_BUTTON', 'PHONE_FIELD', 'TOGGLE', 'DATE_PICKER', 'IMAGE', 'BUTTON', 'UPLOAD_MEDIA', 'ADD_MEDIA', 'SHAPE');

-- CreateTable
CREATE TABLE "public"."User" (
    "id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "role" TEXT NOT NULL DEFAULT 'developer',
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "verified" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."App" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "status" "public"."AppStatus" NOT NULL DEFAULT 'Draft',
    "ownerId" INTEGER NOT NULL,
    "templateId" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "App_pkey" PRIMARY KEY ("id")
);

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

-- CreateTable
CREATE TABLE "public"."Component" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "appId" INTEGER NOT NULL,
    "properties" JSONB NOT NULL,

    CONSTRAINT "Component_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Workflow" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "appId" INTEGER NOT NULL,
    "steps" JSONB NOT NULL,

    CONSTRAINT "Workflow_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Otp" (
    "id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "otp" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "used" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Otp_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Project" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "ownerId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),
    "activationDate" TIMESTAMP(3),
    "favorite" BOOLEAN DEFAULT false,
    "status" TEXT NOT NULL DEFAULT 'Inactive',

    CONSTRAINT "Project_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."AppSchema" (
    "id" SERIAL NOT NULL,
    "appId" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AppSchema_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."AppField" (
    "id" SERIAL NOT NULL,
    "schemaId" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "type" "public"."FieldType" NOT NULL,
    "constraints" JSONB NOT NULL DEFAULT '{}',
    "relatedSchemaId" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AppField_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."AppData" (
    "id" SERIAL NOT NULL,
    "schemaId" INTEGER NOT NULL,
    "data" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AppData_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Video" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Video_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."AppMetric" (
    "id" SERIAL NOT NULL,
    "appId" INTEGER NOT NULL,
    "activeDays" INTEGER NOT NULL,
    "downtime" DOUBLE PRECISION NOT NULL,
    "totalUsers" INTEGER NOT NULL,
    "traffic" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AppMetric_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."AppIssue" (
    "id" SERIAL NOT NULL,
    "appId" INTEGER NOT NULL,
    "severity" "public"."IssueSeverity" NOT NULL,
    "description" TEXT NOT NULL,
    "status" "public"."IssueStatus" NOT NULL DEFAULT 'open',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AppIssue_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."AppWarning" (
    "id" SERIAL NOT NULL,
    "appId" INTEGER NOT NULL,
    "message" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AppWarning_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Notification" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "type" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "read" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."BlacklistedToken" (
    "id" SERIAL NOT NULL,
    "token" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "BlacklistedToken_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."backup_users_20250916" (
    "id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "role" TEXT NOT NULL DEFAULT 'user',
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "verified" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "backup_users_20250916_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."backup_notifications_20250916" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "type" TEXT NOT NULL,
    "message" TEXT NOT NULL,
    "read" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "backup_notifications_20250916_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Canvas" (
    "id" SERIAL NOT NULL,
    "appId" INTEGER NOT NULL,
    "name" TEXT NOT NULL DEFAULT 'Untitled Canvas',
    "description" TEXT,
    "width" INTEGER NOT NULL DEFAULT 1200,
    "height" INTEGER NOT NULL DEFAULT 800,
    "background" JSONB NOT NULL DEFAULT '{"color": "#ffffff", "opacity": 100}',
    "gridEnabled" BOOLEAN NOT NULL DEFAULT true,
    "snapEnabled" BOOLEAN NOT NULL DEFAULT true,
    "zoomLevel" DOUBLE PRECISION NOT NULL DEFAULT 1.0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Canvas_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."CanvasElement" (
    "id" SERIAL NOT NULL,
    "canvasId" INTEGER NOT NULL,
    "elementId" TEXT NOT NULL,
    "type" "public"."ElementType" NOT NULL,
    "name" TEXT NOT NULL DEFAULT 'Untitled Element',
    "x" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "y" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "width" DOUBLE PRECISION NOT NULL DEFAULT 100,
    "height" DOUBLE PRECISION NOT NULL DEFAULT 50,
    "rotation" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "zIndex" INTEGER NOT NULL DEFAULT 0,
    "locked" BOOLEAN NOT NULL DEFAULT false,
    "visible" BOOLEAN NOT NULL DEFAULT true,
    "groupId" TEXT,
    "parentId" INTEGER,
    "properties" JSONB NOT NULL DEFAULT '{}',
    "styles" JSONB NOT NULL DEFAULT '{}',
    "constraints" JSONB NOT NULL DEFAULT '{}',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "CanvasElement_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."ElementInteraction" (
    "id" SERIAL NOT NULL,
    "elementId" INTEGER NOT NULL,
    "event" TEXT NOT NULL,
    "action" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ElementInteraction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."ElementValidation" (
    "id" SERIAL NOT NULL,
    "elementId" INTEGER NOT NULL,
    "rule" TEXT NOT NULL,
    "value" JSONB NOT NULL,
    "message" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ElementValidation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."CanvasHistory" (
    "id" SERIAL NOT NULL,
    "canvasId" INTEGER NOT NULL,
    "action" TEXT NOT NULL,
    "elementId" TEXT,
    "oldState" JSONB,
    "newState" JSONB,
    "userId" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CanvasHistory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."MediaFile" (
    "id" SERIAL NOT NULL,
    "filename" TEXT NOT NULL,
    "originalName" TEXT NOT NULL,
    "mimeType" TEXT NOT NULL,
    "size" INTEGER NOT NULL,
    "url" TEXT NOT NULL,
    "thumbnail" TEXT,
    "userId" INTEGER NOT NULL,
    "appId" INTEGER,
    "metadata" JSONB NOT NULL DEFAULT '{}',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "MediaFile_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "public"."User"("email");

-- CreateIndex
CREATE INDEX "App_ownerId_idx" ON "public"."App"("ownerId");

-- CreateIndex
CREATE INDEX "App_status_idx" ON "public"."App"("status");

-- CreateIndex
CREATE INDEX "App_templateId_idx" ON "public"."App"("templateId");

-- CreateIndex
CREATE INDEX "Template_category_idx" ON "public"."Template"("category");

-- CreateIndex
CREATE INDEX "Otp_email_type_idx" ON "public"."Otp"("email", "type");

-- CreateIndex
CREATE INDEX "Project_ownerId_idx" ON "public"."Project"("ownerId");

-- CreateIndex
CREATE INDEX "Project_status_idx" ON "public"."Project"("status");

-- CreateIndex
CREATE INDEX "Project_deletedAt_idx" ON "public"."Project"("deletedAt");

-- CreateIndex
CREATE INDEX "Project_activationDate_idx" ON "public"."Project"("activationDate");

-- CreateIndex
CREATE INDEX "idx_project_deleted" ON "public"."Project"("deletedAt");

-- CreateIndex
CREATE INDEX "idx_project_owner" ON "public"."Project"("ownerId");

-- CreateIndex
CREATE INDEX "AppSchema_appId_idx" ON "public"."AppSchema"("appId");

-- CreateIndex
CREATE INDEX "AppField_schemaId_idx" ON "public"."AppField"("schemaId");

-- CreateIndex
CREATE INDEX "AppData_schemaId_idx" ON "public"."AppData"("schemaId");

-- CreateIndex
CREATE INDEX "Video_category_idx" ON "public"."Video"("category");

-- CreateIndex
CREATE INDEX "AppMetric_appId_idx" ON "public"."AppMetric"("appId");

-- CreateIndex
CREATE INDEX "AppMetric_createdAt_idx" ON "public"."AppMetric"("createdAt");

-- CreateIndex
CREATE INDEX "AppIssue_appId_idx" ON "public"."AppIssue"("appId");

-- CreateIndex
CREATE INDEX "AppIssue_severity_idx" ON "public"."AppIssue"("severity");

-- CreateIndex
CREATE INDEX "AppIssue_status_idx" ON "public"."AppIssue"("status");

-- CreateIndex
CREATE INDEX "AppWarning_appId_idx" ON "public"."AppWarning"("appId");

-- CreateIndex
CREATE INDEX "AppWarning_createdAt_idx" ON "public"."AppWarning"("createdAt");

-- CreateIndex
CREATE INDEX "Notification_userId_idx" ON "public"."Notification"("userId");

-- CreateIndex
CREATE INDEX "Notification_read_idx" ON "public"."Notification"("read");

-- CreateIndex
CREATE INDEX "Notification_createdAt_idx" ON "public"."Notification"("createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "BlacklistedToken_token_key" ON "public"."BlacklistedToken"("token");

-- CreateIndex
CREATE INDEX "BlacklistedToken_token_idx" ON "public"."BlacklistedToken"("token");

-- CreateIndex
CREATE INDEX "BlacklistedToken_expiresAt_idx" ON "public"."BlacklistedToken"("expiresAt");

-- CreateIndex
CREATE UNIQUE INDEX "backup_users_20250916_email_key" ON "public"."backup_users_20250916"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Canvas_appId_key" ON "public"."Canvas"("appId");

-- CreateIndex
CREATE INDEX "Canvas_appId_idx" ON "public"."Canvas"("appId");

-- CreateIndex
CREATE UNIQUE INDEX "CanvasElement_elementId_key" ON "public"."CanvasElement"("elementId");

-- CreateIndex
CREATE INDEX "CanvasElement_canvasId_idx" ON "public"."CanvasElement"("canvasId");

-- CreateIndex
CREATE INDEX "CanvasElement_elementId_idx" ON "public"."CanvasElement"("elementId");

-- CreateIndex
CREATE INDEX "CanvasElement_type_idx" ON "public"."CanvasElement"("type");

-- CreateIndex
CREATE INDEX "CanvasElement_groupId_idx" ON "public"."CanvasElement"("groupId");

-- CreateIndex
CREATE INDEX "CanvasElement_zIndex_idx" ON "public"."CanvasElement"("zIndex");

-- CreateIndex
CREATE INDEX "ElementInteraction_elementId_idx" ON "public"."ElementInteraction"("elementId");

-- CreateIndex
CREATE INDEX "ElementValidation_elementId_idx" ON "public"."ElementValidation"("elementId");

-- CreateIndex
CREATE INDEX "CanvasHistory_canvasId_idx" ON "public"."CanvasHistory"("canvasId");

-- CreateIndex
CREATE INDEX "CanvasHistory_userId_idx" ON "public"."CanvasHistory"("userId");

-- CreateIndex
CREATE INDEX "CanvasHistory_createdAt_idx" ON "public"."CanvasHistory"("createdAt");

-- CreateIndex
CREATE INDEX "MediaFile_userId_idx" ON "public"."MediaFile"("userId");

-- CreateIndex
CREATE INDEX "MediaFile_appId_idx" ON "public"."MediaFile"("appId");

-- CreateIndex
CREATE INDEX "MediaFile_mimeType_idx" ON "public"."MediaFile"("mimeType");

-- AddForeignKey
ALTER TABLE "public"."App" ADD CONSTRAINT "App_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."App" ADD CONSTRAINT "App_templateId_fkey" FOREIGN KEY ("templateId") REFERENCES "public"."Template"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Component" ADD CONSTRAINT "Component_appId_fkey" FOREIGN KEY ("appId") REFERENCES "public"."App"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Workflow" ADD CONSTRAINT "Workflow_appId_fkey" FOREIGN KEY ("appId") REFERENCES "public"."App"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Project" ADD CONSTRAINT "Project_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."AppSchema" ADD CONSTRAINT "AppSchema_appId_fkey" FOREIGN KEY ("appId") REFERENCES "public"."App"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."AppField" ADD CONSTRAINT "AppField_relatedSchemaId_fkey" FOREIGN KEY ("relatedSchemaId") REFERENCES "public"."AppSchema"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."AppField" ADD CONSTRAINT "AppField_schemaId_fkey" FOREIGN KEY ("schemaId") REFERENCES "public"."AppSchema"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."AppData" ADD CONSTRAINT "AppData_schemaId_fkey" FOREIGN KEY ("schemaId") REFERENCES "public"."AppSchema"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."AppMetric" ADD CONSTRAINT "AppMetric_appId_fkey" FOREIGN KEY ("appId") REFERENCES "public"."App"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."AppIssue" ADD CONSTRAINT "AppIssue_appId_fkey" FOREIGN KEY ("appId") REFERENCES "public"."App"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."AppWarning" ADD CONSTRAINT "AppWarning_appId_fkey" FOREIGN KEY ("appId") REFERENCES "public"."App"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Notification" ADD CONSTRAINT "Notification_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Canvas" ADD CONSTRAINT "Canvas_appId_fkey" FOREIGN KEY ("appId") REFERENCES "public"."App"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."CanvasElement" ADD CONSTRAINT "CanvasElement_canvasId_fkey" FOREIGN KEY ("canvasId") REFERENCES "public"."Canvas"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."CanvasElement" ADD CONSTRAINT "CanvasElement_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "public"."CanvasElement"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ElementInteraction" ADD CONSTRAINT "ElementInteraction_elementId_fkey" FOREIGN KEY ("elementId") REFERENCES "public"."CanvasElement"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."ElementValidation" ADD CONSTRAINT "ElementValidation_elementId_fkey" FOREIGN KEY ("elementId") REFERENCES "public"."CanvasElement"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."CanvasHistory" ADD CONSTRAINT "CanvasHistory_canvasId_fkey" FOREIGN KEY ("canvasId") REFERENCES "public"."Canvas"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."CanvasHistory" ADD CONSTRAINT "CanvasHistory_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."MediaFile" ADD CONSTRAINT "MediaFile_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."MediaFile" ADD CONSTRAINT "MediaFile_appId_fkey" FOREIGN KEY ("appId") REFERENCES "public"."App"("id") ON DELETE SET NULL ON UPDATE CASCADE;
