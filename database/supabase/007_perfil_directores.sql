-- ============================================================================
-- SCRIPT DE COMPATIBILIDAD - PERFIL DE DIRECTORES (SUPABASE / POSTGRESQL)
-- ============================================================================

-- 1. Agregar columnas a productos en PostgreSQL
ALTER TABLE IF EXISTS sagrisa.productos 
    ADD COLUMN IF NOT EXISTS clase text,
    ADD COLUMN IF NOT EXISTS fecha_vencimiento date,
    ADD COLUMN IF NOT EXISTS lote text;

-- 2. Vista de Clientes Regionales
CREATE OR REPLACE VIEW sagrisa.v_clientes_regionales AS
SELECT 
    codigo AS custnmbr,
    nombre AS custname,
    NOT activo AS inactive,
    FALSE AS hold,
    pais,
    COALESCE(tipo, 'DIRECTO') AS clase_cliente
FROM sagrisa.clientes;

-- 3. Vista de Categorías / Clases de Productos
CREATE OR REPLACE VIEW sagrisa.v_categoria_productos AS
SELECT DISTINCT 
    UPPER(COALESCE(clase, categoria, familia, 'GENERAL')) AS itmclscd,
    COALESCE(clase, categoria, familia, 'GENERAL') AS itmclsdc
FROM sagrisa.productos;

-- 4. Vista de Productos por Vencer
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
