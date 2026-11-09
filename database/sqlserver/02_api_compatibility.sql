/*
    SAGRISA - compatibilidad de la API con el esquema canónico

    Ejecutar después de 01_sagrisa_schema.sql y antes de conectar la API.
    Este script no importa movil.sql. Agrega únicamente los campos operativos
    que necesita la API actual mientras el ETL del legado se define.
*/

SET XACT_ABORT ON;
SET NOCOUNT ON;
GO

BEGIN TRANSACTION;

/* Usuarios y autenticación DUI/PIN. */
IF COL_LENGTH(N'dbo.usuarios', N'dui') IS NULL ALTER TABLE dbo.usuarios ADD dui nvarchar(20) NULL;
IF COL_LENGTH(N'dbo.usuarios', N'pin_hash') IS NULL ALTER TABLE dbo.usuarios ADD pin_hash nvarchar(255) NULL;
IF COL_LENGTH(N'dbo.usuarios', N'division') IS NULL ALTER TABLE dbo.usuarios ADD division nvarchar(80) NULL;
IF COL_LENGTH(N'dbo.usuarios', N'pais') IS NULL ALTER TABLE dbo.usuarios ADD pais nvarchar(80) NULL;
IF COL_LENGTH(N'dbo.usuarios', N'cod_vendedor') IS NULL ALTER TABLE dbo.usuarios ADD cod_vendedor nvarchar(50) NULL;
IF COL_LENGTH(N'dbo.usuarios', N'cargo') IS NULL ALTER TABLE dbo.usuarios ADD cargo nvarchar(100) NULL;
IF COL_LENGTH(N'dbo.usuarios', N'cambiado') IS NULL ALTER TABLE dbo.usuarios ADD cambiado nvarchar(1) NOT NULL CONSTRAINT DF_usuarios_cambiado DEFAULT N'N';
IF COL_LENGTH(N'dbo.usuarios', N'doc_personal') IS NULL ALTER TABLE dbo.usuarios ADD doc_personal nvarchar(50) NULL;
IF COL_LENGTH(N'dbo.usuarios', N'fecha_sesion') IS NULL ALTER TABLE dbo.usuarios ADD fecha_sesion datetime2(3) NULL;
IF COL_LENGTH(N'dbo.usuarios', N'gerenciado_por') IS NULL ALTER TABLE dbo.usuarios ADD gerenciado_por nvarchar(20) NULL;
IF COL_LENGTH(N'dbo.usuarios', N'supervisado_por') IS NULL ALTER TABLE dbo.usuarios ADD supervisado_por nvarchar(20) NULL;
IF COL_LENGTH(N'dbo.usuarios', N'is_offline_capable') IS NULL ALTER TABLE dbo.usuarios ADD is_offline_capable bit NOT NULL CONSTRAINT DF_usuarios_is_offline_capable DEFAULT 0;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_usuarios_dui' AND object_id = OBJECT_ID(N'dbo.usuarios'))
    CREATE UNIQUE INDEX UX_usuarios_dui ON dbo.usuarios(dui) WHERE dui IS NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_usuarios_cod_vendedor' AND object_id = OBJECT_ID(N'dbo.usuarios'))
    CREATE UNIQUE INDEX UX_usuarios_cod_vendedor ON dbo.usuarios(cod_vendedor) WHERE cod_vendedor IS NOT NULL;

/* La API soporta todos los roles definidos en el contrato de SAGRISA. */
IF OBJECT_ID(N'dbo.CK_usuarios_rol', N'C') IS NOT NULL ALTER TABLE dbo.usuarios DROP CONSTRAINT CK_usuarios_rol;
IF OBJECT_ID(N'dbo.CK_usuarios_rol_api', N'C') IS NULL ALTER TABLE dbo.usuarios ADD CONSTRAINT CK_usuarios_rol_api CHECK (rol IN (N'admin', N'Admin', N'cliente', N'Cliente', N'vendedor', N'Vendedor', N'supervisor', N'Supervisor', N'gerente', N'Gerente', N'director', N'Director', N'aprobador', N'usuario'));

