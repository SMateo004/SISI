-- CreateIndex
CREATE INDEX "billing_periods_start_at_idx" ON "billing_periods"("start_at");

-- CreateIndex
CREATE INDEX "billing_periods_status_start_at_idx" ON "billing_periods"("status", "start_at");

