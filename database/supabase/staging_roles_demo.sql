-- SAGRISA - usuarios y datos ficticios para pruebas de staging.
-- Ejecutar solamente en el SQL Editor del proyecto de STAGING, despues de
-- aplicar database/supabase/001_sagrisa_schema.sql. No es una migracion de produccion.
-- Crea Cliente, Vendedor, Supervisor, Gerente y Director; no crea Admin.
-- Los PIN se convierten a BCrypt en PostgreSQL y nunca se guardan en texto plano.
-- Los registros TEST-* son sinteticos. Ejecutar de nuevo actualiza estos mismos registros.

begin;

insert into sagrisa.usuarios
    (id, dui, pin_hash, nombre, division, pais, cod_vendedor, cargo, email,
     cambiado, doc_personal, gerenciado_por, supervisado_por, rol, activo,
     is_offline_capable)
values
    ('a0000000-0000-4000-8000-000000000100', '90000100-1', crypt('583104', gen_salt('bf', 11)),
     'Cliente de Prueba SAGRISA', 'Clientes', 'El Salvador', null, 'Cliente',
     'cliente.prueba@sagrisa.local', 'N', 'TEST-CLIENTE', null, null, 'Cliente', true, false),
    ('a0000000-0000-4000-8000-000000000101', '90000101-2', crypt('614927', gen_salt('bf', 11)),
     'Vendedor de Prueba SAGRISA', 'Ventas', 'El Salvador', 'TEST-VEND-001', 'Vendedor',
     'vendedor.prueba@sagrisa.local', 'N', 'TEST-VENDEDOR', null, null, 'Vendedor', true, false),
    ('a0000000-0000-4000-8000-000000000102', '90000102-3', crypt('738205', gen_salt('bf', 11)),
     'Supervisor de Prueba SAGRISA', 'Ventas', 'El Salvador', null, 'Supervisor',
     'supervisor.prueba@sagrisa.local', 'N', 'TEST-SUPERVISOR', null, null, 'Supervisor', true, false),
    ('a0000000-0000-4000-8000-000000000103', '90000103-4', crypt('492681', gen_salt('bf', 11)),
     'Gerente de Prueba SAGRISA', 'Ventas', 'El Salvador', null, 'Gerente',
     'gerente.prueba@sagrisa.local', 'N', 'TEST-GERENTE', null, null, 'Gerente', true, false),
    ('a0000000-0000-4000-8000-000000000104', '90000104-5', crypt('865310', gen_salt('bf', 11)),
     'Director de Prueba SAGRISA', 'Direccion', 'El Salvador', null, 'Director',
     'director.prueba@sagrisa.local', 'N', 'TEST-DIRECTOR', null, null, 'Director', true, false)
on conflict (id) do update set
    dui = excluded.dui,
    pin_hash = excluded.pin_hash,
    nombre = excluded.nombre,
    division = excluded.division,
    pais = excluded.pais,
    cod_vendedor = excluded.cod_vendedor,
    cargo = excluded.cargo,
    email = excluded.email,
    cambiado = excluded.cambiado,
    doc_personal = excluded.doc_personal,
    gerenciado_por = excluded.gerenciado_por,
    supervisado_por = excluded.supervisado_por,
    rol = excluded.rol,
    activo = excluded.activo,
    is_offline_capable = excluded.is_offline_capable,
    updated_at = timezone('utc', now());

-- Asigna el usuario de ventas a las jerarquias para verificar el alcance
-- real de Supervisor y Gerente sin usar codigos de vendedores reales.
update sagrisa.usuarios
set supervisado_por = '90000102-3', gerenciado_por = '90000103-4',
    updated_at = timezone('utc', now())
where id = 'a0000000-0000-4000-8000-000000000101';

insert into sagrisa.clientes as current_customer
    (cod_cliente, profile_id, nom_cliente, dui, clase, vendedor, ciudad, direccion,
     telefono, tpago, inactive, hold, l_precios, monto_credito, total_deuda,
     saldo_credito, correo)
values
    ('TEST-CLI-001', 'a0000000-0000-4000-8000-000000000100', 'Cliente de Prueba SAGRISA',
     '90000100-1', 'Retail', 'TEST-VEND-001', 'San Salvador', 'Direccion ficticia de pruebas',
     null, 'Credito', 0, 0, 'TEST', 500.00, 75.00, 425.00,
     'cliente.prueba@sagrisa.local')
on conflict (cod_cliente) do update set
    profile_id = excluded.profile_id,
    nom_cliente = excluded.nom_cliente,
    dui = excluded.dui,
    clase = excluded.clase,
    vendedor = excluded.vendedor,
    ciudad = excluded.ciudad,
    direccion = excluded.direccion,
    tpago = excluded.tpago,
    inactive = excluded.inactive,
    hold = excluded.hold,
    l_precios = excluded.l_precios,
    monto_credito = excluded.monto_credito,
    total_deuda = excluded.total_deuda,
    saldo_credito = excluded.saldo_credito,
    correo = excluded.correo
