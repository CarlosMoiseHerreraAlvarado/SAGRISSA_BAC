-- =========================================================================
-- SAGRISA / Supabase PostgreSQL
-- Migración 005: Tablas y Datos para Lotes de Inventario y Metas por División.
-- =========================================================================

-- PASO 1: CREAR TABLA DE LOTES
CREATE TABLE IF NOT EXISTS public.producto_lotes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cod_producto TEXT NOT NULL REFERENCES public.productos (codigo)
        ON UPDATE CASCADE ON DELETE CASCADE,
    numero_lote TEXT NOT NULL,
    saldo_lote INTEGER NOT NULL DEFAULT 0 CHECK (saldo_lote >= 0),
    bodega TEXT NOT NULL DEFAULT 'Bodega Central',
    fecha_vencimiento DATE NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT uq_producto_lote UNIQUE (cod_producto, numero_lote, bodega)
);

CREATE INDEX IF NOT EXISTS ix_producto_lotes_cod ON public.producto_lotes (cod_producto);
CREATE INDEX IF NOT EXISTS ix_producto_lotes_venc ON public.producto_lotes (fecha_vencimiento);

-- PASO 2: CREAR TABLA DE METAS POR DIVISIÓN
CREATE TABLE IF NOT EXISTS public.metas_divisiones (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo_division TEXT NOT NULL CHECK (codigo_division IN ('AGR', 'VET', 'IND', 'PRO', 'TAL')),
    nombre_division TEXT NOT NULL,
    anio INTEGER NOT NULL DEFAULT 2022,
    mes INTEGER NOT NULL DEFAULT 11 CHECK (mes BETWEEN 1 AND 12),
    trimestre INTEGER NOT NULL DEFAULT 4 CHECK (trimestre BETWEEN 1 AND 4),
    proyeccion NUMERIC(18, 2) NOT NULL DEFAULT 1000000.00 CHECK (proyeccion >= 0),
    ventas_reales NUMERIC(18, 2) NOT NULL DEFAULT 0.00 CHECK (ventas_reales >= 0),
    cobros_reales NUMERIC(18, 2) NOT NULL DEFAULT 0.00 CHECK (cobros_reales >= 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT uq_metas_div_periodo UNIQUE (codigo_division, anio, mes)
);

CREATE INDEX IF NOT EXISTS ix_metas_div_periodo ON public.metas_divisiones (anio, mes);

-- PASO 3: INSERTAR PRODUCTOS BASE
INSERT INTO public.productos (codigo, nombre, descripcion, familia, presentacion, precio, stock, bodega, activo)
VALUES 
    ('BIO-11-BL', 'BIOMIN BOOTER 11 (1gl) BLANCO 120 UNIDADES PACK 2', 'Fertilizante bioestimulante foliar quelatado', 'Agrícola', 'Galón (1gl) Pack 2', 55.70, 10000, 'Bodega Central', true),
    ('VET-ANT-500', 'ANTIBIÓTICO VETERINARIO AMPLIO ESPECTRO 500ML', 'Solución inyectable para uso veterinario', 'Veterinaria', 'Frasco 500ml', 150.00, 350, 'Bodega Oriental', true),
    ('IND-DES-20L', 'DESINFECTANTE INDUSTRIAL BIOCIDA 20L', 'Compuesto desinfectante grado industrial concentrado', 'Industrial y Servicios', 'Bidón 20L', 275.00, 200, 'Bodega Occidental', true)
ON CONFLICT (codigo) DO UPDATE SET
    nombre = EXCLUDED.nombre,
    precio = EXCLUDED.precio,
    stock = EXCLUDED.stock,
    bodega = EXCLUDED.bodega;

-- PASO 4: INSERTAR LOTES
INSERT INTO public.producto_lotes (cod_producto, numero_lote, saldo_lote, bodega, fecha_vencimiento)
VALUES
    ('BIO-11-BL', 'W2204046', 252, 'Bodega Central', '2025-04-30'),
    ('BIO-11-BL', 'W2204047', 180, 'Bodega Central', '2025-06-15'),
    ('BIO-11-BL', 'W2204048', 95, 'Bodega Oriental', '2025-08-28'),
    ('BIO-11-BL', 'W2204049', 320, 'Bodega Occidental', '2025-12-10'),
    ('VET-ANT-500', 'V2301010', 150, 'Bodega Oriental', '2025-11-30'),
    ('IND-DES-20L', 'I2302020', 200, 'Bodega Occidental', '2026-03-31')
ON CONFLICT (cod_producto, numero_lote, bodega) DO UPDATE SET
    saldo_lote = EXCLUDED.saldo_lote,
    fecha_vencimiento = EXCLUDED.fecha_vencimiento;

-- PASO 5: INSERTAR METAS
INSERT INTO public.metas_divisiones (codigo_division, nombre_division, anio, mes, trimestre, proyeccion, ventas_reales, cobros_reales)
VALUES
    ('AGR', 'Agrícola', 2022, 11, 4, 1000000.00, 580000.00, 575000.00),
    ('VET', 'Veterinaria', 2022, 11, 4, 1000000.00, 575000.00, 580000.00),
    ('IND', 'Industrial y Servicios', 2022, 11, 4, 1000000.00, 650000.00, 610000.00),
    ('PRO', 'Proyectos', 2022, 11, 4, 1000000.00, 420000.00, 400000.00),
    ('TAL', 'Talleres', 2022, 11, 4, 1000000.00, 800000.00, 790000.00)
ON CONFLICT (codigo_division, anio, mes) DO UPDATE SET
    proyeccion = EXCLUDED.proyeccion,
    ventas_reales = EXCLUDED.ventas_reales,
    cobros_reales = EXCLUDED.cobros_reales;
