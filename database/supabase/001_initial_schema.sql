-- SAGRISA / Supabase PostgreSQL
-- Migracion 001: esquema base para la API .NET.
-- Ejecutar una sola vez en un proyecto Supabase nuevo o previamente respaldado.
-- La PWA no debe conectarse con service_role; el acceso de negocio sera por la API.

begin;

create extension if not exists pgcrypto;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
    new.updated_at = now();
    return new;
end;
$$;

create table if not exists public.usuarios (
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
    is_active boolean not null default true,
    is_offline_capable boolean not null default false,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    constraint uq_usuarios_dui unique (dui)
);

create unique index if not exists ux_usuarios_cod_vendedor
    on public.usuarios (cod_vendedor)
    where cod_vendedor is not null;

create index if not exists ix_usuarios_nombre on public.usuarios (nombre);
create index if not exists ix_usuarios_rol_active on public.usuarios (rol, is_active);

create table if not exists public.clientes (
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
    inactive smallint not null default 0 check (inactive in (0, 1)),
    hold smallint not null default 0 check (hold in (0, 1)),
    l_precios text,
    monto_credito numeric(18, 2) not null default 0 check (monto_credito >= 0),
    total_deuda numeric(18, 2) not null default 0 check (total_deuda >= 0),
    saldo_credito numeric(18, 2) not null default 0,
    correo text,
    created_at timestamptz not null default now()
);

create index if not exists ix_clientes_vendedor on public.clientes (vendedor);
create index if not exists ix_clientes_estado on public.clientes (inactive, hold);
create index if not exists ix_clientes_nombre on public.clientes (nom_cliente);
create index if not exists ix_clientes_ciudad on public.clientes (ciudad);

create table if not exists public.productos (
    id uuid primary key default gen_random_uuid(),
    codigo text not null,
    nombre text not null,
    descripcion text,
    familia text not null default 'General',
    presentacion text not null default 'Unidad',
    precio numeric(18, 2) not null default 0 check (precio >= 0),
    stock integer not null default 0,
    bodega text not null default 'Bodega Central',
    activo boolean not null default true,
    created_at timestamptz not null default now(),
    constraint uq_productos_codigo unique (codigo)
);

create index if not exists ix_productos_familia_activo on public.productos (familia, activo);
create index if not exists ix_productos_nombre on public.productos (nombre);

create table if not exists public.pedidos (
    id uuid primary key default gen_random_uuid(),
    num_pedido text not null,
    cod_cliente text not null references public.clientes (cod_cliente)
        on update cascade on delete restrict,
    cod_vendedor text not null,
    tpago text not null default 'Contado',
    fecha_pedido timestamptz not null default now(),
    fecha_entrega timestamptz,
    plazo_entrega_pedido integer not null default 1 check (plazo_entrega_pedido >= 0),
    observacion text not null default '',
    total_pedido numeric(18, 2) not null default 0 check (total_pedido >= 0),
    pais text not null default 'SV',
    id_direccion integer,
    direccion_entrega text,
    latitud numeric(9, 6),
    longitud numeric(9, 6),
    is_synced boolean not null default true,
    status smallint not null default 1 check (status between 1 and 5),
    est_corr text not null default 'A',
    fech_hora_insert timestamptz not null default now(),
    origen text not null default 'PWA',
    id_bac text not null default '',
    id_clie_caf text not null default '',
    estado_bac text not null default '',
    order_caf text not null default '',
    estatus text not null default 'Activo',
    num_factura text not null default '',
    err_correo text not null default '',
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    constraint uq_pedidos_num_pedido unique (num_pedido),
    constraint ck_pedidos_latitud check (latitud is null or latitud between -90 and 90),
    constraint ck_pedidos_longitud check (longitud is null or longitud between -180 and 180)
);

create index if not exists ix_pedidos_cliente_fecha
    on public.pedidos (cod_cliente, fecha_pedido desc);
create index if not exists ix_pedidos_vendedor_fecha
    on public.pedidos (cod_vendedor, fecha_pedido desc);
create index if not exists ix_pedidos_status on public.pedidos (status, estatus);

create table if not exists public.pedido_detalles (
    id uuid primary key default gen_random_uuid(),
    order_id uuid not null references public.pedidos (id)
        on update cascade on delete cascade,
    num_pedido text not null,
    cod_cliente text not null references public.clientes (cod_cliente)
        on update cascade on delete restrict,
    cod_producto text not null references public.productos (codigo)
        on update cascade on delete restrict,
    nom_producto text not null,
    presentacion text not null default 'Unidad',
    cantidad numeric(18, 3) not null check (cantidad > 0),
    precio_unitario numeric(18, 2) not null check (precio_unitario >= 0),
    precio_total numeric(18, 2) not null check (precio_total >= 0),
    cod_vendedor text not null,
    bodega text not null default 'B01',
    origen text not null default 'PWA',
    created_at timestamptz not null default now()
);

create index if not exists ix_pedido_detalles_order on public.pedido_detalles (order_id);
create index if not exists ix_pedido_detalles_producto on public.pedido_detalles (cod_producto);

