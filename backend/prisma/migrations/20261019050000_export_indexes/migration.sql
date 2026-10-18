-- CreateIndex
CREATE INDEX "ledger_entries_created_at_id_idx" ON "ledger_entries"("created_at", "id");

-- CreateIndex
CREATE INDEX "ledger_entries_type_created_at_idx" ON "ledger_entries"("type", "created_at");

-- CreateIndex
CREATE INDEX "payments_paid_at_id_idx" ON "payments"("paid_at", "id");

