-- SAGRISA / Supabase PostgreSQL
-- Datos DEMO solamente. No ejecutar en produccion.
-- Los PIN se almacenan unicamente como hashes BCrypt.

begin;

insert into public.usuarios
    (id, dui, pin_hash, nombre, division, pais, cod_vendedor, cargo, email,
     cambiado, doc_personal, rol, is_active, is_offline_capable)
values
    ('11111111-1111-1111-1111-111111111111', '00123456-7',
     '$2a$11$21SCS.BeuddjK.lWzp2LceBjPIMLxnttSVMmnwl1SXznKV3DA8Dgm',
     'Marcos Antonio Gutierrez', 'Ventas', 'El Salvador', 'GTCMARCOS',
     'Vendedor', 'marcos@sagrisa.com', 'N', 'DOC001', 'Vendedor', true, true),
    ('22222222-2222-2222-2222-222222222222', '00765432-1',
     '$2a$11$LU9n/VquYRmVXa2UWehsE.9iuP37rzZmN19bi.EZD03VNEJQrAYOK',
     'Juan Carlos Perez', 'Ventas', 'El Salvador', 'GTJUAN',
     'Vendedor Senior', 'juan@sagrisa.com', 'N', 'DOC002', 'Vendedor', true, true),
    ('33333333-3333-3333-3333-333333333333', '00987654-3',
     '$2a$11$HrIvmhrI7Pd5wTVxAnPv..YDUojbOXiYJTtIi2d43lbwxF6rUcaG6',
     'Maria Lopez', 'Administracion', 'El Salvador', 'GTMARIA',
     'Gerente', 'maria@sagrisa.com', 'N', 'DOC003', 'Admin', true, false)
on conflict (id) do update set
    pin_hash = excluded.pin_hash,
    nombre = excluded.nombre,
    rol = excluded.rol,
    is_active = excluded.is_active,
    updated_at = now();

insert into public.clientes
    (cod_cliente, nom_cliente, clase, vendedor, ciudad, direccion, telefono,
     tpago, inactive, hold, l_precios, monto_credito, total_deuda, saldo_credito, correo)
values
    ('C001', 'Distribuidora La Paz S.A. de C.V.', 'Mayorista', 'GTCMARCOS',
     'San Salvador', 'Calle Principal #123, San Salvador', '+503 2222-1111',
     'Credito', 0, 0, 'LP01', 5000.00, 1200.00, 3800.00, 'lapaz@correo.com'),
    ('C002', 'Supermercados El Ahorro', 'Retail', 'GTCMARCOS',
     'Santa Tecla', 'Av. San Martin #45, Santa Tecla', '+503 2222-2222',
     'Contado', 0, 0, 'LP02', 10000.00, 0.00, 10000.00, 'ahorro@correo.com'),
    ('C003', 'Bodega San Miguel (INACTIVO)', 'Minorista', 'GTJUAN',
     'San Miguel', 'Carretera Panamericana Km 130', '+503 2660-3333',
     'Credito', 1, 0, 'LP01', 2000.00, 2000.00, 0.00, 'bodegasm@correo.com'),
    ('C004', 'Comercial Los Pinos (BLOQUEADO)', 'Mayorista', 'GTCMARCOS',
     'Sonsonate', 'Barrio El Centro, Sonsonate', '+503 2450-4444',
     'Credito', 0, 1, 'LP03', 3000.00, 3500.00, -500.00, 'lospinos@correo.com'),
    ('C005', 'Tienda Express', 'Minorista', 'GTJUAN',
     'Usulutan', 'Plaza Central Local 4', '+503 2662-5555',
     'Contado', 0, 0, 'LP02', 1500.00, 300.00, 1200.00, 'expres@correo.com')
on conflict (cod_cliente) do update set
    nom_cliente = excluded.nom_cliente,
    vendedor = excluded.vendedor,
    inactive = excluded.inactive,
    hold = excluded.hold,
    total_deuda = excluded.total_deuda,
    saldo_credito = excluded.saldo_credito;

insert into public.productos
    (id, codigo, nombre, descripcion, familia, presentacion, precio, stock, bodega, activo)
