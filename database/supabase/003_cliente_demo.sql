-- SAGRISA / Supabase PostgreSQL
-- Cuenta DEMO de cliente. Ejecutar despues de 001_initial_schema.sql.
-- Credenciales demo: DUI 00555555-5 / PIN 55555.
-- No usar estas credenciales en produccion.

begin;

insert into public.usuarios
    (id, dui, pin_hash, nombre, division, pais, cod_vendedor, cargo, email,
     cambiado, doc_personal, rol, is_active, is_offline_capable)
values
    ('44444444-4444-4444-4444-444444444444', '00555555-5',
     crypt('55555', gen_salt('bf', 11)), 'Cliente Demo SAGRISA', 'Clientes',
     'El Salvador', null, 'Cliente', 'cliente.demo@sagrisa.com',
     'N', 'DOC004', 'Cliente', true, false)
on conflict (id) do update set
    pin_hash = excluded.pin_hash,
    dui = excluded.dui,
    nombre = excluded.nombre,
    division = excluded.division,
    cargo = excluded.cargo,
    email = excluded.email,
    rol = excluded.rol,
    is_active = excluded.is_active,
    is_offline_capable = excluded.is_offline_capable,
    updated_at = now();

insert into public.clientes
    (cod_cliente, profile_id, nom_cliente, dui, clase, vendedor, ciudad, direccion,
     telefono, tpago, inactive, hold, l_precios, monto_credito, total_deuda,
     saldo_credito, correo)
values
    ('C006', '44444444-4444-4444-4444-444444444444', 'Cliente Demo SAGRISA',
     '00555555-5', 'Retail', null, 'San Salvador', 'Direccion demo',
     '+503 7000-0000', 'Contado', 0, 0, 'LP01', 2000.00, 0.00,
     2000.00, 'cliente.demo@sagrisa.com')
on conflict (cod_cliente) do update set
    profile_id = excluded.profile_id,
    nom_cliente = excluded.nom_cliente,
    dui = excluded.dui,
    clase = excluded.clase,
    vendedor = excluded.vendedor,
    ciudad = excluded.ciudad,
    direccion = excluded.direccion,
    telefono = excluded.telefono,
    tpago = excluded.tpago,
    inactive = excluded.inactive,
    hold = excluded.hold,
    l_precios = excluded.l_precios,
    monto_credito = excluded.monto_credito,
    total_deuda = excluded.total_deuda,
    saldo_credito = excluded.saldo_credito,
    correo = excluded.correo;

commit;