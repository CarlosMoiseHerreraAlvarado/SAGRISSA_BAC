/*
    SAGRISA - compatibilidad con Perfil de Gerentes
    
    1. Agrega columna 'division' a dbo.productos.
    2. Crea el esquema [SAG] si no existe.
    3. Implementa el Procedimiento Almacenado [SAG].[InsertAutorizacion].
    4. Crea vistas de compatibilidad:
       - dbo.UsuarioMovil
       - dbo.TSAGDetalleVentas (El Salvador)
       - dbo.TSAGDetalleVentasGT (Guatemala)
       - dbo.TSAGMovilExistencias (El Salvador, con división)
       - dbo.TSAGMovilExisteciasGT (Guatemala, sin división)
*/

SET XACT_ABORT ON;
SET NOCOUNT ON;
GO

BEGIN TRANSACTION;

-- 1. Columna 'division' en dbo.productos
IF COL_LENGTH(N'dbo.productos', N'division') IS NULL
    ALTER TABLE dbo.productos ADD division nvarchar(100) NULL;
GO

UPDATE dbo.productos SET division = N'Agrícola' WHERE division IS NULL AND (familia LIKE N'%agri%' OR familia LIKE N'%grano%' OR familia LIKE N'%abarrote%');
UPDATE dbo.productos SET division = N'Veterinaria' WHERE division IS NULL AND (familia LIKE N'%vet%' OR familia LIKE N'%limpieza%');
UPDATE dbo.productos SET division = N'Industrial' WHERE division IS NULL AND (familia LIKE N'%ind%' OR familia LIKE N'%bebida%');
UPDATE dbo.productos SET division = N'Taller' WHERE division IS NULL AND (familia LIKE N'%tall%' OR familia LIKE N'%vario%');
UPDATE dbo.productos SET division = N'Proyectos' WHERE division IS NULL AND (familia LIKE N'%proy%');
UPDATE dbo.productos SET division = N'Agrícola' WHERE division IS NULL;
GO

-- 2. Esquema [SAG]
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'SAG')
BEGIN
    EXEC(N'CREATE SCHEMA [SAG]');
END;
GO

-- 3. Procedimiento Almacenado [SAG].[InsertAutorizacion]
IF OBJECT_ID(N'[SAG].[InsertAutorizacion]', N'P') IS NOT NULL
    DROP PROCEDURE [SAG].[InsertAutorizacion];
GO

CREATE PROCEDURE [SAG].[InsertAutorizacion]
    @NumFact nvarchar(50),
    @User    nvarchar(100)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Actualizar estado del pedido relacionado si existe
        UPDATE p
        SET p.estatus = N'Aprobado',
            p.status = 2 -- OrderStatus.Approved
        FROM dbo.pedidos AS p
        WHERE p.num_factura = @NumFact OR p.num_pedido = @NumFact;

        -- Actualizar o insertar en la tabla de aprobaciones
        IF EXISTS (SELECT 1 FROM dbo.aprobaciones WHERE num_pedido = @NumFact)
        BEGIN
            UPDATE dbo.aprobaciones
            SET estado = N'approved',
                comentario_decision = N'Autorizado mediante SP [SAG].[InsertAutorizacion] por ' + @User
            WHERE num_pedido = @NumFact;
        END

        -- Registrar evento de auditoria
        IF OBJECT_ID(N'dbo.audit_events', N'U') IS NOT NULL
        BEGIN
            INSERT INTO dbo.audit_events (id, action, entity_type, entity_id, after_data, created_at)
            VALUES (
                NEWID(),
                N'approval.approve.sp',
                N'factura_o_pedido',
                @NumFact,
                N'{"usuario":"' + @User + N'","sp":"[SAG].[InsertAutorizacion]"}',
                SYSUTCDATETIME()
            );
        END

        COMMIT TRANSACTION;

        SELECT 
            1 AS Exito, 
            N'Autorización procesada exitosamente para documento ' + @NumFact AS Mensaje;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- 4. Vista dbo.UsuarioMovil
IF OBJECT_ID(N'dbo.UsuarioMovil', N'V') IS NOT NULL
    DROP VIEW dbo.UsuarioMovil;
GO

CREATE VIEW dbo.UsuarioMovil AS
SELECT 
    id,
    dui            AS Dui,
    nombre         AS Nombre,
    division       AS Division,
    pais           AS Pais,
    cod_vendedor   AS CodVendedor,
    cargo          AS Cargo,
    email          AS email,
    cambiado       AS Cambiado,
    doc_personal   AS DocPersonal,
    fecha_sesion   AS FechaSesion,
    gerenciado_por AS GerenciadoPor,
    supervisado_por AS SupervisadoPor,
    rol            AS Rol,
    activo         AS Activo
FROM dbo.usuarios;
GO

-- 5. Vistas de Ventas para El Salvador y Guatemala
IF OBJECT_ID(N'dbo.TSAGDetalleVentas', N'V') IS NOT NULL
    DROP VIEW dbo.TSAGDetalleVentas;
GO

