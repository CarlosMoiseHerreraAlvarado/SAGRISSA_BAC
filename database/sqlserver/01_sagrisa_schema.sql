/*
    SAGRISA - esquema canónico para la API

    Ejecutar dentro de SagrisaStaging o SagrisaProd.
    No ejecutar movil.sql encima de este esquema.

    La base legacy Movil debe mantenerse separada y usarse como fuente de
    migración. Las tablas se dejan en dbo para que EF Core pueda utilizarlas
    sin depender de un esquema PostgreSQL llamado public.
*/

SET XACT_ABORT ON;
SET NOCOUNT ON;
GO

BEGIN TRANSACTION;

IF OBJECT_ID(N'dbo.usuarios', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.usuarios
    (
        id                  uniqueidentifier NOT NULL CONSTRAINT PK_usuarios PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
        nombre              nvarchar(150) NOT NULL,
        email               nvarchar(254) NOT NULL,
        password_hash       nvarchar(255) NULL,
        rol                 nvarchar(50) NOT NULL CONSTRAINT DF_usuarios_rol DEFAULT N'usuario',
        activo              bit NOT NULL CONSTRAINT DF_usuarios_activo DEFAULT 1,
        ultimo_acceso       datetime2(3) NULL,
        created_at          datetime2(3) NOT NULL CONSTRAINT DF_usuarios_created_at DEFAULT SYSUTCDATETIME(),
        updated_at          datetime2(3) NOT NULL CONSTRAINT DF_usuarios_updated_at DEFAULT SYSUTCDATETIME(),
        row_version         rowversion NOT NULL,
        CONSTRAINT CK_usuarios_email CHECK (email NOT LIKE N'% %' AND email LIKE N'%@%'),
        CONSTRAINT CK_usuarios_rol CHECK (rol IN (N'admin', N'vendedor', N'aprobador', N'usuario'))
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_usuarios_email' AND object_id = OBJECT_ID(N'dbo.usuarios'))
    CREATE UNIQUE INDEX UX_usuarios_email ON dbo.usuarios(email);
GO

IF OBJECT_ID(N'dbo.clientes', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.clientes
    (
        id                  uniqueidentifier NOT NULL CONSTRAINT PK_clientes PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
        codigo              nvarchar(30) NOT NULL,
        nombre              nvarchar(200) NOT NULL,
        documento           nvarchar(50) NULL,
        email               nvarchar(254) NULL,
        telefono            nvarchar(40) NULL,
        direccion           nvarchar(500) NULL,
        pais                nvarchar(80) NULL,
        activo              bit NOT NULL CONSTRAINT DF_clientes_activo DEFAULT 1,
        created_at          datetime2(3) NOT NULL CONSTRAINT DF_clientes_created_at DEFAULT SYSUTCDATETIME(),
        updated_at          datetime2(3) NOT NULL CONSTRAINT DF_clientes_updated_at DEFAULT SYSUTCDATETIME(),
        row_version         rowversion NOT NULL
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_clientes_codigo' AND object_id = OBJECT_ID(N'dbo.clientes'))
    CREATE UNIQUE INDEX UX_clientes_codigo ON dbo.clientes(codigo);
GO

IF OBJECT_ID(N'dbo.productos', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.productos
    (
        id                  uniqueidentifier NOT NULL CONSTRAINT PK_productos PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
        codigo              nvarchar(50) NOT NULL,
        nombre              nvarchar(200) NOT NULL,
        descripcion         nvarchar(1000) NULL,
        precio              decimal(19,4) NOT NULL CONSTRAINT DF_productos_precio DEFAULT 0,
        existencia          decimal(19,4) NOT NULL CONSTRAINT DF_productos_existencia DEFAULT 0,
        activo              bit NOT NULL CONSTRAINT DF_productos_activo DEFAULT 1,
        created_at          datetime2(3) NOT NULL CONSTRAINT DF_productos_created_at DEFAULT SYSUTCDATETIME(),
        updated_at          datetime2(3) NOT NULL CONSTRAINT DF_productos_updated_at DEFAULT SYSUTCDATETIME(),
        row_version         rowversion NOT NULL,
        CONSTRAINT CK_productos_precio CHECK (precio >= 0),
        CONSTRAINT CK_productos_existencia CHECK (existencia >= 0)
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_productos_codigo' AND object_id = OBJECT_ID(N'dbo.productos'))
    CREATE UNIQUE INDEX UX_productos_codigo ON dbo.productos(codigo);
GO

IF OBJECT_ID(N'dbo.pedidos', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.pedidos
    (
        id                  uniqueidentifier NOT NULL CONSTRAINT PK_pedidos PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
        num_pedido          nvarchar(50) NOT NULL,
        cliente_id          uniqueidentifier NOT NULL,
        vendedor_id         uniqueidentifier NULL,
        estado              nvarchar(30) NOT NULL CONSTRAINT DF_pedidos_estado DEFAULT N'pendiente',
        moneda              char(3) NOT NULL CONSTRAINT DF_pedidos_moneda DEFAULT 'USD',
        subtotal            decimal(19,4) NOT NULL CONSTRAINT DF_pedidos_subtotal DEFAULT 0,
        impuesto            decimal(19,4) NOT NULL CONSTRAINT DF_pedidos_impuesto DEFAULT 0,
        total               decimal(19,4) NOT NULL CONSTRAINT DF_pedidos_total DEFAULT 0,
        observaciones      nvarchar(1000) NULL,
        created_at          datetime2(3) NOT NULL CONSTRAINT DF_pedidos_created_at DEFAULT SYSUTCDATETIME(),
        updated_at          datetime2(3) NOT NULL CONSTRAINT DF_pedidos_updated_at DEFAULT SYSUTCDATETIME(),
        row_version         rowversion NOT NULL,
        CONSTRAINT FK_pedidos_cliente FOREIGN KEY (cliente_id) REFERENCES dbo.clientes(id),
        CONSTRAINT FK_pedidos_vendedor FOREIGN KEY (vendedor_id) REFERENCES dbo.usuarios(id),
        CONSTRAINT CK_pedidos_estado CHECK (estado IN (N'pendiente', N'confirmado', N'procesando', N'enviado', N'entregado', N'cancelado')),
        CONSTRAINT CK_pedidos_importes CHECK (subtotal >= 0 AND impuesto >= 0 AND total >= 0)
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_pedidos_num_pedido' AND object_id = OBJECT_ID(N'dbo.pedidos'))
    CREATE UNIQUE INDEX UX_pedidos_num_pedido ON dbo.pedidos(num_pedido);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_pedidos_cliente_estado' AND object_id = OBJECT_ID(N'dbo.pedidos'))
    CREATE INDEX IX_pedidos_cliente_estado ON dbo.pedidos(cliente_id, estado, created_at);
GO

IF OBJECT_ID(N'dbo.pedido_detalles', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.pedido_detalles
    (
        id                  uniqueidentifier NOT NULL CONSTRAINT PK_pedido_detalles PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
        pedido_id           uniqueidentifier NOT NULL,
        producto_id         uniqueidentifier NOT NULL,
        cantidad            decimal(19,4) NOT NULL,
        precio_unitario     decimal(19,4) NOT NULL,
        descuento           decimal(19,4) NOT NULL CONSTRAINT DF_pedido_detalles_descuento DEFAULT 0,
        total               decimal(19,4) NOT NULL,
        created_at          datetime2(3) NOT NULL CONSTRAINT DF_pedido_detalles_created_at DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_pedido_detalles_pedido FOREIGN KEY (pedido_id) REFERENCES dbo.pedidos(id),
        CONSTRAINT FK_pedido_detalles_producto FOREIGN KEY (producto_id) REFERENCES dbo.productos(id),
        CONSTRAINT CK_pedido_detalles_importes CHECK (cantidad > 0 AND precio_unitario >= 0 AND descuento >= 0 AND total >= 0)
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_pedido_detalles_pedido' AND object_id = OBJECT_ID(N'dbo.pedido_detalles'))
    CREATE INDEX IX_pedido_detalles_pedido ON dbo.pedido_detalles(pedido_id);
GO

IF OBJECT_ID(N'dbo.facturas', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.facturas
    (
        id                  uniqueidentifier NOT NULL CONSTRAINT PK_facturas PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
        pedido_id           uniqueidentifier NOT NULL,
        numero              nvarchar(50) NOT NULL,
        estado              nvarchar(30) NOT NULL CONSTRAINT DF_facturas_estado DEFAULT N'pendiente',
        fecha_emision       datetime2(3) NULL,
        total               decimal(19,4) NOT NULL CONSTRAINT DF_facturas_total DEFAULT 0,
        codigo_respuesta    nvarchar(50) NULL,
        mensaje_respuesta   nvarchar(1000) NULL,
        created_at          datetime2(3) NOT NULL CONSTRAINT DF_facturas_created_at DEFAULT SYSUTCDATETIME(),
        updated_at          datetime2(3) NOT NULL CONSTRAINT DF_facturas_updated_at DEFAULT SYSUTCDATETIME(),
        row_version         rowversion NOT NULL,
        CONSTRAINT FK_facturas_pedido FOREIGN KEY (pedido_id) REFERENCES dbo.pedidos(id),
        CONSTRAINT CK_facturas_total CHECK (total >= 0)
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_facturas_numero' AND object_id = OBJECT_ID(N'dbo.facturas'))
    CREATE UNIQUE INDEX UX_facturas_numero ON dbo.facturas(numero);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_facturas_pedido' AND object_id = OBJECT_ID(N'dbo.facturas'))
    CREATE INDEX IX_facturas_pedido ON dbo.facturas(pedido_id, estado);
GO

IF OBJECT_ID(N'dbo.cobros', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.cobros
    (
        id                  uniqueidentifier NOT NULL CONSTRAINT PK_cobros PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
        pedido_id           uniqueidentifier NOT NULL,
        factura_id          uniqueidentifier NULL,
        metodo_pago         nvarchar(50) NOT NULL,
        referencia          nvarchar(100) NULL,
        monto               decimal(19,4) NOT NULL,
        estado              nvarchar(30) NOT NULL CONSTRAINT DF_cobros_estado DEFAULT N'pendiente',
        fecha_pago          datetime2(3) NULL,
        created_at          datetime2(3) NOT NULL CONSTRAINT DF_cobros_created_at DEFAULT SYSUTCDATETIME(),
        updated_at          datetime2(3) NOT NULL CONSTRAINT DF_cobros_updated_at DEFAULT SYSUTCDATETIME(),
        row_version         rowversion NOT NULL,
        CONSTRAINT FK_cobros_pedido FOREIGN KEY (pedido_id) REFERENCES dbo.pedidos(id),
        CONSTRAINT FK_cobros_factura FOREIGN KEY (factura_id) REFERENCES dbo.facturas(id),
        CONSTRAINT CK_cobros_monto CHECK (monto > 0)
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_cobros_pedido_estado' AND object_id = OBJECT_ID(N'dbo.cobros'))
    CREATE INDEX IX_cobros_pedido_estado ON dbo.cobros(pedido_id, estado);
GO

IF OBJECT_ID(N'dbo.aprobaciones', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.aprobaciones
    (
        id                  uniqueidentifier NOT NULL CONSTRAINT PK_aprobaciones PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
        pedido_id           uniqueidentifier NOT NULL,
        decidido_por        uniqueidentifier NULL,
        estado              nvarchar(30) NOT NULL CONSTRAINT DF_aprobaciones_estado DEFAULT N'pendiente',
        comentario          nvarchar(1000) NULL,
        decidido_at         datetime2(3) NULL,
        created_at          datetime2(3) NOT NULL CONSTRAINT DF_aprobaciones_created_at DEFAULT SYSUTCDATETIME(),
        updated_at          datetime2(3) NOT NULL CONSTRAINT DF_aprobaciones_updated_at DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_aprobaciones_pedido FOREIGN KEY (pedido_id) REFERENCES dbo.pedidos(id),
        CONSTRAINT FK_aprobaciones_usuario FOREIGN KEY (decidido_por) REFERENCES dbo.usuarios(id),
        CONSTRAINT CK_aprobaciones_estado CHECK (estado IN (N'pendiente', N'aprobada', N'rechazada'))
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_aprobaciones_pedido_estado' AND object_id = OBJECT_ID(N'dbo.aprobaciones'))
    CREATE INDEX IX_aprobaciones_pedido_estado ON dbo.aprobaciones(pedido_id, estado);
GO

IF OBJECT_ID(N'dbo.webhook_events', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.webhook_events
    (
        id                  uniqueidentifier NOT NULL CONSTRAINT PK_webhook_events PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
        proveedor           nvarchar(80) NOT NULL,
        evento_id           nvarchar(200) NOT NULL,
        tipo                nvarchar(120) NOT NULL,
        payload             nvarchar(max) NOT NULL,
        estado              nvarchar(30) NOT NULL CONSTRAINT DF_webhook_events_estado DEFAULT N'recibido',
        intentos            int NOT NULL CONSTRAINT DF_webhook_events_intentos DEFAULT 0,
        procesado_at        datetime2(3) NULL,
        created_at          datetime2(3) NOT NULL CONSTRAINT DF_webhook_events_created_at DEFAULT SYSUTCDATETIME(),
        updated_at          datetime2(3) NOT NULL CONSTRAINT DF_webhook_events_updated_at DEFAULT SYSUTCDATETIME(),
        CONSTRAINT CK_webhook_events_intentos CHECK (intentos >= 0)
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'UX_webhook_events_proveedor_evento' AND object_id = OBJECT_ID(N'dbo.webhook_events'))
    CREATE UNIQUE INDEX UX_webhook_events_proveedor_evento ON dbo.webhook_events(proveedor, evento_id);
GO

IF OBJECT_ID(N'dbo.audit_events', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.audit_events
    (
        id                  uniqueidentifier NOT NULL CONSTRAINT PK_audit_events PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
        usuario_id          uniqueidentifier NULL,
        accion              nvarchar(80) NOT NULL,
        entidad             nvarchar(120) NOT NULL,
        entidad_id          nvarchar(100) NULL,
        datos_anteriores    nvarchar(max) NULL,
        datos_nuevos        nvarchar(max) NULL,
        ip                  nvarchar(48) NULL,
        user_agent          nvarchar(1000) NULL,
        created_at          datetime2(3) NOT NULL CONSTRAINT DF_audit_events_created_at DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_audit_events_usuario FOREIGN KEY (usuario_id) REFERENCES dbo.usuarios(id)
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_audit_events_entidad' AND object_id = OBJECT_ID(N'dbo.audit_events'))
    CREATE INDEX IX_audit_events_entidad ON dbo.audit_events(entidad, entidad_id, created_at);
GO

IF OBJECT_ID(N'dbo.outbox_events', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.outbox_events
    (
        id                  uniqueidentifier NOT NULL CONSTRAINT PK_outbox_events PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
        event_type          nvarchar(200) NOT NULL,
        aggregate_type      nvarchar(120) NOT NULL,
        aggregate_id        nvarchar(100) NOT NULL,
        payload             nvarchar(max) NOT NULL,
        estado              nvarchar(30) NOT NULL CONSTRAINT DF_outbox_events_estado DEFAULT N'pendiente',
        intentos            int NOT NULL CONSTRAINT DF_outbox_events_intentos DEFAULT 0,
        disponible_at       datetime2(3) NOT NULL CONSTRAINT DF_outbox_events_disponible_at DEFAULT SYSUTCDATETIME(),
        procesado_at        datetime2(3) NULL,
        error               nvarchar(2000) NULL,
        created_at          datetime2(3) NOT NULL CONSTRAINT DF_outbox_events_created_at DEFAULT SYSUTCDATETIME(),
        CONSTRAINT CK_outbox_events_intentos CHECK (intentos >= 0)
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_outbox_events_pendientes' AND object_id = OBJECT_ID(N'dbo.outbox_events'))
    CREATE INDEX IX_outbox_events_pendientes ON dbo.outbox_events(estado, disponible_at, created_at);
GO

COMMIT TRANSACTION;
GO

