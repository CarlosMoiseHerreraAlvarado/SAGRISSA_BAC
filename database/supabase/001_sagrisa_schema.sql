-- SAGRISA / Supabase PostgreSQL
-- Esquema canónico para la API .NET 8.
-- Ejecutar en el SQL Editor de Supabase como administrador.
-- No incluye datos demo, credenciales ni datos del backup legacy.

begin;

create extension if not exists pgcrypto;

create schema if not exists sagrisa;

create or replace function sagrisa.set_updated_at()
returns trigger
language plpgsql
as $$
begin
    new.updated_at = timezone('utc', now());
    return new;
end;
$$;

create table if not exists sagrisa.usuarios (
    id uuid primary key default gen_random_uuid(),
    dui text not null,
    pin_hash text,
    nombre text not null,
    division text,
    pais text,
    cod_vendedor text,
    cargo text,
    email text,
    cambiado text not null default 'N',
    doc_personal text,
    fecha_sesion timestamptz,
    gerenciado_por text,
    supervisado_por text,
    rol text not null default 'Vendedor'
        check (rol in ('Cliente', 'Vendedor', 'Supervisor', 'Gerente', 'Director', 'Admin')),
    activo boolean not null default true,
    is_offline_capable boolean not null default false,
    created_at timestamptz not null default timezone('utc', now()),
    updated_at timestamptz not null default timezone('utc', now()),
    constraint uq_usuarios_dui unique (dui)
);

create unique index if not exists ux_usuarios_cod_vendedor
    on sagrisa.usuarios (cod_vendedor)
    where cod_vendedor is not null;
create index if not exists ix_usuarios_nombre on sagrisa.usuarios (nombre);
create index if not exists ix_usuarios_rol_activo on sagrisa.usuarios (rol, activo);

create table if not exists sagrisa.clientes (
    cod_cliente text primary key,
    profile_id uuid,
    nom_cliente text not null,
    dui text,
    clase text,
    vendedor text,
    ciudad text,
    direccion text,
    telefono text,
    tpago text,
    inactive integer not null default 0 check (inactive in (0, 1)),
    hold integer not null default 0 check (hold in (0, 1)),
    l_precios text,
    monto_credito numeric(18, 2) not null default 0 check (monto_credito >= 0),
    total_deuda numeric(18, 2) not null default 0 check (total_deuda >= 0),
    saldo_credito numeric(18, 2) not null default 0,
    correo text,
    created_at timestamptz not null default timezone('utc', now())
);

create index if not exists ix_clientes_vendedor on sagrisa.clientes (vendedor);
create index if not exists ix_clientes_estado on sagrisa.clientes (inactive, hold);
create index if not exists ix_clientes_nombre on sagrisa.clientes (nom_cliente);
create index if not exists ix_clientes_ciudad on sagrisa.clientes (ciudad);

create table if not exists sagrisa.productos (
    id uuid primary key default gen_random_uuid(),
    codigo text not null,
    nombre text not null,
    descripcion text,
    familia text not null default 'General',
    division text,
    presentacion text not null default 'Unidad',
    precio numeric(18, 2) not null default 0 check (precio >= 0),
    stock integer not null default 0 check (stock >= 0),
    bodega text not null default 'Bodega Central',
    activo boolean not null default true,
    created_at timestamptz not null default timezone('utc', now()),
    constraint uq_productos_codigo unique (codigo)
);

create index if not exists ix_productos_familia_activo on sagrisa.productos (familia, activo);
create index if not exists ix_productos_nombre on sagrisa.productos (nombre);

