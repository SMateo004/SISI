-- Una cuenta eliminada guarda "eliminado:<id>" en lugar del teléfono (libera el número para una
-- cuenta nueva). La restricción se amplía: todo valor que el código anterior escribe sigue siendo
-- válido, así que es compatible hacia atrás.
-- contract: se reemplaza por una más amplia (no rompe al código anterior)
ALTER TABLE "users" DROP CONSTRAINT "users_phone_e164_check";
ALTER TABLE "users" ADD CONSTRAINT "users_phone_e164_check" CHECK (
  "phone" ~ '^[+][1-9][0-9]{7,14}$'
  OR ("deleted_at" IS NOT NULL AND "phone" = 'eliminado:' || "id"::text)
);

