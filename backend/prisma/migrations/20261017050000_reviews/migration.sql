-- Calificaciones ciegas y promedio del empleador (ADR-0032).
-- CreateEnum
CREATE TYPE "reviewer_role" AS ENUM ('employer', 'worker');

-- AlterTable
ALTER TABLE "users" ADD COLUMN     "employer_rating_avg" DECIMAL(3,2) NOT NULL DEFAULT 0,
ADD COLUMN     "employer_rating_count" INTEGER NOT NULL DEFAULT 0;

-- CreateTable
CREATE TABLE "reviews" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "job_id" UUID NOT NULL,
    "city_id" UUID NOT NULL,
    "from_user" UUID NOT NULL,
    "to_user" UUID NOT NULL,
    "reviewer_role" "reviewer_role" NOT NULL,
    "stars" SMALLINT NOT NULL,
    "comment" TEXT,
    "comment_held" BOOLEAN NOT NULL DEFAULT false,
    "published_at" TIMESTAMPTZ(3),
    "created_at" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "reviews_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "reviews_to_user_reviewer_role_published_at_idx" ON "reviews"("to_user", "reviewer_role", "published_at");

-- CreateIndex
CREATE INDEX "reviews_published_at_created_at_idx" ON "reviews"("published_at", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "reviews_job_id_from_user_key" ON "reviews"("job_id", "from_user");

-- AddForeignKey
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_job_id_fkey" FOREIGN KEY ("job_id") REFERENCES "jobs"("id") ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE "reviews" ADD CONSTRAINT "reviews_stars_check" CHECK ("stars" BETWEEN 1 AND 5);
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_not_self_check" CHECK ("from_user" <> "to_user");