create table if not exists sagrisa.pedidos (
    id uuid primary key default gen_random_uuid(),
    num_pedido text not null,
    cod_cliente text not null references sagrisa.clientes (cod_cliente)
        on update cascade on delete restrict,
    cod_vendedor text not null,
    tpago text not null default 'Contado',
    fecha_pedido timestamptz not null default timezone('utc', now()),
    fecha_entrega timestamptz,
    plazo_entrega_pedido integer not null default 1 check (plazo_entrega_pedido >= 0),
    observacion text not null default '',
    total_pedido numeric(18, 2) not null default 0 check (total_pedido >= 0),
    pais text not null default 'SV',
    id_direccion integer,
    direccion_entrega text,
    latitud numeric(9, 6) check (latitud is null or latitud between -90 and 90),
    longitud numeric(9, 6) check (longitud is null or longitud between -180 and 180),
    is_synced boolean not null default true,
    status smallint not null default 1 check (status between 1 and 5),
    est_corr text not null default 'A',
    fech_hora_insert timestamptz not null default timezone('utc', now()),
    origen text not null default 'PWA',
    id_bac text not null default '',
    id_clie_caf text not null default '',
    estado_bac text not null default '',
    order_caf text not null default '',
    estatus text not null default 'Activo',
    num_factura text not null default '',
    err_correo text not null default '',
    created_at timestamptz not null default timezone('utc', now()),
    updated_at timestamptz not null default timezone('utc', now()),
    constraint uq_pedidos_num_pedido unique (num_pedido)
);

create index if not exists ix_pedidos_cliente_fecha
    on sagrisa.pedidos (cod_cliente, fecha_pedido desc);
create index if not exists ix_pedidos_vendedor_fecha
    on sagrisa.pedidos (cod_vendedor, fecha_pedido desc);
create index if not exists ix_pedidos_status on sagrisa.pedidos (status, estatus);

create table if not exists sagrisa.pedido_detalles (
    id uuid primary key default gen_random_uuid(),
    order_id uuid not null references sagrisa.pedidos (id)
        on update cascade on delete cascade,
    num_pedido text not null,
    cod_cliente text not null references sagrisa.clientes (cod_cliente)
        on update cascade on delete restrict,
    cod_producto text not null references sagrisa.productos (codigo)
        on update cascade on delete restrict,
    nom_producto text not null,
    presentacion text not null default 'Unidad',
    cantidad numeric(18, 3) not null check (cantidad > 0),
    precio_unitario numeric(18, 2) not null check (precio_unitario >= 0),
    precio_total numeric(18, 2) not null check (precio_total >= 0),
    cod_vendedor text not null,
    bodega text not null default 'B01',
    origen text not null default 'PWA',
    created_at timestamptz not null default timezone('utc', now())
);

create index if not exists ix_pedido_detalles_order on sagrisa.pedido_detalles (order_id);
create index if not exists ix_pedido_detalles_producto on sagrisa.pedido_detalles (cod_producto);

create table if not exists sagrisa.facturas (
    id uuid primary key default gen_random_uuid(),
    num_factura text not null,
    order_id uuid references sagrisa.pedidos (id)
        on update cascade on delete set null,
    cod_cliente text not null references sagrisa.clientes (cod_cliente)
        on update cascade on delete restrict,
    fecha_emision timestamptz not null default timezone('utc', now()),
    fecha_vencimiento timestamptz not null,
    total_factura numeric(18, 2) not null check (total_factura >= 0),
    saldo numeric(18, 2) not null check (saldo >= 0),
    status smallint not null default 1 check (status between 1 and 6),
    pdf_url text,
    created_at timestamptz not null default timezone('utc', now()),
    constraint uq_facturas_num_factura unique (num_factura)
);

create index if not exists ix_facturas_cliente_fecha
    on sagrisa.facturas (cod_cliente, fecha_emision desc);
create index if not exists ix_facturas_status on sagrisa.facturas (status);

create table if not exists sagrisa.cobros (
    id uuid primary key default gen_random_uuid(),
    factura_id uuid not null references sagrisa.facturas (id)
        on update cascade on delete restrict,
    num_factura text not null,
    cod_cliente text not null references sagrisa.clientes (cod_cliente)
        on update cascade on delete restrict,
    cod_vendedor text,
    monto numeric(18, 2) not null check (monto > 0),
    metodo_pago smallint not null default 2 check (metodo_pago between 1 and 3),
    referencia text,
    comprobante_url text,
    firma_url text,
    status smallint not null default 1 check (status between 1 and 3),
    notas text,
    created_at timestamptz not null default timezone('utc', now())
);

