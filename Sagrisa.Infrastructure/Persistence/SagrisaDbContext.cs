using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Sagrisa.Domain.Entities;

namespace Sagrisa.Infrastructure.Persistence;

public sealed class SagrisaDbContext : DbContext
{
    public SagrisaDbContext(DbContextOptions<SagrisaDbContext> options)
        : base(options)
    {
    }

    public DbSet<Usuario> Usuarios => Set<Usuario>();
    public DbSet<Cliente> Clientes => Set<Cliente>();
    public DbSet<Producto> Productos => Set<Producto>();
    public DbSet<Pedido> Pedidos => Set<Pedido>();
    public DbSet<PedidoDetalle> PedidoDetalles => Set<PedidoDetalle>();
    public DbSet<Factura> Facturas => Set<Factura>();
    public DbSet<Cobro> Cobros => Set<Cobro>();
    public DbSet<Aprobacion> Aprobaciones => Set<Aprobacion>();
    public DbSet<AuditEvent> AuditEvents => Set<AuditEvent>();
    public DbSet<WebhookEvent> WebhookEvents => Set<WebhookEvent>();
    public DbSet<MetaComercial> MetasComerciales => Set<MetaComercial>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema("sagrisa");
        ConfigureUsuario(modelBuilder.Entity<Usuario>());
        ConfigureCliente(modelBuilder.Entity<Cliente>());
        ConfigureProducto(modelBuilder.Entity<Producto>());
        ConfigurePedido(modelBuilder.Entity<Pedido>());
        ConfigurePedidoDetalle(modelBuilder.Entity<PedidoDetalle>());
        ConfigureFactura(modelBuilder.Entity<Factura>());
        ConfigureCobro(modelBuilder.Entity<Cobro>());
        ConfigureAprobacion(modelBuilder.Entity<Aprobacion>());
        ConfigureMetaComercial(modelBuilder.Entity<MetaComercial>());
    }

    private static void ConfigureUsuario(EntityTypeBuilder<Usuario> entity)
    {
        entity.ToTable("usuarios");
        entity.HasKey(x => x.Id);
        entity.Property(x => x.Id).HasColumnName("id");
        entity.Property(x => x.Dui).HasColumnName("dui").IsRequired();
        entity.Property(x => x.PinHash).HasColumnName("pin_hash");
        entity.Property(x => x.Nombre).HasColumnName("nombre").IsRequired();
        entity.Property(x => x.Division).HasColumnName("division");
        entity.Property(x => x.Pais).HasColumnName("pais");
        entity.Property(x => x.CodVendedor).HasColumnName("cod_vendedor");
        entity.Property(x => x.Cargo).HasColumnName("cargo");
        entity.Property(x => x.Email).HasColumnName("email");
        entity.Property(x => x.Cambiado).HasColumnName("cambiado").IsRequired();
        entity.Property(x => x.DocPersonal).HasColumnName("doc_personal");
        entity.Property(x => x.FechaSesion).HasColumnName("fecha_sesion");
        entity.Property(x => x.GerenciadoPor).HasColumnName("gerenciado_por");
        entity.Property(x => x.SupervisadoPor).HasColumnName("supervisado_por");
        entity.Property(x => x.Rol).HasColumnName("rol").IsRequired();
        entity.Property(x => x.IsActive).HasColumnName("activo");
        entity.Property(x => x.IsOfflineCapable).HasColumnName("is_offline_capable");
        entity.Property(x => x.CreatedAt).HasColumnName("created_at");
        entity.Property(x => x.UpdatedAt).HasColumnName("updated_at");
        entity.Ignore(x => x.Pin);
        entity.Ignore(x => x.Token);
        entity.HasIndex(x => x.Dui).IsUnique();
        entity.HasIndex(x => x.CodVendedor).IsUnique().HasFilter("cod_vendedor IS NOT NULL");
    }

    private static void ConfigureCliente(EntityTypeBuilder<Cliente> entity)
    {
        entity.ToTable("clientes");
        entity.HasKey(x => x.CodCliente);
        entity.Property(x => x.CodCliente).HasColumnName("cod_cliente");
        entity.Property(x => x.ProfileId).HasColumnName("profile_id");
        entity.Property(x => x.NomCliente).HasColumnName("nom_cliente").IsRequired();
        entity.Property(x => x.Dui).HasColumnName("dui");
        entity.Property(x => x.Clase).HasColumnName("clase");
        entity.Property(x => x.Vendedor).HasColumnName("vendedor");
        entity.Property(x => x.Ciudad).HasColumnName("ciudad");
        entity.Property(x => x.Direccion).HasColumnName("direccion");
        entity.Property(x => x.Telefono).HasColumnName("telefono");
        entity.Property(x => x.TPago).HasColumnName("tpago");
        entity.Property(x => x.INACTIVE).HasColumnName("inactive");
        entity.Property(x => x.HOLD).HasColumnName("hold");
        entity.Property(x => x.LPrecios).HasColumnName("l_precios");
        entity.Property(x => x.MontoCredito).HasColumnName("monto_credito").HasPrecision(18, 2);
        entity.Property(x => x.TotalDeuda).HasColumnName("total_deuda").HasPrecision(18, 2);
        entity.Property(x => x.SaldoCredito).HasColumnName("saldo_credito").HasPrecision(18, 2);
        entity.Property(x => x.Correo).HasColumnName("correo");
        entity.Property(x => x.CreatedAt).HasColumnName("created_at");
        entity.Ignore(x => x.Activo);
        entity.Ignore(x => x.EstaInactivo);
        entity.Ignore(x => x.EstaBloqueado);
    }

    private static void ConfigureProducto(EntityTypeBuilder<Producto> entity)
    {
        entity.ToTable("productos");
        entity.HasKey(x => x.Id);
        entity.Property(x => x.Id).HasColumnName("id");
        entity.Property(x => x.Codigo).HasColumnName("codigo").IsRequired();
        entity.Property(x => x.Nombre).HasColumnName("nombre").IsRequired();
        entity.Property(x => x.Descripcion).HasColumnName("descripcion");
        entity.Property(x => x.Familia).HasColumnName("familia").IsRequired();
        entity.Property(x => x.Division).HasColumnName("division");
        entity.Property(x => x.Presentacion).HasColumnName("presentacion").IsRequired();
        entity.Property(x => x.Precio).HasColumnName("precio").HasPrecision(18, 2);
        entity.Property(x => x.Stock).HasColumnName("stock");
        entity.Property(x => x.Bodega).HasColumnName("bodega").IsRequired();
        entity.Property(x => x.Activo).HasColumnName("activo");
        entity.Property(x => x.CreatedAt).HasColumnName("created_at");
        entity.Ignore(x => x.Sku);
        entity.HasIndex(x => x.Codigo).IsUnique();
    }

    private static void ConfigurePedido(EntityTypeBuilder<Pedido> entity)
    {
        entity.ToTable("pedidos");
        entity.HasKey(x => x.Id);
        entity.Property(x => x.Id).HasColumnName("id");
        entity.Property(x => x.NumPedido).HasColumnName("num_pedido").IsRequired();
        entity.Property(x => x.CodCliente).HasColumnName("cod_cliente").IsRequired();
        entity.Property(x => x.CodVendedor).HasColumnName("cod_vendedor").IsRequired();
        entity.Property(x => x.Tpago).HasColumnName("tpago").IsRequired();
        entity.Property(x => x.FechaPedido).HasColumnName("fecha_pedido");
        entity.Property(x => x.FechaEntrega).HasColumnName("fecha_entrega");
        entity.Property(x => x.PlazoEntregaPedido).HasColumnName("plazo_entrega_pedido");
        entity.Property(x => x.Observacion).HasColumnName("observacion").IsRequired();
        entity.Property(x => x.TotalPedido).HasColumnName("total_pedido").HasPrecision(18, 2);
        entity.Property(x => x.Pais).HasColumnName("pais").IsRequired();
        entity.Property(x => x.IdDireccion).HasColumnName("id_direccion");
        entity.Property(x => x.DireccionEntrega).HasColumnName("direccion_entrega");
        entity.Property(x => x.Latitud).HasColumnName("latitud").HasPrecision(9, 6);
        entity.Property(x => x.Longitud).HasColumnName("longitud").HasPrecision(9, 6);
        entity.Property(x => x.IsSynced).HasColumnName("is_synced");
        entity.Property(x => x.Status).HasColumnName("status").HasConversion<short>();
        entity.Property(x => x.EstCorr).HasColumnName("est_corr").IsRequired();
        entity.Property(x => x.FechHoraInsert).HasColumnName("fech_hora_insert");
        entity.Property(x => x.Origen).HasColumnName("origen").IsRequired();
        entity.Property(x => x.IdBac).HasColumnName("id_bac").IsRequired();
        entity.Property(x => x.IdClieCaf).HasColumnName("id_clie_caf").IsRequired();
        entity.Property(x => x.EstadoBac).HasColumnName("estado_bac").IsRequired();
        entity.Property(x => x.OrderCaf).HasColumnName("order_caf").IsRequired();
        entity.Property(x => x.Estatus).HasColumnName("estatus").IsRequired();
        entity.Property(x => x.NumFactura).HasColumnName("num_factura").IsRequired();
        entity.Property(x => x.ErrCorreo).HasColumnName("err_correo").IsRequired();
        entity.Property(x => x.CreatedAt).HasColumnName("created_at");
        entity.Property(x => x.UpdatedAt).HasColumnName("updated_at");
        entity.HasIndex(x => x.NumPedido).IsUnique();
        entity.HasOne<Cliente>()
            .WithMany()
            .HasForeignKey(x => x.CodCliente)
            .OnDelete(DeleteBehavior.Restrict);
        entity.HasMany(x => x.Detalles)
            .WithOne()
            .HasForeignKey(x => x.OrderId)
            .OnDelete(DeleteBehavior.Cascade);
    }

    private static void ConfigurePedidoDetalle(EntityTypeBuilder<PedidoDetalle> entity)
    {
        entity.ToTable("pedido_detalles");
        entity.HasKey(x => x.Id);
        entity.Property(x => x.Id).HasColumnName("id");
        entity.Property(x => x.OrderId).HasColumnName("order_id");
        entity.Property(x => x.NumPedido).HasColumnName("num_pedido").IsRequired();
        entity.Property(x => x.CodCliente).HasColumnName("cod_cliente").IsRequired();
        entity.Property(x => x.CodProducto).HasColumnName("cod_producto").IsRequired();
        entity.Property(x => x.NomProducto).HasColumnName("nom_producto").IsRequired();
        entity.Property(x => x.Presentacion).HasColumnName("presentacion").IsRequired();
        entity.Property(x => x.Cantidad).HasColumnName("cantidad").HasPrecision(18, 3);
        entity.Property(x => x.PrecioUnitario).HasColumnName("precio_unitario").HasPrecision(18, 2);
        entity.Property(x => x.PrecioTotal).HasColumnName("precio_total").HasPrecision(18, 2);
        entity.Property(x => x.CodVendedor).HasColumnName("cod_vendedor").IsRequired();
        entity.Property(x => x.Bodega).HasColumnName("bodega").IsRequired();
        entity.Property(x => x.Origen).HasColumnName("origen").IsRequired();
        entity.Property(x => x.CreatedAt).HasColumnName("created_at");
        entity.HasOne<Cliente>()
            .WithMany()
            .HasForeignKey(x => x.CodCliente)
            .OnDelete(DeleteBehavior.Restrict);
        entity.HasOne<Producto>()
            .WithMany()
            .HasForeignKey(x => x.CodProducto)
            .HasPrincipalKey(x => x.Codigo)
            .OnDelete(DeleteBehavior.Restrict);
    }

    private static void ConfigureFactura(EntityTypeBuilder<Factura> entity)
    {
        entity.ToTable("facturas");
        entity.HasKey(x => x.Id);
        entity.Property(x => x.Id).HasColumnName("id");
        entity.Property(x => x.NumFactura).HasColumnName("num_factura").IsRequired();
        entity.Property(x => x.OrderId).HasColumnName("order_id");
        entity.Property(x => x.CodCliente).HasColumnName("cod_cliente").IsRequired();
        entity.Property(x => x.FechaEmision).HasColumnName("fecha_emision");
        entity.Property(x => x.FechaVencimiento).HasColumnName("fecha_vencimiento");
        entity.Property(x => x.TotalFactura).HasColumnName("total_factura").HasPrecision(18, 2);
        entity.Property(x => x.Saldo).HasColumnName("saldo").HasPrecision(18, 2);
        entity.Property(x => x.Status).HasColumnName("status").HasConversion<short>();
        entity.Property(x => x.PdfUrl).HasColumnName("pdf_url");
        entity.Property(x => x.CreatedAt).HasColumnName("created_at");
        entity.HasIndex(x => x.NumFactura).IsUnique();
        entity.HasOne<Cliente>()
            .WithMany()
            .HasForeignKey(x => x.CodCliente)
            .OnDelete(DeleteBehavior.Restrict);
    }

    private static void ConfigureCobro(EntityTypeBuilder<Cobro> entity)
    {
        entity.ToTable("cobros");
        entity.HasKey(x => x.Id);
        entity.Property(x => x.Id).HasColumnName("id");
        entity.Property(x => x.FacturaId).HasColumnName("factura_id");
        entity.Property(x => x.NumFactura).HasColumnName("num_factura").IsRequired();
        entity.Property(x => x.CodCliente).HasColumnName("cod_cliente").IsRequired();
        entity.Property(x => x.CodVendedor).HasColumnName("cod_vendedor");
        entity.Property(x => x.Monto).HasColumnName("monto").HasPrecision(18, 2);
        entity.Property(x => x.MetodoPago).HasColumnName("metodo_pago").HasConversion<short>();
        entity.Property(x => x.Referencia).HasColumnName("referencia");
        entity.Property(x => x.ComprobanteUrl).HasColumnName("comprobante_url");
        entity.Property(x => x.FirmaUrl).HasColumnName("firma_url");
        entity.Property(x => x.Status).HasColumnName("status").HasConversion<short>();
        entity.Property(x => x.Notas).HasColumnName("notas");
        entity.Property(x => x.CreatedAt).HasColumnName("created_at");
        entity.HasOne<Factura>()
            .WithMany()
            .HasForeignKey(x => x.FacturaId)
            .OnDelete(DeleteBehavior.Restrict);
        entity.HasOne<Cliente>()
            .WithMany()
            .HasForeignKey(x => x.CodCliente)
            .OnDelete(DeleteBehavior.Restrict);
    }

    private static void ConfigureAprobacion(EntityTypeBuilder<Aprobacion> entity)
    {
        entity.ToTable("aprobaciones");
        entity.HasKey(x => x.Id);
        entity.Property(x => x.Id).HasColumnName("id");
        entity.Property(x => x.NumPedido).HasColumnName("num_pedido");
        entity.Property(x => x.CodCliente).HasColumnName("cod_cliente").IsRequired();
        entity.Property(x => x.CodVendedor).HasColumnName("cod_vendedor");
        entity.Property(x => x.Monto).HasColumnName("monto").HasPrecision(18, 2);
        entity.Property(x => x.Motivo).HasColumnName("motivo").IsRequired();
        entity.Property(x => x.Detalles).HasColumnName("detalles");
        entity.Property(x => x.Estado).HasColumnName("estado").IsRequired();
        entity.Property(x => x.DecididoPor).HasColumnName("decidido_por");
        entity.Property(x => x.ComentarioDecision).HasColumnName("comentario_decision");
        entity.Property(x => x.CreatedAt).HasColumnName("created_at");
    }

    private static void ConfigureAuditEvent(EntityTypeBuilder<AuditEvent> entity)
    {
        entity.ToTable("audit_events");
        entity.HasKey(x => x.Id);
        entity.Property(x => x.Id).HasColumnName("id");
        entity.Property(x => x.ActorId).HasColumnName("actor_id");
        entity.Property(x => x.Action).HasColumnName("action").IsRequired();
        entity.Property(x => x.EntityType).HasColumnName("entity_type").IsRequired();
        entity.Property(x => x.EntityId).HasColumnName("entity_id");
        entity.Property(x => x.BeforeData).HasColumnName("before_data").HasColumnType("jsonb");
        entity.Property(x => x.AfterData).HasColumnName("after_data").HasColumnType("jsonb");
        entity.Property(x => x.IpAddress).HasColumnName("ip_address").HasColumnType("inet").HasConversion(
            value => value == null ? null : value.ToString(),
            value => string.IsNullOrWhiteSpace(value) ? null : System.Net.IPAddress.Parse(value));
        entity.Property(x => x.UserAgent).HasColumnName("user_agent");
        entity.Property(x => x.CreatedAt).HasColumnName("created_at");
    }

    private static void ConfigureWebhookEvent(EntityTypeBuilder<WebhookEvent> entity)
    {
        entity.ToTable("webhook_events");
        entity.HasKey(x => x.Id);
        entity.Property(x => x.Id).HasColumnName("id");
        entity.Property(x => x.Source).HasColumnName("source").IsRequired();
        entity.Property(x => x.EventKey).HasColumnName("event_key").IsRequired();
        entity.Property(x => x.EventType).HasColumnName("event_type").IsRequired();
        entity.Property(x => x.Payload).HasColumnName("payload").HasColumnType("jsonb").IsRequired();
        entity.Property(x => x.Status).HasColumnName("status").IsRequired();
        entity.Property(x => x.Attempts).HasColumnName("attempts");
        entity.Property(x => x.ReceivedAt).HasColumnName("received_at");
        entity.Property(x => x.ProcessedAt).HasColumnName("processed_at");
        entity.Property(x => x.LastError).HasColumnName("last_error");
        entity.HasIndex(x => new { x.Source, x.EventKey }).IsUnique();
    }

    private static void ConfigureMetaComercial(EntityTypeBuilder<MetaComercial> entity)
    {
        entity.ToTable("metas_comerciales");
        entity.HasKey(x => x.Id);
        entity.Property(x => x.Id).HasColumnName("id");
        entity.Property(x => x.PeriodoTipo).HasColumnName("periodo_tipo").IsRequired();
        entity.Property(x => x.PeriodoInicio).HasColumnName("periodo_inicio").HasColumnType("date");
        entity.Property(x => x.PeriodoFin).HasColumnName("periodo_fin").HasColumnType("date");
        entity.Property(x => x.DivisionCodigo).HasColumnName("division_codigo");
        entity.Property(x => x.VendedorCodigo).HasColumnName("vendedor_codigo");
        entity.Property(x => x.Proyeccion).HasColumnName("proyeccion").HasPrecision(19, 4);
        entity.Property(x => x.CreatedAt).HasColumnName("created_at");
        entity.HasIndex(x => new { x.PeriodoTipo, x.PeriodoInicio, x.DivisionCodigo, x.VendedorCodigo }).IsUnique();
    }
}
