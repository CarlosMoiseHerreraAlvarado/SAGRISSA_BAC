-- ============================================================================
-- SCRIPT DE COMPATIBILIDAD - PERFIL DE DIRECTORES (SUPABASE / POSTGRESQL)
-- ============================================================================

-- 1. Agregar columnas a productos en esquema sagrisa
ALTER TABLE IF EXISTS sagrisa.productos 
    ADD COLUMN IF NOT EXISTS clase text,
    ADD COLUMN IF NOT EXISTS fecha_vencimiento date,
    ADD COLUMN IF NOT EXISTS lote text;

-- Si la tabla está en public (fallback)
ALTER TABLE IF EXISTS public.productos 
    ADD COLUMN IF NOT EXISTS clase text,
    ADD COLUMN IF NOT EXISTS fecha_vencimiento date,
    ADD COLUMN IF NOT EXISTS lote text;

-- 2. Vista de Clientes Regionales (dbo.SAGClientesRegionales)
CREATE OR REPLACE VIEW sagrisa.v_clientes_regionales AS
SELECT 
    cod_cliente AS custnmbr,
    nom_cliente AS custname,
    inactive,
    hold,
    CASE 
        WHEN cod_cliente ILIKE 'GT%' THEN 'GT' 
        ELSE 'SV' 
    END AS pais,
    COALESCE(clase, 'DIRECTO') AS clase_cliente
FROM sagrisa.clientes;

-- 3. Vista de Categorías / Clases de Productos (dbo.SAGCategoriaProductos)
CREATE OR REPLACE VIEW sagrisa.v_categoria_productos AS
SELECT DISTINCT 
    UPPER(COALESCE(clase, familia, 'GENERAL')) AS itmclscd,
    COALESCE(clase, familia, 'GENERAL') AS itmclsdc
FROM sagrisa.productos;

-- 4. Vista de Productos por Vencer (dbo.SAGProductosPorVencer)
CREATE OR REPLACE VIEW sagrisa.v_productos_por_vencer AS
SELECT 
    codigo AS codigo_producto,
    nombre AS descripcion_producto,
    COALESCE(lote, 'LOT-GENERAL') AS numero_lote,
    bodega,
    fecha_vencimiento,
    stock AS cantidad_restante,
    CASE 
        WHEN fecha_vencimiento < CURRENT_DATE THEN 'VENCIDO'
        WHEN fecha_vencimiento <= CURRENT_DATE + INTERVAL '30 days' THEN 'POR VENCER'
        ELSE 'VIGENTE'
    END AS estado_vencimiento
FROM sagrisa.productos
WHERE fecha_vencimiento IS NOT NULL;

-- 5. Vistas de Detalle de Facturas por País (dbo.SAGDetalleFacturasSV / GT)
CREATE OR REPLACE VIEW sagrisa.v_detalle_facturas_sv AS
SELECT 
    f.id,
    f.num_factura AS documento,
    f.fecha_emision AS fecha_doc,
    EXTRACT(MONTH FROM f.fecha_emision)::int AS mes,
    EXTRACT(YEAR FROM f.fecha_emision)::int AS anio,
    'SV' AS pais,
    f.cod_cliente,
    c.nom_cliente AS nombre_cliente,
    f.total_factura AS total_precio
FROM sagrisa.facturas f
LEFT JOIN sagrisa.clientes c ON f.cod_cliente = c.cod_cliente
WHERE f.cod_cliente NOT ILIKE 'GT%';

CREATE OR REPLACE VIEW sagrisa.v_detalle_facturas_gt AS
SELECT 
    f.id,
    f.num_factura AS documento,
    f.fecha_emision AS fecha_doc,
    EXTRACT(MONTH FROM f.fecha_emision)::int AS mes,
    EXTRACT(YEAR FROM f.fecha_emision)::int AS anio,
    'GT' AS pais,
    f.cod_cliente,
    c.nom_cliente AS nombre_cliente,
    f.total_factura AS total_precio
FROM sagrisa.facturas f
LEFT JOIN sagrisa.clientes c ON f.cod_cliente = c.cod_cliente
WHERE f.cod_cliente ILIKE 'GT%';
