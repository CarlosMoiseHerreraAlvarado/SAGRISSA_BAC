-- SAGRISA / Supabase PostgreSQL
-- Validaciones posteriores a 001_sagrisa_schema.sql y 002_runtime_role.sql.
-- Este archivo no inserta datos demo ni modifica registros operativos.

do $$
declare
    expected_tables text[] := array[
        'usuarios', 'clientes', 'productos', 'pedidos', 'pedido_detalles',
        'facturas', 'cobros', 'aprobaciones', 'audit_events',
        'webhook_events', 'metas_comerciales'
    ];
    table_name text;
begin
    foreach table_name in array expected_tables loop
        if to_regclass(format('sagrisa.%I', table_name)) is null then
            raise exception 'Falta la tabla sagrisa.%', table_name;
        end if;
    end loop;

    if not exists (select 1 from pg_roles where rolname = 'sagrisa_api') then
        raise exception 'Falta el rol de runtime sagrisa_api. Ejecuta 002_runtime_role.sql.';
    end if;
end;
$$;

select current_database() as database_name,
       current_user as validation_user,
       current_schema() as current_schema;

select table_name,
       table_type
from information_schema.tables
where table_schema = 'sagrisa'
order by table_name;

select table_name,
       column_name,
       data_type,
       udt_name,
       is_nullable
from information_schema.columns
where table_schema = 'sagrisa'
  and table_name in (
      'usuarios', 'clientes', 'productos', 'pedidos', 'pedido_detalles',
      'facturas', 'cobros', 'aprobaciones', 'audit_events',
      'webhook_events', 'metas_comerciales'
  )
order by table_name, ordinal_position;

select n.nspname as schema_name,
       c.relname as table_name,
       c.reltuples::bigint as estimated_rows
from pg_class c
join pg_namespace n on n.oid = c.relnamespace
where n.nspname = 'sagrisa'
  and c.relkind = 'r'
order by c.relname;
