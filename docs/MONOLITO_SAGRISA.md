# Monolito modular SAGRISA

## Propósito

Este documento fija la arquitectura objetivo para continuar el backend SAGRISA sin perder el flujo actual ni migrar datos de forma irreversible.

La solución será un **monolito modular**: una sola API desplegable, con módulos internos separados por responsabilidad. No se crearán microservicios mientras los requerimientos, las queries y el sistema transaccional oficial no estén cerrados.

## Decisiones confirmadas

- Backend: C# con .NET 8 y ASP.NET Core Web API.
- Arquitectura: API, Application, Domain e Infrastructure dentro de una única solución.
- Frontend: React + TypeScript + Vite + Tailwind CSS + PWA.
- Entrada pública: ASP.NET Core; Azure API Management queda fuera de la arquitectura actual.
- Contrato: REST/JSON documentado con OpenAPI/Swagger.
- Identidad objetivo: Microsoft Entra ID con OAuth 2.0/OIDC.
- Consultas de alta demanda: Azure SQL como mirror de lectura.
- Operaciones oficiales: Dynamics o el sistema fuente autorizado por SAGRISA.
- Archivos: Azure Blob Storage para comprobantes, firmas y documentos.
- Secretos: Azure Key Vault y Managed Identity.
- Observabilidad: Application Insights y Azure Monitor.
- Despliegue de API: Azure App Service.
- Despliegue de PWA: Azure Static Web Apps.
- Supabase/PostgreSQL: se conserva únicamente durante la transición y el periodo de rollback.

## Principio de datos

La API es la única puerta de entrada para el frontend.

```text
React PWA -> ASP.NET Core API -> Azure SQL mirror (lecturas)
                           -> Dynamics/sistema oficial (escrituras)
                           -> Blob Storage (archivos)
```

Reglas obligatorias:

1. React nunca accede directamente a SQL Server, Azure SQL, Supabase ni Dynamics.
2. El mirror SQL es read-only desde la lógica de negocio.
3. Los pedidos, cobros, aprobaciones y anulaciones deben llegar al sistema transaccional oficial.
4. Toda escritura debe ser idempotente y auditable.
5. La migración no elimina la fuente anterior hasta completar reconciliación y rollback.

## Módulos del monolito

### Identity and Access

- Integración con Entra ID.
- Validación de tokens.
- Mapeo de claims a permisos efectivos.
- Alcance por cliente, vendedor, supervisor, gerente, división y país.
- Compatibilidad temporal con el login DUI/PIN solamente mientras se define la transición.

### Customers and Accounts

- Clientes.
- Direcciones.
- Saldos.
- Crédito.
- Antigüedad de deuda.
- Historial de cuenta.
- Alcance por usuario autenticado.

### Catalog and Inventory

- Productos.
- Presentaciones.
- Precios.
- Listas de precio.
- Bodegas.
- Existencias.
- Lotes y vencimientos.
- Validación de disponibilidad.

### Orders

- Creación de pedidos.
- Detalles de pedido.
- Dirección y fecha de entrega.
- Observaciones.
- Estados de pedido.
- Problemas de crédito.
- Historial.
- Correlativo oficial.
- Sincronización con el sistema transaccional.

### Billing and Payments

- Facturas.
- Saldos.
- Cobros parciales.
- Cobros totales.
- Cobros de múltiples facturas.
- Métodos de pago.
- Referencias y comprobantes.
- Firma del cliente.
- DUI opcional.
- Anulaciones controladas.

### Approvals

- Solicitudes de aprobación.
- Aprobar o rechazar.
- Comentario y justificación.
- Usuario, fecha y estado anterior.
- Auditoría obligatoria.
- Protección contra doble decisión.

### Goals and Analytics

- Metas de ventas.
- Metas de cobros.
- Resúmenes mensuales, trimestrales y anuales.
- Filtros por vendedor, división, área, país y región.
- Consultas optimizadas sobre el mirror.

### Synchronization, Audit and Files

- Cola de sincronización.
- Idempotency-Key.
- Outbox para eventos que deban reintentarse.
- Registro de auditoría.
- Webhooks entrantes.
- Blob Storage.
- Retención y limpieza de archivos.

## Puertos de infraestructura

La lógica de negocio no debe depender de una base concreta. Se deben mantener adaptadores separados:

```text
Application
  IQueryStore
  ITransactionGateway
  IIdentityProvider
  IFileStorage
  IAuditWriter
  IIdempotencyStore

Infrastructure
  AzureSqlQueryStore
  DynamicsTransactionGateway
  EntraIdentityProvider
  AzureBlobFileStorage
  AuditRepository
  IdempotencyRepository
  LegacyMovilAdapter
  SupabaseTransitionAdapter
```

`LegacyMovilAdapter` y `SupabaseTransitionAdapter` son temporales o de compatibilidad. No deben convertirse en dependencias de los controladores.

