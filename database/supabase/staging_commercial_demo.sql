-- SAGRISA - datos comerciales ficticios adicionales para STAGING.
-- Ejecutar SOLO despues de staging_roles_demo.sql en el proyecto Supabase de STAGING.
-- No usar en produccion. Solo crea/actualiza registros identificados como TEST-*.
-- Seguro para reejecucion: usa UUID y codigos de prueba estables.

begin;

do $$
begin
    if not exists (
        select 1 from sagrisa.clientes
        where cod_cliente = 'TEST-CLI-001'
          and profile_id = 'a0000000-0000-4000-8000-000000000100'
    ) then
        raise exception 'No se encontro el cliente demo esperado. Ejecute primero staging_roles_demo.sql.';
    end if;

    if not exists (
        select 1 from sagrisa.usuarios
        where dui = '90000101-2'
          and cod_vendedor = 'TEST-VEND-001'
          and rol = 'Vendedor'
          and activo
    ) then
        raise exception 'No se encontro el vendedor demo esperado. No se agregaron datos.';
    end if;
end;
$$;

insert into sagrisa.productos
    (id, codigo, nombre, descripcion, familia, presentacion, precio, stock, bodega, activo)
values
    ('a0000000-0000-4000-8000-000000000202', 'TEST-PROD-002',
     'Fertilizante de prueba', 'Producto ficticio de staging.', 'Fertilizantes', 'Saco 25 kg', 40.00, 14, 'TEST', true),
    ('a0000000-0000-4000-8000-000000000203', 'TEST-PROD-003',
     'Semilla de prueba', 'Producto ficticio de staging.', 'Semillas', 'Bolsa 5 kg', 65.00, 8, 'TEST', true)
on conflict (id) do update set
    codigo = excluded.codigo,
    nombre = excluded.nombre,
    descripcion = excluded.descripcion,
    familia = excluded.familia,
    presentacion = excluded.presentacion,
    precio = excluded.precio,
    stock = excluded.stock,
    bodega = excluded.bodega,
    activo = excluded.activo
where sagrisa.productos.codigo = excluded.codigo;

insert into sagrisa.pedidos
    (id, num_pedido, cod_cliente, cod_vendedor, tpago, fecha_pedido, fecha_entrega,
     plazo_entrega_pedido, observacion, total_pedido, pais, status, est_corr, origen, estatus)
values
    ('a0000000-0000-4000-8000-000000000311', 'TEST-PED-002', 'TEST-CLI-001',
     'TEST-VEND-001', 'Credito', timezone('utc', now()) - interval '45 days',
     timezone('utc', now()) - interval '40 days', 5, 'Pedido ficticio completado para pruebas.',
     210.00, 'SV', 5, 'A', 'PWA', 'Entregado'),
    ('a0000000-0000-4000-8000-000000000312', 'TEST-PED-003', 'TEST-CLI-001',
     'TEST-VEND-001', 'Credito', timezone('utc', now()) - interval '12 days', null,
     3, 'Pedido ficticio en proceso para pruebas.', 50.00, 'SV', 3, 'A', 'PWA', 'Activo')
on conflict (id) do update set
    num_pedido = excluded.num_pedido,
    cod_cliente = excluded.cod_cliente,
    cod_vendedor = excluded.cod_vendedor,
    tpago = excluded.tpago,
    fecha_pedido = excluded.fecha_pedido,
    fecha_entrega = excluded.fecha_entrega,
    plazo_entrega_pedido = excluded.plazo_entrega_pedido,
    observacion = excluded.observacion,
    total_pedido = excluded.total_pedido,
    pais = excluded.pais,
    status = excluded.status,
    est_corr = excluded.est_corr,
    origen = excluded.origen,
    estatus = excluded.estatus,
    updated_at = timezone('utc', now())
where sagrisa.pedidos.num_pedido = excluded.num_pedido;

insert into sagrisa.pedido_detalles
    (id, order_id, num_pedido, cod_cliente, cod_producto, nom_producto,
     presentacion, cantidad, precio_unitario, precio_total, cod_vendedor, bodega, origen)
