-- ============================================================================
-- SCRIPT DE COMPATIBILIDAD - PERFIL DE DIRECTORES (SUPABASE / POSTGRESQL)
-- ============================================================================

-- 1. Agregar columnas a productos en esquema sagrisa y public
ALTER TABLE IF EXISTS sagrisa.productos 
    ADD COLUMN IF NOT EXISTS clase text,
    ADD COLUMN IF NOT EXISTS fecha_vencimiento date,
    ADD COLUMN IF NOT EXISTS lote text;

ALTER TABLE IF EXISTS public.productos 
    ADD COLUMN IF NOT EXISTS clase text,
    ADD COLUMN IF NOT EXISTS fecha_vencimiento date,
    ADD COLUMN IF NOT EXISTS lote text;

-- 2. Agregar columna pais a cobros en esquema sagrisa y public
ALTER TABLE IF EXISTS sagrisa.cobros 
    ADD COLUMN IF NOT EXISTS pais text;

ALTER TABLE IF EXISTS public.cobros 
    ADD COLUMN IF NOT EXISTS pais text;

-- 3. Poblar pais en cobros existentes basado en el prefijo del cliente
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'sagrisa' AND table_name = 'cobros') THEN
        UPDATE sagrisa.cobros 
        SET pais = CASE WHEN cod_cliente ILIKE 'GT%' THEN 'GT' ELSE 'SV' END
        WHERE pais IS NULL;
    END IF;
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'cobros') THEN
        UPDATE public.cobros 
        SET pais = CASE WHEN cod_cliente ILIKE 'GT%' THEN 'GT' ELSE 'SV' END
        WHERE pais IS NULL;
    END IF;
END $$;

-- 4. Poblar clase, lote y vencimiento en productos existentes
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'sagrisa' AND table_name = 'productos') THEN
        UPDATE sagrisa.productos 
        SET 
            clase = COALESCE(clase, CASE 
                WHEN familia ILIKE '%vet%' THEN 'Desparasitantes'
                WHEN familia ILIKE '%agri%' THEN 'Fertilizantes y Nutrición'
                ELSE 'Especialidades'
            END),
            fecha_vencimiento = COALESCE(fecha_vencimiento, CURRENT_DATE + INTERVAL '120 days'),
            lote = COALESCE(lote, 'LOT-SAG-2026')
        WHERE clase IS NULL;
    END IF;
END $$;

-- 5. Vista de Clientes Regionales (dbo.SAGClientesRegionales)
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

-- 6. Vista de Categorías / Clases de Productos (dbo.SAGCategoriaProductos)
CREATE OR REPLACE VIEW sagrisa.v_categoria_productos AS
SELECT DISTINCT 
    UPPER(COALESCE(clase, familia, 'GENERAL')) AS itmclscd,
    COALESCE(clase, familia, 'GENERAL') AS itmclsdc
FROM sagrisa.productos;

-- 7. Vista de Productos por Vencer (dbo.SAGProductosPorVencer)
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

-- 8. Vistas de Detalle de Facturas por País (dbo.SAGDetalleFacturasSV / GT)
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
