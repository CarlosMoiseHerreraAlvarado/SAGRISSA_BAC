-- ============================================================================
-- SCRIPT DE COMPATIBILIDAD - PERFIL DE DIRECTORES (SQL SERVER / MOVIL)
-- ============================================================================
-- Este script valida y asegura la existencia de las vistas requeridas
-- para el perfil de Directores en SAGRISA.
-- ============================================================================

USE [Movil];
GO

-- 1. Agregar columnas clase y fecha de vencimiento a dbo.productos si no existen
IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID(N'dbo.productos') AND name = 'clase'
)
BEGIN
    ALTER TABLE dbo.productos ADD clase VARCHAR(100) NULL;
END;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID(N'dbo.productos') AND name = 'fecha_vencimiento'
)
BEGIN
    ALTER TABLE dbo.productos ADD fecha_vencimiento DATETIME NULL;
END;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID(N'dbo.productos') AND name = 'lote'
)
BEGIN
    ALTER TABLE dbo.productos ADD lote VARCHAR(50) NULL;
END;
GO

-- 2. Asegurar vista SAGClientesRegionales
IF NOT EXISTS (SELECT 1 FROM sys.views WHERE name = 'SAGClientesRegionales')
BEGIN
    EXEC('
    CREATE VIEW dbo.SAGClientesRegionales AS
    SELECT CUSTNMBR, CUSTNAME, INACTIVE, HOLD, PAIS, ClaseCliente
    FROM dbo.TSAGClientesRegionales;
    ');
END;
GO

-- 3. Asegurar vista SAGProductosPorVencer
IF NOT EXISTS (SELECT 1 FROM sys.views WHERE name = 'SAGProductosPorVencer')
BEGIN
    EXEC('
    CREATE VIEW dbo.SAGProductosPorVencer AS
    SELECT 
        RTRIM(CodProducto) AS CodigoProducto,
        RTRIM(NomProducto) AS DescripcionProducto,
        RTRIM(LOTNUMBR) AS NumeroLote,
        RTRIM(Bodega) AS Bodega,
        NULL AS FechaFabricacion,
        FechaVto AS FechaVencimiento,
        Existencia AS CantidadRecibida,
        0 AS CantidadSalida,
        SaldoLote AS CantidadRestante,
        DATEDIFF(DAY, GETDATE(), FechaVto) AS DiasParaVencer,
        CASE
            WHEN FechaVto < CAST(GETDATE() AS DATE) THEN ''VENCIDO''
            WHEN FechaVto <= DATEADD(DAY, 30, CAST(GETDATE() AS DATE)) THEN ''POR VENCER''
            ELSE ''VIGENTE''
        END AS EstadoVencimiento
    FROM dbo.TSAGMovilExistenciasLote
    WHERE FechaVto IS NOT NULL;
    ');
END;
GO

PRINT 'Compatibilidad de Perfil de Directores en SQL Server completada con éxito.';
GO