CREATE VIEW dbo.TSAGDetalleVentas AS
SELECT 
    d.id AS id_detalle,
    p.num_pedido,
    p.cod_cliente,
    c.nom_cliente,
    p.cod_vendedor,
    u.nombre AS nom_vendedor,
    COALESCE(u.division, pr.division, N'Agrícola') AS division,
    CASE 
        WHEN COALESCE(u.division, pr.division) LIKE N'%agri%' THEN 'A'
        WHEN COALESCE(u.division, pr.division) LIKE N'%vet%'  THEN 'V'
        WHEN COALESCE(u.division, pr.division) LIKE N'%ind%'  THEN 'I'
        WHEN COALESCE(u.division, pr.division) LIKE N'%tall%' THEN 'T'
        WHEN COALESCE(u.division, pr.division) LIKE N'%proy%' THEN 'P'
        ELSE 'A'
    END AS area,
    d.cod_producto,
    d.nom_producto,
    d.cantidad,
    d.precio_unitario,
    d.precio_total,
    d.bodega,
    p.fecha_pedido AS fecha,
    MONTH(p.fecha_pedido) AS mes,
    YEAR(p.fecha_pedido)  AS anio,
    DATEPART(QUARTER, p.fecha_pedido) AS trimestre,
    p.pais
FROM dbo.pedido_detalles AS d
INNER JOIN dbo.pedidos AS p ON p.id = d.order_id
LEFT JOIN dbo.clientes AS c ON c.cod_cliente = p.cod_cliente
LEFT JOIN dbo.usuarios AS u ON u.cod_vendedor = p.cod_vendedor
LEFT JOIN dbo.productos AS pr ON pr.codigo = d.cod_producto
WHERE p.pais = N'SV' OR p.pais LIKE N'%salvador%';
GO

IF OBJECT_ID(N'dbo.TSAGDetalleVentasGT', N'V') IS NOT NULL
    DROP VIEW dbo.TSAGDetalleVentasGT;
GO

CREATE VIEW dbo.TSAGDetalleVentasGT AS
SELECT 
    d.id AS id_detalle,
    p.num_pedido,
    p.cod_cliente,
    c.nom_cliente,
    p.cod_vendedor,
    u.nombre AS nom_vendedor,
    COALESCE(u.division, pr.division, N'Agrícola') AS division,
    CASE 
        WHEN COALESCE(u.division, pr.division) LIKE N'%agri%' THEN 'A'
        WHEN COALESCE(u.division, pr.division) LIKE N'%vet%'  THEN 'V'
        WHEN COALESCE(u.division, pr.division) LIKE N'%ind%'  THEN 'I'
        WHEN COALESCE(u.division, pr.division) LIKE N'%tall%' THEN 'T'
        WHEN COALESCE(u.division, pr.division) LIKE N'%proy%' THEN 'P'
        ELSE 'A'
    END AS area,
    d.cod_producto,
    d.nom_producto,
    d.cantidad,
    d.precio_unitario,
    d.precio_total,
    d.bodega,
    p.fecha_pedido AS fecha,
    MONTH(p.fecha_pedido) AS mes,
    YEAR(p.fecha_pedido)  AS anio,
    DATEPART(QUARTER, p.fecha_pedido) AS trimestre,
    p.pais
FROM dbo.pedido_detalles AS d
INNER JOIN dbo.pedidos AS p ON p.id = d.order_id
LEFT JOIN dbo.clientes AS c ON c.cod_cliente = p.cod_cliente
LEFT JOIN dbo.usuarios AS u ON u.cod_vendedor = p.cod_vendedor
LEFT JOIN dbo.productos AS pr ON pr.codigo = d.cod_producto
WHERE p.pais = N'GT' OR p.pais LIKE N'%guatemala%';
GO

-- 6. Vistas de Existencias e Inventario
IF OBJECT_ID(N'dbo.TSAGMovilExistencias', N'V') IS NOT NULL
    DROP VIEW dbo.TSAGMovilExistencias;
GO

CREATE VIEW dbo.TSAGMovilExistencias AS
SELECT 
    codigo       AS Codigo,
    nombre       AS Nombre,
    descripcion  AS Descripcion,
    familia      AS Familia,
    division     AS Division,
    presentacion AS Presentacion,
    precio       AS Precio,
    stock        AS Stock,
    bodega       AS Bodega,
    activo       AS Activo
FROM dbo.productos;
GO

IF OBJECT_ID(N'dbo.TSAGMovilExisteciasGT', N'V') IS NOT NULL
    DROP VIEW dbo.TSAGMovilExisteciasGT;
GO

CREATE VIEW dbo.TSAGMovilExisteciasGT AS
SELECT 
    codigo       AS Codigo,
    nombre       AS Nombre,
    descripcion  AS Descripcion,
    familia      AS Familia,
    CAST(NULL AS nvarchar(100)) AS Division,
    presentacion AS Presentacion,
    precio       AS Precio,
    stock        AS Stock,
    bodega       AS Bodega,
    activo       AS Activo
FROM dbo.productos;
GO

COMMIT TRANSACTION;
GO
