-- SAGRISA / Supabase PostgreSQL
-- Permisos mínimos para la API ASP.NET Core.
--
-- IMPORTANTE:
-- 1) Sustituye el valor de runtime_password antes de ejecutar este archivo.
-- 2) No guardes la contraseña en Git ni en el frontend.
-- 3) Ejecuta este script en el SQL Editor de Supabase con un usuario administrador.
-- 4) La API debe conectarse con el usuario sagrisa_api (en el pooler compartido,
--    Supabase normalmente requiere el formato sagrisa_api.<project-ref>).

begin;

do $$
declare
    runtime_password text := '__REPLACE_WITH_A_LONG_RANDOM_PASSWORD__';
begin
    if runtime_password = '__REPLACE_WITH_A_LONG_RANDOM_PASSWORD__'
       or length(runtime_password) < 24 then
        raise exception 'Debes reemplazar runtime_password por una contraseña aleatoria de al menos 24 caracteres.';
    end if;

    if not exists (select 1 from pg_roles where rolname = 'sagrisa_api') then
        execute format(
            'create role sagrisa_api login password %L nosuperuser nocreatedb nocreaterole noreplication',
            runtime_password
        );
    else
        execute format('alter role sagrisa_api login password %L', runtime_password);
        alter role sagrisa_api nosuperuser nocreatedb nocreaterole noreplication;
    end if;
end;
$$;

do $$
begin
    execute format('grant connect on database %I to sagrisa_api', current_database());
end;
$$;

grant usage on schema sagrisa to sagrisa_api;
grant select, insert, update on all tables in schema sagrisa to sagrisa_api;
grant usage, select on all sequences in schema sagrisa to sagrisa_api;

-- Los objetos actuales los crea el administrador del proyecto. Estas reglas
-- cubren futuras tablas y secuencias creadas por el rol postgres en este esquema.
alter default privileges for role postgres in schema sagrisa
    grant select, insert, update on tables to sagrisa_api;
alter default privileges for role postgres in schema sagrisa
    grant usage, select on sequences to sagrisa_api;

-- La API no utiliza el Data API de Supabase. El esquema sagrisa no debe quedar
-- expuesto a los roles anon/authenticated, aunque el proyecto los tenga creados.
do $$
declare
    role_name text;
begin
    foreach role_name in array array['anon', 'authenticated'] loop
        if exists (select 1 from pg_roles where rolname = role_name) then
            execute format('revoke all on schema sagrisa from %I', role_name);
            execute format('revoke all on all tables in schema sagrisa from %I', role_name);
            execute format('revoke all on all sequences in schema sagrisa from %I', role_name);
        end if;
    end loop;
end;
$$;

commit;
