/* SAGRISA legacy Movil - tables. Generado desde movil.sql. Conectarse a la base destino antes de ejecutar. */

SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGPedidosEncabezadosH]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGPedidosEncabezadosH](
	[NumPedidoT] [nvarchar](13) NULL,
	[CodCliente] [nvarchar](10) NULL,
	[CodVendedor] [nvarchar](15) NULL,
	[Tpago] [nvarchar](30) NULL,
	[FechaPedido] [datetime] NULL,
	[FechaEntrega] [datetime] NULL,
	[Observacion] [nvarchar](250) NULL,
	[TotalPedido] [money] NULL,
	[Pais] [nchar](30) NULL,
	[IdDireccion] [nchar](30) NULL,
	[EstCorr] [int] NULL,
	[FechHoraInsert] [datetime] NULL,
	[hhmmss] [varchar](15) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [SAG].[TAUTORIZAR_2FacConMargenVA]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [SAG].[TAUTORIZAR_2FacConMargenVA](
	[NumFactura] [varchar](21) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGPedidosAppVrsGP]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGPedidosAppVrsGP](
	[NumPedidoT] [nvarchar](13) NULL,
	[FechaPedido] [datetime] NULL,
	[CodVendedor] [nvarchar](15) NULL,
	[CodCliente] [nvarchar](10) NULL,
	[TotalPedidoApp] [money] NULL,
	[ElPedido] [char](31) NULL,
	[Factura] [varchar](21) NULL,
	[FechaFac] [datetime] NULL,
	[IdCliente] [varchar](15) NULL,
	[SubTotalGP] [numeric](19, 5) NULL,
	[Diferencia] [numeric](21, 5) NULL,
	[VendedorFac] [varchar](15) NULL,
	[Pais] [nchar](30) NULL,
	[FechHoraInsert] [datetime] NULL,
	[PedidoGP] [char](21) NULL,
	[EstadoFac] [smallint] NULL,
	[HoraMinSeg] [varchar](15) NULL,
	[NombreCliente] [char](65) NULL,
	[NumFEL] [char](42) NULL,
	[TotalFactura] [numeric](19, 5) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [SAG].[TAUTORIZAR_3FacturasXAutorizarVA]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [SAG].[TAUTORIZAR_3FacturasXAutorizarVA](
	[Facturas] [varchar](21) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGMovilExistencias00]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGMovilExistencias00](
	[CodProducto] [char](31) NOT NULL,
	[NomProducto] [char](101) NOT NULL,
	[Bodega] [char](11) NULL,
	[Existencia] [numeric](20, 5) NULL,
	[Pbase] [numeric](19, 5) NULL,
	[Comentario] [varchar](1) NOT NULL,
	[PMinimo] [numeric](38, 9) NULL,
	[Costo] [numeric](19, 5) NOT NULL,
	[Division] [varchar](1) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGMovilExistenciasLote]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGMovilExistenciasLote](
	[CodProducto] [varchar](31) NULL,
	[NomProducto] [varchar](101) NULL,
	[Existencia] [numeric](20, 5) NULL,
	[Bodega] [char](11) NULL,
	[LOTNUMBR] [char](21) NULL,
	[SaldoLote] [numeric](38, 5) NULL,
	[PBase] [numeric](19, 5) NULL,
	[FechaVto] [datetime] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGDetalleVentas]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGDetalleVentas](
	[PAIS] [nvarchar](30) NULL,
	[ANO] [int] NULL,
	[MES] [numeric](29, 0) NULL,
	[DIVISION] [nvarchar](255) NULL,
	[Monto] [numeric](38, 6) NULL,
	[PRESUPUESTO] [numeric](38, 4) NULL,
	[TIPO] [varchar](3) NOT NULL,
	[MontoLocal] [numeric](38, 6) NULL,
	[DEX_ROW_ID] [int] NULL,
	[VENDEDOR] [nvarchar](20) NULL,
	[Factura] [nvarchar](255) NULL,
	[Nombre] [nchar](60) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGDivisionVendedor]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGDivisionVendedor](
	[CodVendedor] [nchar](15) NULL,
	[Division] [nvarchar](1) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGDetalleVentasGT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGDetalleVentasGT](
	[PAIS] [nvarchar](30) NULL,
	[ANO] [int] NULL,
	[MES] [numeric](29, 0) NULL,
	[DIVISION] [nvarchar](255) NULL,
	[MONTO] [numeric](38, 6) NULL,
	[PRESUPUESTO] [numeric](21, 4) NULL,
	[TIPO] [varchar](3) NOT NULL,
	[MontoLocal] [numeric](38, 5) NULL,
	[DEX_ROW_ID] [int] NULL,
	[Vendedor] [nvarchar](20) NULL,
	[Factura] [nvarchar](255) NULL,
	[Nombre] [nchar](60) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGMovilExistenciasGT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGMovilExistenciasGT](
	[CodProducto] [char](31) NOT NULL,
	[NomProducto] [char](101) NOT NULL,
	[Bodega] [varchar](11) NULL,
	[Existencia] [numeric](20, 5) NULL,
	[Pbase] [numeric](19, 5) NULL,
	[Comentario] [varchar](1) NOT NULL,
	[PMinimo] [numeric](38, 9) NULL,
	[Costo] [numeric](19, 5) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGMovilExistenciasLoteGT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGMovilExistenciasLoteGT](
	[CodProducto] [char](31) NOT NULL,
	[NomProducto] [char](101) NOT NULL,
	[Existencia] [numeric](20, 5) NULL,
	[Bodega] [char](11) NULL,
	[LOTNUMBR] [char](21) NULL,
	[SaldoLote] [numeric](38, 5) NULL,
	[PBase] [numeric](19, 5) NULL,
	[FechaVto] [datetime] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGDetalleVentasHN]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGDetalleVentasHN](
	[PAIS] [nvarchar](30) NULL,
	[ANO] [int] NULL,
	[MES] [numeric](29, 0) NULL,
	[DIVISION] [nvarchar](255) NULL,
	[MONTO] [numeric](38, 6) NULL,
	[PRESUPUESTO] [numeric](19, 4) NULL,
	[TIPO] [varchar](3) NOT NULL,
	[MontoLocal] [numeric](38, 6) NULL,
	[DEX_ROW_ID] [int] NULL,
	[Vendedor] [nvarchar](20) NULL,
	[Factura] [nvarchar](255) NULL,
	[Nombre] [nchar](60) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGCobrosRegional1]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGCobrosRegional1](
	[IDVENDOR] [varchar](15) NULL,
	[NUMMES] [numeric](2, 0) NULL,
	[YEAR] [varchar](4) NULL,
	[TotalCobrado] [numeric](38, 5) NULL,
	[Presupuesto] [money] NULL,
	[Pais] [varchar](2) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGPedidosPendientes]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGPedidosPendientes](
	[NumPedido] [varchar](10) NULL,
	[CodCliente] [varchar](10) NULL,
	[CodProducto] [varchar](30) NULL,
	[NomProducto] [varchar](60) NULL,
	[Presentacion] [varchar](30) NULL,
	[Cantidad] [numeric](18, 0) NULL,
	[PrecioUnitario] [money] NULL,
	[PrecioTotal] [money] NULL,
	[CodVendedor] [varchar](15) NULL,
	[Bodega] [varchar](30) NULL,
	[NomCliente] [char](65) NOT NULL,
	[FechaPedido] [datetime] NULL,
	[Observacion] [varchar](250) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGCobrosRegional2]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGCobrosRegional2](
	[Vendedor] [varchar](15) NULL,
	[MES] [numeric](2, 0) NULL,
	[Ano] [varchar](4) NULL,
	[TotalCobrado] [numeric](38, 5) NULL,
	[Presupuesto] [money] NULL,
	[Pais] [varchar](2) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGCobrosGT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGCobrosGT](
	[IDVENDOR] [varchar](15) NULL,
	[NUMMES] [numeric](2, 0) NULL,
	[YEAR] [varchar](4) NULL,
	[TotalCobrado] [numeric](38, 5) NULL,
	[Pais] [varchar](2) NOT NULL,
	[COBRARA] [money] NULL,
	[Nombre] [nchar](60) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGListadoFacturas]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGListadoFacturas](
	[CodigoCliente] [char](15) NOT NULL,
	[NombreCliente] [char](65) NOT NULL,
	[Factura] [char](21) NOT NULL,
	[FechaVence] [datetime] NOT NULL,
	[Saldo] [numeric](38, 5) NULL,
	[Dias] [int] NULL,
	[Vendedor] [char](15) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGListadoFacturasHN]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGListadoFacturasHN](
	[CodigoCliente] [char](15) NOT NULL,
	[NombreCliente] [char](65) NOT NULL,
	[Factura] [char](21) NOT NULL,
	[FechaVence] [datetime] NOT NULL,
	[Saldo] [numeric](38, 5) NULL,
	[Dias] [int] NULL,
	[Vendedor] [char](15) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGListadoFacturasGT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGListadoFacturasGT](
	[CodigoCliente] [char](15) NOT NULL,
	[NombreCliente] [char](65) NOT NULL,
	[Factura] [char](21) NOT NULL,
	[FechaVence] [datetime] NOT NULL,
	[Saldo] [numeric](38, 5) NULL,
	[Dias] [int] NULL,
	[Vendedor] [char](15) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGCobrosBorro]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGCobrosBorro](
	[Vendedor] [varchar](15) NULL,
	[NumCobro] [varchar](21) NOT NULL,
	[MES] [numeric](10, 0) NULL,
	[Ano] [int] NULL,
	[TotalCobrado] [numeric](38, 5) NULL,
	[TipoTrans] [varchar](3) NOT NULL,
	[Pais] [varchar](2) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGComparaGerencial]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGComparaGerencial](
	[PAIS] [nvarchar](30) NULL,
	[ANO] [int] NULL,
	[MES] [numeric](29, 0) NULL,
	[TotalVent] [numeric](38, 6) NULL,
	[TotalPres] [numeric](38, 4) NULL,
	[TIPO] [varchar](3) NOT NULL,
	[DIVISION] [nvarchar](255) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGUsuariosMovil]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGUsuariosMovil](
	[Pin] [nchar](10) NULL,
	[Nombre] [nchar](60) NULL,
	[Pais] [nchar](30) NULL,
	[CodVendedor] [nchar](15) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGMovilExistencias_borrar]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGMovilExistencias_borrar](
	[CodProducto] [char](31) NOT NULL,
	[NomProducto] [char](101) NOT NULL,
	[Bodega] [char](11) NULL,
	[Existencia] [numeric](20, 5) NULL,
	[Pbase] [numeric](19, 5) NULL,
	[Comentario] [varchar](1) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGMovilExistencias01]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGMovilExistencias01](
	[CodProducto] [varchar](31) NULL,
	[NomProducto] [varchar](101) NULL,
	[Bodega] [char](11) NULL,
	[Existencia] [numeric](20, 5) NULL,
	[Pbase] [numeric](38, 6) NULL,
	[Comentario] [varchar](14) NOT NULL,
	[PMinimo] [numeric](38, 6) NULL,
	[Costo] [numeric](19, 5) NOT NULL,
	[Division] [varchar](1) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGMovilExistencias]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGMovilExistencias](
	[CodProducto] [varchar](31) NULL,
	[NomProducto] [varchar](101) NULL,
	[Bodega] [char](11) NULL,
	[Existencia] [numeric](20, 5) NULL,
	[Pbase] [numeric](38, 6) NULL,
	[Comentario] [varchar](14) NOT NULL,
	[PMinimo] [numeric](38, 6) NULL,
	[Costo] [numeric](19, 5) NOT NULL,
	[Division] [varchar](1) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGExistenciasAgropecuariaWEB]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGExistenciasAgropecuariaWEB](
	[CodProducto] [varchar](31) NULL,
	[NomProducto] [varchar](101) NULL,
	[Bodega] [char](11) NULL,
	[Existencia] [numeric](20, 5) NULL,
	[Division] [varchar](1) NULL,
	[Pais] [varchar](2) NOT NULL,
	[Peso] [float] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [SAG].[TCobrosParaChequeGT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [SAG].[TCobrosParaChequeGT](
	[IdCliente] [char](15) NOT NULL,
	[Cliente] [char](65) NULL,
	[Factura] [char](21) NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[FechaVence] [datetime] NOT NULL,
	[MesV] [int] NULL,
	[YearV] [int] NULL,
	[MontoFactura] [numeric](19, 5) NOT NULL,
	[Vendedor] [char](15) NOT NULL,
	[Tipo] [smallint] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TClientesGT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TClientesGT](
	[CodCliente] [char](15) NOT NULL,
	[NomCliente] [char](65) NOT NULL,
	[Clase] [char](15) NOT NULL,
	[Vendedor] [char](15) NOT NULL,
	[Ciudad] [char](35) NOT NULL,
	[TPago] [char](21) NOT NULL,
	[INACTIVE] [tinyint] NOT NULL,
	[HOLD] [tinyint] NOT NULL,
	[Lprecios] [char](11) NOT NULL,
	[MontoCredito] [numeric](19, 5) NOT NULL,
	[TotalDeuda] [numeric](38, 5) NOT NULL,
	[SaldoCredito] [numeric](38, 5) NULL,
	[Correo] [char](201) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGCobrosHoy]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGCobrosHoy](
	[IDVENDOR] [nvarchar](15) NULL,
	[NUMMES] [nvarchar](2) NULL,
	[YEAR] [nvarchar](4) NULL,
	[Pais] [varchar](2) NOT NULL,
	[TotalCobrado] [numeric](38, 5) NULL,
	[Nombre] [nchar](60) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGPreciosEnLinea]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGPreciosEnLinea](
	[CodProducto] [char](31) NOT NULL,
	[NomProducto] [char](101) NOT NULL,
	[Bodega] [char](11) NULL,
	[Existencia] [numeric](22, 5) NULL,
	[Pbase] [numeric](19, 5) NULL,
	[Costo] [numeric](19, 5) NOT NULL,
	[Peso] [numeric](16, 6) NULL,
	[ListaPrecio] [char](11) NOT NULL,
	[PorcentajeDesc] [numeric](19, 5) NOT NULL,
	[PrecioVenta] [numeric](38, 7) NULL,
	[Pais] [varchar](2) NOT NULL,
	[Clase] [char](31) NOT NULL,
	[PrecioSinIVA] [numeric](38, 9) NULL,
	[CantDecimales] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGCobros]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGCobros](
	[IDVENDOR] [nvarchar](15) NULL,
	[NUMMES] [nvarchar](2) NULL,
	[YEAR] [nvarchar](4) NULL,
	[Pais] [varchar](2) NOT NULL,
	[COBRARA] [money] NULL,
	[TotalCobrado] [numeric](38, 5) NULL,
	[Nombre] [nchar](60) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TClientes]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TClientes](
	[CodCliente] [varchar](15) NULL,
	[NomCliente] [varchar](65) NULL,
	[Clase] [char](15) NOT NULL,
	[Vendedor] [char](15) NOT NULL,
	[Ciudad] [char](35) NOT NULL,
	[TPago] [char](21) NOT NULL,
	[INACTIVE] [tinyint] NOT NULL,
	[HOLD] [tinyint] NOT NULL,
	[LPrecios] [char](11) NOT NULL,
	[MontoCredito] [numeric](19, 5) NOT NULL,
	[TotalDeuda] [numeric](38, 5) NOT NULL,
	[SaldoCredito] [numeric](38, 5) NULL,
	[Correo] [char](201) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TDireccionSV]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TDireccionSV](
	[CodCliente] [char](15) NOT NULL,
	[CodDireccion] [char](15) NOT NULL,
	[Dir1] [char](61) NOT NULL,
	[Dir2] [char](61) NOT NULL,
	[Dir3] [char](61) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [SAG].[TAUTORIZAR_1FacNoImpresasGT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [SAG].[TAUTORIZAR_1FacNoImpresasGT](
	[NumFactura] [varchar](21) NULL,
	[Fecha] [datetime] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TDireccionGT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TDireccionGT](
	[CodCliente] [char](15) NOT NULL,
	[CodDireccion] [char](15) NOT NULL,
	[Dir1] [char](61) NOT NULL,
	[Dir2] [char](61) NOT NULL,
	[Dir3] [char](61) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [SAG].[TMargenesAutorizarGT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [SAG].[TMargenesAutorizarGT](
	[IdClase] [varchar](11) NULL,
	[UNITCOST] [numeric](19, 5) NOT NULL,
	[PU] [numeric](19, 5) NOT NULL,
	[Margen] [numeric](38, 14) NULL,
	[MargenType] [int] NOT NULL,
	[Autorizado] [float] NULL,
	[NumFactura] [char](21) NOT NULL,
	[Descripcion] [char](101) NOT NULL,
	[Nombre] [char](65) NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[CodCliente] [char](15) NOT NULL,
	[CodProducto] [char](31) NOT NULL,
	[TotalFactura] [numeric](19, 5) NOT NULL,
	[Cantidad] [numeric](19, 5) NOT NULL,
	[SUBTOTAL] [numeric](19, 5) NOT NULL,
	[HECHO] [varchar](15) NULL,
	[TipoDoc] [char](3) NOT NULL,
	[Vendedor] [char](15) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [SAG].[TMargenesAutorizar2GT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [SAG].[TMargenesAutorizar2GT](
	[IdClase] [varchar](11) NULL,
	[UNITCOST] [numeric](19, 5) NOT NULL,
	[PU] [numeric](19, 5) NOT NULL,
	[Margen] [numeric](38, 14) NULL,
	[MargenType] [int] NOT NULL,
	[Autorizado] [float] NULL,
	[NumFactura] [char](21) NOT NULL,
	[Descripcion] [char](101) NOT NULL,
	[Estatus] [nchar](10) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGVPedidoEncabezado]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGVPedidoEncabezado](
	[NumPedido] [numeric](18, 0) NULL,
	[CodCliente] [nvarchar](10) NULL,
	[CodVendedor] [nvarchar](15) NULL,
	[Tpago] [nvarchar](30) NULL,
	[FechaPedido] [datetime] NULL,
	[FechaEntrega] [datetime] NULL,
	[Observacion] [nvarchar](250) NULL,
	[TotalPedido] [money] NULL,
	[Pais] [nchar](30) NULL,
	[IdDireccion] [nchar](30) NULL,
	[EstCorr] [int] NULL,
	[FechHoraInsert] [datetime] NULL,
	[Origen] [nchar](3) NULL,
	[idBac] [char](50) NULL,
	[idClieCaf] [nchar](15) NULL,
	[EstadoBac] [char](15) NULL,
	[orderCaf] [char](50) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TMargenAutorizar1GT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TMargenAutorizar1GT](
	[IdClase] [varchar](11) NULL,
	[UNITCOST] [numeric](19, 5) NOT NULL,
	[PU] [numeric](19, 5) NOT NULL,
	[Margen] [numeric](38, 14) NULL,
	[MargenType] [int] NOT NULL,
	[Autorizado] [float] NULL,
	[NumFactura] [char](21) NOT NULL,
	[Descripcion] [char](101) NOT NULL,
	[Nombre] [char](65) NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[CodCliente] [char](15) NOT NULL,
	[CodProducto] [char](31) NOT NULL,
	[TotalFactura] [numeric](19, 5) NOT NULL,
	[Cantidad] [numeric](19, 5) NOT NULL,
	[SUBTOTAL] [numeric](19, 5) NOT NULL,
	[HECHO] [varchar](15) NULL,
	[TipoDoc] [char](3) NOT NULL,
	[Vendedor] [char](15) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGVPedidoDetalle]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGVPedidoDetalle](
	[NumPedido] [numeric](18, 0) NULL,
	[CodCliente] [varchar](10) NULL,
	[CodProducto] [varchar](30) NULL,
	[NomProducto] [varchar](60) NULL,
	[Presentacion] [varchar](30) NULL,
	[Cantidad] [numeric](18, 0) NULL,
	[PrecioUnitario] [money] NULL,
	[PrecioTotal] [money] NULL,
	[CodVendedor] [nvarchar](15) NULL,
	[Bodega] [nvarchar](30) NULL,
	[Origen] [char](3) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [SAG].[TAUTORIZAR_2FacConMargenGT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [SAG].[TAUTORIZAR_2FacConMargenGT](
	[NumFactura] [varchar](21) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [SAG].[TAUTORIZAR_3FacturasXAutorizarGT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [SAG].[TAUTORIZAR_3FacturasXAutorizarGT](
	[Facturas] [varchar](21) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGVPedidosVsFac]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGVPedidosVsFac](
	[NumPedido] [nvarchar](18) NULL,
	[FechaPedido] [datetime] NULL,
	[CodVendedor] [nvarchar](15) NULL,
	[CodCliente] [nvarchar](10) NULL,
	[TotalPedido] [money] NULL,
	[ElPedido] [varchar](31) NULL,
	[Factura] [varchar](21) NULL,
	[FechaFac] [datetime] NULL,
	[IdCliente] [varchar](15) NULL,
	[SUBTOTAL] [numeric](19, 5) NULL,
	[Diferencia] [numeric](21, 5) NULL,
	[VendedorFac] [varchar](15) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGResumenDeudaCliente]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGResumenDeudaCliente](
	[CodCliente] [char](15) NOT NULL,
	[NomCliente] [char](65) NOT NULL,
	[0a30 dias] [numeric](38, 5) NULL,
	[31a60 dias] [numeric](38, 5) NULL,
	[61a90 dias] [numeric](38, 5) NULL,
	[91a120 dias] [numeric](38, 5) NULL,
	[Mas 120 dias] [numeric](38, 5) NULL,
	[TotalDeuda] [numeric](38, 5) NULL,
	[Pais] [varchar](2) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGVPedidosHistóricos]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGVPedidosHistóricos](
	[NumPedido] [numeric](18, 0) NULL,
	[CodCliente] [nvarchar](10) NULL,
	[CodVendedor] [nvarchar](10) NULL,
	[Tpago] [nvarchar](30) NULL,
	[FechaPedido] [datetime] NULL,
	[Mes] [int] NULL,
	[Año] [int] NULL,
	[FechaEntrega] [datetime] NULL,
	[Observacion] [nvarchar](250) NULL,
	[TotalPedido] [money] NULL,
	[Pais] [nchar](30) NULL,
	[IdDireccion] [nchar](30) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGTotalEnPedido]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGTotalEnPedido](
	[CodProducto] [varchar](30) NULL,
	[TotalP] [numeric](18, 2) NULL,
	[Origen] [char](3) NULL,
	[Pais] [nchar](30) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGMovilExistencias02]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGMovilExistencias02](
	[CodProducto] [varchar](31) NULL,
	[NomProducto] [varchar](101) NULL,
	[Bodega] [char](11) NULL,
	[Existencia] [numeric](20, 5) NULL,
	[Pbase] [numeric](38, 6) NULL,
	[Comentario] [varchar](14) NOT NULL,
	[PMinimo] [numeric](38, 6) NULL,
	[Costo] [numeric](19, 5) NOT NULL,
	[Division] [varchar](1) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGMovilExistencias000]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGMovilExistencias000](
	[CodProducto] [varchar](31) NULL,
	[NomProducto] [varchar](101) NULL,
	[Bodega] [char](11) NULL,
	[Existencia] [numeric](20, 5) NULL,
	[Pbase] [numeric](19, 5) NULL,
	[Comentario] [varchar](1) NOT NULL,
	[PMinimo] [numeric](38, 9) NULL,
	[Expr1] [nchar](18) NULL,
	[Costo] [numeric](19, 5) NOT NULL,
	[Division] [varchar](1) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGPreciosEnLineaAgropA]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGPreciosEnLineaAgropA](
	[CodCliente] [nchar](15) NULL,
	[CUSTNAME] [char](65) NOT NULL,
	[CodProd] [nchar](10) NULL,
	[Precio] [float] NULL,
	[CodPais] [char](2) NULL,
	[Clase] [char](31) NOT NULL,
	[ITMCLSDC] [char](31) NOT NULL,
	[ClaseCliente] [char](31) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGDatosClientesSV]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGDatosClientesSV](
	[CodCliente] [char](15) NOT NULL,
	[NomCliente] [char](65) NOT NULL,
	[UltimoPago] [numeric](19, 5) NOT NULL,
	[FUltimoPAgo] [datetime] NOT NULL,
	[PDiasPago] [smallint] NOT NULL,
	[UltimaFactura] [numeric](19, 5) NOT NULL,
	[FUltimaFactura] [datetime] NOT NULL,
	[DiasC] [varchar](16) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [SAG].[TMargenesAutorizar]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [SAG].[TMargenesAutorizar](
	[IdClase] [varchar](11) NULL,
	[UNITCOST] [numeric](19, 5) NOT NULL,
	[PU] [numeric](19, 5) NOT NULL,
	[Margen] [numeric](38, 14) NULL,
	[MargenType] [int] NOT NULL,
	[Autorizado] [float] NULL,
	[NumFactura] [char](21) NOT NULL,
	[Descripcion] [nvarchar](143) NULL,
	[Nombre] [char](65) NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[CodCliente] [char](15) NOT NULL,
	[CodProducto] [char](31) NOT NULL,
	[TotalFactura] [numeric](19, 5) NOT NULL,
	[Cantidad] [numeric](19, 5) NOT NULL,
	[SUBTOTAL] [numeric](19, 5) NOT NULL,
	[HECHO] [nvarchar](15) NULL,
	[TipoDoc] [char](3) NOT NULL,
	[Vendedor] [char](15) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [SAG].[TMargenesAutorizar2]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [SAG].[TMargenesAutorizar2](
	[IdClase] [varchar](11) NULL,
	[UNITCOST] [numeric](19, 5) NOT NULL,
	[PU] [numeric](19, 5) NOT NULL,
	[Margen] [numeric](38, 14) NULL,
	[MargenType] [int] NOT NULL,
	[Autorizado] [float] NULL,
	[NumFactura] [char](21) NOT NULL,
	[Descripcion] [nvarchar](143) NULL,
	[Estatus] [nchar](10) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [SAG].[TAUTORIZAR_1FacNoImpresas]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [SAG].[TAUTORIZAR_1FacNoImpresas](
	[NumFactura] [varchar](21) NULL,
	[Fecha] [datetime] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [SAG].[TAUTORIZAR_2FacConMargen]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [SAG].[TAUTORIZAR_2FacConMargen](
	[NumFactura] [varchar](21) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [SAG].[TAUTORIZAR_3FacturasXAutorizar]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [SAG].[TAUTORIZAR_3FacturasXAutorizar](
	[Facturas] [varchar](21) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TMargenAutorizar1]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TMargenAutorizar1](
	[IdClase] [varchar](11) NULL,
	[UNITCOST] [numeric](19, 5) NOT NULL,
	[PU] [numeric](19, 5) NOT NULL,
	[Margen] [numeric](38, 14) NULL,
	[MargenType] [int] NOT NULL,
	[Autorizado] [float] NULL,
	[NumFactura] [char](21) NOT NULL,
	[Descripcion] [nvarchar](143) NULL,
	[Nombre] [char](65) NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[CodCliente] [char](15) NOT NULL,
	[CodProducto] [char](31) NOT NULL,
	[TotalFactura] [numeric](19, 5) NOT NULL,
	[Cantidad] [numeric](19, 5) NOT NULL,
	[SUBTOTAL] [numeric](19, 5) NOT NULL,
	[HECHO] [nvarchar](15) NULL,
	[TipoDoc] [char](3) NOT NULL,
	[Vendedor] [char](15) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGMovilExistenciasZZ]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGMovilExistenciasZZ](
	[CodProducto] [varchar](9) NOT NULL,
	[NomProducto] [varchar](9) NOT NULL,
	[Bodega] [varchar](11) NOT NULL,
	[Existencia] [int] NOT NULL,
	[Pbase] [numeric](4, 2) NULL,
	[Comentario] [varchar](1) NOT NULL,
	[PMinimo] [int] NOT NULL,
	[Costo] [int] NOT NULL,
	[Division] [varchar](1) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGMovilExistenciasLoteZZ]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGMovilExistenciasLoteZZ](
	[CodProducto] [varchar](9) NOT NULL,
	[NomProducto] [varchar](9) NOT NULL,
	[Existencia] [int] NOT NULL,
	[Bodega] [varchar](11) NOT NULL,
	[LOTNUMBR] [char](21) NULL,
	[SaldoLote] [numeric](38, 5) NULL,
	[PBase] [numeric](19, 5) NULL,
	[FechaVto] [datetime] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGProductosSinPrecio]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGProductosSinPrecio](
	[CodProducto] [varchar](31) NULL,
	[NomProducto] [varchar](101) NULL,
	[Bodega] [char](11) NULL,
	[Existencia] [numeric](20, 5) NULL,
	[Pbase] [numeric](38, 6) NULL,
	[Comentario] [varchar](14) NOT NULL,
	[PMinimo] [numeric](38, 6) NULL,
	[Costo] [numeric](19, 5) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TDireccionCR]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TDireccionCR](
	[CodCliente] [char](15) NOT NULL,
	[CodDireccion] [char](15) NOT NULL,
	[Dir1] [char](61) NOT NULL,
	[Dir2] [char](61) NOT NULL,
	[Dir3] [char](61) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGClientesRegionales]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGClientesRegionales](
	[CUSTNMBR] [char](15) NOT NULL,
	[CUSTNAME] [char](65) NOT NULL,
	[INACTIVE] [tinyint] NOT NULL,
	[HOLD] [tinyint] NOT NULL,
	[PAIS] [varchar](2) NOT NULL,
	[ClaseCliente] [char](31) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGPreciosEnLineaAgrop]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGPreciosEnLineaAgrop](
	[CodCliente] [nchar](15) NOT NULL,
	[CUSTNAME] [char](65) NOT NULL,
	[CodProd] [nchar](15) NOT NULL,
	[Cantidad] [int] NULL,
	[PrecioUOferta] [numeric](18, 2) NULL,
	[CodPais] [nchar](2) NULL,
	[Clase] [char](31) NOT NULL,
	[DescListPre] [char](100) NULL,
	[CodLstPrec] [nchar](15) NOT NULL,
	[ClaseCliente] [char](31) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGBorrar]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGBorrar](
	[CodProducto] [char](31) NOT NULL,
	[NomProducto] [char](101) NOT NULL,
	[Bodega] [char](11) NULL,
	[Existencia] [numeric](20, 5) NULL,
	[Pbase] [numeric](19, 5) NULL,
	[Costo] [numeric](19, 5) NOT NULL,
	[Peso] [numeric](14, 6) NULL,
	[ListaPrecio] [char](11) NOT NULL,
	[PorcentajeDesc] [numeric](19, 5) NOT NULL,
	[PrecioVenta] [numeric](38, 9) NULL,
	[Pais] [varchar](2) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGResumenDeudaClienteWEB]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGResumenDeudaClienteWEB](
	[CodCliente] [char](15) NOT NULL,
	[NomCliente] [char](65) NOT NULL,
	[0a30 dias] [numeric](38, 5) NULL,
	[31a60 dias] [numeric](38, 5) NULL,
	[61a90 dias] [numeric](38, 5) NULL,
	[91a120 dias] [numeric](38, 5) NULL,
	[Mas 120 dias] [numeric](38, 5) NULL,
	[TotalDeuda] [numeric](38, 5) NULL,
	[Pais] [varchar](2) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGDatosClientesWEB]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGDatosClientesWEB](
	[CodCliente] [char](15) NOT NULL,
	[NomCliente] [char](65) NOT NULL,
	[UltimoPago] [numeric](19, 5) NOT NULL,
	[FUltimoPAgo] [datetime] NOT NULL,
	[PDiasPago] [smallint] NOT NULL,
	[UltimaFactura] [numeric](19, 5) NOT NULL,
	[FUltimaFactura] [datetime] NOT NULL,
	[DiasC] [varchar](16) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGDetalleDeudaClienteWEB]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGDetalleDeudaClienteWEB](
	[CodCliente] [char](15) NOT NULL,
	[FAC] [char](21) NOT NULL,
	[De0a30Dias] [numeric](38, 5) NULL,
	[De31a60Dias] [numeric](38, 5) NULL,
	[De61a90Dias] [numeric](38, 5) NULL,
	[De91a120Dias] [numeric](38, 5) NULL,
	[MasDe120Dias] [numeric](38, 5) NULL,
	[Saldo] [numeric](38, 5) NULL,
	[FechaVence] [datetime] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TSAGPedidosAppVrsFactVrsDespacho]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TSAGPedidosAppVrsFactVrsDespacho](
	[NumPedidoT] [nvarchar](13) NULL,
	[FechaPedido] [datetime] NULL,
	[CodVendedor] [nvarchar](15) NULL,
	[CodCliente] [nvarchar](10) NULL,
	[TotalPedidoApp] [money] NULL,
	[Factura] [varchar](21) NULL,
	[FechaFac] [datetime] NULL,
	[IdCliente] [varchar](15) NULL,
	[SubTotalGP] [numeric](19, 5) NULL,
	[Diferencia] [numeric](21, 5) NULL,
	[VendedorFac] [varchar](15) NULL,
	[FechHoraInsert] [datetime] NULL,
	[PedidoGP] [char](21) NULL,
	[EstadoFac] [smallint] NULL,
	[HoraMinSeg] [varchar](15) NULL,
	[NombreCliente] [char](65) NULL,
	[HoraFactura] [varchar](15) NULL,
	[FechaDespacho] [datetime] NULL,
	[MOTORISTA] [nvarchar](50) NULL,
	[Dias] [int] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[Banco]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[Banco](
	[id_banco] [int] IDENTITY(1,1) NOT NULL,
	[descripcion_banco] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_banco] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[Cargos]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[Cargos](
	[CodCargo] [nchar](10) NULL,
	[NombreCargo] [nchar](60) NULL,
	[Tipo] [int] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[ClaseProductos]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[ClaseProductos](
	[CodClase] [nchar](10) NULL,
	[Porcentaje] [decimal](18, 2) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[Cobro]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[Cobro](
	[id_cobro] [int] IDENTITY(1,1) NOT NULL,
	[monto_cobro] [decimal](8, 2) NULL,
	[metodo_pago_fk_cobro] [int] NULL,
	[marca_tarjeta_fk_cobro] [int] NULL,
	[banco_fk_cobro] [int] NULL,
	[numero_transaccion_cobro] [varchar](100) NULL,
	[uri_comprobante_cobro] [varchar](255) NULL,
	[uri_firma_cobro] [varchar](255) NULL,
	[dui_cobro] [varchar](10) NULL,
	[correo_cobro] [varchar](100) NULL,
	[numero_cheque_cobro] [varchar](100) NULL,
	[fecha_cobro] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[id_cobro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[Correlativo1]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[Correlativo1](
	[Pais] [nchar](30) NULL,
	[IdCorrelativo] [nchar](10) NULL,
	[NumSiguiente] [bigint] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[CorreosPendientes]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[CorreosPendientes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[NumPedido] [numeric](18, 0) NOT NULL,
	[FechaRegistro] [datetime] NOT NULL,
	[Procesado] [bit] NOT NULL,
	[FechaProcesado] [datetime] NULL,
	[MensajeError] [nvarchar](500) NULL,
	[Pais] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[DirectorioTelefonico]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[DirectorioTelefonico](
	[Usuario] [nchar](60) NULL,
	[NumFijo] [nchar](10) NULL,
	[Extension] [nchar](10) NULL,
	[Correo] [nchar](30) NULL,
	[Pais] [nchar](30) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[Divisiones]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[Divisiones](
	[CodDivision] [nchar](10) NULL,
	[NombreDivision] [nchar](50) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[MarcaTarjeta]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[MarcaTarjeta](
	[id_marca_tarjeta] [int] IDENTITY(1,1) NOT NULL,
	[descripcion_marca_tarjeta] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_marca_tarjeta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[MetodoPago]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[MetodoPago](
	[id_metodo_pago] [int] IDENTITY(1,1) NOT NULL,
	[descripcion_metodo_pago] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_metodo_pago] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[PedidoDetalle]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[PedidoDetalle](
	[NumPedido] [varchar](10) NULL,
	[CodCliente] [varchar](10) NULL,
	[CodProducto] [varchar](30) NULL,
	[NomProducto] [varchar](60) NULL,
	[Presentacion] [varchar](30) NULL,
	[Cantidad] [numeric](18, 0) NULL,
	[PrecioUnitario] [money] NULL,
	[PrecioTotal] [money] NULL,
	[CodVendedor] [varchar](15) NULL,
	[Bodega] [varchar](30) NULL,
	[Origen] [char](3) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[PedidoDetalleE]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[PedidoDetalleE](
	[NumPedido] [numeric](18, 0) NULL,
	[CodCliente] [varchar](10) NULL,
	[CodProducto] [varchar](30) NULL,
	[NomProducto] [varchar](60) NULL,
	[Presentacion] [varchar](30) NULL,
	[Cantidad] [numeric](18, 0) NULL,
	[PrecioUnitario] [money] NULL,
	[PrecioTotal] [money] NULL,
	[CodVendedor] [nvarchar](15) NULL,
	[Bodega] [nvarchar](30) NULL,
	[Origen] [char](3) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[PedidoDetalleH]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[PedidoDetalleH](
	[NumPedido] [numeric](18, 0) NULL,
	[CodCliente] [varchar](10) NULL,
	[CodProducto] [varchar](30) NULL,
	[NomProducto] [varchar](60) NULL,
	[Presentacion] [varchar](30) NULL,
	[Cantidad] [numeric](18, 0) NULL,
	[PrecioUnitario] [money] NULL,
	[PrecioTotal] [money] NULL,
	[CodVendedor] [nvarchar](15) NULL,
	[Bodega] [nvarchar](30) NULL,
	[Origen] [char](3) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[PedidoDetalleHistorico]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[PedidoDetalleHistorico](
	[NumPedido] [numeric](18, 0) NULL,
	[CodCliente] [varchar](10) NULL,
	[CodProducto] [varchar](30) NULL,
	[NomProducto] [varchar](60) NULL,
	[Presentacion] [varchar](30) NULL,
	[Cantidad] [numeric](18, 0) NULL,
	[PrecioUnitario] [money] NULL,
	[PrecioTotal] [money] NULL,
	[CodVendedor] [nvarchar](15) NULL,
	[Bodega] [nvarchar](30) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[PedidoDetalleStatusBac]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[PedidoDetalleStatusBac](
	[NumPedido] [varchar](10) NULL,
	[CodCliente] [varchar](10) NULL,
	[CodProducto] [varchar](30) NULL,
	[NomProducto] [varchar](60) NULL,
	[Presentacion] [varchar](30) NULL,
	[Cantidad] [numeric](18, 0) NULL,
	[PrecioUnitario] [money] NULL,
	[PrecioTotal] [money] NULL,
	[CodVendedor] [varchar](15) NULL,
	[Bodega] [varchar](30) NULL,
	[Origen] [char](3) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[PedidoEncabezado]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[PedidoEncabezado](
	[NumPedido] [numeric](18, 0) NULL,
	[CodCliente] [varchar](10) NULL,
	[CodVendedor] [varchar](15) NULL,
	[Tpago] [varchar](30) NULL,
	[FechaPedido] [datetime] NULL,
	[FechaEntrega] [datetime] NULL,
	[PlazoEntregaPedido] [int] NULL,
	[Observacion] [varchar](250) NULL,
	[TotalPedido] [money] NULL,
	[Pais] [nchar](30) NULL,
	[IdDireccion] [nchar](30) NULL,
	[EstCorr] [int] NULL,
	[FechHoraInsert] [datetime] NULL,
	[Origen] [nchar](3) NULL,
	[idBac] [char](50) NULL,
	[idClieCaf] [char](15) NULL,
	[EstadoBac] [char](15) NULL,
	[orderCaf] [char](50) NULL,
	[estatus] [nchar](2) NULL,
	[NumFactura] [char](20) NULL,
	[ErrCorreo] [nvarchar](250) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[PedidoEncabezadoE]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[PedidoEncabezadoE](
	[NumPedido] [numeric](18, 0) NULL,
	[CodCliente] [nvarchar](10) NULL,
	[CodVendedor] [nvarchar](15) NULL,
	[Tpago] [nvarchar](30) NULL,
	[FechaPedido] [datetime] NULL,
	[FechaEntrega] [datetime] NULL,
	[PlazoEntregaPedido] [int] NULL,
	[Observacion] [nvarchar](250) NULL,
	[TotalPedido] [money] NULL,
	[Pais] [nchar](30) NULL,
	[IdDireccion] [nchar](30) NULL,
	[EstCorr] [int] NULL,
	[FechHoraInsert] [datetime] NULL,
	[Origen] [nchar](3) NULL,
	[idBac] [char](50) NULL,
	[idClieCaf] [nchar](15) NULL,
	[EstadoBac] [char](15) NULL,
	[orderCaf] [char](50) NULL,
	[estatus] [nchar](2) NULL,
	[NumFacturas] [char](20) NULL,
	[ErrCorreo] [nvarchar](250) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[PedidoEncabezadoH]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[PedidoEncabezadoH](
	[NumPedido] [numeric](18, 0) NULL,
	[CodCliente] [nvarchar](10) NULL,
	[CodVendedor] [nvarchar](15) NULL,
	[Tpago] [nvarchar](30) NULL,
	[FechaPedido] [datetime] NULL,
	[FechaEntrega] [datetime] NULL,
	[PlazoEntregaPedido] [int] NULL,
	[Observacion] [nvarchar](250) NULL,
	[TotalPedido] [money] NULL,
	[Pais] [nchar](30) NULL,
	[IdDireccion] [nchar](30) NULL,
	[EstCorr] [int] NULL,
	[FechHoraInsert] [datetime] NULL,
	[Origen] [nchar](3) NULL,
	[idBac] [char](50) NULL,
	[idClieCaf] [nchar](15) NULL,
	[EstadoBac] [char](15) NULL,
	[orderCaf] [char](50) NULL,
	[estatus] [nchar](2) NULL,
	[NumFacturas] [char](20) NULL,
	[ErrCorreo] [nvarchar](250) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[PedidoEncabezadoHistorico]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[PedidoEncabezadoHistorico](
	[NumPedido] [numeric](18, 0) NULL,
	[CodCliente] [nvarchar](10) NULL,
	[CodVendedor] [nvarchar](15) NULL,
	[Tpago] [nvarchar](30) NULL,
	[FechaPedido] [datetime] NULL,
	[FechaEntrega] [datetime] NULL,
	[Observacion] [nvarchar](250) NULL,
	[PlazoEntregaPedido] [int] NULL,
	[TotalPedido] [money] NULL,
	[Pais] [nchar](30) NULL,
	[IdDireccion] [nchar](30) NULL,
	[EstCorr] [int] NULL,
	[FechHoraInsert] [datetime] NULL,
	[Origen] [nchar](3) NULL,
	[orderCaf] [char](50) NULL,
	[estatus] [nchar](2) NULL,
	[NumFactura] [char](20) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[PedidoEncabezadoStatusBac]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[PedidoEncabezadoStatusBac](
	[NumPedido] [numeric](18, 0) NULL,
	[CodCliente] [varchar](10) NULL,
	[CodVendedor] [varchar](15) NULL,
	[Tpago] [varchar](30) NULL,
	[FechaPedido] [datetime] NULL,
	[FechaEntrega] [datetime] NULL,
	[PlazoEntregaPedido] [int] NULL,
	[Observacion] [varchar](250) NULL,
	[TotalPedido] [money] NULL,
	[Pais] [nchar](30) NULL,
	[IdDireccion] [nchar](30) NULL,
	[EstCorr] [int] NULL,
	[FechHoraInsert] [datetime] NULL,
	[Origen] [nchar](3) NULL,
	[idBac] [char](50) NULL,
	[idClieCaf] [char](15) NULL,
	[EstadoBac] [nchar](15) NULL,
	[orderCaf] [char](50) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[PedidoEncabezadoVs]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[PedidoEncabezadoVs](
	[NumPedido] [nvarchar](18) NULL,
	[CodCliente] [nvarchar](10) NULL,
	[CodVendedor] [nvarchar](15) NULL,
	[Tpago] [nvarchar](30) NULL,
	[FechaPedido] [datetime] NULL,
	[FechaEntrega] [datetime] NULL,
	[Observacion] [nvarchar](250) NULL,
	[TotalPedido] [money] NULL,
	[Pais] [nchar](30) NULL,
	[IdDireccion] [nchar](30) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[PedidoEncabezadoX]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[PedidoEncabezadoX](
	[NumPedido] [numeric](18, 0) NULL,
	[CodCliente] [varchar](10) NULL,
	[CodVendedor] [varchar](15) NULL,
	[Tpago] [varchar](30) NULL,
	[FechaPedido] [datetime] NULL,
	[FechaEntrega] [datetime] NULL,
	[PlazoEntregaPedido] [int] NULL,
	[Observacion] [varchar](250) NULL,
	[TotalPedido] [money] NULL,
	[Pais] [nchar](30) NULL,
	[IdDireccion] [nchar](30) NULL,
	[EstCorr] [int] NULL,
	[FechHoraInsert] [datetime] NULL,
	[Origen] [nchar](3) NULL,
	[idBac] [char](50) NULL,
	[idClieCaf] [char](15) NULL,
	[EstadoBac] [char](15) NULL,
	[orderCaf] [char](50) NULL,
	[estatus] [nchar](2) NULL,
	[NumFactura] [char](20) NULL,
	[ErrCorreo] [nvarchar](250) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[PruebaMP]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[PruebaMP](
	[NumPedido] [numeric](18, 0) NULL,
	[CodCliente] [varchar](10) NULL,
	[CodVendedor] [varchar](15) NULL,
	[Tpago] [varchar](30) NULL,
	[FechaPedido] [datetime] NULL,
	[FechaEntrega] [datetime] NULL,
	[Observacion] [varchar](250) NULL,
	[TotalPedido] [money] NULL,
	[Pais] [nchar](30) NULL,
	[IdDireccion] [nchar](30) NULL,
	[EstCorr] [int] NULL,
	[FechHoraInsert] [datetime] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[SAGDetalleVentas_3]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[SAGDetalleVentas_3](
	[PAIS] [nvarchar](30) NULL,
	[ANO] [int] NULL,
	[MES] [numeric](29, 0) NULL,
	[DIVISION] [nvarchar](255) NULL,
	[MONTO] [numeric](38, 6) NULL,
	[PRESUPUESTO] [numeric](19, 4) NULL,
	[TIPO] [varchar](3) NOT NULL,
	[MontoLocal] [numeric](38, 6) NULL,
	[DEX_ROW_ID] [int] NOT NULL,
	[Vendedor] [nvarchar](20) NULL,
	[Factura] [nvarchar](255) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[SAGPagosDetalle]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[SAGPagosDetalle](
	[NumPagoDetalle] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[NumPago] [numeric](18, 0) NOT NULL,
	[NumFactura] [nvarchar](50) NOT NULL,
	[MontoCancelado] [money] NOT NULL,
	[Estado] [nvarchar](15) NULL,
	[TipoCobro] [nvarchar](15) NULL,
	[TipoDocumento] [nvarchar](15) NULL,
	[NumCheque] [nvarchar](50) NULL,
	[BancoCheque] [nvarchar](255) NULL,
	[NumTransaccionTarjeta] [nvarchar](50) NULL,
	[TipoTarjeta] [nvarchar](50) NULL,
	[BancoTarjeta] [nvarchar](255) NULL,
	[Imagen] [varbinary](max) NULL,
	[Area] [nvarchar](15) NULL,
 CONSTRAINT [PK_SAGPagosDetalle] PRIMARY KEY CLUSTERED 
(
	[NumPagoDetalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[SAGPagosEncabezado]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[SAGPagosEncabezado](
	[NumPago] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[CodCliente] [nvarchar](15) NOT NULL,
	[CodVendedor] [nvarchar](15) NOT NULL,
	[FechaPago] [datetime] NOT NULL,
	[MontoTotal] [money] NOT NULL,
	[CorreoCliente] [nvarchar](255) NULL,
	[DUIClienta] [nvarchar](50) NULL,
 CONSTRAINT [PK_SAGPagosEncabezado] PRIMARY KEY CLUSTERED 
(
	[NumPago] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[SAGProductosDescuentos]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[SAGProductosDescuentos](
	[CodProducto] [nchar](18) NULL,
	[Porcentaje] [decimal](18, 2) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[SAGSaldosCXCMovilSV]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[SAGSaldosCXCMovilSV](
	[FAC] [char](21) NOT NULL,
	[CodCliente] [char](15) NOT NULL,
	[NomCliente] [char](65) NOT NULL,
	[Saldo] [numeric](38, 5) NULL,
	[SLPRSNID] [char](15) NOT NULL,
	[FechaVence] [datetime] NOT NULL,
	[DiasVencido] [int] NULL,
	[De0a30Dias] [numeric](38, 5) NULL,
	[De31a60Dias] [numeric](38, 5) NULL,
	[De61a90Dias] [numeric](38, 5) NULL,
	[De91a120Dias] [numeric](38, 5) NULL,
	[MasDe120Dias] [numeric](38, 5) NULL,
	[DIV] [char](11) NOT NULL,
	[Pais] [varchar](2) NOT NULL,
	[UltimoPago] [numeric](19, 5) NOT NULL,
	[FUltimoPAgo] [datetime] NOT NULL,
	[PDiasPago] [smallint] NOT NULL,
	[UltimaFactura] [numeric](19, 5) NOT NULL,
	[FUltimaFactura] [datetime] NOT NULL,
	[TCredito] [char](21) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[SAGTPreciosEnLinea]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[SAGTPreciosEnLinea](
	[CodProducto] [char](31) NOT NULL,
	[NomProducto] [char](101) NOT NULL,
	[Bodega] [char](11) NULL,
	[Existencia] [numeric](20, 5) NULL,
	[Pbase] [numeric](19, 5) NULL,
	[Costo] [numeric](19, 5) NOT NULL,
	[Peso] [int] NOT NULL,
	[ListaPrecio] [char](11) NOT NULL,
	[UOMPRICE] [numeric](19, 5) NOT NULL,
	[PrecioVenta] [numeric](38, 9) NULL,
	[Pais] [varchar](2) NOT NULL,
	[TodoPublico] [nchar](2) NULL,
	[Oferta] [numeric](18, 2) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[TipoPago]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[TipoPago](
	[id_tipo_pago] [int] IDENTITY(1,1) NOT NULL,
	[descripcion_tipo_pago] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_tipo_pago] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[UsuariosMovil]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[UsuariosMovil](
	[Pin] [nchar](10) NULL,
	[Nombre] [nchar](60) NULL,
	[Division] [nchar](30) NULL,
	[Pais] [nchar](30) NULL,
	[CodVendedor] [nchar](15) NULL,
	[Cargo] [nchar](10) NULL,
	[email] [nchar](60) NULL,
	[Cambiado] [nchar](1) NULL,
	[Dui] [nchar](10) NULL,
	[DocPersonal] [nchar](13) NULL,
	[Token] [char](60) NULL,
	[FechaSesion] [datetime] NULL,
	[GerenciadoPor] [nchar](15) NULL,
	[SupervisadoPor] [nchar](15) NULL,
	[Rol] [nchar](10) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[UsuariosMovil_Nueva]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[UsuariosMovil_Nueva](
	[Pin] [nchar](10) NULL,
	[Nombre] [nchar](60) NULL,
	[Division] [nchar](30) NULL,
	[Pais] [nchar](30) NULL,
	[CodVendedor] [nchar](15) NULL,
	[Cargo] [nchar](10) NULL,
	[email] [nchar](60) NULL,
	[Cambiado] [nchar](1) NULL,
	[Dui] [nchar](10) NULL,
	[DocPersonal] [nchar](13) NULL,
	[Token] [char](60) NULL,
	[FechaSesion] [datetime] NULL,
	[GerenciadoPor] [nchar](15) NULL,
	[SupervisadoPor] [nchar](15) NULL,
	[Rol] [nchar](10) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[VendedorBodega]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[VendedorBodega](
	[CodVendedor] [nchar](15) NULL,
	[CodBodega] [nchar](30) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[WS_Cliente]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[WS_Cliente](
	[CodCliente] [char](15) NULL,
	[IdClieCafeina] [char](10) NULL,
	[Password] [nchar](100) NULL,
	[Contrasena] [varbinary](200) NULL,
	[PrimerNombre] [char](50) NULL,
	[SegundoNombre] [char](15) NULL,
	[PrimerApellido] [char](50) NULL,
	[SegundoApellido] [char](15) NULL,
	[Billing_Name] [char](50) NULL,
	[Dui] [char](10) NULL,
	[Nit] [char](21) NULL,
	[TarjetaIva] [char](25) NULL,
	[NCR] [char](15) NULL,
	[TipoDoc] [char](3) NULL,
	[Correo] [char](255) NULL,
	[IdDireccCaf] [char](10) NULL,
	[IdDireccion] [char](20) NULL,
	[Telefono] [char](15) NULL,
	[No_Celular] [char](15) NULL,
	[Comentarios] [varchar](250) NULL,
	[RutaCCF] [char](200) NULL,
	[CodPais] [char](2) NULL,
	[SitioWeb] [char](15) NULL,
	[AgregadoPor] [char](15) NULL,
	[FechaAgregado] [datetime] NULL,
	[ModificadoPor] [char](15) NULL,
	[FechaModif] [datetime] NULL,
	[Receptor_Nombre] [char](50) NULL,
	[Receptor_email] [char](50) NULL,
	[Receptor_Telefono] [char](25) NULL,
	[Receptor_IdPais] [char](5) NULL,
	[Receptor_Pais] [char](25) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[WS_ClienteListPrecio]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[WS_ClienteListPrecio](
	[IdIncrement] [int] IDENTITY(1,1) NOT NULL,
	[CodLstPrec] [nchar](15) NOT NULL,
	[CodProd] [nchar](15) NOT NULL,
	[CodCliente] [nchar](15) NOT NULL,
	[DescListPre] [char](100) NULL,
	[PrecioBase] [numeric](18, 2) NULL,
	[Cantidad] [int] NULL,
	[PrecioUOferta] [numeric](18, 2) NULL,
	[CodPais] [nchar](2) NULL,
	[UsuarioCrea] [nchar](10) NULL,
	[FechaCrea] [datetime] NULL,
	[UsuarioModif] [nchar](10) NULL,
	[FechaModif] [datetime] NULL,
 CONSTRAINT [PK_WS_ClienteListPrecio] PRIMARY KEY CLUSTERED 
(
	[CodLstPrec] ASC,
	[CodProd] ASC,
	[CodCliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[WS_ClienteListPrecio_AGRI]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[WS_ClienteListPrecio_AGRI](
	[IdIncrement] [int] IDENTITY(1,1) NOT NULL,
	[CodProd] [nchar](10) NULL,
	[CodCliente] [nchar](15) NULL,
	[Precio] [float] NULL,
	[Descripcion] [nchar](100) NULL,
	[CodPais] [char](2) NULL,
	[UsuarioCrea] [char](15) NULL,
	[FechaCrea] [datetime] NULL,
	[UsuarioModif] [char](15) NULL,
	[FechaModif] [datetime] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[WS_Departamentos]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[WS_Departamentos](
	[idDepto] [nchar](2) NOT NULL,
	[Depa] [nchar](30) NULL,
	[Latitud] [nchar](30) NULL,
	[Longitud] [nchar](30) NULL,
 CONSTRAINT [PK_WS_Departamentos] PRIMARY KEY CLUSTERED 
(
	[idDepto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[WS_DiasFestivos]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[WS_DiasFestivos](
	[Dia] [date] NOT NULL,
	[Descripcion] [varchar](50) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[WS_DireccCliente]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[WS_DireccCliente](
	[CodCliente] [char](15) NULL,
	[IdDireccion] [char](20) NULL,
	[IdClieCafeina] [char](10) NOT NULL,
	[IdDireccionCaf] [char](10) NOT NULL,
	[Nombre] [char](30) NULL,
	[Principal] [bit] NULL,
	[deleted] [bit] NULL,
	[Direccion] [char](183) NULL,
	[DireccionTotal] [varchar](max) NULL,
	[Telefono1] [char](20) NULL,
	[Telefono2] [char](20) NULL,
	[idCity] [char](10) NULL,
	[Ciudad] [char](50) NULL,
	[idDepartamento] [char](10) NULL,
	[Departamento] [char](25) NULL,
	[idMunicipio] [char](10) NULL,
	[Municipio] [char](25) NULL,
	[Pais] [char](2) NULL,
	[CodPostal] [char](10) NULL,
	[PersonaContacto] [char](100) NULL,
	[Comentario] [char](200) NULL,
 CONSTRAINT [PK_WS_DireccCliente] PRIMARY KEY CLUSTERED 
(
	[IdClieCafeina] ASC,
	[IdDireccionCaf] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[WS_ListaPrecio]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[WS_ListaPrecio](
	[CodLstPrec] [nchar](15) NOT NULL,
	[NombreLstPre] [varchar](100) NULL,
	[CodPais] [varchar](2) NULL,
	[UsuarioCrea] [nchar](10) NULL,
	[FechaCrea] [datetime] NULL,
	[UsuarioModif] [nchar](10) NULL,
	[FechaModif] [datetime] NULL,
 CONSTRAINT [PK_WS_ListaPrecio] PRIMARY KEY CLUSTERED 
(
	[CodLstPrec] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[WS_Municipios]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[WS_Municipios](
	[IdDepartamento] [varchar](2) NOT NULL,
	[IdMunicipio] [varchar](2) NOT NULL,
	[DEPARTAMENTO] [nchar](30) NULL,
	[Municipio] [nchar](50) NULL,
	[LATITUD] [nchar](30) NULL,
	[LONGITUD] [nchar](30) NULL,
 CONSTRAINT [PK_WS_Municipios] PRIMARY KEY CLUSTERED 
(
	[IdDepartamento] ASC,
	[IdMunicipio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[WS_Notificaciones]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[WS_Notificaciones](
	[idIncrement] [int] IDENTITY(1,1) NOT NULL,
	[CodigoNotif] [char](10) NULL,
	[Descrip_Notif] [char](255) NULL,
	[UsuarioCrea] [nchar](10) NULL,
	[FechaCrea] [datetime] NULL,
	[UsuarioModif] [nchar](10) NULL,
	[FechaModif] [datetime] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[WS_NotifMail]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[WS_NotifMail](
	[idIncrement] [int] IDENTITY(1,1) NOT NULL,
	[CodigoNotif] [char](25) NULL,
	[CodigoSistema] [nchar](50) NULL,
	[CodPais] [char](2) NULL,
	[Activo] [bit] NULL,
	[Correo] [char](100) NULL,
	[Comentarios] [char](255) NULL,
	[UsuarioCrea] [char](10) NULL,
	[FechaCrea] [datetime] NULL,
	[UsuarioModif] [char](10) NULL,
	[FechaModif] [char](10) NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[WS_Pais]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[WS_Pais](
	[CodPais] [nchar](2) NULL,
	[NombrePais] [nchar](25) NULL,
	[Activo] [bit] NULL,
	[Moneda] [nvarchar](1) NULL,
	[logo] [varchar](max) NULL,
	[img] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[WS_SitioOrigenPedido]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[WS_SitioOrigenPedido](
	[NumPedido] [nchar](10) NULL,
	[CodCliente] [nchar](15) NULL,
	[SitioOrigen] [nchar](10) NULL,
	[FechaInsert] [datetime] NULL,
	[RequiereEnvio] [bit] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[WS_Usuarios]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[WS_Usuarios](
	[IdIncrement] [int] IDENTITY(1,1) NOT NULL,
	[Usuario] [nchar](25) NOT NULL,
	[Password] [nchar](50) NULL,
	[Empresa] [nchar](15) NULL,
	[UsuarioCrea] [nchar](10) NULL,
	[FechaCrea] [datetime] NULL,
	[UsuarioModif] [nchar](10) NULL,
	[FechaModif] [datetime] NULL,
 CONSTRAINT [PK_WS_Usuarios] PRIMARY KEY CLUSTERED 
(
	[Usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [dbo].[WS_ZonaCoberCAEX]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [dbo].[WS_ZonaCoberCAEX](
	[IdIncrement] [int] IDENTITY(1,1) NOT NULL,
	[Codigo] [nchar](5) NULL,
	[Zona] [nchar](15) NULL,
	[Agencia] [nchar](10) NULL,
	[Departamento] [int] NULL,
	[Lunes] [bit] NULL,
	[Martes] [bit] NULL,
	[Miercoles] [bit] NULL,
	[Jueves] [bit] NULL,
	[Viernes] [bit] NULL,
	[Sabado] [bit] NULL,
	[Domingo] [bit] NULL,
	[UsuarioCrea] [nchar](10) NULL,
	[FechaCrea] [datetime] NULL,
	[UsuarioModif] [nchar](10) NULL,
	[FechaModif] [datetime] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [SAG].[SecurityMacro]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [SAG].[SecurityMacro](
	[Pais] [nvarchar](2) NOT NULL,
	[Password] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  Table [SAG].[TEMP_VTAS_PRESU_REGIONAL]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE TABLE [SAG].[TEMP_VTAS_PRESU_REGIONAL](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PAIS] [nvarchar](50) NULL,
	[Division] [nvarchar](50) NULL,
	[ANO] [int] NULL,
	[MES] [int] NULL,
	[Monto] [money] NULL,
	[PRESUPUESTO] [money] NULL,
	[TIPO] [nvarchar](50) NULL,
	[VENDEDOR] [nvarchar](50) NULL,
	[Factura] [nvarchar](50) NULL,
	[Cliente] [nvarchar](50) NULL,
	[CUSTNAME] [nvarchar](max) NULL,
	[DOCDATE] [datetime] NULL,
	[Fecha] [nvarchar](max) NULL,
	[Costo] [money] NULL,
	[DIF] [money] NULL,
	[MontoDolar] [money] NULL,
	[CostoDolar] [money] NULL,
	[MuestraSemana] [tinyint] NULL,
	[MuestraMes] [tinyint] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