/* Clientes: código operativo, crédito y relación de perfil. */
IF COL_LENGTH(N'dbo.clientes', N'cod_cliente') IS NULL ALTER TABLE dbo.clientes ADD cod_cliente nvarchar(30) NULL;
IF COL_LENGTH(N'dbo.clientes', N'profile_id') IS NULL ALTER TABLE dbo.clientes ADD profile_id uniqueidentifier NULL;
IF COL_LENGTH(N'dbo.clientes', N'nom_cliente') IS NULL ALTER TABLE dbo.clientes ADD nom_cliente nvarchar(200) NULL;
IF COL_LENGTH(N'dbo.clientes', N'dui') IS NULL ALTER TABLE dbo.clientes ADD dui nvarchar(20) NULL;
IF COL_LENGTH(N'dbo.clientes', N'clase') IS NULL ALTER TABLE dbo.clientes ADD clase nvarchar(30) NULL;
IF COL_LENGTH(N'dbo.clientes', N'vendedor') IS NULL ALTER TABLE dbo.clientes ADD vendedor nvarchar(50) NULL;
IF COL_LENGTH(N'dbo.clientes', N'ciudad') IS NULL ALTER TABLE dbo.clientes ADD ciudad nvarchar(100) NULL;
IF COL_LENGTH(N'dbo.clientes', N'tpago') IS NULL ALTER TABLE dbo.clientes ADD tpago nvarchar(50) NULL;
IF COL_LENGTH(N'dbo.clientes', N'inactive') IS NULL ALTER TABLE dbo.clientes ADD inactive int NOT NULL CONSTRAINT DF_clientes_inactive DEFAULT 0;
IF COL_LENGTH(N'dbo.clientes', N'hold') IS NULL ALTER TABLE dbo.clientes ADD hold int NOT NULL CONSTRAINT DF_clientes_hold DEFAULT 0;
IF COL_LENGTH(N'dbo.clientes', N'l_precios') IS NULL ALTER TABLE dbo.clientes ADD l_precios nvarchar(50) NULL;
IF COL_LENGTH(N'dbo.clientes', N'monto_credito') IS NULL ALTER TABLE dbo.clientes ADD monto_credito decimal(19,4) NOT NULL CONSTRAINT DF_clientes_monto_credito DEFAULT 0;
IF COL_LENGTH(N'dbo.clientes', N'total_deuda') IS NULL ALTER TABLE dbo.clientes ADD total_deuda decimal(19,4) NOT NULL CONSTRAINT DF_clientes_total_deuda DEFAULT 0;
IF COL_LENGTH(N'dbo.clientes', N'saldo_credito') IS NULL ALTER TABLE dbo.clientes ADD saldo_credito decimal(19,4) NOT NULL CONSTRAINT DF_clientes_saldo_credito DEFAULT 0;
IF COL_LENGTH(N'dbo.clientes', N'correo') IS NULL ALTER TABLE dbo.clientes ADD correo nvarchar(254) NULL;
UPDATE dbo.clientes SET cod_cliente = codigo WHERE cod_cliente IS NULL;
UPDATE dbo.clientes SET nom_cliente = nombre WHERE nom_cliente IS NULL;
ALTER TABLE dbo.clientes ALTER COLUMN cod_cliente nvarchar(30) NOT NULL;
ALTER TABLE dbo.clientes ALTER COLUMN nom_cliente nvarchar(200) NOT NULL;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_clientes_cod_cliente' AND object_id = OBJECT_ID(N'dbo.clientes'))
    CREATE UNIQUE INDEX UX_clientes_cod_cliente ON dbo.clientes(cod_cliente);

