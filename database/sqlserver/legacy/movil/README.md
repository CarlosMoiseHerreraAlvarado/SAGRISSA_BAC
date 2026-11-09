# Movil limpia para SQL Server

Generada a partir de movil.sql sin modificar el original.

Orden:
1. 00_schemas.sql
2. 01_tables.sql
3. 02_constraints.sql
4. 03_data.sql
5. 04_functions.sql
6. 05_views.sql
7. 06_procedures.sql
8. 07_other.sql

También existe movil_limpia.sql como archivo único.

Se retiró:
- CREATE DATABASE y configuración de master
- Rutas locales MDF/LDF de SQL Express
- CREATE USER y ALTER ROLE, incluyendo db_owner
- Propiedades extendidas del script generado

Pendientes:
El SQL conserva referencias a GPSAG, NUTGT, NUTCR y SAGRI_MOVIL. Esas bases deben existir en el mismo entorno o esos objetos deben adaptarse antes de producción.
