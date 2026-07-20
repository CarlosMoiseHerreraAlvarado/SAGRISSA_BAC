 🚀 SAGRISA API — Sistema de Gestión REST

[![.NET 8 LTS](https://img.shields.io/badge/.NET-8.0_LTS-512BD4?style=for-the-badge&logo=dotnet)](https://dotnet.microsoft.com/en-us/download/dotnet/8.0)
[![Architecture](https://img.shields.io/badge/Architecture-Clean_Architecture-0052FF?style=for-the-badge)](https://learn.microsoft.com/en-us/dotnet/architecture/modern-web-apps-azure/common-web-application-architectures)
[![Status](https://img.shields.io/badge/Status-Initial_Phase_/_Mock_Data-⚡_Orange?style=for-the-badge)](#estado-actual-del-proyecto)

Backend de alto rendimiento desarrollado bajo estándares modernos con **ASP.NET Core Web API (.NET 8 LTS)** para el ecosistema institucional e integraciones del sistema **SAGRISA**.

---

## 📝 Descripción del Estado Actual

El proyecto se encuentra en su **Fase Inicial de Homologación Estructural**. Todos los endpoints actuales exponen información simulada (*mock data*) estructurada rigurosamente bajo contratos e interfaces de negocio bien definidos. 

Esta estrategia permite:
1. **Validación Temprana:** Asegurar la consistencia de los contratos REST expuestos mediante Swagger y colecciones de Postman.
2. **Desacoplamiento Frontend/Integraciones:** Permitir que los consumidores del servicio inicien integraciones sin depender del despliegue final de base de datos.
3. **Migración Transparente:** La persistencia de datos real hacia **SQL Server** se activará a nivel de infraestructura sin mutar ni afectar la lógica de aplicación ni los controladores existentes.

---

## 🏛️ Diseño de Arquitectura (Clean Architecture)

La solución implementa una arquitectura desacoplada por capas orientada a dominios, garantizando mantenibilidad, escalabilidad y facilidad de pruebas (*testability*):

```text
Sagrisa (Solución)
├── 💻 Sagrisa.API             [Capa de Presentación / REST Entrypoint]
├── ⚙️ Sagrisa.Application     [Lógica de Aplicación / Casos de Uso]
├── 📦 Sagrisa.Domain          [Núcleo del Negocio / Entidades puras]
└── 🛠️ Sagrisa.Infrastructure  [Acceso a Datos / Agentes Externos]
```

### 🎛️ 1. Sagrisa.API
Punto de entrada HTTP. Es una capa puramente de orquestación y exposición de interfaces públicas. No contiene reglas de negocio.
* **Responsabilidades:** Controladores REST (`Controllers`), inyección de dependencias global, middlewares de manejo de excepciones y auditoría, configuraciones transaccionales y documentación automática via OpenAPI/Swagger.

### ⚙️ 2. Sagrisa.Application
Define las capacidades y flujo transaccional de la solución. Contiene las interfaces e implementaciones de los servicios que coordinan el negocio.
* **Responsabilidades:** Casos de uso específicos, mapeadores de datos (`Mappings`), contratos abstractos (`Interfaces`), manejo de servicios (`Services`) y orquestación de Objetos de Transferencia de Datos (`DTOs`).

### 📦 3. Sagrisa.Domain
El corazón del sistema. Es una biblioteca pura que representa los conceptos fundamentales del negocio. **No posee dependencias ni referencias externas hacia ningún proyecto o framework.**
* **Responsabilidades:** Definición de modelos principales (`Entities`), enumeraciones restrictivas (`Enums`) y constantes compartidas de negocio (`Common`).

### 🛠️ 4. Sagrisa.Infrastructure
Abstrae y gestiona todas las dependencias tecnológicas externas. Implementa las firmas e interfaces requeridas por la aplicación.
* **Responsabilidades:** Implementación del patrón repositorio (`Repositories`), contextos de acceso y mapeo relacional a base de datos para **SQL Server** (`Context`) y perfiles de configuración de persistencia nativa.

---

## 🔄 Flujo Transaccional de Datos

El recorrido de las peticiones mantiene un orden unidireccional e inmutable para preservar la integridad de la arquitectura:

```text
[ Cliente / Consumidor ]
          │
          ▼
   ┌─────────────┐
   │ Controllers │  (Sagrisa.API)
   └──────┬──────┘
          │
          ▼
   ┌─────────────┐
   │  Services   │  (Sagrisa.Application)
   └──────┬──────┘
          │
          ▼
   ┌─────────────┐
   │Repositories │  (Sagrisa.Infrastructure)
   └──────┬──────┘
          │
          ▼
   ┌─────────────┐
   │ SQL Server  │  (Persistencia Real - Mock en Transición)
   └─────────────┘
```

---

## 📌 Estado Actual del Proyecto

- [x] **Estructuración Base:** Inicialización de solución multiplataforma basada en Clean Architecture (.NET 8).
- [x] **Capa REST Avanzada:** Middleware global y enrutamiento unificado de Controladores.
- [x] **Auto-Documentación:** Motor interactivo de OpenAPI/Swagger completamente integrado y tipado.
- [x] **Contratos de Datos:** Diseños e implementación de DTOs nativos para respuestas uniformes.
- [x] **Simulación Controlada:** Repositorios Mock inyectados mediante contenedores de dependencias nativos.
- [x] **Ambiente Sandbox:** Preparado para pruebas de integración con herramientas como Postman.
- [ ] **Persistencia Nativa:** Conexión y mapeo físico relacional con SQL Server (En desarrollo activo 🔄).

---

## 🚀 Endpoints Disponibles

### 🛠️ Servicio Técnico y Diagnóstico
* `GET /api/test` → Ejecuta un chequeo básico del estado general de la API (*Health Probe*).

### 👥 Gestión de Usuarios
* `GET /api/usuarios` → Recupera la lista completa de usuarios operativos activos del sistema.
* `GET /api/usuarios/{pin}` → Localiza detalladamente el perfil de un usuario mapeado a través de su código PIN único.

### 💼 Catálogo de Clientes
* `GET /api/clientes` → Devuelve la nómina maestra de clientes comerciales consolidados.
* `GET /api/clientes/{codigo}` → Extrae la información corporativa, financiera y general de un cliente por su código institucional.

### 📦 Módulo de Pedidos y Ventas
* `GET /api/pedidos` → Historial generalizado y consolidado de las órdenes de pedidos procesadas en el canal.
* `GET /api/pedidos/{numero}` → Desglose completo de ítems, totales, metadatos y estados específicos de un pedido consultado por su número correlativo único.

---

## 🛠️ Stack Tecnológico Integrado

* **Core Runtime:** ASP.NET Core Web API bajo la plataforma unificada **.NET 8 LTS**.
* **Engine Relacional:** Microsoft SQL Server (Planificado y en proceso de acoplamiento).
* **Documentación Dinámica:** OpenAPI Suite con interfaz gráfica interactiva vía **Swagger UI**.
* **Pruebas y Diagnóstico:** Postman API Platform.