/* Catálogo comercial. */
IF COL_LENGTH(N'dbo.productos', N'familia') IS NULL ALTER TABLE dbo.productos ADD familia nvarchar(100) NOT NULL CONSTRAINT DF_productos_familia DEFAULT N'General';
IF COL_LENGTH(N'dbo.productos', N'presentacion') IS NULL ALTER TABLE dbo.productos ADD presentacion nvarchar(100) NOT NULL CONSTRAINT DF_productos_presentacion DEFAULT N'Unidad';
IF COL_LENGTH(N'dbo.productos', N'stock') IS NULL ALTER TABLE dbo.productos ADD stock int NOT NULL CONSTRAINT DF_productos_stock DEFAULT 0;
IF COL_LENGTH(N'dbo.productos', N'bodega') IS NULL ALTER TABLE dbo.productos ADD bodega nvarchar(100) NOT NULL CONSTRAINT DF_productos_bodega DEFAULT N'Bodega Central';
IF COL_LENGTH(N'dbo.productos', N'division') IS NULL ALTER TABLE dbo.productos ADD division nvarchar(100) NULL;

/* Pedidos y sus detalles. Las FK canónicas son opcionales para permitir que
   la API opere con códigos provenientes del legado mientras se completa el ETL. */
IF COL_LENGTH(N'dbo.pedidos', N'cod_cliente') IS NULL ALTER TABLE dbo.pedidos ADD cod_cliente nvarchar(30) NULL;
IF COL_LENGTH(N'dbo.pedidos', N'cod_vendedor') IS NULL ALTER TABLE dbo.pedidos ADD cod_vendedor nvarchar(50) NULL;
IF COL_LENGTH(N'dbo.pedidos', N'tpago') IS NULL ALTER TABLE dbo.pedidos ADD tpago nvarchar(50) NOT NULL CONSTRAINT DF_pedidos_tpago DEFAULT N'Contado';
IF COL_LENGTH(N'dbo.pedidos', N'fecha_pedido') IS NULL ALTER TABLE dbo.pedidos ADD fecha_pedido datetime2(3) NOT NULL CONSTRAINT DF_pedidos_fecha_pedido DEFAULT SYSUTCDATETIME();
IF COL_LENGTH(N'dbo.pedidos', N'fecha_entrega') IS NULL ALTER TABLE dbo.pedidos ADD fecha_entrega datetime2(3) NULL;
IF COL_LENGTH(N'dbo.pedidos', N'plazo_entrega_pedido') IS NULL ALTER TABLE dbo.pedidos ADD plazo_entrega_pedido int NOT NULL CONSTRAINT DF_pedidos_plazo_entrega DEFAULT 1;
IF COL_LENGTH(N'dbo.pedidos', N'observacion') IS NULL ALTER TABLE dbo.pedidos ADD observacion nvarchar(1000) NOT NULL CONSTRAINT DF_pedidos_observacion DEFAULT N'';
IF COL_LENGTH(N'dbo.pedidos', N'total_pedido') IS NULL ALTER TABLE dbo.pedidos ADD total_pedido decimal(19,4) NOT NULL CONSTRAINT DF_pedidos_total_pedido DEFAULT 0;
IF COL_LENGTH(N'dbo.pedidos', N'pais') IS NULL ALTER TABLE dbo.pedidos ADD pais nvarchar(80) NOT NULL CONSTRAINT DF_pedidos_pais DEFAULT N'SV';
IF COL_LENGTH(N'dbo.pedidos', N'id_direccion') IS NULL ALTER TABLE dbo.pedidos ADD id_direccion int NULL;
IF COL_LENGTH(N'dbo.pedidos', N'direccion_entrega') IS NULL ALTER TABLE dbo.pedidos ADD direccion_entrega nvarchar(500) NULL;
IF COL_LENGTH(N'dbo.pedidos', N'latitud') IS NULL ALTER TABLE dbo.pedidos ADD latitud decimal(9,6) NULL;
IF COL_LENGTH(N'dbo.pedidos', N'longitud') IS NULL ALTER TABLE dbo.pedidos ADD longitud decimal(9,6) NULL;
IF COL_LENGTH(N'dbo.pedidos', N'is_synced') IS NULL ALTER TABLE dbo.pedidos ADD is_synced bit NOT NULL CONSTRAINT DF_pedidos_is_synced DEFAULT 1;
IF COL_LENGTH(N'dbo.pedidos', N'status') IS NULL ALTER TABLE dbo.pedidos ADD status smallint NOT NULL CONSTRAINT DF_pedidos_status DEFAULT 0;
IF COL_LENGTH(N'dbo.pedidos', N'est_corr') IS NULL ALTER TABLE dbo.pedidos ADD est_corr nvarchar(10) NOT NULL CONSTRAINT DF_pedidos_est_corr DEFAULT N'A';
IF COL_LENGTH(N'dbo.pedidos', N'fech_hora_insert') IS NULL ALTER TABLE dbo.pedidos ADD fech_hora_insert datetime2(3) NOT NULL CONSTRAINT DF_pedidos_fech_hora_insert DEFAULT SYSUTCDATETIME();
IF COL_LENGTH(N'dbo.pedidos', N'origen') IS NULL ALTER TABLE dbo.pedidos ADD origen nvarchar(30) NOT NULL CONSTRAINT DF_pedidos_origen DEFAULT N'PWA';
IF COL_LENGTH(N'dbo.pedidos', N'id_bac') IS NULL ALTER TABLE dbo.pedidos ADD id_bac nvarchar(100) NOT NULL CONSTRAINT DF_pedidos_id_bac DEFAULT N'';
IF COL_LENGTH(N'dbo.pedidos', N'id_clie_caf') IS NULL ALTER TABLE dbo.pedidos ADD id_clie_caf nvarchar(100) NOT NULL CONSTRAINT DF_pedidos_id_clie_caf DEFAULT N'';
IF COL_LENGTH(N'dbo.pedidos', N'estado_bac') IS NULL ALTER TABLE dbo.pedidos ADD estado_bac nvarchar(50) NOT NULL CONSTRAINT DF_pedidos_estado_bac DEFAULT N'';
IF COL_LENGTH(N'dbo.pedidos', N'order_caf') IS NULL ALTER TABLE dbo.pedidos ADD order_caf nvarchar(100) NOT NULL CONSTRAINT DF_pedidos_order_caf DEFAULT N'';
IF COL_LENGTH(N'dbo.pedidos', N'estatus') IS NULL ALTER TABLE dbo.pedidos ADD estatus nvarchar(30) NOT NULL CONSTRAINT DF_pedidos_estatus DEFAULT N'Activo';
IF COL_LENGTH(N'dbo.pedidos', N'num_factura') IS NULL ALTER TABLE dbo.pedidos ADD num_factura nvarchar(50) NOT NULL CONSTRAINT DF_pedidos_num_factura DEFAULT N'';
IF COL_LENGTH(N'dbo.pedidos', N'err_correo') IS NULL ALTER TABLE dbo.pedidos ADD err_correo nvarchar(500) NOT NULL CONSTRAINT DF_pedidos_err_correo DEFAULT N'';
UPDATE p SET cod_cliente = c.cod_cliente
FROM dbo.pedidos AS p
INNER JOIN dbo.clientes AS c ON c.id = p.cliente_id
WHERE p.cod_cliente IS NULL;
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.pedidos') AND name = N'cliente_id' AND is_nullable = 0) ALTER TABLE dbo.pedidos ALTER COLUMN cliente_id uniqueidentifier NULL;
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.pedidos') AND name = N'vendedor_id' AND is_nullable = 0) ALTER TABLE dbo.pedidos ALTER COLUMN vendedor_id uniqueidentifier NULL;