create unique index if not exists ux_cobros_factura_referencia
    on sagrisa.cobros (factura_id, referencia)
    where referencia is not null and btrim(referencia) <> '';
create index if not exists ix_cobros_cliente_fecha
    on sagrisa.cobros (cod_cliente, created_at desc);
create index if not exists ix_cobros_status on sagrisa.cobros (status);

create table if not exists sagrisa.aprobaciones (
    id uuid primary key default gen_random_uuid(),
    num_pedido text,
    cod_cliente text not null references sagrisa.clientes (cod_cliente)
        on update cascade on delete restrict,
    cod_vendedor text,
    monto numeric(18, 2) not null default 0 check (monto >= 0),
    motivo text not null,
    detalles text,
    estado text not null default 'pending'
        check (estado in ('pending', 'pendiente', 'approved', 'aprobada', 'rejected', 'rechazada', 'cancelled')),
    decidido_por uuid references sagrisa.usuarios (id)
        on update cascade on delete set null,
    comentario_decision text,
    created_at timestamptz not null default timezone('utc', now())
);

create unique index if not exists ux_aprobaciones_num_pedido
    on sagrisa.aprobaciones (num_pedido)
    where num_pedido is not null and btrim(num_pedido) <> '';
create index if not exists ix_aprobaciones_estado_fecha
    on sagrisa.aprobaciones (estado, created_at desc);
create index if not exists ix_aprobaciones_cliente on sagrisa.aprobaciones (cod_cliente);

create table if not exists sagrisa.audit_events (
    id uuid primary key default gen_random_uuid(),
    actor_id uuid references sagrisa.usuarios (id)
        on update cascade on delete set null,
    action text not null,
    entity_type text not null,
    entity_id text,
    before_data jsonb,
    after_data jsonb,
    ip_address inet,
    user_agent text,
    created_at timestamptz not null default timezone('utc', now())
);

create index if not exists ix_audit_events_entity
    on sagrisa.audit_events (entity_type, entity_id, created_at desc);
create index if not exists ix_audit_events_actor
    on sagrisa.audit_events (actor_id, created_at desc);

create table if not exists sagrisa.webhook_events (
    id uuid primary key default gen_random_uuid(),
    source text not null,
    event_key text not null,
    event_type text not null,
    payload jsonb not null,
    status text not null default 'pending'
        check (status in ('pending', 'processing', 'processed', 'failed')),
    attempts integer not null default 0 check (attempts >= 0),
    received_at timestamptz not null default timezone('utc', now()),
    processed_at timestamptz,
    last_error text,
    constraint uq_webhook_events_source_key unique (source, event_key)
);

create index if not exists ix_webhook_events_pending
    on sagrisa.webhook_events (status, received_at);

create table if not exists sagrisa.metas_comerciales (
    id uuid primary key default gen_random_uuid(),
    periodo_tipo text not null default 'mensual',
    periodo_inicio date not null,
    periodo_fin date not null,
    division_codigo text,
    vendedor_codigo text,
    proyeccion numeric(19, 4) not null default 0 check (proyeccion >= 0),
    created_at timestamptz not null default timezone('utc', now()),
    constraint ck_metas_periodo check (periodo_fin >= periodo_inicio),
    constraint uq_metas_periodo unique (periodo_tipo, periodo_inicio, division_codigo, vendedor_codigo)
);

create index if not exists ix_metas_periodo
    on sagrisa.metas_comerciales (periodo_inicio, periodo_fin);

drop trigger if exists trg_usuarios_updated_at on sagrisa.usuarios;
create trigger trg_usuarios_updated_at
before update on sagrisa.usuarios
for each row execute function sagrisa.set_updated_at();

drop trigger if exists trg_pedidos_updated_at on sagrisa.pedidos;
create trigger trg_pedidos_updated_at
before update on sagrisa.pedidos
for each row execute function sagrisa.set_updated_at();

commit;
