/* SAGRISA - validación posterior a la creación/importación */

SET NOCOUNT ON;
GO

SELECT DB_NAME() AS database_name;

SELECT
    s.name AS schema_name,
    t.name AS table_name,
    SUM(p.rows) AS row_count
FROM sys.tables AS t
JOIN sys.schemas AS s ON s.schema_id = t.schema_id
JOIN sys.partitions AS p ON p.object_id = t.object_id AND p.index_id IN (0, 1)
WHERE s.name = N'dbo'
GROUP BY s.name, t.name
ORDER BY t.name;

SELECT
    fk.name AS foreign_key_name,
    OBJECT_SCHEMA_NAME(fk.parent_object_id) + N'.' + OBJECT_NAME(fk.parent_object_id) AS child_table,
    OBJECT_SCHEMA_NAME(fk.referenced_object_id) + N'.' + OBJECT_NAME(fk.referenced_object_id) AS parent_table,
    fk.is_disabled
FROM sys.foreign_keys AS fk
WHERE fk.schema_id = SCHEMA_ID(N'dbo')
ORDER BY child_table, foreign_key_name;

SELECT name, type_desc
FROM sys.objects
WHERE schema_id = SCHEMA_ID(N'dbo')
  AND type IN ('V', 'P', 'FN', 'IF', 'TF')
ORDER BY type_desc, name;

/* Debe devolver cero filas: referencias huérfanas en detalles. */
SELECT d.id, d.pedido_id
FROM dbo.pedido_detalles AS d
LEFT JOIN dbo.pedidos AS p ON p.id = d.pedido_id
WHERE d.pedido_id IS NOT NULL AND p.id IS NULL;

/* Debe devolver cero filas: columnas operativas críticas sin código. */
SELECT N'clientes.cod_cliente' AS campo, COUNT_BIG(*) AS registros
FROM dbo.clientes WHERE cod_cliente IS NULL
UNION ALL
SELECT N'clientes.nom_cliente', COUNT_BIG(*)
FROM dbo.clientes WHERE nom_cliente IS NULL
UNION ALL
SELECT N'pedidos.cod_cliente', COUNT_BIG(*)
FROM dbo.pedidos WHERE cod_cliente IS NULL;