IF COL_LENGTH(N'dbo.pedido_detalles', N'order_id') IS NULL ALTER TABLE dbo.pedido_detalles ADD order_id uniqueidentifier NULL;
IF COL_LENGTH(N'dbo.pedido_detalles', N'num_pedido') IS NULL ALTER TABLE dbo.pedido_detalles ADD num_pedido nvarchar(50) NOT NULL CONSTRAINT DF_pedido_detalles_num_pedido DEFAULT N'';
IF COL_LENGTH(N'dbo.pedido_detalles', N'cod_cliente') IS NULL ALTER TABLE dbo.pedido_detalles ADD cod_cliente nvarchar(30) NOT NULL CONSTRAINT DF_pedido_detalles_cod_cliente DEFAULT N'';
IF COL_LENGTH(N'dbo.pedido_detalles', N'cod_producto') IS NULL ALTER TABLE dbo.pedido_detalles ADD cod_producto nvarchar(50) NOT NULL CONSTRAINT DF_pedido_detalles_cod_producto DEFAULT N'';
IF COL_LENGTH(N'dbo.pedido_detalles', N'nom_producto') IS NULL ALTER TABLE dbo.pedido_detalles ADD nom_producto nvarchar(200) NOT NULL CONSTRAINT DF_pedido_detalles_nom_producto DEFAULT N'';
IF COL_LENGTH(N'dbo.pedido_detalles', N'presentacion') IS NULL ALTER TABLE dbo.pedido_detalles ADD presentacion nvarchar(100) NOT NULL CONSTRAINT DF_pedido_detalles_presentacion DEFAULT N'Unidad';
IF COL_LENGTH(N'dbo.pedido_detalles', N'precio_total') IS NULL ALTER TABLE dbo.pedido_detalles ADD precio_total decimal(19,4) NOT NULL CONSTRAINT DF_pedido_detalles_precio_total DEFAULT 0;
IF COL_LENGTH(N'dbo.pedido_detalles', N'cod_vendedor') IS NULL ALTER TABLE dbo.pedido_detalles ADD cod_vendedor nvarchar(50) NOT NULL CONSTRAINT DF_pedido_detalles_cod_vendedor DEFAULT N'';
IF COL_LENGTH(N'dbo.pedido_detalles', N'bodega') IS NULL ALTER TABLE dbo.pedido_detalles ADD bodega nvarchar(100) NOT NULL CONSTRAINT DF_pedido_detalles_bodega DEFAULT N'B01';
IF COL_LENGTH(N'dbo.pedido_detalles', N'origen') IS NULL ALTER TABLE dbo.pedido_detalles ADD origen nvarchar(30) NOT NULL CONSTRAINT DF_pedido_detalles_origen DEFAULT N'PWA';
UPDATE d SET order_id = d.pedido_id
FROM dbo.pedido_detalles AS d
WHERE d.order_id IS NULL;
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.pedido_detalles') AND name = N'pedido_id' AND is_nullable = 0) ALTER TABLE dbo.pedido_detalles ALTER COLUMN pedido_id uniqueidentifier NULL;
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.pedido_detalles') AND name = N'producto_id' AND is_nullable = 0) ALTER TABLE dbo.pedido_detalles ALTER COLUMN producto_id uniqueidentifier NULL;

