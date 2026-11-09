# Base SQL Server de SAGRISA

## Ejecución

1. Crear `SagrisaStaging` en Azure SQL Database o ejecutar `00_create_database.sql` en SQL Server local.
2. Conectarse directamente a `SagrisaStaging`.
3. Ejecutar `01_sagrisa_schema.sql` desde SQL Server Management Studio o Azure Data Studio.
4. Ejecutar `02_api_compatibility.sql` para completar el contrato operativo de la API.
5. Ejecutar `99_validation.sql` y guardar el resultado.
6. Importar datos desde `Movil` mediante un ETL controlado, después de aprobar el mapeo de columnas.

## Importante

- `movil.sql` es una base legacy independiente. No debe ejecutarse encima de este esquema.
- En Azure SQL no se deben ejecutar las líneas de `CREATE DATABASE`, rutas MDF/LDF ni usuarios/roles del archivo legacy sin revisarlas.
- La base de producción debe crearse después de validar la de staging.
- Este esquema no inventa una migración automática de datos: `PedidoEncabezado` y `PedidoDetalle` no tienen la misma estructura que las tablas canónicas de la API.
- La API ya está preparada para `Database:Provider=SqlServer` y `ConnectionStrings:SqlServer`.
- `InMemory` queda reservado para pruebas automatizadas; no debe usarse en staging ni producción.

