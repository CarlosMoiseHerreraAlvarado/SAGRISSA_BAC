-- SAGRISA / Supabase PostgreSQL
-- Migracion 004: relaciones de aprobacion y protecciones de idempotencia.
-- Ejecutar despues de 001_initial_schema.sql en el SQL Editor de Supabase.

begin;

alter table if exists public.aprobaciones
    add column if not exists num_pedido text;

create unique index if not exists ux_aprobaciones_num_pedido
    on public.aprobaciones (num_pedido)
    where num_pedido is not null;

create index if not exists ix_pedidos_cliente_status_fecha
    on public.pedidos (cod_cliente, status, fecha_pedido desc);

create index if not exists ix_cobros_factura_status
    on public.cobros (factura_id, status, created_at desc);

commit;
