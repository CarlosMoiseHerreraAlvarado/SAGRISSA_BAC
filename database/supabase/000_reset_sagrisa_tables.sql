-- SAGRISA / Supabase PostgreSQL
-- RESET DESTRUCTIVO Y ACOTADO.
--
-- Elimina únicamente las tablas conocidas de la aplicación SAGRISA en los
-- esquemas public y sagrisa. No elimina auth, storage, extensiones, usuarios
-- internos de Supabase ni otros objetos que no pertenezcan a esta aplicación.
--
-- Ejecutar SOLO después de verificar que el proyecto Supabase seleccionado es
-- el correcto y que no se necesita conservar los datos actuales.
-- Este archivo no se puede deshacer.

begin;

do $$
declare
    schema_name text;
    table_name text;
    application_tables text[] := array[
        'pedido_detalles',
        'cobros',
        'facturas',
        'aprobaciones',
        'producto_lotes',
        'outbox_events',
        'webhook_events',
        'audit_events',
        'pedidos',
        'metas_divisiones',
        'metas_comerciales',
        'productos',
        'clientes',
        'usuarios'
    ];
begin
    foreach schema_name in array array['public', 'sagrisa'] loop
        foreach table_name in array application_tables loop
            if to_regclass(format('%I.%I', schema_name, table_name)) is not null then
                -- RESTRICT hace que el reset falle en vez de borrar objetos
                -- desconocidos que dependan de una tabla de SAGRISA.
                execute format('drop table %I.%I restrict', schema_name, table_name);
            end if;
        end loop;
    end loop;
end;
$$;

drop function if exists public.set_updated_at() restrict;
drop function if exists sagrisa.set_updated_at() restrict;

commit;

-- Después de que este archivo termine correctamente, ejecuta en este orden:
-- 1) 001_sagrisa_schema.sql
-- 2) 002_runtime_role.sql, sustituyendo antes la contraseña de sagrisa_api
-- 3) 003_validation.sql