values
    ('aaaaaaaa-1111-1111-1111-111111111111', 'P001', 'Aceite Vegetal 1L',
     'Aceite vegetal 100% puro para cocina', 'Abarrotes', 'Unidad', 10.50, 250, 'B01', true),
    ('bbbbbbbb-2222-2222-2222-222222222222', 'P002', 'Arroz Premium 5lb',
     'Arroz grano entero seleccionado', 'Granos Básicos', 'Bolsa', 10.50, 500, 'B01', true),
    ('cccccccc-3333-3333-3333-333333333333', 'P003', 'Cafe Molido 1lb',
     'Café arábica de altura tostado medio', 'Bebidas', 'Paquete', 8.75, 120, 'B02', true),
    ('dddddddd-4444-4444-4444-444444444444', 'P004', 'Jabon en Barra',
     'Jabón multiusos para lavado', 'Limpieza', 'Unidad', 5.78, 300, 'B01', true),
    ('eeeeeeee-5555-5555-5555-555555555555', 'P005', 'Producto Descontinuado',
     'Item fuera de catalogo', 'Varios', 'Caja', 15.00, 0, 'B03', false)
on conflict (id) do update set
    nombre = excluded.nombre,
    precio = excluded.precio,
    stock = excluded.stock,
    activo = excluded.activo;

insert into public.pedidos
    (id, num_pedido, cod_cliente, cod_vendedor, tpago, fecha_pedido, fecha_entrega,
     plazo_entrega_pedido, observacion, total_pedido, pais, id_direccion,
     direccion_entrega, status, est_corr, fech_hora_insert, origen, estatus, num_factura)
values
    ('11111111-aaaa-aaaa-aaaa-111111111111', '00012345', 'C001', 'GTCMARCOS', 'Credito',
     '2026-07-15 10:30:00+00', '2026-07-20 00:00:00+00', 5,
     'Pedido de prueba - entrega en bodega', 262.50, 'SV', 1,
     'Calle Principal #123, San Salvador', 3, 'A', '2026-07-15 10:30:00+00',
     'PWA', 'Activo', ''),
    ('22222222-bbbb-bbbb-bbbb-222222222222', '00012346', 'C002', 'GTCMARCOS', 'Contado',
     '2026-07-16 14:00:00+00', '2026-07-18 00:00:00+00', 2,
     'Entrega en tienda principal', 787.50, 'SV', 2,
     'Av. San Martin #45, Santa Tecla', 5, 'E', '2026-07-16 14:00:00+00',
     'PWA', 'Procesado', 'FAC-001')
on conflict (id) do update set
    estatus = excluded.estatus,
    num_factura = excluded.num_factura,
    updated_at = now();

insert into public.pedido_detalles
    (id, order_id, num_pedido, cod_cliente, cod_producto, nom_producto, presentacion,
     cantidad, precio_unitario, precio_total, cod_vendedor, bodega, origen)
values
    ('11111111-aaaa-aaaa-aaaa-000000000001', '11111111-aaaa-aaaa-aaaa-111111111111',
     '00012345', 'C001', 'P001', 'Aceite Vegetal 1L', 'Unidad', 15, 10.50, 157.50,
     'GTCMARCOS', 'B01', 'PWA'),
    ('11111111-aaaa-aaaa-aaaa-000000000002', '11111111-aaaa-aaaa-aaaa-111111111111',
     '00012345', 'C001', 'P002', 'Arroz Premium 5lb', 'Bolsa', 10, 10.50, 105.00,
     'GTCMARCOS', 'B01', 'PWA'),
    ('22222222-bbbb-bbbb-bbbb-000000000001', '22222222-bbbb-bbbb-bbbb-222222222222',
     '00012346', 'C002', 'P003', 'Cafe Molido 1lb', 'Paquete', 50, 8.75, 437.50,
     'GTCMARCOS', 'B02', 'PWA'),
    ('22222222-bbbb-bbbb-bbbb-000000000002', '22222222-bbbb-bbbb-bbbb-222222222222',
     '00012346', 'C002', 'P001', 'Aceite Vegetal 1L', 'Unidad', 20, 10.50, 210.00,
     'GTCMARCOS', 'B02', 'PWA')
on conflict (id) do nothing;

insert into public.facturas
    (id, num_factura, cod_cliente, fecha_emision, fecha_vencimiento,
     total_factura, saldo, status)
values
    ('f1111111-1111-1111-1111-111111111111', 'FAC-2026-001', 'C001',
     '2026-07-10 00:00:00+00', '2026-08-10 00:00:00+00', 1200.00, 1200.00, 1),
    ('f2222222-2222-2222-2222-222222222222', 'FAC-2026-002', 'C004',
     '2026-06-01 00:00:00+00', '2026-07-01 00:00:00+00', 3500.00, 3500.00, 6)
on conflict (id) do update set
    saldo = excluded.saldo,
    status = excluded.status;

commit;