values
    ('a0000000-0000-4000-8000-000000000321', 'a0000000-0000-4000-8000-000000000311',
     'TEST-PED-002', 'TEST-CLI-001', 'TEST-PROD-002', 'Fertilizante de prueba',
     'Saco 25 kg', 2, 40.00, 80.00, 'TEST-VEND-001', 'TEST', 'PWA'),
    ('a0000000-0000-4000-8000-000000000322', 'a0000000-0000-4000-8000-000000000311',
     'TEST-PED-002', 'TEST-CLI-001', 'TEST-PROD-003', 'Semilla de prueba',
     'Bolsa 5 kg', 2, 65.00, 130.00, 'TEST-VEND-001', 'TEST', 'PWA'),
    ('a0000000-0000-4000-8000-000000000323', 'a0000000-0000-4000-8000-000000000312',
     'TEST-PED-003', 'TEST-CLI-001', 'TEST-PROD-001', 'Producto de prueba SAGRISA',
     'Unidad', 2, 25.00, 50.00, 'TEST-VEND-001', 'TEST', 'PWA')
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
    ('a0000000-0000-4000-8000-000000000402', 'TEST-FAC-002',
     'a0000000-0000-4000-8000-000000000311', 'TEST-CLI-001',
     timezone('utc', now()) - interval '45 days', timezone('utc', now()) - interval '15 days',
     210.00, 0.00, 4),
    ('a0000000-0000-4000-8000-000000000403', 'TEST-FAC-003',
     'a0000000-0000-4000-8000-000000000312', 'TEST-CLI-001',
     timezone('utc', now()) - interval '40 days', timezone('utc', now()) - interval '10 days',
     50.00, 50.00, 6)
on conflict (id) do update set
    num_factura = excluded.num_factura,
    order_id = excluded.order_id,
    cod_cliente = excluded.cod_cliente,
    fecha_emision = excluded.fecha_emision,
    fecha_vencimiento = excluded.fecha_vencimiento,
    total_factura = excluded.total_factura,
    saldo = excluded.saldo,
    status = excluded.status
where sagrisa.facturas.num_factura = excluded.num_factura;

insert into sagrisa.cobros
    (id, factura_id, num_factura, cod_cliente, cod_vendedor, monto,
     metodo_pago, referencia, status, notas, created_at)
values
    ('a0000000-0000-4000-8000-000000000501', 'a0000000-0000-4000-8000-000000000401',
     'TEST-FAC-001', 'TEST-CLI-001', 'TEST-VEND-001', 50.00, 2,
     'TEST-PAGO-001', 2, 'Pago ficticio aplicado a factura parcial.', timezone('utc', now()) - interval '8 days'),
    ('a0000000-0000-4000-8000-000000000502', 'a0000000-0000-4000-8000-000000000402',
     'TEST-FAC-002', 'TEST-CLI-001', 'TEST-VEND-001', 210.00, 1,
     'TEST-PAGO-002', 2, 'Pago ficticio aplicado a factura pagada.', timezone('utc', now()) - interval '20 days'),
    ('a0000000-0000-4000-8000-000000000503', 'a0000000-0000-4000-8000-000000000403',
     'TEST-FAC-003', 'TEST-CLI-001', 'TEST-VEND-001', 20.00, 3,
     'TEST-PAGO-003', 1, 'Pago ficticio pendiente; no reduce el saldo.', timezone('utc', now()) - interval '2 days')
on conflict (id) do update set
    factura_id = excluded.factura_id,
    num_factura = excluded.num_factura,
    cod_cliente = excluded.cod_cliente,
    cod_vendedor = excluded.cod_vendedor,
    monto = excluded.monto,
    metodo_pago = excluded.metodo_pago,
    referencia = excluded.referencia,
    status = excluded.status,
    notas = excluded.notas,
    created_at = excluded.created_at
where sagrisa.cobros.referencia = excluded.referencia;

-- Mantiene los acumulados demo consistentes con las facturas de prueba:
-- TEST-FAC-001 (75 pendiente) + TEST-FAC-003 (50 pendiente) = 125.
update sagrisa.clientes
set total_deuda = 125.00,
    saldo_credito = 375.00
where cod_cliente = 'TEST-CLI-001'
  and profile_id = 'a0000000-0000-4000-8000-000000000100';

commit;

-- Verificacion rapida al terminar:
-- select 'productos' as tabla, count(*) from sagrisa.productos where codigo like 'TEST-PROD-%'
-- union all select 'pedidos', count(*) from sagrisa.pedidos where num_pedido like 'TEST-PED-%'
-- union all select 'facturas', count(*) from sagrisa.facturas where num_factura like 'TEST-FAC-%'
-- union all select 'cobros', count(*) from sagrisa.cobros where referencia like 'TEST-PAGO-%';
