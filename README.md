# SAGRISA API

## Descripción
Backend REST desarrollado en ASP.NET Core Web API (**NET 8 LTS**) para la integración con el sistema SAGRISA.

Actualmente el proyecto se encuentra en una fase inicial donde los endpoints devuelven información simulada (*mock data*) para validar la arquitectura, los contratos REST y la comunicación mediante Swagger y Postman. Posteriormente los datos serán obtenidos desde SQL Server utilizando la infraestructura definida.

## Arquitectura
La solución está organizada siguiendo una separación por capas (Clean Architecture):

Sagrisa
├── Sagrisa.API
├── Sagrisa.Application
├── Sagrisa.Domain
└── Sagrisa.Infrastructure

### Sagrisa.API
Contiene la exposición de la API REST. No contiene lógica de negocio.
* **Responsabilidades:** Controllers, Configuración, Swagger, Middlewares, Dependency Injection.

### Sagrisa.Application
Contiene los casos de uso del sistema. Aquí vive la lógica de aplicación.
* **Responsabilidades:** Servicios, Interfaces, DTOs, Mapping.

### Sagrisa.Domain
Representa el dominio del negocio. No depende de ningún otro proyecto de la solución.
* **Contiene:** Entidades, Enumeraciones, Objetos comunes.

### Sagrisa.Infrastructure
Implementa el acceso a datos. Actualmente devuelve datos simulados hasta contar con acceso a la base de datos oficial.
* **Responsabilidades:** Repositorios, Conexión SQL Server, Configuración de base de datos.

## Flujo de la Aplicación
Cliente ──> Controller ──> Service ──> Repository ──> SQL Server

## Estado Actual del Proyecto
- [x] API creada
- [x] Swagger configurado
- [x] Endpoint de prueba
- [x] Comunicación mediante Postman
- [x] Arquitectura base
- [ ] Pendiente conexión con SQL Server (En desarrollo 🔄)

## Endpoints Disponibles

### Test
* `GET /api/test` - Verifica el funcionamiento de la API.

### Usuarios
* `GET /api/usuarios` - Listar usuarios (Datos simulados).
* `GET /api/usuarios/{pin}` - Obtener usuario por PIN (Datos simulados).

### Clientes
* `GET /api/clientes` - Listar clientes (Datos simulados).
* `GET /api/clientes/{codigo}` - Obtener cliente por código (Datos simulados).

### Pedidos
* `GET /api/pedidos` - Listar pedidos (Datos simulados).
* `GET /api/pedidos/{numero}` - Obtener pedido por número (Datos simulados).

## Tecnologías Utilizadas
* ASP.NET Core Web API
* .NET 8 LTS
* Swagger / OpenAPI
* SQL Server (pendiente integración)
* Postman
