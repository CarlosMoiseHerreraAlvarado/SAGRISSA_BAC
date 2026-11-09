/* SAGRISA legacy Movil - views. Generado desde movil.sql. Conectarse a la base destino antes de ejecutar. */

SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGPedidosEncabezadosH]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGPedidosEncabezadosH]
AS
SELECT  NumPedidoT, CodCliente, CodVendedor, Tpago, FechaPedido, FechaEntrega, Observacion, TotalPedido, Pais, IdDireccion, EstCorr, FechHoraInsert, hhmmss
FROM    dbo.TSAGPedidosEncabezadosH
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [SAG].[AUTORIZAR_2FacConMargenVA]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [SAG].[AUTORIZAR_2FacConMargenVA]
AS
SELECT        NumFactura
FROM            SAG.TAUTORIZAR_2FacConMargenVA
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGPedidosAppVrsGP]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGPedidosAppVrsGP]
AS
SELECT  TOP (100) PERCENT NumPedidoT, FechaPedido, CodVendedor, CodCliente, TotalPedidoApp, ElPedido, Factura, FechaFac, IdCliente, SubTotalGP, Diferencia, VendedorFac, Pais, FechHoraInsert, PedidoGP, EstadoFac, HoraMinSeg, NombreCliente, NumFEL, TotalFactura
FROM    dbo.TSAGPedidosAppVrsGP
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [SAG].[AUTORIZAR_3FacturasXAutorizarVA]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [SAG].[AUTORIZAR_3FacturasXAutorizarVA]
AS
SELECT        Facturas
FROM            SAG.TAUTORIZAR_3FacturasXAutorizarVA
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGMovilExistencias00]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGMovilExistencias00]
AS
SELECT  TOP (100) PERCENT CodProducto, NomProducto, Bodega, Existencia, Pbase, Comentario, PMinimo, Costo, Division
FROM    dbo.TSAGMovilExistencias00
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGMovilExistenciasLote]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGMovilExistenciasLote]
AS
SELECT  TOP (100) PERCENT CodProducto, NomProducto, Existencia, Bodega, LOTNUMBR, SaldoLote, PBase, FechaVto
FROM    dbo.TSAGMovilExistenciasLote
GROUP BY CodProducto, NomProducto, Existencia, Bodega, LOTNUMBR, SaldoLote, PBase, FechaVto
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGDetalleVentas]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGDetalleVentas]
AS
SELECT        PAIS, ANO, MES, DIVISION, Monto, PRESUPUESTO, TIPO, MontoLocal, DEX_ROW_ID, VENDEDOR, Factura, Nombre
FROM            dbo.TSAGDetalleVentas
GROUP BY PAIS, ANO, MES, DIVISION, Monto, PRESUPUESTO, TIPO, MontoLocal, DEX_ROW_ID, VENDEDOR, Factura, Nombre
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGDivisionVendedor]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGDivisionVendedor]
AS
SELECT        CodVendedor, Division
FROM            dbo.TSAGDivisionVendedor
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGDetalleVentasGT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGDetalleVentasGT]
AS
SELECT        PAIS, ANO, MES, DIVISION, MONTO, PRESUPUESTO, TIPO, MontoLocal, DEX_ROW_ID, Vendedor, Factura, Nombre
FROM            dbo.TSAGDetalleVentasGT
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGMovilExistenciasGT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGMovilExistenciasGT]
AS
SELECT  CodProducto, NomProducto, Bodega, Existencia, Pbase, Comentario, PMinimo, Costo
FROM    dbo.TSAGMovilExistenciasGT
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGMovilExistenciasLoteGT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGMovilExistenciasLoteGT]
AS
SELECT  TOP (100) PERCENT CodProducto, NomProducto, Existencia, Bodega, LOTNUMBR, SaldoLote, PBase, FechaVto
FROM    dbo.TSAGMovilExistenciasLoteGT
GROUP BY CodProducto, NomProducto, Existencia, Bodega, LOTNUMBR, SaldoLote, PBase, FechaVto
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGDetalleVentasHN]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGDetalleVentasHN]
AS
SELECT        PAIS, ANO, MES, DIVISION, MONTO, PRESUPUESTO, TIPO, MontoLocal, DEX_ROW_ID, Vendedor, Factura, Nombre
FROM            dbo.TSAGDetalleVentasHN
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGCobrosRegional1]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGCobrosRegional1]
AS
SELECT        IDVENDOR, NUMMES, YEAR, TotalCobrado, Presupuesto, Pais
FROM            dbo.TSAGCobrosRegional1
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGPedidosPendientes]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGPedidosPendientes]
AS
SELECT  NumPedido, CodCliente, CodProducto, NomProducto, Presentacion, Cantidad, PrecioUnitario, PrecioTotal, CodVendedor, Bodega, NomCliente, FechaPedido, Observacion
FROM    dbo.TSAGPedidosPendientes
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGCobrosRegional2]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGCobrosRegional2]
AS
SELECT        Vendedor, MES, Ano, TotalCobrado, Presupuesto, Pais
FROM            dbo.TSAGCobrosRegional2
GROUP BY Vendedor, MES, Ano, TotalCobrado, Presupuesto, Pais
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGCobrosGT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGCobrosGT]
AS
SELECT        IDVENDOR, NUMMES, YEAR, TotalCobrado, Pais, COBRARA, Nombre
FROM            dbo.TSAGCobrosGT
GROUP BY IDVENDOR, NUMMES, YEAR, TotalCobrado, Pais, COBRARA, Nombre
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGListadoFacturas]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGListadoFacturas]
AS
SELECT        TOP (100) PERCENT CodigoCliente, NombreCliente, Factura, FechaVence, Saldo, Dias, Vendedor
FROM            dbo.TSAGListadoFacturas
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGListadoFacturasHN]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGListadoFacturasHN]
AS
SELECT        TOP (100) PERCENT CodigoCliente, NombreCliente, Factura, FechaVence, Saldo, Dias, Vendedor
FROM            dbo.TSAGListadoFacturasHN
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGListadoFacturasGT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGListadoFacturasGT]
AS
SELECT        TOP (100) PERCENT CodigoCliente, NombreCliente, Factura, FechaVence, Saldo, Dias, Vendedor
FROM            dbo.TSAGListadoFacturasGT
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGCobrosBorro]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGCobrosBorro]
AS
SELECT        Vendedor, NumCobro, MES, Ano, TotalCobrado, TipoTrans, Pais
FROM            dbo.TSAGCobrosBorro
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGComparaGerencial]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGComparaGerencial]
AS
SELECT        PAIS, ANO, MES, TotalVent, TotalPres, TIPO, DIVISION
FROM            dbo.TSAGComparaGerencial
GROUP BY PAIS, ANO, MES, TotalVent, TotalPres, TIPO, DIVISION
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGUsuariosMovil]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGUsuariosMovil]
AS
SELECT  Pin, Nombre, Pais, CodVendedor
FROM    dbo.TSAGUsuariosMovil
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGMovilExistencias_borrar]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGMovilExistencias_borrar]
AS
SELECT        TOP (100) PERCENT CodProducto, NomProducto, Bodega, Existencia, Pbase, Comentario
FROM            dbo.TSAGMovilExistencias_borrar
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGMovilExistencias01]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGMovilExistencias01]
AS
SELECT  TOP (100) PERCENT CodProducto, NomProducto, Bodega, Existencia, Pbase, Comentario, PMinimo, Costo, Division
FROM    dbo.TSAGMovilExistencias01
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGMovilExistencias]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGMovilExistencias]
AS
SELECT        CodProducto, NomProducto, Bodega, Existencia, Pbase, Comentario, PMinimo, Costo, Division
FROM            dbo.TSAGMovilExistencias
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGExistenciasAgropecuariaWEB]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGExistenciasAgropecuariaWEB]
AS
SELECT        CodProducto, NomProducto, Bodega, Existencia, Division, Pais, Peso
FROM            dbo.TSAGExistenciasAgropecuariaWEB
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [SAG].[CobrosParaChequeGT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [SAG].[CobrosParaChequeGT]
AS
SELECT        SAG.TCobrosParaChequeGT.*
FROM            SAG.TCobrosParaChequeGT
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[ClientesGT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[ClientesGT]
AS
SELECT  CodCliente, NomCliente, Clase, Vendedor, Ciudad, TPago, INACTIVE, HOLD, Lprecios, MontoCredito, TotalDeuda, SaldoCredito, Correo
FROM    dbo.TClientesGT
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGCobrosHoy]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGCobrosHoy]
AS
SELECT        IDVENDOR, NUMMES, YEAR, Pais, TotalCobrado, Nombre
FROM            dbo.TSAGCobrosHoy
GROUP BY IDVENDOR, NUMMES, YEAR, Pais, TotalCobrado, Nombre
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGPreciosEnLinea]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGPreciosEnLinea]
AS
SELECT  CodProducto, NomProducto, Bodega, Existencia, Pbase, Costo, Peso, ListaPrecio, PorcentajeDesc, PrecioVenta, Pais, Clase, PrecioSinIVA, CantDecimales
FROM    dbo.TSAGPreciosEnLinea
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGCobros]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGCobros]
AS
SELECT        IDVENDOR, NUMMES, YEAR, Pais, COBRARA, TotalCobrado, Nombre
FROM            dbo.TSAGCobros
GROUP BY IDVENDOR, NUMMES, YEAR, Pais, COBRARA, TotalCobrado, Nombre
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[Clientes]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[Clientes]
AS
SELECT  TOP (100) PERCENT CodCliente, NomCliente, Clase, Vendedor, Ciudad, TPago, INACTIVE, HOLD, LPrecios, MontoCredito, TotalDeuda, SaldoCredito, Correo
FROM    dbo.TClientes
WHERE  (INACTIVE <> 1) AND (HOLD <> 1)
ORDER BY NomCliente
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[DireccionSV]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[DireccionSV]
AS
SELECT  CodCliente, CodDireccion, Dir1, Dir2, Dir3
FROM    dbo.TDireccionSV
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [SAG].[AUTORIZAR_1FacNoImpresasGT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [SAG].[AUTORIZAR_1FacNoImpresasGT]
AS
SELECT        NumFactura, Fecha
FROM            SAG.TAUTORIZAR_1FacNoImpresasGT
GROUP BY NumFactura, Fecha
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[DireccionGT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[DireccionGT]
AS
SELECT  CodCliente, CodDireccion, Dir1, Dir2, Dir3
FROM    dbo.TDireccionGT
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [SAG].[MargenesAutorizarGT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [SAG].[MargenesAutorizarGT]
AS
SELECT        TOP (100) PERCENT IdClase, UNITCOST, PU, Margen, MargenType, Autorizado, NumFactura, Descripcion, Nombre, Fecha, CodCliente, CodProducto, TotalFactura, Cantidad, SUBTOTAL, HECHO, TipoDoc, Vendedor
FROM            SAG.TMargenesAutorizarGT
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [SAG].[MargenesAutorizar2GT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [SAG].[MargenesAutorizar2GT]
AS
SELECT        IdClase, UNITCOST, PU, Margen, MargenType, Autorizado, NumFactura, Descripcion, Estatus
FROM            SAG.TMargenesAutorizar2GT
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGVPedidoEncabezado]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGVPedidoEncabezado]
AS
SELECT  NumPedido, CodCliente, CodVendedor, Tpago, FechaPedido, FechaEntrega, Observacion, TotalPedido, Pais, IdDireccion, EstCorr, FechHoraInsert, Origen, idBac, idClieCaf, EstadoBac, orderCaf
FROM    dbo.TSAGVPedidoEncabezado
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[MargenAutorizar1GT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[MargenAutorizar1GT]
AS
SELECT        IdClase, UNITCOST, PU, Margen, MargenType, Autorizado, NumFactura, Descripcion, Nombre, Fecha, CodCliente, CodProducto, TotalFactura, Cantidad, SUBTOTAL, HECHO, TipoDoc, Vendedor
FROM            dbo.TMargenAutorizar1GT
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGVPedidoDetalle]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGVPedidoDetalle]
AS
SELECT  NumPedido, CodCliente, CodProducto, NomProducto, Presentacion, Cantidad, PrecioUnitario, PrecioTotal, CodVendedor, Bodega, Origen
FROM    dbo.TSAGVPedidoDetalle
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [SAG].[AUTORIZAR_2FacConMargenGT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [SAG].[AUTORIZAR_2FacConMargenGT]
AS
SELECT        NumFactura
FROM            SAG.TAUTORIZAR_2FacConMargenGT
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [SAG].[AUTORIZAR_3FacturasXAutorizarGT]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [SAG].[AUTORIZAR_3FacturasXAutorizarGT]
AS
SELECT        Facturas
FROM            SAG.TAUTORIZAR_3FacturasXAutorizarGT
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGVPedidosVsFac]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGVPedidosVsFac]
AS
SELECT  TOP (100) PERCENT NumPedido, FechaPedido, CodVendedor, CodCliente, TotalPedido, ElPedido, Factura, FechaFac, IdCliente, SUBTOTAL, Diferencia, VendedorFac
FROM    dbo.TSAGVPedidosVsFac
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGResumenDeudaCliente]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGResumenDeudaCliente]
AS
SELECT  CodCliente, NomCliente, [0a30 dias], [31a60 dias], [61a90 dias], [91a120 dias], [Mas 120 dias], TotalDeuda, Pais
FROM    dbo.TSAGResumenDeudaCliente
GROUP BY CodCliente, NomCliente, [0a30 dias], [31a60 dias], [61a90 dias], [91a120 dias], [Mas 120 dias], TotalDeuda, Pais
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGVPedidosHistóricos]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGVPedidosHistóricos]
AS
SELECT  NumPedido, CodCliente, CodVendedor, Tpago, FechaPedido, Mes, Año, FechaEntrega, Observacion, TotalPedido, Pais, IdDireccion
FROM    dbo.TSAGVPedidosHistóricos
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGTotalEnPedido]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGTotalEnPedido]
AS
SELECT  CodProducto, TotalP, Origen, Pais
FROM    dbo.TSAGTotalEnPedido
GROUP BY CodProducto, TotalP, Origen, Pais
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGMovilExistencias02]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGMovilExistencias02]
AS
SELECT  TOP (100) PERCENT CodProducto, NomProducto, Bodega, Existencia, Pbase, Comentario, PMinimo, Costo, Division
FROM    dbo.TSAGMovilExistencias02
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGMovilExistencias000]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGMovilExistencias000]
AS
SELECT  CodProducto, NomProducto, Bodega, Existencia, Pbase, Comentario, PMinimo, Expr1, Costo, Division
FROM    dbo.TSAGMovilExistencias000
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGPreciosEnLineaAgropA]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGPreciosEnLineaAgropA]
AS
SELECT  CodCliente, CUSTNAME, CodProd, Precio, CodPais, Clase, ITMCLSDC, ClaseCliente
FROM    dbo.TSAGPreciosEnLineaAgropA
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGDatosClientesSV]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGDatosClientesSV]
AS
SELECT        CodCliente, NomCliente, UltimoPago, FUltimoPAgo, PDiasPago, UltimaFactura, FUltimaFactura, DiasC
FROM            dbo.TSAGDatosClientesSV AS TSAGDatosClientesSV_1
GROUP BY CodCliente, NomCliente, UltimoPago, FUltimoPAgo, PDiasPago, UltimaFactura, FUltimaFactura, DiasC
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [SAG].[MargenesAutorizar]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [SAG].[MargenesAutorizar]
AS
SELECT        TOP (100) PERCENT SAG.TMargenesAutorizar.*
FROM            SAG.TMargenesAutorizar
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [SAG].[MargenesAutorizar2]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [SAG].[MargenesAutorizar2]
AS
SELECT        SAG.TMargenesAutorizar2.*
FROM            SAG.TMargenesAutorizar2
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [SAG].[AUTORIZAR_1FacNoImpresas]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [SAG].[AUTORIZAR_1FacNoImpresas]
AS
SELECT        NumFactura, Fecha
FROM            SAG.TAUTORIZAR_1FacNoImpresas
GROUP BY NumFactura, Fecha
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [SAG].[AUTORIZAR_2FacConMargen]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [SAG].[AUTORIZAR_2FacConMargen]
AS
SELECT        NumFactura
FROM            SAG.TAUTORIZAR_2FacConMargen
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [SAG].[AUTORIZAR_3FacturasXAutorizar]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [SAG].[AUTORIZAR_3FacturasXAutorizar]
AS
SELECT        Facturas
FROM            SAG.TAUTORIZAR_3FacturasXAutorizar
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[MargenAutorizar1]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[MargenAutorizar1]
AS
SELECT        IdClase, UNITCOST, PU, Margen, MargenType, Autorizado, NumFactura, Descripcion, Nombre, Fecha, CodCliente, CodProducto, TotalFactura, Cantidad, SUBTOTAL, HECHO, TipoDoc, Vendedor
FROM            dbo.TMargenAutorizar1
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGMovilExistenciasZZ]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGMovilExistenciasZZ]
AS
SELECT  CodProducto, NomProducto, Bodega, Existencia, Pbase, Comentario, PMinimo, Costo, Division
FROM    dbo.TSAGMovilExistenciasZZ
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGMovilExistenciasLoteZZ]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGMovilExistenciasLoteZZ]
AS
SELECT  TOP (100) PERCENT dbo.TSAGMovilExistenciasLoteZZ.CodProducto, dbo.TSAGMovilExistenciasLoteZZ.NomProducto, dbo.TSAGMovilExistenciasLoteZZ.Existencia, dbo.TSAGMovilExistenciasLoteZZ.Bodega, dbo.TSAGMovilExistenciasLoteZZ.LOTNUMBR, dbo.TSAGMovilExistenciasLoteZZ.SaldoLote, dbo.TSAGMovilExistenciasLoteZZ.PBase, dbo.TSAGMovilExistenciasLoteZZ.FechaVto
FROM    GPSAG.dbo.IV00105 CROSS JOIN
           dbo.TSAGMovilExistenciasLoteZZ
