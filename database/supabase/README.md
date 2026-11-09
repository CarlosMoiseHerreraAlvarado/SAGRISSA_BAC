# Base de datos SAGRISA en Supabase

Estos scripts definen la base operativa de la API ASP.NET Core. La aplicación se conecta a PostgreSQL mediante el backend; el frontend no debe usar la URL, la `anon key` ni la `service_role key` de Supabase.

## Orden de ejecución

Si el proyecto ya contiene tablas de una versión anterior y confirmaste que no necesitas conservar sus datos, ejecuta primero `000_reset_sagrisa_tables.sql`. Es un reset destructivo y acotado: elimina solamente las tablas conocidas de SAGRISA en `public` y `sagrisa`, sin borrar los esquemas internos de Supabase. Si existen dependencias externas, usa el error como señal para detenerte y revisarlas.

Ejecuta cada archivo completo en el SQL Editor del proyecto Supabase:

1. `000_reset_sagrisa_tables.sql` (solo si se autorizó vaciar la base anterior).
2. `001_sagrisa_schema.sql`: crea el esquema `sagrisa`, tablas, índices, restricciones y triggers.
3. `002_runtime_role.sql`: crea o actualiza el usuario restringido `sagrisa_api`. Antes de ejecutarlo, reemplaza el marcador de contraseña por una contraseña aleatoria de al menos 24 caracteres.
4. `003_validation.sql`: confirma que las tablas y el rol esperado existan.

No ejecutes sobre esta base los scripts históricos `001_initial_schema.sql`, `002_seed_development.sql`, `003_cliente_demo.sql` ni `005_lotes_y_metas.sql`: contienen otro diseño o datos de demostración y pueden romper el contrato de la API.

## Conexión de la API

En el Dashboard de Supabase abre **Connect** y copia la cadena PostgreSQL del **Session pooler** para un backend persistente. Para una API desplegada en App Service o en otro entorno con IPv4, el pooler compartido suele ser la opción compatible. Usa SSL y conserva la cadena únicamente en variables protegidas del backend.

Configuración esperada:

```text
Database__Provider=Postgres
ConnectionStrings__Postgres=Host=...;Port=5432;Database=postgres;Username=sagrisa_api.<project-ref>;Password=...;SSL Mode=Require;Trust Server Certificate=true;Timeout=15;Command Timeout=30;Maximum Pool Size=20
```

La cadena exacta debe salir del botón **Connect** de tu proyecto. No inventes el host, el puerto ni el formato del usuario. Para EF Core/Npgsql se usa inicialmente el Session pooler en el puerto 5432; no uses el Transaction pooler en 6543 para esta API sin verificar antes sus limitaciones con prepared statements.

## Seguridad y alcance

- `sagrisa_api` no es superusuario y no recibe permisos de escritura sobre otros esquemas.
- La API mantiene el login propio por DUI/PIN y emite sus tokens Bearer.
- La `service_role key` no es necesaria para la API y nunca debe llegar al navegador.
- El esquema `sagrisa` no depende de las políticas RLS del Data API porque el backend se conecta directamente a PostgreSQL. Si en el futuro se expone una tabla por la API de Supabase, primero habrá que diseñar sus grants y políticas RLS.
- `001_sagrisa_schema.sql` no crea usuarios, PIN, clientes, productos ni facturas demo. Esos datos deben cargarse mediante una importación controlada y validada.

## Límites del plan gratuito

El plan gratuito puede pausar proyectos con baja actividad y tiene límites de almacenamiento. Para una demo o prototipo es válido, pero se debe revisar el estado del proyecto antes de una prueba y no presentarlo como garantía de disponibilidad productiva.