where current_customer.profile_id is null
   or current_customer.profile_id = excluded.profile_id;

insert into sagrisa.productos
    (id, codigo, nombre, descripcion, familia, presentacion, precio, stock, bodega, activo)
values
    ('a0000000-0000-4000-8000-000000000201', 'TEST-PROD-001',
     'Producto de prueba SAGRISA', 'Registro ficticio para validar catalogo y pedidos.',
     'Agrícola', 'Unidad', 25.00, 20, 'TEST', true)
on conflict (id) do update set
    codigo = excluded.codigo,
    nombre = excluded.nombre,
    descripcion = excluded.descripcion,
    familia = excluded.familia,
    presentacion = excluded.presentacion,
    precio = excluded.precio,
    stock = excluded.stock,
    bodega = excluded.bodega,
    activo = excluded.activo;

insert into sagrisa.pedidos
    (id, num_pedido, cod_cliente, cod_vendedor, tpago, observacion,
     total_pedido, pais, status, est_corr, origen, estatus)
values
    ('a0000000-0000-4000-8000-000000000301', 'TEST-PED-001', 'TEST-CLI-001',
     'TEST-VEND-001', 'Credito', 'Pedido ficticio para pruebas de roles.',
     125.00, 'SV', 3, 'A', 'PWA', 'Activo')
on conflict (id) do update set
    num_pedido = excluded.num_pedido,
    cod_cliente = excluded.cod_cliente,
    cod_vendedor = excluded.cod_vendedor,
    tpago = excluded.tpago,
    observacion = excluded.observacion,
    total_pedido = excluded.total_pedido,
    status = excluded.status,
    est_corr = excluded.est_corr,
    updated_at = timezone('utc', now());

insert into sagrisa.pedido_detalles
    (id, order_id, num_pedido, cod_cliente, cod_producto, nom_producto,
     presentacion, cantidad, precio_unitario, precio_total, cod_vendedor,
     bodega, origen)
values
    ('a0000000-0000-4000-8000-000000000302',
     'a0000000-0000-4000-8000-000000000301', 'TEST-PED-001', 'TEST-CLI-001',
     'TEST-PROD-001', 'Producto de prueba SAGRISA', 'Unidad', 5, 25.00,
     125.00, 'TEST-VEND-001', 'TEST', 'PWA')
on conflict (id) do update set
    order_id = excluded.order_id,
    num_pedido = excluded.num_pedido,
    cod_cliente = excluded.cod_cliente,
    cod_producto = excluded.cod_producto,
    nom_producto = excluded.nom_producto,
    presentacion = excluded.presentacion,
    cantidad = excluded.cantidad,
    precio_unitario = excluded.precio_unitario,
    precio_total = excluded.precio_total,
    cod_vendedor = excluded.cod_vendedor,
    bodega = excluded.bodega,
    origen = excluded.origen;

insert into sagrisa.facturas
    (id, num_factura, order_id, cod_cliente, fecha_emision, fecha_vencimiento,
     total_factura, saldo, status)
values
    ('a0000000-0000-4000-8000-000000000401', 'TEST-FAC-001',
     'a0000000-0000-4000-8000-000000000301', 'TEST-CLI-001',
     timezone('utc', now()), timezone('utc', now()) + interval '30 days',
     125.00, 75.00, 3)
on conflict (id) do update set
    num_factura = excluded.num_factura,
    order_id = excluded.order_id,
    cod_cliente = excluded.cod_cliente,
    fecha_emision = excluded.fecha_emision,
    fecha_vencimiento = excluded.fecha_vencimiento,
    total_factura = excluded.total_factura,
    saldo = excluded.saldo,
    status = excluded.status;

do $$
begin
    if not exists (
        select 1 from sagrisa.clientes
        where cod_cliente = 'TEST-CLI-001'
          and profile_id = 'a0000000-0000-4000-8000-000000000100'
          and vendedor = 'TEST-VEND-001'
    ) then
        raise exception 'TEST-CLI-001 ya existe y no pertenece a esta semilla. No se aplicaron los datos de prueba.';
    end if;
end;
$$;

commit;

-- Accesos ficticios para compartir solamente con el equipo de pruebas:
-- Cliente:    DUI 90000100-1 / PIN 583104
-- Vendedor:   DUI 90000101-2 / PIN 614927
-- Supervisor: DUI 90000102-3 / PIN 738205
-- Gerente:    DUI 90000103-4 / PIN 492681
-- Director:   DUI 90000104-5 / PIN 865310
-- Retirar o desactivar estas cuentas y los registros TEST-* al terminar.