GROUP BY dbo.TSAGMovilExistenciasLoteZZ.CodProducto, dbo.TSAGMovilExistenciasLoteZZ.NomProducto, dbo.TSAGMovilExistenciasLoteZZ.Existencia, dbo.TSAGMovilExistenciasLoteZZ.Bodega, dbo.TSAGMovilExistenciasLoteZZ.LOTNUMBR, dbo.TSAGMovilExistenciasLoteZZ.SaldoLote, dbo.TSAGMovilExistenciasLoteZZ.PBase, dbo.TSAGMovilExistenciasLoteZZ.FechaVto
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGProductosSinPrecio]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGProductosSinPrecio]
AS
SELECT  CodProducto, NomProducto, Bodega, Existencia, Pbase, Comentario, PMinimo, Costo
FROM    dbo.TSAGProductosSinPrecio
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[DireccionCR]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[DireccionCR]
AS
SELECT  CodCliente, CodDireccion, Dir1, Dir2, Dir3
FROM    dbo.TDireccionCR
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGClientesRegionales]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGClientesRegionales]
AS
SELECT        CUSTNMBR, CUSTNAME, INACTIVE, HOLD, PAIS, ClaseCliente
FROM            dbo.TSAGClientesRegionales
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGPreciosEnLineaAgrop]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGPreciosEnLineaAgrop]
AS
SELECT  CodCliente, CUSTNAME, CodProd, Cantidad, PrecioUOferta, CodPais, Clase, DescListPre, CodLstPrec, ClaseCliente
FROM    dbo.TSAGPreciosEnLineaAgrop
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGBorrar]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGBorrar]
AS
SELECT        TOP (100) PERCENT CodProducto, NomProducto, Bodega, Existencia, Pbase, Costo, Peso, ListaPrecio, PorcentajeDesc, PrecioVenta, Pais
FROM            dbo.TSAGBorrar
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGResumenDeudaClienteWEB]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGResumenDeudaClienteWEB]
AS
SELECT  CodCliente, NomCliente, [0a30 dias], [31a60 dias], [61a90 dias], [91a120 dias], [Mas 120 dias], TotalDeuda, Pais
FROM    dbo.TSAGResumenDeudaClienteWEB
GROUP BY CodCliente, NomCliente, [0a30 dias], [31a60 dias], [61a90 dias], [91a120 dias], [Mas 120 dias], TotalDeuda, Pais
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGDatosClientesWEB]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGDatosClientesWEB]
AS
SELECT        CodCliente, NomCliente, UltimoPago, FUltimoPAgo, PDiasPago, UltimaFactura, FUltimaFactura, DiasC
FROM            dbo.TSAGDatosClientesWEB
GROUP BY CodCliente, NomCliente, UltimoPago, FUltimoPAgo, PDiasPago, UltimaFactura, FUltimaFactura, DiasC
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGDetalleDeudaClienteWEB]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGDetalleDeudaClienteWEB]
AS
SELECT        CodCliente, FAC, De0a30Dias, De31a60Dias, De61a90Dias, De91a120Dias, MasDe120Dias, Saldo, FechaVence
FROM            dbo.TSAGDetalleDeudaClienteWEB
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  View [dbo].[SAGPedidosAppVrsFactVrsDespacho]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE VIEW [dbo].[SAGPedidosAppVrsFactVrsDespacho]
AS
SELECT  TOP (100) PERCENT NumPedidoT, FechaPedido, CodVendedor, CodCliente, TotalPedidoApp, Factura, FechaFac, IdCliente, SubTotalGP, Diferencia, VendedorFac, FechHoraInsert, PedidoGP, EstadoFac, HoraMinSeg, NombreCliente, HoraFactura, FechaDespacho, MOTORISTA, Dias
FROM    dbo.TSAGPedidosAppVrsFactVrsDespacho
GO
