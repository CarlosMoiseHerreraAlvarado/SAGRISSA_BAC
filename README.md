# 🚀 SAGRISA API — Sistema de Gestión REST sobre PostgreSQL/Supabase

[![.NET 8 LTS](https://img.shields.io/badge/.NET-8.0_LTS-512BD4?style=for-the-badge&logo=dotnet)](https://dotnet.microsoft.com/en-us/download/dotnet/8.0)
[![Architecture](https://img.shields.io/badge/Architecture-Clean_Architecture-0052FF?style=for-the-badge)](https://learn.microsoft.com/en-us/dotnet/architecture/modern-web-apps-azure/common-web-application-architectures)
[![Security](https://img.shields.io/badge/Security-JWT_Bearer_+_BCrypt-green?style=for-the-badge)](https://jwt.io/)
[![Tests](https://img.shields.io/badge/Unit_Tests-19_Passed-success?style=for-the-badge)](#-cobertura-de-pruebas-unitarias)

Backend corporativo desarrollado con **ASP.NET Core Web API (.NET 8 LTS)** para el ecosistema comercial de **SAGRISA**, con autenticación segura (JWT + BCrypt), lógica de negocio desacoplada, gestión de pedidos/cartera y persistencia operativa en **PostgreSQL administrado por Supabase**.

---

## 🏛️ Diseño de Arquitectura (Clean Architecture)

La solución implementa una arquitectura por capas estrictamente desacoplada:

```text
Sagrisa (Solución)
├── 💻 Sagrisa.API             [Capa de Presentación / Controladores REST / Middlewares / Swagger / JWT]
├── ⚙️ Sagrisa.Application     [Servicios de Negocio / DTOs / Interfaces / Casos de Uso / Validaciones]
├── 📦 Sagrisa.Domain          [Entidades puras / Enums / Modelos Comunes / ApiResponse]
├── 🛠️ Sagrisa.Infrastructure  [Repositorios / Generación JWT / Hasher BCrypt / Configuración]
└── 🧪 Sagrisa.UnitTests       [Pruebas Unitarias xUnit / Moq / Cobertura de Servicios y Controladores]
```

---

## 🔒 Modelo de Seguridad & Autenticación

1. **Autenticación JWT:** Token firmado con algoritmo HMAC SHA-256 conteniendo claims de usuario (`sub`, `dui`, `role`, `codVendedor`, `name`, `email`).
2. **Protección de PIN / Claves:** Hashing criptográfico unidireccional con **BCrypt** (factor de costo 11).
3. **Privacidad de Credenciales:** Los DTOs de salida (`UserProfileDto`, `UsuarioDto`) **nunca exponen PINs ni contraseñas**.
4. **Autorización Granular por Roles:** Políticas aplicadas vía atributos `[Authorize(Roles = "...")]` para proteger módulos administrativos y filtrar automáticamente la cartera y pedidos según el vendedor autenticado.
5. **Formato Estandarizado de Respuestas:** Todas las peticiones exitosas o fallidas devuelven la estructura unificada `ApiResponse<T>`:
   ```json
   {
     "success": true,
     "message": "Operación exitosa",
     "data": { ... },
     "errors": null
   }
   ```

---

## 🚀 Catálogo de Endpoints REST

### 🛡️ 1. Autenticación (`/api/auth`)
* `POST /api/auth/login` → Inicia sesión con DUI y PIN; devuelve Token JWT y perfil de usuario.
* `GET /api/auth/me` → Obtiene los datos del usuario autenticado a partir del Token Bearer.
* `POST /api/auth/change-pin` → Permite al usuario autenticado cambiar su PIN de forma segura.

### 💼 2. Cartera de Clientes (`/api/clientes`) `[Authorize]`
* `GET /api/clientes` → Lista paginada de clientes comerciales (con soporte de búsqueda y filtro por vendedor).
* `GET /api/clientes/{codigo}` → Consulta individual de cliente por código único (ej. `C001`).

### 🏷️ 3. Catálogo de Productos (`/api/productos`)
* `GET /api/productos` → Catálogo paginado con filtros por familia (`Abarrotes`, `Bebidas`, `Granos Básicos`, etc.) y estado activo.
* `GET /api/productos/{codigo}` → Ficha técnica y precio del producto por código o SKU.

### 📦 4. Módulo de Pedidos (`/api/pedidos`) `[Authorize]`
* `GET /api/pedidos` → Historial paginado de pedidos con filtros por vendedor y cliente.
* `GET /api/pedidos/{numero}` → Desglose completo de encabezado y líneas de detalle de un pedido.
* `POST /api/pedidos` → Registro atómico de nuevos pedidos con validación de cliente, bloqueo comercial e inventario.

### 💳 5. Cobros, aprobaciones y reportes
* `GET/POST /api/cobros` → Consulta y registra cobros pendientes de aprobación.
* `PATCH /api/cobros/{id}/status` → Aplica un cobro con actualización atómica de factura y cartera.
* `GET /api/approvals` y `POST /api/approvals/{id}/decision` → Gestiona aprobaciones almacenadas en PostgreSQL.
* `GET /api/reports` y `GET /api/reports/{id}/download` → Genera reportes a partir de registros reales.

### 👥 6. Administración de Usuarios (`/api/usuarios`) `[Authorize(Roles = "Admin,Director,Gerente")]`
* `GET /api/usuarios` → Listado paginado de usuarios (sin exposición de claves).
* `GET /api/usuarios/{dui}` → Perfil operativo por documento de identidad.

### 🩺 7. Diagnóstico & Health Probes
* `GET /health` → Comprueba la conectividad de la API con PostgreSQL.
* `GET /api/test` → Estado general del entorno y metadatos de integración.

---

## 🧪 Cobertura de Pruebas Unitarias

La suite de pruebas en `Sagrisa.UnitTests` valida:
* **Autenticación:** Tokens válidos, credenciales incorrectas, validación de modelos.
* **Seguridad:** Generación y verificación de hashes BCrypt.
* **Servicios de Negocio:** Lógica de `ClienteService`, `PedidoService` (restricciones de clientes bloqueados y productos inactivos).
* **Manejo de Errores:** Formato de respuestas `ApiResponse` y códigos HTTP.

```bash
dotnet test Sagrisa.sln
```
* **Resultado:** 19 pruebas superadas, 0 errores, 0 advertencias.

---

## 🛠️ Ejecución Local

La API usa PostgreSQL por defecto. Configura una cadena de conexión en `ConnectionStrings:Postgres` o mediante la variable `ConnectionStrings__Postgres`. Para el esquema y los permisos de Supabase consulta [`database/supabase/README.md`](database/supabase/README.md).

```bash
# Restaurar dependencias y compilar
dotnet build

# Ejecutar API
dotnet run --project Sagrisa.API
```

Swagger UI interactivo disponible en la raíz: `http://localhost:5201/`