/* Facturas y cobros: saldo e idempotencia a nivel de referencia. */
IF COL_LENGTH(N'dbo.facturas', N'num_factura') IS NULL ALTER TABLE dbo.facturas ADD num_factura nvarchar(50) NULL;
IF COL_LENGTH(N'dbo.facturas', N'order_id') IS NULL ALTER TABLE dbo.facturas ADD order_id uniqueidentifier NULL;
IF COL_LENGTH(N'dbo.facturas', N'cod_cliente') IS NULL ALTER TABLE dbo.facturas ADD cod_cliente nvarchar(30) NULL;
IF COL_LENGTH(N'dbo.facturas', N'fecha_vencimiento') IS NULL ALTER TABLE dbo.facturas ADD fecha_vencimiento datetime2(3) NULL;
IF COL_LENGTH(N'dbo.facturas', N'total_factura') IS NULL ALTER TABLE dbo.facturas ADD total_factura decimal(19,4) NOT NULL CONSTRAINT DF_facturas_total_factura DEFAULT 0;
IF COL_LENGTH(N'dbo.facturas', N'saldo') IS NULL ALTER TABLE dbo.facturas ADD saldo decimal(19,4) NOT NULL CONSTRAINT DF_facturas_saldo DEFAULT 0;
IF COL_LENGTH(N'dbo.facturas', N'status') IS NULL ALTER TABLE dbo.facturas ADD status smallint NOT NULL CONSTRAINT DF_facturas_status DEFAULT 0;
IF COL_LENGTH(N'dbo.facturas', N'pdf_url') IS NULL ALTER TABLE dbo.facturas ADD pdf_url nvarchar(1000) NULL;
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.facturas') AND name = N'pedido_id' AND is_nullable = 0) ALTER TABLE dbo.facturas ALTER COLUMN pedido_id uniqueidentifier NULL;
UPDATE dbo.facturas SET num_factura = numero WHERE num_factura IS NULL;
UPDATE dbo.facturas SET total_factura = total WHERE total_factura = 0 AND total <> 0;
UPDATE dbo.facturas SET saldo = total_factura WHERE saldo = 0 AND total_factura <> 0;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_facturas_num_factura_api' AND object_id = OBJECT_ID(N'dbo.facturas')) CREATE UNIQUE INDEX UX_facturas_num_factura_api ON dbo.facturas(num_factura) WHERE num_factura IS NOT NULL;

