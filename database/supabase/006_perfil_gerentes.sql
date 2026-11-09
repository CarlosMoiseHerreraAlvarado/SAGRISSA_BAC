-- =========================================================================
-- SAGRISA / Supabase PostgreSQL
-- Migración 006: Compatibilidad con Perfil de Gerentes
-- =========================================================================

BEGIN;

-- 1. Agregar columna 'division' a la tabla de productos si no existe
ALTER TABLE IF EXISTS sagrisa.productos 
    ADD COLUMN IF NOT EXISTS division TEXT;

-- Asignar división a productos de catálogo existentes
UPDATE sagrisa.productos SET division = 'Agrícola' WHERE division IS NULL AND (familia ILIKE '%agri%' OR familia ILIKE '%grano%' OR familia ILIKE '%abarrote%');
UPDATE sagrisa.productos SET division = 'Veterinaria' WHERE division IS NULL AND (familia ILIKE '%vet%' OR familia ILIKE '%limpieza%');
UPDATE sagrisa.productos SET division = 'Industrial' WHERE division IS NULL AND (familia ILIKE '%ind%' OR familia ILIKE '%bebida%');
UPDATE sagrisa.productos SET division = 'Taller' WHERE division IS NULL AND (familia ILIKE '%tall%' OR familia ILIKE '%vario%');
UPDATE sagrisa.productos SET division = 'Proyectos' WHERE division IS NULL AND (familia ILIKE '%proy%');
UPDATE sagrisa.productos SET division = 'Agrícola' WHERE division IS NULL;

-- 2. Vista de compatibilidad UsuarioMovil
CREATE OR REPLACE VIEW sagrisa.v_usuario_movil AS
SELECT 
    id,
    dui AS "Dui",
    nombre AS "Nombre",
    division AS "Division",
    pais AS "Pais",
    cod_vendedor AS "CodVendedor",
    cargo AS "Cargo",
    email AS "email",
    cambiado AS "Cambiado",
    doc_personal AS "DocPersonal",
    fecha_sesion AS "FechaSesion",
    gerenciado_por AS "GerenciadoPor",
    supervisado_por AS "SupervisadoPor",
    rol AS "Rol",
    activo AS "Activo"
FROM sagrisa.usuarios;

-- 3. Vista de compatibilidad TSAGDetalleVentas (El Salvador)
CREATE OR REPLACE VIEW sagrisa.tsag_detalle_ventas AS
SELECT 
    d.id AS id_detalle,
    p.num_pedido,
    p.cod_cliente,
    c.nom_cliente,
    p.cod_vendedor,
    u.nombre AS nom_vendedor,
    COALESCE(u.division, pr.division, 'Agrícola') AS division,
    CASE 
        WHEN COALESCE(u.division, pr.division) ILIKE '%agri%' THEN 'A'
        WHEN COALESCE(u.division, pr.division) ILIKE '%vet%' THEN 'V'
        WHEN COALESCE(u.division, pr.division) ILIKE '%ind%' THEN 'I'
        WHEN COALESCE(u.division, pr.division) ILIKE '%tall%' THEN 'T'
        WHEN COALESCE(u.division, pr.division) ILIKE '%proy%' THEN 'P'
        ELSE 'A'
    END AS area,
    d.cod_producto,
    d.nom_producto,
    d.cantidad,
    d.precio_unitario,
    d.precio_total,
    d.bodega,
    p.fecha_pedido AS fecha,
    EXTRACT(MONTH FROM p.fecha_pedido)::INT AS mes,
    EXTRACT(YEAR FROM p.fecha_pedido)::INT AS anio,
    EXTRACT(QUARTER FROM p.fecha_pedido)::INT AS trimestre,
    p.pais
FROM sagrisa.pedido_detalles d
JOIN sagrisa.pedidos p ON p.id = d.order_id
LEFT JOIN sagrisa.clientes c ON c.cod_cliente = p.cod_cliente
LEFT JOIN sagrisa.usuarios u ON u.cod_vendedor = p.cod_vendedor
LEFT JOIN sagrisa.productos pr ON pr.codigo = d.cod_producto
WHERE p.pais = 'SV' OR p.pais ILIKE '%salvador%';

-- 4. Vista de compatibilidad TSAGDetalleVentasGT (Guatemala)
CREATE OR REPLACE VIEW sagrisa.tsag_detalle_ventas_gt AS
SELECT 
    d.id AS id_detalle,
    p.num_pedido,
    p.cod_cliente,
    c.nom_cliente,
    p.cod_vendedor,
    u.nombre AS nom_vendedor,
    COALESCE(u.division, pr.division, 'Agrícola') AS division,
    CASE 
        WHEN COALESCE(u.division, pr.division) ILIKE '%agri%' THEN 'A'
        WHEN COALESCE(u.division, pr.division) ILIKE '%vet%' THEN 'V'
        WHEN COALESCE(u.division, pr.division) ILIKE '%ind%' THEN 'I'
        WHEN COALESCE(u.division, pr.division) ILIKE '%tall%' THEN 'T'
        WHEN COALESCE(u.division, pr.division) ILIKE '%proy%' THEN 'P'
        ELSE 'A'
    END AS area,
    d.cod_producto,
    d.nom_producto,
    d.cantidad,
    d.precio_unitario,
    d.precio_total,
    d.bodega,
    p.fecha_pedido AS fecha,
    EXTRACT(MONTH FROM p.fecha_pedido)::INT AS mes,
    EXTRACT(YEAR FROM p.fecha_pedido)::INT AS anio,
    EXTRACT(QUARTER FROM p.fecha_pedido)::INT AS trimestre,
    p.pais
FROM sagrisa.pedido_detalles d
JOIN sagrisa.pedidos p ON p.id = d.order_id
LEFT JOIN sagrisa.clientes c ON c.cod_cliente = p.cod_cliente
LEFT JOIN sagrisa.usuarios u ON u.cod_vendedor = p.cod_vendedor
LEFT JOIN sagrisa.productos pr ON pr.codigo = d.cod_producto
WHERE p.pais = 'GT' OR p.pais ILIKE '%guatemala%';

-- 5. Vistas de existencias / inventario
-- El Salvador: Con Divisiones
CREATE OR REPLACE VIEW sagrisa.tsag_movil_existencias AS
SELECT 
    codigo AS "Codigo",
    nombre AS "Nombre",
    descripcion AS "Descripcion",
    familia AS "Familia",
    division AS "Division",
    presentacion AS "Presentacion",
    precio AS "Precio",
    stock AS "Stock",
    bodega AS "Bodega",
    activo AS "Activo"
FROM sagrisa.productos;

-- Guatemala: Sin Divisiones (según requerimiento explícito)
CREATE OR REPLACE VIEW sagrisa.tsag_movil_existencias_gt AS
SELECT 
    codigo AS "Codigo",
    nombre AS "Nombre",
    descripcion AS "Descripcion",
    familia AS "Familia",
    NULL::TEXT AS "Division",
    presentacion AS "Presentacion",
    precio AS "Precio",
    stock AS "Stock",
    bodega AS "Bodega",
    activo AS "Activo"
FROM sagrisa.productos;

COMMIT;
