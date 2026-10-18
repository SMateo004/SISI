-- CreateIndex
CREATE INDEX "jobs_city_id_completed_at_idx" ON "jobs"("city_id", "completed_at");

-- CreateIndex
CREATE INDEX "jobs_city_id_cancelled_at_idx" ON "jobs"("city_id", "cancelled_at");

-- CreateIndex
CREATE INDEX "jobs_status_disputed_at_idx" ON "jobs"("status", "disputed_at");

-- CreateIndex
CREATE INDEX "service_requests_city_id_created_at_idx" ON "service_requests"("city_id", "created_at");

-- CreateIndex
CREATE INDEX "worker_locations_available_located_at_idx" ON "worker_locations"("available", "located_at");

-- CreateIndex
CREATE INDEX "worker_profiles_status_submitted_at_idx" ON "worker_profiles"("status", "submitted_at");