IF COL_LENGTH(N'dbo.cobros', N'num_factura') IS NULL ALTER TABLE dbo.cobros ADD num_factura nvarchar(50) NOT NULL CONSTRAINT DF_cobros_num_factura DEFAULT N'';
IF COL_LENGTH(N'dbo.cobros', N'cod_cliente') IS NULL ALTER TABLE dbo.cobros ADD cod_cliente nvarchar(30) NOT NULL CONSTRAINT DF_cobros_cod_cliente DEFAULT N'';
IF COL_LENGTH(N'dbo.cobros', N'cod_vendedor') IS NULL ALTER TABLE dbo.cobros ADD cod_vendedor nvarchar(50) NULL;
IF COL_LENGTH(N'dbo.cobros', N'metodo_pago_code') IS NULL ALTER TABLE dbo.cobros ADD metodo_pago_code smallint NOT NULL CONSTRAINT DF_cobros_metodo_pago_code DEFAULT 1;
IF COL_LENGTH(N'dbo.cobros', N'status') IS NULL ALTER TABLE dbo.cobros ADD status smallint NOT NULL CONSTRAINT DF_cobros_status DEFAULT 0;
IF COL_LENGTH(N'dbo.cobros', N'comprobante_url') IS NULL ALTER TABLE dbo.cobros ADD comprobante_url nvarchar(1000) NULL;
IF COL_LENGTH(N'dbo.cobros', N'firma_url') IS NULL ALTER TABLE dbo.cobros ADD firma_url nvarchar(1000) NULL;
IF COL_LENGTH(N'dbo.cobros', N'notas') IS NULL ALTER TABLE dbo.cobros ADD notas nvarchar(1000) NULL;
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.cobros') AND name = N'pedido_id' AND is_nullable = 0) ALTER TABLE dbo.cobros ALTER COLUMN pedido_id uniqueidentifier NULL;
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_cobros_referencia' AND object_id = OBJECT_ID(N'dbo.cobros')) CREATE UNIQUE INDEX UX_cobros_referencia ON dbo.cobros(referencia) WHERE referencia IS NOT NULL;