create table if not exists public.facturas (
    id uuid primary key default gen_random_uuid(),
    num_factura text not null,
    order_id uuid references public.pedidos (id)
        on update cascade on delete set null,
    cod_cliente text not null references public.clientes (cod_cliente)
        on update cascade on delete restrict,
    fecha_emision timestamptz not null default now(),
    fecha_vencimiento timestamptz not null,
    total_factura numeric(18, 2) not null check (total_factura >= 0),
    saldo numeric(18, 2) not null check (saldo >= 0),
    status smallint not null default 1 check (status between 1 and 6),
    pdf_url text,
    created_at timestamptz not null default now(),
    constraint uq_facturas_num_factura unique (num_factura)
);

create index if not exists ix_facturas_cliente_fecha
    on public.facturas (cod_cliente, fecha_emision desc);
create index if not exists ix_facturas_status on public.facturas (status);

create table if not exists public.cobros (
    id uuid primary key default gen_random_uuid(),
    factura_id uuid not null references public.facturas (id)
        on update cascade on delete restrict,
    num_factura text not null,
    cod_cliente text not null references public.clientes (cod_cliente)
        on update cascade on delete restrict,
    cod_vendedor text,
    monto numeric(18, 2) not null check (monto > 0),
    metodo_pago smallint not null default 2 check (metodo_pago between 1 and 3),
    referencia text,
    comprobante_url text,
    firma_url text,
    status smallint not null default 1 check (status between 1 and 3),
    notas text,
    created_at timestamptz not null default now()
);

create unique index if not exists ux_cobros_factura_referencia
    on public.cobros (factura_id, referencia)
    where referencia is not null;
create index if not exists ix_cobros_cliente_fecha
    on public.cobros (cod_cliente, created_at desc);
create index if not exists ix_cobros_status on public.cobros (status);

create table if not exists public.aprobaciones (
    id uuid primary key default gen_random_uuid(),
    cod_cliente text not null references public.clientes (cod_cliente)
        on update cascade on delete restrict,
    cod_vendedor text,
    monto numeric(18, 2) not null check (monto >= 0),
    motivo text not null,
    detalles text,
    estado text not null default 'pending'
    num_pedido text,
        check (estado in ('pending', 'approved', 'rejected', 'cancelled')),
    decidido_por uuid references public.usuarios (id)
        on update cascade on delete set null,
    comentario_decision text,
    created_at timestamptz not null default now()
);

create index if not exists ix_aprobaciones_estado_fecha
    on public.aprobaciones (estado, created_at desc);
create index if not exists ix_aprobaciones_cliente on public.aprobaciones (cod_cliente);

-- Infraestructura para webhooks idempotentes y futuras sincronizaciones ERP.
create table if not exists public.webhook_events (
    id uuid primary key default gen_random_uuid(),
    source text not null,
    event_key text not null,
    event_type text not null,
    payload jsonb not null,
    status text not null default 'pending'
        check (status in ('pending', 'processing', 'processed', 'failed')),
    attempts integer not null default 0 check (attempts >= 0),
    received_at timestamptz not null default now(),
    processed_at timestamptz,
    last_error text,
    constraint uq_webhook_events_source_key unique (source, event_key)
);

create index if not exists ix_webhook_events_pending
    on public.webhook_events (status, received_at);

create table if not exists public.outbox_events (
    id uuid primary key default gen_random_uuid(),
    event_type text not null,
    aggregate_type text not null,
    aggregate_id uuid,
    payload jsonb not null,
    status text not null default 'pending'
        check (status in ('pending', 'processing', 'processed', 'failed')),
    attempts integer not null default 0 check (attempts >= 0),
    available_at timestamptz not null default now(),
    processed_at timestamptz,
    last_error text,
    created_at timestamptz not null default now()
);

create index if not exists ix_outbox_events_pending
    on public.outbox_events (status, available_at);

create table if not exists public.audit_events (
    id uuid primary key default gen_random_uuid(),
    actor_id uuid references public.usuarios (id)
        on update cascade on delete set null,
    action text not null,
    entity_type text not null,
    entity_id text,
    before_data jsonb,
    after_data jsonb,
    ip_address inet,
    user_agent text,
    created_at timestamptz not null default now()
);

create index if not exists ix_audit_events_entity
    on public.audit_events (entity_type, entity_id, created_at desc);
create index if not exists ix_audit_events_actor
    on public.audit_events (actor_id, created_at desc);

drop trigger if exists trg_usuarios_updated_at on public.usuarios;
create trigger trg_usuarios_updated_at
before update on public.usuarios
for each row execute function public.set_updated_at();

drop trigger if exists trg_pedidos_updated_at on public.pedidos;
create trigger trg_pedidos_updated_at
before update on public.pedidos
for each row execute function public.set_updated_at();

-- Estas tablas se consumen exclusivamente a traves de la API .NET.
-- Sin politicas publicas, la PWA no puede leerlas directamente mediante la Data API.
alter table public.usuarios enable row level security;
alter table public.clientes enable row level security;
alter table public.productos enable row level security;
alter table public.pedidos enable row level security;
alter table public.pedido_detalles enable row level security;
alter table public.facturas enable row level security;
alter table public.cobros enable row level security;
alter table public.aprobaciones enable row level security;
alter table public.webhook_events enable row level security;
alter table public.outbox_events enable row level security;
alter table public.audit_events enable row level security;

commit;