## Lecturas y escrituras

### Lecturas que se pueden preparar

- Clientes.
- Productos.
- Inventario.
- Precios.
- Facturas.
- Saldos.
- Historial de pedidos.
- Historial de cobros.
- Metas y reportes.

### Escrituras que requieren requisitos finales

- Crear pedido.
- Editar pedido.
- Registrar cobro.
- Registrar cobro parcial.
- Registrar cobro múltiple.
- Aprobar factura o pedido.
- Rechazar factura o pedido.
- Anular cobro.
- Actualizar cliente o dirección.

No se habilitarán como definitivas hasta recibir la matriz de permisos, las queries optimizadas y el contrato del sistema fuente.

## Seguridad de producción

- No exponer credenciales heredadas del backup.
- No migrar usuarios SQL ni roles `db_owner`.
- No conservar contraseñas antiguas en texto.
- No devolver excepciones SQL al frontend.
- Restringir CORS a dominios reales.
- No permitir `localhost` en producción.
- Aplicar rate limiting en ASP.NET Core.
- Proteger Swagger o limitarlo a staging.
- Usar Key Vault y Managed Identity.
- Auditar toda operación financiera y de autorización.
- Validar permisos tanto en endpoint como en alcance de datos.

## Migración del backup Movil.bak

El backup contiene datos reales y debe conservarse como evidencia de la fuente. Se analizó una restauración temporal con los siguientes resultados:

- Backup válido.
- `DBCC CHECKDB` sin errores.
- 117 tablas de usuario.
- 67 vistas.
- 83 procedimientos.
- 2 funciones.
- 4 triggers.
- Aproximadamente 1.3 millones de filas.
- 102 tablas sin clave primaria.
- Referencias nominales a `GPSAG` y al entorno `SAGRI_MOVIL`.

El backup no se debe convertir automáticamente en el modelo de dominio. Se requiere clasificación, mapeo, limpieza y reconciliación.

## Estado actual del repositorio

El backend actual todavía está orientado a PostgreSQL/Supabase:

- `UseNpgsql()` está activo.
- El health check se llama `SupabaseHealthCheck`.
- Hay SQL PostgreSQL con `public` y `FOR UPDATE`.
- El contexto utiliza tipos `jsonb`.
- No está instalado el proveedor EF Core de SQL Server.
- No hay migraciones EF Core para SQL Server.
- La autenticación actual es DUI/PIN con JWT propio.
- No se encontró configuración final de Entra ID, rate limiting ni Application Insights.
- El perfil ARM guardado corresponde a una Function App antigua con .NET 3.1 y no debe usarse para publicar esta API .NET 8.

La solución compila y las pruebas unitarias actuales pasan, pero esas pruebas no certifican compatibilidad con SQL Server, Azure, Entra, Dynamics ni producción.

## Gates antes de producción

### Gate 0 - Requisitos

- Requerimientos finales.
- Matriz rol-endpoint-operación-alcance.
- Catálogo de queries.
- Fuente oficial de cada escritura.

### Gate 1 - Datos

- Respaldo original protegido.
- Diccionario de datos.
- Clasificación de tablas.
- Dependencias externas identificadas.
- Reconciliación de conteos y totales.

### Gate 2 - Backend

- Proveedor SQL Server implementado.
- DTOs separados de tablas heredadas.
- Transacciones.
- Idempotencia.
- Auditoría obligatoria.
- Integración con el sistema oficial.

### Gate 3 - Seguridad y operación

- Entra ID.
- CORS productivo.
- Rate limiting.
- Key Vault.
- Logs y Application Insights.
- Health check real.
- Swagger protegido.

### Gate 4 - Staging

- Smoke tests por rol.
- Pruebas de lectura.
- Pruebas de pedido.
- Pruebas de cobro.
- Pruebas de aprobación.
- Pruebas offline y reintentos.
- Prueba de rollback.

### Gate 5 - Producción

- Ventana de cambio aprobada.
- Congelamiento de escrituras durante el corte.
- Delta final de datos.
- Monitoreo activo.
- Rollback documentado.
- Fuente anterior conservada en modo seguro.

## Decisiones todavía pendientes

1. Confirmar si el sistema oficial es Dynamics 365 o Dynamics GP.
2. Confirmar si Azure SQL será solo mirror o también fuente operacional.
3. Recibir la matriz final de permisos.
4. Recibir el catálogo de queries optimizadas.
5. Confirmar el mecanismo de sincronización con el sistema oficial.
6. Definir el pipeline CI/CD: GitHub Actions o Azure DevOps.

Mientras estas decisiones no estén cerradas, el alcance seguro es staging y lecturas controladas. No se debe retirar Supabase ni publicar cobros, aprobaciones o pedidos como producción definitiva.