/* Aprobaciones para el contrato actual del frontend. */
IF COL_LENGTH(N'dbo.aprobaciones', N'num_pedido') IS NULL ALTER TABLE dbo.aprobaciones ADD num_pedido nvarchar(50) NULL;
IF COL_LENGTH(N'dbo.aprobaciones', N'cod_cliente') IS NULL ALTER TABLE dbo.aprobaciones ADD cod_cliente nvarchar(30) NOT NULL CONSTRAINT DF_aprobaciones_cod_cliente DEFAULT N'';
IF COL_LENGTH(N'dbo.aprobaciones', N'cod_vendedor') IS NULL ALTER TABLE dbo.aprobaciones ADD cod_vendedor nvarchar(50) NULL;
IF COL_LENGTH(N'dbo.aprobaciones', N'monto') IS NULL ALTER TABLE dbo.aprobaciones ADD monto decimal(19,4) NOT NULL CONSTRAINT DF_aprobaciones_monto DEFAULT 0;
IF COL_LENGTH(N'dbo.aprobaciones', N'motivo') IS NULL ALTER TABLE dbo.aprobaciones ADD motivo nvarchar(500) NOT NULL CONSTRAINT DF_aprobaciones_motivo DEFAULT N'';
IF COL_LENGTH(N'dbo.aprobaciones', N'detalles') IS NULL ALTER TABLE dbo.aprobaciones ADD detalles nvarchar(max) NULL;
IF COL_LENGTH(N'dbo.aprobaciones', N'comentario_decision') IS NULL ALTER TABLE dbo.aprobaciones ADD comentario_decision nvarchar(1000) NULL;
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.aprobaciones') AND name = N'pedido_id' AND is_nullable = 0) ALTER TABLE dbo.aprobaciones ALTER COLUMN pedido_id uniqueidentifier NULL;
IF OBJECT_ID(N'dbo.CK_aprobaciones_estado', N'C') IS NOT NULL ALTER TABLE dbo.aprobaciones DROP CONSTRAINT CK_aprobaciones_estado;
IF OBJECT_ID(N'dbo.CK_aprobaciones_estado_api', N'C') IS NULL ALTER TABLE dbo.aprobaciones ADD CONSTRAINT CK_aprobaciones_estado_api CHECK (estado IN (N'pending', N'pendiente', N'approved', N'aprobada', N'rejected', N'rechazada'));

/* Auditoría y eventos: nombres canónicos + datos requeridos por la API. */
IF COL_LENGTH(N'dbo.audit_events', N'user_agent') IS NULL ALTER TABLE dbo.audit_events ADD user_agent nvarchar(1000) NULL;
IF COL_LENGTH(N'dbo.webhook_events', N'received_at') IS NULL ALTER TABLE dbo.webhook_events ADD received_at datetime2(3) NOT NULL CONSTRAINT DF_webhook_events_received_at DEFAULT SYSUTCDATETIME();
IF COL_LENGTH(N'dbo.webhook_events', N'last_error') IS NULL ALTER TABLE dbo.webhook_events ADD last_error nvarchar(1000) NULL;

/* Metas configurables. Si no hay registros, /goals devuelve una colección vacía. */
IF OBJECT_ID(N'dbo.metas_comerciales', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.metas_comerciales
    (
        id uniqueidentifier NOT NULL CONSTRAINT PK_metas_comerciales PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
        periodo_tipo nvarchar(20) NOT NULL,
        periodo_inicio date NOT NULL,
        periodo_fin date NOT NULL,
        division_codigo nvarchar(30) NULL,
        vendedor_codigo nvarchar(50) NULL,
        proyeccion decimal(19,4) NOT NULL CONSTRAINT DF_metas_comerciales_proyeccion DEFAULT 0,
        created_at datetime2(3) NOT NULL CONSTRAINT DF_metas_comerciales_created_at DEFAULT SYSUTCDATETIME()
    );
    CREATE UNIQUE INDEX UX_metas_comerciales_periodo ON dbo.metas_comerciales(periodo_tipo, periodo_inicio, division_codigo, vendedor_codigo);
END;

COMMIT TRANSACTION;
GO
