/* SAGRISA legacy Movil - procedures. Generado desde movil.sql. Conectarse a la base destino antes de ejecutar. */

SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [dbo].[WEB_PObtenerCredenciales]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE             PROCEDURE [dbo].[WEB_PObtenerCredenciales] 
(		
	@Usuario varchar(30),
	@Pin varchar(10)
)as 
BEGIN  
		 SET NOCOUNT ON;

		select 
		CodVendedor,
		Pin,
		Cargo,
		Pais
		from [dbo].[UsuariosMovil]
		where CodVendedor = @Usuario AND Pin = @Pin;
END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [dbo].[WS_PCrearMacroPedidos_PRU]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 08/05/2021
  Procedimiento para crear macro de ORDEN DE COMPRA en modulo de presupuestos y solicitudes
  */


CREATE         procedure [dbo].[WS_PCrearMacroPedidos_PRU]
(
	@Pedido varchar(15),
	@CodPais varchar(2),
	@Direccon varchar(100), /*add mpinto  15/11/2021 */
	@IdCliente varchar(1) = null /*add mpinto 17/09/2021 se agrega parametro para indicar si es a partir de una sol compra*/
)as 
BEGIN TRY
BEGIN TRANSACTION
BEGIN


DECLARE @Macro varchar(max) ='';

DECLARE @Count_Prov INT = 0;
DECLARE @Count_Analitica INT = 0;
DECLARE @ContadorLoop INT = 1;
DECLARE @codprov varchar(15);


	SELECT @Macro = @Macro + 

					'# DEXVERSION=16.00.0033.000 2 2'+ CHAR(13) + CHAR(10)+
					'CheckActiveWin dictionary ''Project Accounting''  form ''POP_PO_Entry'' window ''POP_PO_Entry''' + CHAR(13) + CHAR(10)+
        '  TypeTo field ''Customer Number'' , ''' +@IdCliente  + ''''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Customer Name'''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Primary Shipto Address Code'''+ CHAR(13) + CHAR(10)+
        '  TypeTo field ''Primary Shipto Address Code'' , ''' +@Direccon  + ''''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Document Date'''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Location Code'''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Customer PO Number'''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Currency ID'''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Expansion Button 1'''+ CHAR(13) + CHAR(10)+
        '  ClickHit field ''Expansion Button 1'''+ CHAR(13) + CHAR(10)+
        'NewActiveWin dictionary ''default''  form ''SOP_Document_Detail_Entry'' window ''SOP_Document_Detail_Entry'''+ CHAR(13) + CHAR(10)+
        '  TypeTo field Reference , ''' +@Pedido  + ''''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''OK Button'''+ CHAR(13) + CHAR(10)+
        '  ClickHit field ''OK Button'''+ CHAR(13) + CHAR(10)+
        'NewActiveWin dictionary ''default''  form ''SOP_Entry'' window ''SOP_Entry'''+ CHAR(13) + CHAR(10)+
        'ActivateWindow dictionary ''default''  form ''SOP_Entry'' window ''SOP_Entry'''+ CHAR(13) + CHAR(10)+
			'# Key 1: '+ CHAR(13) + CHAR(10);
		
		
		
	  SELECT @Macro = @Macro + ''
		
		SELECT @Macro = @Macro + 
		'CheckActiveWin dictionary ''default''  form ''SOP_Entry'' window ''SOP_Entry'''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Expansion Button 4'''+ CHAR(13) + CHAR(10)+
        '  ClickHit field ''Expansion Button 4'''+ CHAR(13) + CHAR(10)+
        'NewActiveWin dictionary ''default''  form ''SOP_Customer_Detail_Entry'' window ''SOP_Customer_Detail_Entry'''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Salesperson ID'''+ CHAR(13) + CHAR(10)+
        '  TypeTo field ''Salesperson ID'' , ''" & Me.THecho.Text & "'''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Sales Territory'''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''OK Button'''+ CHAR(13) + CHAR(10)+
        '  ClickHit field ''OK Button'''+ CHAR(13) + CHAR(10)+
        'ActivateWindow dictionary ''default''  form ''SOP_Entry'' window ''SOP_Entry'''+ CHAR(13) + CHAR(10)+
        'ActivateWindow dictionary ''default''  form ''SOP_Entry'' window ''SOP_Entry'''+ CHAR(13) + CHAR(10)+
        'ActivateWindow dictionary ''default''  form ''SOP_Entry'' window ''SOP_Entry'''+ CHAR(13) + CHAR(10)
					;




SELECT '1' Result, @Macro Macro;
END		   		      
commit transaction;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS Result,
	@Macro Macro;

ROLLBACK TRANSACTION;
END CATCH
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[getCobrosSV]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
create procedure [SAG].[getCobrosSV] as begin    

SELECT 
       sum([De0a30Dias]) as [0a30dias]
      ,sum([De31a60Dias]) as [31a60dias]
      ,sum([De61a75Dias]) + sum([De75a90Dias]) as [61a90dias]
      ,sum([De91a120Dias]) as [91a120dias]
      ,sum([MasDe120Dias])as [mas120dias]
  FROM [GPSAG].[dbo].[SAGSaldosCXCCM01]


end
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[getCobrosSVbyDivision]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE procedure [SAG].[getCobrosSVbyDivision] as begin    

--SELECT        SUM(dbo.SAGResumenDeudaCliente.[0a30 dias]) AS [0a30dias], SUM(dbo.SAGResumenDeudaCliente.[31a60 dias]) AS [31a60dias], SUM(dbo.SAGResumenDeudaCliente.[61a90 dias]) AS [61a90dias], 
--                         SUM(dbo.SAGResumenDeudaCliente.[91a120 dias]) AS [91a120dias], SUM(dbo.SAGResumenDeudaCliente.[Mas 120 dias]) AS mas120dias, 
--						 GPSAG.dbo.RM00301.ZIP AS Division
--FROM            dbo.SAGResumenDeudaCliente INNER JOIN
--                         GPSAG.dbo.RM00101 ON dbo.SAGResumenDeudaCliente.CodCliente = GPSAG.dbo.RM00101.CUSTNMBR INNER JOIN
--                         GPSAG.dbo.RM00301 ON GPSAG.dbo.RM00101.SLPRSNID = GPSAG.dbo.RM00301.SLPRSNID
--where GPSAG.dbo.RM00301.ZIP in ('A', 'V', 'P', 'I', 'T', 'J')
--GROUP BY GPSAG.dbo.RM00301.ZIP


SELECT 
       sum([De0a30Dias]) as [0a30dias]
      ,sum([De31a60Dias]) as [31a60dias]
      ,sum([De61a75Dias]) + sum([De75a90Dias]) as [61a90dias]
      ,sum([De91a120Dias]) as [91a120dias]
      ,sum([MasDe120Dias])as [mas120dias]
	        ,[Division]

  FROM [GPSAG].[dbo].[SAGSaldosCXCCM01]
  where Division in ('A', 'V', 'P', 'I', 'T', 'J')
group by [Division]



end
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[InsertAutorizacion]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE   procedure [SAG].[InsertAutorizacion]( @NumFact nvarchar(max), @User nvarchar(max) ) as begin    

--EXEC [SAG].[InsertAutorizacion] 

if left(@NumFact,4)='FAE0'
begin 

INSERT INTO NUTGT.DBO.SAGTFactAutorizadasPrint
SELECT  
 t1.[Facturas] AS NUMFACTURA,
t2.[Fecha] AS FECHADOC,
t2.[CodCliente] AS IDCLIENTE,
t2.[CodProducto] as ITEMNMBR,
t2.[Nombre] AS CLIENTE,
 t2.[UNITCOST] as COSTUNITP,
 t2.[PU] as PREUNITP,
 t2.CANTIDAD,
 t2.SUBTOTAL,
 t2.[TotalFactura] as TOTALFACT,
 t2.TipoDoc as TIPODOC,
 t2.Hecho as HECHO,
 getdate() as FECAUTO,
 'Autorizado desde APP' as COMMENT,
 @User AS USUARIO
     FROM SAGRI_MOVIL.[SAG].[AUTORIZAR_3FacturasXAutorizarGT] t1  
	 left join SAGRI_MOVIL.[SAG].[MargenesAutorizarGT] t2  
		on t1.[Facturas] = t2.[NumFactura]
 where t1.[Facturas] = @NumFact;
end
else
begin
INSERT INTO GPSAG.DBO.SAGTFactAutorizadasPrint
SELECT  
 t1.[Facturas] AS NUMFACTURA,
t2.[Fecha] AS FECHADOC,
t2.[CodCliente] AS IDCLIENTE,
t2.[CodProducto] as ITEMNMBR,
t2.[Nombre] AS CLIENTE,
 t2.[UNITCOST] as COSTUNITP,
 t2.[PU] as PREUNITP,
 t2.CANTIDAD,
 t2.SUBTOTAL,
 t2.[TotalFactura] as TOTALFACT,
 t2.TipoDoc as TIPODOC,
 t2.Hecho as HECHO,
 getdate() as FECAUTO,
 'Autorizado desde APP' as COMMENT,
 @User AS USUARIO
     FROM SAGRI_MOVIL.[SAG].[AUTORIZAR_3FacturasXAutorizar] t1  
	 left join SAGRI_MOVIL.[SAG].[MargenesAutorizar] t2  
		on t1.[Facturas] = t2.[NumFactura]
 where t1.[Facturas] = @NumFact;
 end

 RETURN 1 

end
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[PedidioNuevo]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE                     PROCEDURE [SAG].[PedidioNuevo] (@NumPedido numeric(18,0) , @Pais NCHAR(30)) AS
BEGIN

SET NOCOUNT ON;




WITH htmlresult AS (
SELECT ROW_NUMBER() OVER (ORDER BY [SAGRI_MOVIL].[dbo].[PedidoEncabezado].NumPedido) AS RowNumber,

'<td><center>' + CONVERT(nvarchar,[SAGRI_MOVIL].[dbo].[PedidoEncabezado].[NumPedido])  + '</center></td>' +
'<td><center>' + [SAGRI_MOVIL].[dbo].[PedidoEncabezado].[CodCliente] + '</center></td>' +
'<td><center>' + [SAGRI_MOVIL].[dbo].[PedidoEncabezado].[CodVendedor]  + '</center></td>'+
'<td><center>' + CONVERT(nvarchar,[SAGRI_MOVIL].[dbo].[PedidoEncabezado].[FechHoraInsert],103)  +' '+ CONVERT(nvarchar,[SAGRI_MOVIL].[dbo].[PedidoEncabezado].[FechHoraInsert],108)+ '</center></td>' +
'<td><center>' + CONVERT(nvarchar,CAST([SAGRI_MOVIL].[dbo].[PedidoEncabezado].[TotalPedido] as money),1)  + '</center></td>'  
						 AS Reporte_Cobros
from [SAGRI_MOVIL].[dbo].[PedidoEncabezado]
where [SAGRI_MOVIL].[dbo].[PedidoEncabezado].NumPedido=@NumPedido
and Pais=@Pais
--WHERE (AuditTrail.EnteredDate > GETDATE() - 1)
)

, htmlresult2 AS (
SELECT ROW_NUMBER() OVER (ORDER BY [SAGRI_MOVIL].[dbo].[PedidoEncabezado].NumPedido) AS RowNumber,

'<td><center>' + CONVERT(nvarchar,[SAGRI_MOVIL].[dbo].[PedidoEncabezado].[NumPedido])  + '</center></td>' +
'<td><center>' + [SAGRI_MOVIL].[dbo].[PedidoEncabezado].[CodCliente] + '</center></td>' +
'<td><center>' + [SAGRI_MOVIL].[dbo].[PedidoEncabezado].[CodVendedor]  + '</center></td>'+
'<td><center>' + CONVERT(nvarchar,[SAGRI_MOVIL].[dbo].[PedidoEncabezado].[FechHoraInsert],103)  +' '+ CONVERT(nvarchar,[SAGRI_MOVIL].[dbo].[PedidoEncabezado].[FechHoraInsert],108)+ '</center></td>' +
'<td><center>' + CONVERT(nvarchar,CAST([SAGRI_MOVIL].[dbo].[PedidoEncabezado].[TotalPedido] as money),1)  + '</center></td>'  
						 AS Reporte_CobrosPendientes
from [SAGRI_MOVIL].[dbo].[PedidoEncabezado]
where [SAGRI_MOVIL].[dbo].[PedidoEncabezado].NumPedido<@NumPedido
and Pais=@Pais
--WHERE (AuditTrail.EnteredDate > GETDATE() - 1)
)

SELECT '<table><tr style="background-color: #5D7B9D; font-weight: bold; color: white;">
    <td>Nuedo Pedido</td>	<td>Codigo Cliente</td>	<td>Codigo Vendedor</td> <td>Fecha Pedido</td>	<td>Total Pedido</td>' AS Reporte_Cobros
UNION ALL
SELECT Reporte_Cobros =
    CASE RowNumber%2
        WHEN 0 THEN '<tr style="background-color: #F7F6F3">' + Reporte_Cobros + '</tr>'
        ELSE '<tr>' + Reporte_Cobros + '</tr>'
END
FROM htmlresult
UNION ALL
SELECT '</table>'

union all


SELECT '<table><tr style="background-color: #5D7B9D; font-weight: bold; color: white;">
    <td>Pedido Pendiente</td>	<td>Codigo Cliente</td>	<td>Codigo Vendedor</td> <td>Fecha Pedido</td>	<td>Total Pedido</td>' AS Reporte_CobrosPendientes
UNION ALL
SELECT Reporte_CobrosPendientes =
    CASE RowNumber%2
        WHEN 0 THEN '<tr style="background-color: #F7F6F3">' + Reporte_CobrosPendientes + '</tr>'
        ELSE '<tr>' + Reporte_CobrosPendientes + '</tr>'
END
FROM htmlresult2
UNION ALL
SELECT '</table>'
END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[PedidioNuevoControl]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE                                 PROCEDURE [SAG].[PedidioNuevoControl] AS
BEGIN


SET NOCOUNT ON;






    declare @Body nvarchar(MAX)
set @Body = '<h3>Se ha ejecutado la tarea de Notificaciones<h3> '
declare @TheMailID int
declare @subjectVendedor nvarchar(400)
set @subjectVendedor  = 'Control ejecucion de Tarea Notificaciones'
--declare @queryVendedor nvarchar(400)
--set @queryVendedor  = 'EXECUTE [SAGRI_MOVIL].[SAG].[PedidioNuevo] '+ @PEDIDO+''
declare @recipientsVendedor nvarchar(400)
set @recipientsVendedor  = 'amenjivar@sagrisa.com'

--declare @blind_copy_recipientsTI nvarchar(400)
--set @blind_copy_recipientsTI  = 'amenjivar@sagrisa.com; emunoz@sagrisa.com; sbaldez@sagrisa.com; msacul@sagrisa.com; aalvarez@sagrisa.com; cmarcos@sagrisa.com'

select @subjectVendedor

--EXEC msdb.dbo.sp_send_dbmail
--@profile_name = 'Email Reportes',
--@blind_copy_recipients='amenjivar@sagrisa.com',
--@subject = @subjectVendedor,
--@body=@Body,
--@query_result_header = 0,
--@attach_query_result_as_file = 0,
--@body_format = 'HTML'











END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[PedidioNuevoCorreo]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE                                 PROCEDURE [SAG].[PedidioNuevoCorreo] (@NumPedido numeric(18,0), @Pais NCHAR(30)) AS
BEGIN


SET NOCOUNT ON;



DECLARE @DOCUMENTO AS nvarchar(400)
DECLARE @CODIGOTIPO AS nvarchar(400)
DECLARE @TIPODOCUMENTO AS nvarchar(400)
DECLARE @CODIGOCLIENTE AS nvarchar(400)
DECLARE @NOMBRECLIENTE AS nvarchar(400)
DECLARE @TIPOPAGO AS nvarchar(400)
DECLARE @VENDEDOR AS nvarchar(400)
DECLARE @CORREO AS nvarchar(400)
DECLARE @PEDIDO nvarchar(400)
DECLARE @SALDO AS numeric(18,2)
DECLARE @CREDITO AS numeric(18,2)
DECLARE @MONTO AS numeric(18,2)
DECLARE @COLA AS int


SELECT  CONVERT(nvarchar,[SAGRI_MOVIL].[dbo].[PedidoEncabezado].[NumPedido]) PEDIDO
,[SAGRI_MOVIL].[dbo].[UsuariosMovil].email CORREO
from [SAGRI_MOVIL].[dbo].[PedidoEncabezado]
,[SAGRI_MOVIL].[dbo].[UsuariosMovil]

where 
[SAGRI_MOVIL].[dbo].[PedidoEncabezado].[CodVendedor]=[SAGRI_MOVIL].[dbo].[UsuariosMovil].[CodVendedor]
and [SAGRI_MOVIL].[dbo].[PedidoEncabezado].Pais=@Pais
AND [SAGRI_MOVIL].[dbo].[PedidoEncabezado].NumPedido=@NumPedido


SELECT @COLA = COUNT(NumPedido)
from [SAGRI_MOVIL].[dbo].[PedidoEncabezado]
,[SAGRI_MOVIL].[dbo].[UsuariosMovil]

where 
[SAGRI_MOVIL].[dbo].[PedidoEncabezado].[CodVendedor]=[SAGRI_MOVIL].[dbo].[UsuariosMovil].[CodVendedor]
and [SAGRI_MOVIL].[dbo].[PedidoEncabezado].Pais=@Pais
AND [SAGRI_MOVIL].[dbo].[PedidoEncabezado].NumPedido<@NumPedido


DECLARE ProdInfo CURSOR FOR 


SELECT  CONVERT(nvarchar,[SAGRI_MOVIL].[dbo].[PedidoEncabezado].[NumPedido]) PEDIDO
,[SAGRI_MOVIL].[dbo].[UsuariosMovil].email CORREO
from [SAGRI_MOVIL].[dbo].[PedidoEncabezado]
,[SAGRI_MOVIL].[dbo].[UsuariosMovil]

where 
[SAGRI_MOVIL].[dbo].[PedidoEncabezado].[CodVendedor]=[SAGRI_MOVIL].[dbo].[UsuariosMovil].[CodVendedor]
and [SAGRI_MOVIL].[dbo].[PedidoEncabezado].Pais=@Pais
AND [SAGRI_MOVIL].[dbo].[PedidoEncabezado].NumPedido=@NumPedido


OPEN ProdInfo

FETCH NEXT FROM ProdInfo INTO @PEDIDO ,@CORREO

WHILE @@fetch_status = 0

BEGIN




    declare @Body nvarchar(MAX)
set @Body = '<h3>Se ha generado un nuevo Pedido Móvil: ' +@PEDIDO+'<h3> '
set @Body=@Body+'<h3>Pedidos pendientes de transferir a GP: ' +convert(nvarchar(15),@COLA)+'<h3> '
declare @TheMailID int
declare @subjectVendedor nvarchar(400)
set @subjectVendedor  = 'Pedido Móvil No:  '+ @PEDIDO
declare @queryVendedor nvarchar(400)
set @queryVendedor  = 'EXECUTE [SAGRI_MOVIL].[SAG].[PedidioNuevo] '+ @PEDIDO+','+@Pais
declare @recipientsVendedor nvarchar(400)
set @recipientsVendedor  = @CORREO

--declare @blind_copy_recipientsTI nvarchar(400)
--set @blind_copy_recipientsTI  = 'amenjivar@sagrisa.com; emunoz@sagrisa.com; sbaldez@sagrisa.com; msacul@sagrisa.com; aalvarez@sagrisa.com; cmarcos@sagrisa.com'

select @subjectVendedor

EXEC msdb.dbo.sp_send_dbmail
--@profile_name = 'SAGRISA',
@profile_name = 'Email Reportes',
@recipients = @recipientsVendedor,
--@blind_copy_recipients=@blind_copy_recipientsTI,
@blind_copy_recipients='amenjivar@sagrisa.com; emunoz@sagrisa.com',
@subject = @subjectVendedor,
@body=@Body,
@query_result_header = 0,
@query =@queryVendedor,
@attach_query_result_as_file = 0,
@body_format = 'HTML'

    FETCH NEXT FROM ProdInfo INTO  @PEDIDO , @CORREO 

END

CLOSE ProdInfo

DEALLOCATE ProdInfo








END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[ProcesarCorreosPendientes]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE         PROCEDURE [SAG].[ProcesarCorreosPendientes]
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Id INT, @NumPedido  NUMERIC(18,0), @Pais NCHAR(30);

    DECLARE c CURSOR LOCAL FAST_FORWARD FOR
        SELECT Id, NumPedido,Pais
        FROM [SAGRI_MOVIL].[dbo].[CorreosPendientes]
       WHERE Procesado = 0 
	  --and Pais ='GUATEMALA';

    OPEN c;
    FETCH NEXT FROM c INTO @Id, @NumPedido,@Pais;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        BEGIN TRY
		if @Pais='GUATEMALA'
		begin 
            EXEC [SAGRI_MOVIL].[SAG].[PedidioNuevoCorreo] @NumPedido,@Pais;
		end 


            UPDATE [SAGRI_MOVIL].[dbo].[CorreosPendientes]
            SET Procesado = 1, FechaProcesado = GETDATE()
            WHERE Id = @Id;
        END TRY
        BEGIN CATCH
            UPDATE [dbo].[CorreosPendientes]
            SET MensajeError = ERROR_MESSAGE()
            WHERE Id = @Id;
        END CATCH;

        FETCH NEXT FROM c INTO @Id, @NumPedido,@Pais;
    END

    CLOSE c;
    DEALLOCATE c;
END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[UpdateNumFacturas]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado AMENJIVAR 30/11/2020
  Procedimiento para actualizar numero de factura
  */
CREATE   procedure [SAG].[UpdateNumFacturas] 
as 
BEGIN TRY
BEGIN TRANSACTION
BEGIN

update SAGRI_MOVIL.dbo.PedidoEncabezado
set PedidoEncabezado.NumFactura=SOP30200.SOPNUMBE 
from GPSAG.dbo.SOP30200  
where convert(nvarchar(50),PedidoEncabezado.NumPedido)=convert(nvarchar(50),SOP30200.REFRENCE) and Pais='EL SALVADOR'
and SOP30200.SOPTYPE='3'
and PedidoEncabezado.NumFactura is null
and SOP30200.SOPNUMBE is not null
and DOCDATE>='2020-01-01'
;
update SAGRI_MOVIL.dbo.PedidoEncabezadoH
set PedidoEncabezadoH.NumFacturas=SOP30200.SOPNUMBE   
from GPSAG.dbo.SOP30200  
where convert(nvarchar(50),PedidoEncabezadoH.NumPedido)=convert(nvarchar(50),SOP30200.REFRENCE) and Pais='EL SALVADOR'
and SOP30200.SOPTYPE='3'
and PedidoEncabezadoH.NumFacturas is null
and SOP30200.SOPNUMBE is not null
and DOCDATE>='2020-01-01'
;

update SAGRI_MOVIL.dbo.PedidoEncabezadoH
set PedidoEncabezadoH.NumFacturas=SOP30200.SOPNUMBE   
from GPSAG.dbo.SOP30200 
where 'MOV'+convert(nvarchar(50),PedidoEncabezadoH.NumPedido)=convert(nvarchar(50),SOP30200.REFRENCE) and Pais='EL SALVADOR'
and SOP30200.SOPTYPE='3'
and PedidoEncabezadoH.NumFacturas is null
and SOP30200.SOPNUMBE is not null
and DOCDATE>='2020-01-01'
;

update SAGRI_MOVIL.dbo.PedidoEncabezado
set PedidoEncabezado.NumFactura=SOP30200.SOPNUMBE   
from NUTGT.dbo.SOP30200  
where convert(nvarchar(50),PedidoEncabezado.NumPedido)=convert(nvarchar(50),SOP30200.REFRENCE) and Pais='GUATEMALA'
and SOP30200.SOPTYPE='3'
and PedidoEncabezado.NumFactura is null
and SOP30200.SOPNUMBE is not null
and DOCDATE>='2020-01-01'
;
update SAGRI_MOVIL.dbo.PedidoEncabezadoH
set PedidoEncabezadoH.NumFacturas=SOP30200.SOPNUMBE   
from NUTGT.dbo.SOP30200  
where convert(nvarchar(50),PedidoEncabezadoH.NumPedido)=convert(nvarchar(50),SOP30200.REFRENCE) and Pais='GUATEMALA'
and SOP30200.SOPTYPE='3'
and PedidoEncabezadoH.NumFacturas is null
and SOP30200.SOPNUMBE is not null
and DOCDATE>='2020-01-01'
;
update SAGRI_MOVIL.dbo.PedidoEncabezadoH
set PedidoEncabezadoH.NumFacturas=SOP30200.SOPNUMBE   
from NUTGT.dbo.SOP30200  
where 'MOV'+convert(nvarchar(50),PedidoEncabezadoH.NumPedido)=convert(nvarchar(50),SOP30200.REFRENCE) and Pais='GUATEMALA'
and SOP30200.SOPTYPE='3'
and PedidoEncabezadoH.NumFacturas is null
and SOP30200.SOPNUMBE is not null
and DOCDATE>='2020-01-01'
;


update SAGRI_MOVIL.dbo.PedidoEncabezadoH
set  estatus='F'
from GPSAG.dbo.SOP30200  
where convert(nvarchar(50),PedidoEncabezadoH.NumPedido)=convert(nvarchar(50),SOP30200.REFRENCE) and Pais='EL SALVADOR'
and SOP30200.SOPTYPE='3'
and PedidoEncabezadoH.NumFacturas is not null
and SOP30200.SOPNUMBE is not null
and DOCDATE>='2020-01-01'
and estatus in ('P',NULL)
;


update SAGRI_MOVIL.dbo.PedidoEncabezadoH
set  estatus='F'
from GPSAG.dbo.SOP30200  
where 'MOV'+convert(nvarchar(50),PedidoEncabezadoH.NumPedido)=convert(nvarchar(50),SOP30200.REFRENCE) and Pais='EL SALVADOR'
and SOP30200.SOPTYPE='3'
and PedidoEncabezadoH.NumFacturas is not null
and SOP30200.SOPNUMBE is not null
and DOCDATE>='2020-01-01'
and estatus in ('P',NULL)
;


update SAGRI_MOVIL.dbo.PedidoEncabezadoH
set  estatus='F'
from NUTGT.dbo.SOP30200  
where convert(nvarchar(50),PedidoEncabezadoH.NumPedido)=convert(nvarchar(50),SOP30200.REFRENCE) and Pais='GUATEMALA'
and SOP30200.SOPTYPE='3'
and PedidoEncabezadoH.NumFacturas is not null
and SOP30200.SOPNUMBE is not null
and DOCDATE>='2020-01-01'
and estatus in ('P',NULL)
;

update SAGRI_MOVIL.dbo.PedidoEncabezadoH
set  estatus='F'
from NUTGT.dbo.SOP30200  
where 'MOV'+convert(nvarchar(50),PedidoEncabezadoH.NumPedido)=convert(nvarchar(50),SOP30200.REFRENCE) and Pais='GUATEMALA'
and SOP30200.SOPTYPE='3'
and PedidoEncabezadoH.NumFacturas is not null
and SOP30200.SOPNUMBE is not null
and DOCDATE>='2020-01-01'
and estatus in ('P',NULL)
;


END		   		      
commit transaction;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS ErrorMessage;

ROLLBACK TRANSACTION;
END CATCH
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ActualizarCliente]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 24/04/2020
  Procedimiento creado para actualizar datos del cliente  a traves de un json enviado desde el Web Service
  y como se desglosa en el procedimiento, se ocupa la funcion OPENJSON para extraer la información
  */
CREATE procedure [SAG].[WS_ActualizarCliente] 
(
	@JsonCliente nvarchar(max)
	
)as 
BEGIN TRY
BEGIN TRANSACTION
BEGIN

With Json_data as 
(	SELECT id, name, lastname,DUI, NIT, iva_card, registry,
	         document_type, email, phone,  additional_data, billing_name,
			 recipient_name , recipient_email , recipient_phone,
			 pais.idpais, pais.namepais, cel
			 --addresss.idDir, additional_data, billing_name
	  FROM OPENJSON(@JsonCliente)
		   WITH (id char(15), name char(50),
		        lastname char(50), dui char(10),
				nit char(21), iva_card char(25), registry char(15),
				document_type char(3), email nchar(100),
				 recipient_name char(50), recipient_email char(50), recipient_phone char(25),
				phone char(15), additional_data nchar(200), billing_name nchar(50), country_info nvarchar(max) AS JSON,
				cel char(15))
				 CROSS APPLY             
			OPENJSON (country_info) /*Agregado mpinto 13/07/2020*/
			WITH ( 	
				  idpais char(5) '$.id',
				  namepais char(25) '$.name'
				  )AS pais		      
  )
update S 
SET s.PrimerNombre = jd.name,
	s.PrimerApellido =  jd.lastname,	
	s.Dui = jd.dui,
    s.nit = jd.nit,
    s.TarjetaIva = jd.iva_Card,
	s.NCR = jd.registry,
	s.TipoDoc = JD.document_type,
	s.Correo = jd.email,
	s.Telefono = jd.phone,
	--s.IdDireccCaf = jd.idDir,
	s.Comentarios = jd.additional_data,
	s.Billing_Name = jd.billing_name,
	s.ModificadoPor = user, /* Agregado mpinto 22/06/2020 */
	s.FechaModif = getdate(), /* Agregado mpinto 22/06/2020 */
	/*Campos agregados 13/07/2020*/
	s.Receptor_IdPais = JD.idpais,
	s.Receptor_Pais = jd.namepais,
	s.Receptor_Nombre = jd.recipient_name,
	s.Receptor_email = jd.recipient_email,
	s.Receptor_Telefono = jd.recipient_phone,
	S.No_Celular = JD.cel
 from SAGRI_MOVIL.[dbo].WS_Cliente as S 
inner join Json_data as JD
   on JD.id = S.IdClieCafeina
  
  Select '1' Result;
END		   		      
commit transaction;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS Result;

ROLLBACK TRANSACTION;
END CATCH
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ActualizarCorrelativo]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
CREADO MPINTO 29/05/2020
Procedimiento Creado para obtener el numero de pedido segun el pais para las ventas en linea(SITIO WEB)
*/
CREATE PROCEDURE [SAG].[WS_ActualizarCorrelativo]    
 @CodCorrelativo nvarchar(25)
AS    
BEGIN    
    
 SET NOCOUNT ON;

   /*Actualizar el correlativo al numero siguiente, para cuando realicen un nuevo pedido*/
   UPDATE SAGRI_MOVIL.DBO.Correlativo1
      SET SAGRI_MOVIL.DBO.Correlativo1.NumSiguiente = SAGRI_MOVIL.DBO.Correlativo1.NumSiguiente + 1
   WHERE SAGRI_MOVIL.DBO.Correlativo1.Pais = @CodCorrelativo

END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ActualizarDireccCliente]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 24/04/2020
  Procedimiento creado para registrar cliente nuevo a traves de un json enviado desde el Web Service
  y como se desglosa en el procedimiento, se ocupa la funcion OPENJSON para extraer la información
  */
CREATE procedure [SAG].[WS_ActualizarDireccCliente] 
(
	@JsonCliente nvarchar(max)
	
)as 
BEGIN TRY
BEGIN TRANSACTION
BEGIN


declare @CountDirClie int = 0;


With Json_data as 
(	SELECT id,addresss.idDir, addresss.name,addresss.principal, addresss.cityname + ' ' + addresss.address address, addresss.cityname + ' ' +addresss.addressT addressT, addresss.idcity, addresss.cityname,
           addresss.state_id, addresss.state, addresss.province_id, addresss.province_name, addresss.deleted
	  FROM OPENJSON(@JsonCliente)
		   WITH (id char(15),addresses nvarchar(max) AS JSON)
		   CROSS APPLY 
            OPENJSON (addresses)
			WITH ( 			
				  idDir char(10) '$.id',
				  name char(25),
				  principal bit,
				  --address char(255),
				  address nchar(183), /*mpinto 25062020*/
				  addressT varchar(max) '$.address',
				  deleted bit,
				  state_id char(2),
				  idcity char(10) '$.city.id',
				  cityname char(50) '$.city.name',
				  state char(25) '$.state.name',
				  province_id char(3),
				  province_name char(25) '$.province.name' )AS addresss
  )
update S 
SET s.[Nombre] = jd.name,
	s.Principal =  jd.principal,
	--s.Direccion = jd.cityname + ' '+ JD.address, -- comentado mpinto 13/07/2020 segun cafeina, no permiten actualziacion de direccion
	s.[idDepartamento] = jd.state_id,
	--s.DireccionTotal = jd.cityname + ' '+ jd.addressT, -- comentado mpinto 13/07/2020 segun cafeina, no permiten actualziacion de direccion
	--s.idCity = jd.idcity, -- comentado mpinto 13/07/2020 segun cafeina, no permiten actualziacion de direccion
	--s.Ciudad = jd.cityname, -- comentado mpinto 13/07/2020 segun cafeina, no permiten actualziacion de direccion
    s.[Departamento] = jd.state,
    s.[idMunicipio] = jd.province_id,
	s.[Municipio] = jd.province_name,
	s.deleted = JD.deleted
 from SAGRI_MOVIL.[dbo].[WS_DireccCliente] as S 
inner join Json_data as JD
   on JD.id = S.IdClieCafeina
  and jd.idDir = s.IdDireccionCaf
  ;



  /*Verificar si en la actualizacion viene cambio de direccion principal*/

  SELECT @CountDirClie = COUNT(*)
	  FROM OPENJSON(@JsonCliente)
		   WITH (id char(15),
		       addresses nvarchar(max) AS JSON
			   )
		   CROSS APPLY 
            OPENJSON (addresses)
			WITH ( 	
				  idDir nchar(10) '$.id',
				  principal nchar(1) '$.principal'
				  )AS addresss
			 WHERE addresss.principal = 1
			 ;

  IF @CountDirClie > 0
  BEGIN
		  /*Actualizar cliente con la direccion principal
		  */
		  With Json_dataCL as 
		(	SELECT id, addresss.idDir
			  FROM OPENJSON(@JsonCliente)
				   WITH (id char(15),
					   addresses nvarchar(max) AS JSON
					   )
				   CROSS APPLY 
					OPENJSON (addresses)
					WITH ( 	
						  idDir nchar(10) '$.id',
						  principal nchar(1) '$.principal'
						  )AS addresss
					 WHERE addresss.principal = 1
			 
		  )
		update S 
		SET s.IdDireccCaf = jd.idDir	
		 from SAGRI_MOVIL.[dbo].WS_Cliente as S 
		inner join Json_datacl as JD
		   on JD.id = S.IdClieCafeina
		   ;
  END /*IF @CountDirClie > 0*/

  Select '1' Result;
END		   		      
commit transaction;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS Result;

ROLLBACK TRANSACTION;
END CATCH
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ActualizarPassAGR_VET]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 24/04/2020
  Procedimiento obtener la informacion del cliente para mostrar en pantalla a usuarios de credito y cobros con el fin
  de darle el proceso correspondiente para dar de alta como cliente en sistema GP
  */
CREATE procedure [SAG].[WS_ActualizarPassAGR_VET] 
(
	@codcliente char(10),
	@pass char(50)	
)as 

BEGIN TRY
BEGIN TRANSACTION 


UPDATE C
   SET C.Contrasena = EncryptByPassPhrase('SAG', rtrim(@pass))  
  FROM SAGRI_MOVIL.DBO.WS_Cliente c
WHERE c.CodCliente = @codcliente  
   ;

   Select '1' Result;
 commit transaction;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() as Result;--AS ErrorMessage;

ROLLBACK TRANSACTION;
END CATCH
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ActualizarUsuarioCCF]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 24/04/2020
  Procedimiento obtener la informacion del cliente para mostrar en pantalla a usuarios de credito y cobros con el fin
  de darle el proceso correspondiente para dar de alta como cliente en sistema GP
  */
CREATE procedure [SAG].[WS_ActualizarUsuarioCCF] 
(
	@IdClieCaf char(10),
	@Nombres char(50),
	@Apellidos char(50),
	@Billiing_name char(50), /*Nombre empresa*/
	@CodPais char(15),
	--@dui char(10),
	--@nit char(21),	
	@tarjeta_iva char(25),
    @nrc char(15),
	@correo char(255),
	@telefono char(15),
	@comentarios varchar(250),
	@cel char(15)
)as 
BEGIN  

UPDATE C
   SET C.PrimerNombre = UPPER(@Nombres),
       C.PrimerApellido = UPPER(@Apellidos),
	   c.Billing_Name = UPPER(@Billiing_name),
	   C.Correo = LOWER(@correo),
	   /*c.Nit = @nit,
	   c.Dui = @dui,*/
	   c.NCR = @nrc,
	   c.Telefono = @telefono,
	   c.TarjetaIva = @tarjeta_iva,
	   c.Comentarios = @comentarios,
	   c.No_Celular = @cel /*agregado mpinto 06/07/2020 */
  FROM SAGRI_MOVIL.DBO.WS_Cliente c
WHERE c.IdClieCafeina = @IdClieCaf
  and c.CodPais = @CodPais
   ;

   EXEC SAG.WS_VerificarCliente_GP @nrc, @IdClieCaf;
END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_AgregarArchivoCCFCliente]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 24/04/2020
  Procedimiento creado para actualizar ruta donde se almacena el archivo correspondiente al ccf
   del cliente
  */
CREATE procedure [SAG].[WS_AgregarArchivoCCFCliente] 
(
	@IdCliente char(15),
	@RutaArchivo char(200)	
)as 
BEGIN TRY
BEGIN TRANSACTION
BEGIN

update S 
SET  S.RutaCCF = @RutaArchivo	
 from SAGRI_MOVIL.[dbo].WS_Cliente as S 
WHERE S.IdClieCafeina	= @IdCliente
;
  
  Select '1' Result ;
END		   		      
commit transaction;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS Result;

ROLLBACK TRANSACTION;
END CATCH
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_agregarDireccCliente]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 24/04/2020
  Procedimiento creado para registrar cliente nuevo a traves de un json enviado desde el Web Service
  y como se desglosa en el procedimiento, se ocupa la funcion OPENJSON para extraer la información
  */
CREATE procedure [SAG].[WS_agregarDireccCliente] 
(
	@JsonCliente nvarchar(max)
	
)as

BEGIN TRY
BEGIN TRANSACTION

BEGIN  
/*INSERCION DIRECCION DEL CLIENTE*/

DECLARE @CountDirClie int =0;

INSERT INTO [dbo].[WS_DireccCliente]
           ([IdClieCafeina]
		   ,[IdDireccionCaf]
		   ,[Nombre]
		   ,[Principal]
           ,[Direccion]
		   ,[DireccionTotal]
           /*,[Telefono1]
           ,[Telefono2]*/
		   ,[idCity]
		   ,[Ciudad]
		   ,[idDepartamento]
           ,[Departamento]
           ,[idMunicipio]
		   ,[Municipio]
		  ,[deleted]
		   ,[Pais]
		   /*
           ,[CodPostal]*/) 
   --SELECT id, addresss.idDir, addresss.name,addresss.principal, addresss.address, addresss.state_id,
   SELECT id,addresss.idDir, addresss.name,addresss.principal, addresss.cityname + ' ' + addresss.address, addresss.cityname + ' ' +addresss.addressT, addresss.idcity, addresss.cityname,
		  addresss.state_id, addresss.state, addresss.province_id, addresss.province_name, addresss.deleted,
		  CASE 
		  WHEN country='503' THEN 'SV'
		  WHEN country='502' THEN 'GT'
		  END AS country
		  
	  FROM OPENJSON(@JsonCliente)
		   WITH (id char(15),addresses nvarchar(max) AS JSON, country char(3))
		   CROSS APPLY 
            OPENJSON (addresses)
			WITH ( 			
				  idDir nchar(10) '$.id',
				  name nchar(25),
				  principal bit,
				  --ddress nchar(255),
				    address nchar(183), /*mpinto 25062020*/
				  addressT varchar(max) '$.address',
				  deleted bit,
				  state_id nchar(2),
				  idcity nchar(25) '$.city.id',
				  cityname nchar(25) '$.city.name',
				  state nchar(25) '$.state.name',
				  province_id nchar(3),
				  province_name nchar(25) '$.province.name' )AS addresss
				  --,
		   --Departamento nchar(255) '$.addresses.state.name'


		   /*Verificar si en la actualizacion viene cambio de direccion principal*/

  SELECT @CountDirClie = COUNT(*)
	  FROM OPENJSON(@JsonCliente)
		   WITH (id char(15),
		       addresses nvarchar(max) AS JSON
			   )
		   CROSS APPLY 
            OPENJSON (addresses)
			WITH ( 	
				  idDir nchar(10) '$.id',
				  principal nchar(1) '$.principal'
				  )AS addresss
			 WHERE addresss.principal = 1
			 ;

  IF @CountDirClie > 0
  BEGIN
		  /*Actualizar cliente con la direccion principal
		  */
		  With Json_dataCL as 
		(	SELECT id, addresss.idDir
			  FROM OPENJSON(@JsonCliente)
				   WITH (id char(15),
					   addresses nvarchar(max) AS JSON
					   )
				   CROSS APPLY 
					OPENJSON (addresses)
					WITH ( 	
						  idDir nchar(10) '$.id',
						  principal nchar(1) '$.principal'
						  )AS addresss
					 WHERE addresss.principal = 1
			 
		  )
		update S 
		SET s.IdDireccCaf = jd.idDir	
		 from SAGRI_MOVIL.[dbo].WS_Cliente as S 
		inner join Json_datacl as JD
		   on JD.id = S.IdClieCafeina
		   ;
  END /*IF @CountDirClie > 0*/

Select '1' Result;		   		      
END
COMMIT TRANSACTION;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS Result;

ROLLBACK TRANSACTION;
END CATCH
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_AutenticacionCliente_AG_VET]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 28/07/2020
  Procedimiento para validar autenticacion de usuario proveniente del sitio Agricola Veterinaria

  Modificado MPINTO 30/07/2020
  Agregar validacion existencia de cliente
  */
CREATE procedure [SAG].[WS_AutenticacionCliente_AG_VET] 
(
	--@CodCliente varchar(5),
	@correo char(255),
	@Password char(100)
	
)as 
BEGIN TRY
BEGIN TRANSACTION 

declare @count int = 0;
declare @countVal int = 0;
declare @PassEncrypt varbinary(200);
declare @codcli char(15);

/* Comentado mpinto 30/07/2020
  Se comenta encriptado, ya que cada vez que se realiza encriptacion es diferente el codigo varbinary
SELECT @PassEncrypt= EncryptByPassPhrase('SAG', rtrim(@Password));
SELECT @PassEncrypt;
Select  CONVERT(varchar,DECRYPTBYPASSPHRASE('SAG',@PassEncrypt ));
*/
/*VALIDACION EXISTENCIA CLIENTE*/
SELECT @count = count(*), @codcli = RTRIM(c.codcliente)
  FROM SAGRI_MOVIL.DBO.WS_Cliente C
--WHERE C.CodCliente =  @CodCliente   
WHERE C.Correo =  @correo
group by CodCliente
 ;


 IF @count < 1
	BEGIN
		SELECT 'NR' Result ;
	END
 ELSE 
	BEGIN
	    /*VALIDACION CREDENCIALES CLIENTE*/
		SELECT @countVal = count(*)
		  FROM SAGRI_MOVIL.DBO.WS_Cliente C
	   --WHERE C.CodCliente =  @CodCliente
		 WHERE C.Correo =  @correo
		   --AND C.Contrasena = @PassEncrypt /*Encriptar contraseña y comparar*/
		   AND CONVERT(varchar,DECRYPTBYPASSPHRASE('SAG',C.Contrasena )) = @Password /*Desencriptar contraseña*/
		 ;
		 BEGIN 
		 IF @countVal <1
			SELECT '0' Result;
		 ELSE
			SELECT '1' Result, rtrim(@codcli) codcliente;
		 END		 
	END

commit transaction;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() as Result;--AS ErrorMessage;

ROLLBACK TRANSACTION;
END CATCH
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_CrearMacroClienteCCF]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 23/06/2020
  Procedimiento para crear macro de cliente seleccionado en la pantalla del sistema Clientes CCF
  */
CREATE procedure [SAG].[WS_CrearMacroClienteCCF] 
(
	@idClieCaf char(15)
)as 
BEGIN TRY
BEGIN TRANSACTION
BEGIN


DECLARE @Macro varchar(max);
DECLARE @NombreCliente char(100);
DECLARE @TipoDoc char(25);
DECLARE @CodCli char(25);
DECLARE @cnt INT = 0;
DECLARE @total_dir INT = 0;
/*Contar cuantas direcciones tiene el cliente */
select @total_dir = COUNT(*)
  from SAGRI_MOVIL.dbo.WS_DireccCliente d
 where d.IdClieCafeina = @idClieCaf
   and d.Principal <> 1;
   
 /* LOOP PARA CUANDO TENGA MAS DIRECCIONES
WHILE @cnt < @total_dir
BEGIN
   --{...statements...}
   SET @cnt = @cnt + 1;
END;*/

IF @total_dir < 1
	BEGIN
	 SET LANGUAGE spanish   
		SELECT @NombreCliente =  case when c.TipoDoc ='CCF' THEN UPPER(RTRIM(COALESCE(C.Billing_Name,'')))
														   ELSE RTRIM(UPPER(COALESCE(c.PrimerNombre,''))) +' '+ RTRIM(UPPER(COALESCE(c.PrimerApellido,''))) END,
			   @TipoDoc = RTRIM(c.TipoDoc),
				@CodCli= 'SVC'+CAST((SELECT MAX(v_.CORRELATIVO) + 1
																	FROM(SELECT cast(SUBSTRING(CUSTNMBR,4,LEN(CUSTNMBR)) as int) CORRELATIVO, CUSTNMBR
																		   FROM GPSAG.dbo.RM00101) v_) AS varchar) ,
		       @Macro=
				 '# DEXVERSION=16.00.0033.000 2 2 ' + CHAR(13) + CHAR(10)+
				 'CheckActiveWin dictionary ''Project Accounting''  form ''RM_Customer_Maintenance'' window ''RM_Customer_Maintenance''  ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Customer Number'' , ''SVC'+CAST((SELECT MAX(v_.CORRELATIVO) + 1
																	FROM(SELECT cast(SUBSTRING(CUSTNMBR,4,LEN(CUSTNMBR)) as int) CORRELATIVO, CUSTNMBR
																		   FROM GPSAG.dbo.RM00101) v_) AS varchar) + ''''+ CHAR(13)  + CHAR(10)+
				 '  MoveTo field Hold  # ''FALSE''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Customer Name'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Customer Name'' , ''' + case when c.TipoDoc ='CCF' THEN UPPER(RTRIM(COALESCE(C.Billing_Name,'')))
														   ELSE RTRIM(UPPER(COALESCE(c.PrimerNombre,''))) +' '+ RTRIM(UPPER(COALESCE(c.PrimerApellido,''))) END + '''' + CHAR(13)  + CHAR(10)+
				 '  MoveTo field ''Short Name'' ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Statement Name''  ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Customer Class''  ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Customer Class'' , ''APDIRV''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Customer Priority'' item 1  # ''Ninguno'' ' + CHAR(13) + CHAR(10)+
				 '  ClickHit field ''Customer Priority'' item 2  # ''1'' ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Address Code'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Address Code'' , ''PRINCIPAL''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Contact Person'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Contact Person'' ,  ''' + RTRIM(UPPER(c.PrimerNombre)) +' '+ RTRIM(UPPER(c.PrimerApellido)) + '''' + CHAR(13) + CHAR(10)+
				 --'  TypeTo field ''Contact Person'' ,  ''' + replace(RTRIM(UPPER(c.PrimerNombre)),'Ñ',CHAR(165)) +' '+ replace(RTRIM(UPPER(c.PrimerApellido)),'Ñ',CHAR(165)) + '''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Address 1'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Address 1'' , '''+UPPER(RTRIM(COALESCE(C.Billing_Name,'')))+'''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Address 2'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Address 2'' , '''+UPPER(SUBSTRING(d.Direccion,0,CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/2))))+'''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Address 3'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Address 3'' , '''+UPPER(SUBSTRING( SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/2)))+1, len(d.Direccion)),0,CHARINDEX(' ', SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/2)))+1, len(d.Direccion)),(LEN(d.Direccion)/2))))+'''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field City ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field City , '''+UPPER(RTRIM(d.Municipio))+''''  + CHAR(13) + CHAR(10)+
				 '  MoveTo field State  ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field State  , '''+UPPER(RTRIM(d.Departamento))+''''  + CHAR(13) + CHAR(10)+
				 '  MoveTo field Zip ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Country Code'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Country Code'' , '''+UPPER(RTRIM(c.CodPais))+''''  + CHAR(13) + CHAR(10)+
				 '  MoveTo field Country ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Phone 1'' ' + CHAR(13) + CHAR(10)+
				 /*'  TypeTo field ''Phone 1'' , '''+'503'+UPPER(RTRIM(COALESCE(c.Telefono,'')))+'''' + CHAR(13) + CHAR(10)+*/
				 '  TypeTo field ''Phone 1'' , '''+'503'+replace(substring(c.Telefono,5,LEN(c.telefono)), '-','') +'''' + CHAR(13) + CHAR(10)+				 
				 '  MoveTo field ''Phone 2'' ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field Comment2 ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field Comment2 , '''+UPPER(RTRIM(COALESCE(c.Dui,'')))+'''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Payment Terms ID'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Payment Terms ID'' , ''CONTADO''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field PriceLevel ' + CHAR(13) + CHAR(10)+
				 /*'  TypeTo field PriceLevel , ''PRE2014''' + CHAR(13) + CHAR(10)+*/
				 '  TypeTo field PriceLevel , ''PLINEA''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Accounts Button'' ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Salesperson ID'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Salesperson ID'' , ''SVRMORE''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Sales Territory'' ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''User Defined 2'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''User Defined 2'' ,'''+ case when c.TipoDoc ='CCF' THEN UPPER(RTRIM(replace(c.TarjetaIva,'-','')))
														   ELSE UPPER(RTRIM(replace(c.nit,'-',''))) END +'''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Options Button'' ' + CHAR(13) + CHAR(10)+
				 '  ClickHit field ''Options Button'' ' + CHAR(13) + CHAR(10)+
				 'NewActiveWin dictionary ''Project Accounting''  form ''RM_Customer_Maintenance'' window ''RM_Customer_Options'' ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Tax Registration Number'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Tax Registration Number'' , '''+UPPER(RTRIM(COALESCE(c.ncr,'')))+''''+ CHAR(13) + CHAR(10)+
				 '  MoveTo field ''(L) Email Statements To Address'' ' + CHAR(13) + CHAR(10)+
				 '  SelectChars field ''(L) Email Statements To Address'' ssel 0 esel 0 ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''(L) Email Statements To Address'' , ''A''' + CHAR(13) + CHAR(10)+
				 '  TNT_Event , ''09002B016B0100000000060000E8BE7720F0'' # cntrl chr' + CHAR(13) + CHAR(10)+
				 '  TNT_Event , ''09002B016B01000000001F0000E8BE7720F0'' # cntrl chr' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''(L) Email Statements To Address'' , '''+RTRIM(COALESCE(c.CORREO,''))+''''+ CHAR(13) + CHAR(10)+
				 '  TNT_Event , ''09002B016B0100000000040000E8BE7720F0'' # cntrl chr' + CHAR(13) + CHAR(10)+
				 '  CommandExec dictionary ''Project Accounting''  form ''RM_Customer_Maintenance'' command ''OK Button_w_RM_Customer_Options_f_RM_Customer_Maintenance'' ' + CHAR(13) + CHAR(10)+
				 'NewActiveWin dictionary ''Project Accounting''  form ''RM_Customer_Maintenance'' window ''RM_Customer_Maintenance'' ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''UPS Zone'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo  field ''UPS Zone'' , '''+RTRIM(COALESCE(c.tipodoc,''))+''''+ CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Shipping Method'' '+ CHAR(13) + CHAR(10)+
				 '  MoveTo field ''(L) Address Profile Button'' '+ CHAR(13) + CHAR(10)+
				 '  ClickHit field ''(L) Address Profile Button'' '+ CHAR(13) + CHAR(10)+
				 'NewActiveWin dictionary ''default''  form ''RM_Customer_Address'' window ''RM_Customer_Address'' '+ CHAR(13) + CHAR(10)+
				 'ActivateWindow dictionary ''default''  form ''RM_Customer_Address'' window ''RM_Customer_Address'' '+ CHAR(13) + CHAR(10)+
				 'ActivateWindow dictionary ''default''  form ''RM_Customer_Address'' window ''RM_Customer_Address'' '+ CHAR(13) + CHAR(10)+
				 'ActivateWindow dictionary ''default''  form ''RM_Customer_Address'' window ''RM_Customer_Address'' '+ CHAR(13) + CHAR(10)+
				 'ActivateWindow dictionary ''default''  form ''RM_Customer_Address'' window ''RM_Customer_Address'' '+ CHAR(13) + CHAR(10)+
				 'ActivateWindow dictionary ''default''  form ''RM_Customer_Address'' window ''RM_Customer_Address'' '+ CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Location Code'' '+ CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Location Code'' , ''CENTRAL'''+ CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Salesperson ID'' '+ CHAR(13) + CHAR(10)+
				 '  CommandExec dictionary ''default''  form ''RM_Customer_Address'' command ''Save Button_w_RM_Customer_Address_f_RM_Customer_Address'' '+ CHAR(13) + CHAR(10)+
				 'CloseWindow dictionary ''default''  form ''RM_Customer_Address'' window ''RM_Customer_Address'' '+ CHAR(13) + CHAR(10)+
				 'NewActiveWin dictionary ''Project Accounting''  form ''RM_Customer_Maintenance'' window ''RM_Customer_Maintenance'' '+ CHAR(13) + CHAR(10) 		 +
				 /*Aqui comienza direccion de despacho*/
				 '  MoveTo field ''Primary Shipto Address Code'' '+ CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Primary Shipto Address Code'' , ''DESPACHO'''+ CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Primary Billto Address Code'' '+ CHAR(13) + CHAR(10)+	 
				 '# ¿Desea agregar este Id. de dirección?'+ CHAR(13) + CHAR(10)+
				 'NewActiveWin dictionary ''Project Accounting''  form DiaLog window DiaLog '+ CHAR(13) + CHAR(10)+
				 '  ClickHit field OK '+ CHAR(13) + CHAR(10)+
				 'NewActiveWin dictionary ''Project Accounting''  form ''RM_Customer_Maintenance'' window ''RM_Customer_Maintenance'' '+ CHAR(13) + CHAR(10)+
				 'NewActiveWin dictionary ''default''  form ''RM_Customer_Address'' window ''RM_Customer_Address'' '+ CHAR(13) + CHAR(10)+				 
				 --'  MoveTo field ''Contact Person'' ' + CHAR(13) + CHAR(10)+
				 /*'  TypeTo field ''Contact Person'' ,  ''' + RTRIM(UPPER(c.PrimerNombre)) +' '+ RTRIM(UPPER(c.PrimerApellido)) + '''' + CHAR(13) + CHAR(10)+*/
				 '  TypeTo field ''Contact Person'' ,  ''' + replace(RTRIM(UPPER(c.PrimerNombre)),'Ñ',CHAR(165)) +' '+ replace(RTRIM(UPPER(c.PrimerApellido)),'Ñ',CHAR(165)) + '''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Address 1'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Address 1'' , '''+UPPER(SUBSTRING(d.Direccion,0,CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3))))+'''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Address 2'' ' + CHAR(13) + CHAR(10)+
				 /*'  MoveTo field ''Address 1'' ' + CHAR(13) + CHAR(10)+
				 '  CommandExec form BuiLtin command cmdEditCut ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Address 1'' , ''''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Address 2'' ' + CHAR(13) + CHAR(10)+
				 '  CommandExec form BuiLtin command cmdEditPaste ' + CHAR(13) + CHAR(10)+*/
				 '  TypeTo field ''Address 2'' , '''+UPPER(SUBSTRING( SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),0,CHARINDEX(' ', SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),(LEN(d.Direccion)/3))))+'''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Address 3'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Address 3'' , '''+RTRIM(UPPER(SUBSTRING((SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion))),(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1,LEN(d.Direccion))))+'''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field City ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field City , '''+UPPER(RTRIM(d.Municipio))+''''  + CHAR(13) + CHAR(10)+
				 '  MoveTo field State  ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field State  , '''+UPPER(RTRIM(d.Departamento))+''''  + CHAR(13) + CHAR(10)+
				 '  MoveTo field Zip ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Country Code'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Country Code'' , '''+UPPER(RTRIM(c.CodPais))+''''  + CHAR(13) + CHAR(10)+
				 '  MoveTo field Country ' + CHAR(13) + CHAR(10)+				 
				 '  MoveTo field ''UPS Zone'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''UPS Zone'' , '''+RTRIM(COALESCE(c.tipodoc,''))+''''+ CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Shipping Method'' '+ CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Shipping Method'' , ''CLIENTE'''+ CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Tax Schedule ID'' '+ CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Tax Schedule ID'' , ''IVA 13%'''+ CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Location Code'' '+ CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Location Code'' , ''CENTRAL'''+ CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Salesperson ID'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Salesperson ID'' , ''SVRMORE''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Sales Territory'' ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''User Defined 1'' ' + CHAR(13) + CHAR(10)+
				 '  CommandExec dictionary ''default''  form ''RM_Customer_Address'' command ''Save Button_w_RM_Customer_Address_f_RM_Customer_Address'' ' + CHAR(13) + CHAR(10)+
				 'CloseWindow dictionary ''default''  form ''RM_Customer_Address'' window ''RM_Customer_Address'' ' + CHAR(13) + CHAR(10)+
				 'NewActiveWin dictionary ''Project Accounting''  form ''RM_Customer_Maintenance'' window ''RM_Customer_Maintenance'' ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Statement Address Code'' ' + CHAR(13) + CHAR(10)+
				 '  CommandExec dictionary ''Project Accounting''  form ''RM_Customer_Maintenance'' command ''Save Button_w_RM_Customer_Maintenance_f_RM_Customer_Maintenance'' ' + CHAR(13) + CHAR(10)

				 
					
			FROM SAGRI_MOVIL.dbo.WS_Cliente c  
			inner join SAGRI_MOVIL.dbo.WS_DireccCliente d    
			  on c.IdClieCafeina = d.IdClieCafeina
			 and d.Principal = 1
			 and c.IdClieCafeina =@idClieCaf
		   --ORDER BY Deta.LineaMacro 
		   --'''+UPPER(SUBSTRING(d.Direccion,0,CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/2))))+''''
		   ;
	END
ELSE
BEGIN
 SET LANGUAGE spanish   
	SELECT  @NombreCliente =  case when c.TipoDoc ='CCF' THEN UPPER(RTRIM(COALESCE(C.Billing_Name,'')))
														   ELSE RTRIM(UPPER(COALESCE(c.PrimerNombre,''))) +' '+ RTRIM(UPPER(COALESCE(c.PrimerApellido,''))) END,
			   @TipoDoc = RTRIM(c.TipoDoc),
				@CodCli= 'SVC'+CAST((SELECT MAX(v_.CORRELATIVO) + 1
																	FROM(SELECT cast(SUBSTRING(CUSTNMBR,4,LEN(CUSTNMBR)) as int) CORRELATIVO, CUSTNMBR
																		   FROM GPSAG.dbo.RM00101) v_) AS varchar) ,
				@Macro =
				 '# DEXVERSION=16.00.0033.000 2 2 ' + CHAR(13) + CHAR(10)+
				 'CheckActiveWin dictionary ''Project Accounting''  form ''RM_Customer_Maintenance'' window ''RM_Customer_Maintenance''  ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Customer Number'' , ''SVC'+CAST((SELECT MAX(v_.CORRELATIVO) + 1
																	FROM(SELECT cast(SUBSTRING(CUSTNMBR,4,LEN(CUSTNMBR)) as int) CORRELATIVO, CUSTNMBR
																		   FROM GPSAG.dbo.RM00101) v_) AS varchar) + ''''+ CHAR(13)  + CHAR(10)+
				 '  MoveTo field Hold  # ''FALSE''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Customer Name'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Customer Name'' , ''' + case when c.TipoDoc ='CCF' THEN UPPER(RTRIM(COALESCE(C.Billing_Name,'')))
														   ELSE RTRIM(UPPER(COALESCE(c.PrimerNombre,''))) +' '+ RTRIM(UPPER(COALESCE(c.PrimerApellido,''))) END + '''' + CHAR(13)  + CHAR(10)+
				 '  MoveTo field ''Short Name'' ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Statement Name''  ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Customer Class''  ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Customer Class'' , ''APDIRV''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Customer Priority'' item 1  # ''Ninguno'' ' + CHAR(13) + CHAR(10)+
				 '  ClickHit field ''Customer Priority'' item 2  # ''1'' ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Address Code'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Address Code'' , ''PRINCIPAL''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Contact Person'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Contact Person'' ,  ''' + RTRIM(UPPER(c.PrimerNombre)) +' '+ RTRIM(UPPER(c.PrimerApellido)) + '''' + CHAR(13) + CHAR(10)+
				 --'  TypeTo field ''Contact Person'' ,  ''' + replace(RTRIM(UPPER(c.PrimerNombre)),'Ñ',CHAR(165)) +' '+ replace(RTRIM(UPPER(c.PrimerApellido)),'Ñ',CHAR(165)) + '''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Address 1'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Address 1'' , '''+UPPER(RTRIM(COALESCE(C.Billing_Name,'')))+'''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Address 2'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Address 2'' , '''+UPPER(SUBSTRING(d.Direccion,0,CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/2))))+'''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Address 3'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Address 3'' , '''+RTRIM(UPPER(SUBSTRING((SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion))),(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1,LEN(d.Direccion))))+'''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field City ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field City , '''+UPPER(RTRIM(d.Municipio))+''''  + CHAR(13) + CHAR(10)+
				 '  MoveTo field State  ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field State  , '''+UPPER(RTRIM(d.Departamento))+''''  + CHAR(13) + CHAR(10)+
				 '  MoveTo field Zip ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Country Code'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Country Code'' , '''+UPPER(RTRIM(c.CodPais))+''''  + CHAR(13) + CHAR(10)+
				 '  MoveTo field Country ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Phone 1'' ' + CHAR(13) + CHAR(10)+
				 /*'  TypeTo field ''Phone 1'' , '''+'503'+UPPER(RTRIM(COALESCE(c.Telefono,'')))+'''' + CHAR(13) + CHAR(10)+*/
				 '  TypeTo field ''Phone 1'' , '''+'503'+replace(substring(c.Telefono,5,LEN(c.telefono)), '-','') +'''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Phone 2'' ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field Comment2 ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field Comment2 , '''+UPPER(RTRIM(COALESCE(c.Dui,'')))+'''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Payment Terms ID'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Payment Terms ID'' , ''CONTADO''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field PriceLevel ' + CHAR(13) + CHAR(10)+
				 /*'  TypeTo field PriceLevel , ''PRE2014''' + CHAR(13) + CHAR(10)+*/
				 '  TypeTo field PriceLevel , ''PLINEA''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Accounts Button'' ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Salesperson ID'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Salesperson ID'' , ''SVRMORE''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Sales Territory'' ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''User Defined 2'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''User Defined 2'' ,'''+ case when c.TipoDoc ='CCF' THEN UPPER(RTRIM(replace(c.TarjetaIva,'-','')))
														   ELSE UPPER(RTRIM(replace(c.nit,'-',''))) END +'''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Options Button'' ' + CHAR(13) + CHAR(10)+
				 '  ClickHit field ''Options Button'' ' + CHAR(13) + CHAR(10)+
				 'NewActiveWin dictionary ''Project Accounting''  form ''RM_Customer_Maintenance'' window ''RM_Customer_Options'' ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Tax Registration Number'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Tax Registration Number'' , '''+UPPER(RTRIM(COALESCE(c.ncr,'')))+''''+ CHAR(13) + CHAR(10)+
				 '  MoveTo field ''(L) Email Statements To Address'' ' + CHAR(13) + CHAR(10)+
				 '  SelectChars field ''(L) Email Statements To Address'' ssel 0 esel 0 ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''(L) Email Statements To Address'' , ''A''' + CHAR(13) + CHAR(10)+
				 '  TNT_Event , ''09002B016B0100000000060000E8BE7720F0'' # cntrl chr' + CHAR(13) + CHAR(10)+
				 '  TNT_Event , ''09002B016B01000000001F0000E8BE7720F0'' # cntrl chr' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''(L) Email Statements To Address'' , '''+RTRIM(COALESCE(c.CORREO,''))+''''+ CHAR(13) + CHAR(10)+
				 '  TNT_Event , ''09002B016B0100000000040000E8BE7720F0'' # cntrl chr' + CHAR(13) + CHAR(10)+
				 '  CommandExec dictionary ''Project Accounting''  form ''RM_Customer_Maintenance'' command ''OK Button_w_RM_Customer_Options_f_RM_Customer_Maintenance'' ' + CHAR(13) + CHAR(10)+
				 'NewActiveWin dictionary ''Project Accounting''  form ''RM_Customer_Maintenance'' window ''RM_Customer_Maintenance'' ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''UPS Zone'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo  field ''UPS Zone'' , '''+RTRIM(COALESCE(c.tipodoc,''))+''''+ CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Shipping Method'' '+ CHAR(13) + CHAR(10)+
				 '  MoveTo field ''(L) Address Profile Button'' '+ CHAR(13) + CHAR(10)+
				 '  ClickHit field ''(L) Address Profile Button'' '+ CHAR(13) + CHAR(10)+
				 'NewActiveWin dictionary ''default''  form ''RM_Customer_Address'' window ''RM_Customer_Address'' '+ CHAR(13) + CHAR(10)+
				 'ActivateWindow dictionary ''default''  form ''RM_Customer_Address'' window ''RM_Customer_Address'' '+ CHAR(13) + CHAR(10)+
				 'ActivateWindow dictionary ''default''  form ''RM_Customer_Address'' window ''RM_Customer_Address'' '+ CHAR(13) + CHAR(10)+
				 'ActivateWindow dictionary ''default''  form ''RM_Customer_Address'' window ''RM_Customer_Address'' '+ CHAR(13) + CHAR(10)+
				 'ActivateWindow dictionary ''default''  form ''RM_Customer_Address'' window ''RM_Customer_Address'' '+ CHAR(13) + CHAR(10)+
				 'ActivateWindow dictionary ''default''  form ''RM_Customer_Address'' window ''RM_Customer_Address'' '+ CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Location Code'' '+ CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Location Code'' , ''CENTRAL'''+ CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Salesperson ID'' '+ CHAR(13) + CHAR(10)+
				 '  CommandExec dictionary ''default''  form ''RM_Customer_Address'' command ''Save Button_w_RM_Customer_Address_f_RM_Customer_Address'' '+ CHAR(13) + CHAR(10)+
				 'CloseWindow dictionary ''default''  form ''RM_Customer_Address'' window ''RM_Customer_Address'' '+ CHAR(13) + CHAR(10)+
				 'NewActiveWin dictionary ''Project Accounting''  form ''RM_Customer_Maintenance'' window ''RM_Customer_Maintenance'' '+ CHAR(13) + CHAR(10) 		-- +
				 /*Aqui comienza direccion de despacho
				 '  MoveTo field ''Primary Shipto Address Code'' '+ CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Primary Shipto Address Code'' , ''DESPACHO'''+ CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Primary Billto Address Code'' '+ CHAR(13) + CHAR(10)+	 
				 '# ¿Desea agregar este Id. de dirección?'+ CHAR(13) + CHAR(10)+
				 'NewActiveWin dictionary ''Project Accounting''  form DiaLog window DiaLog '+ CHAR(13) + CHAR(10)+
				 '  ClickHit field OK '+ CHAR(13) + CHAR(10)+
				 'NewActiveWin dictionary ''Project Accounting''  form ''RM_Customer_Maintenance'' window ''RM_Customer_Maintenance'' '+ CHAR(13) + CHAR(10)+
				 'NewActiveWin dictionary ''default''  form ''RM_Customer_Address'' window ''RM_Customer_Address'' '+ CHAR(13) + CHAR(10)+				 
				 --'  MoveTo field ''Contact Person'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Contact Person'' ,  ''' + RTRIM(UPPER(c.PrimerNombre)) +' '+ RTRIM(UPPER(c.PrimerApellido)) + '''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Address 1'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Address 1'' , '''+UPPER(SUBSTRING(d.Direccion,0,CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3))))+'''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Address 2'' ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Address 1'' ' + CHAR(13) + CHAR(10)+
				 '  CommandExec form BuiLtin command cmdEditCut ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Address 1'' , ''''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Address 2'' ' + CHAR(13) + CHAR(10)+
				 '  CommandExec form BuiLtin command cmdEditPaste ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Address 2'' , '''''+UPPER(SUBSTRING( SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),0,CHARINDEX(' ', SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),(LEN(d.Direccion)/3))))+'''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Address 3'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Address 3'' , '''+UPPER(SUBSTRING((SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion))),(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1,LEN(d.Direccion)))+'''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field City ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field City , '''+UPPER(RTRIM(d.Municipio))+''''  + CHAR(13) + CHAR(10)+
				 '  MoveTo field State  ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field State  , '''+UPPER(RTRIM(d.Departamento))+''''  + CHAR(13) + CHAR(10)+
				 '  MoveTo field Zip ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Country Code'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Country Code'' , '''+UPPER(RTRIM(c.CodPais))+''''  + CHAR(13) + CHAR(10)+
				 '  MoveTo field Country ' + CHAR(13) + CHAR(10)+				 
				 '  MoveTo field ''UPS Zone'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''UPS Zone'' , '''+RTRIM(COALESCE(c.tipodoc,''))+''''+ CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Shipping Method'' '+ CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Shipping Method'' , ''CLIENTE'''+ CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Tax Schedule ID'' '+ CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Tax Schedule ID'' , ''IVA 13%'''+ CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Location Code'' '+ CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Location Code'' , ''CENTRAL'''+ CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Salesperson ID'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Salesperson ID'' , ''SVRMORE''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Sales Territory'' ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''User Defined 2'' ' + CHAR(13) + CHAR(10)+
				 '  CommandExec dictionary ''default''  form ''RM_Customer_Address'' command ''Save Button_w_RM_Customer_Address_f_RM_Customer_Address'' ' + CHAR(13) + CHAR(10)+
				 'CloseWindow dictionary ''default''  form ''RM_Customer_Address'' window ''RM_Customer_Address'' ' + CHAR(13) + CHAR(10)+
				 'NewActiveWin dictionary ''Project Accounting''  form ''RM_Customer_Maintenance'' window ''RM_Customer_Maintenance'' ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Statement Address Code'' ' + CHAR(13) + CHAR(10)+
				 '  CommandExec dictionary ''Project Accounting''  form ''RM_Customer_Maintenance'' command ''Save Button_w_RM_Customer_Maintenance_f_RM_Customer_Maintenance'' ' + CHAR(13) + CHAR(10)
				 */
		FROM SAGRI_MOVIL.dbo.WS_Cliente c  
		inner join SAGRI_MOVIL.dbo.WS_DireccCliente d    
		  on c.IdClieCafeina = d.IdClieCafeina
		 and d.Principal = 1
		 and c.IdClieCafeina =@idClieCaf
	   --ORDER BY Deta.LineaMacro 
	   ;

	   /*Cuando tiene mas de una direccion, agregar la primera secundaria*/
	    SET LANGUAGE spanish   
   SELECT top(1) @Macro = @Macro +
				 '  MoveTo field ''Primary Shipto Address Code'' '+ CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Primary Shipto Address Code'' , ''DESPACHO'''+ CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Primary Billto Address Code'' '+ CHAR(13) + CHAR(10)+	 
				 '# ¿Desea agregar este Id. de dirección?'+ CHAR(13) + CHAR(10)+
				 'NewActiveWin dictionary ''Project Accounting''  form DiaLog window DiaLog '+ CHAR(13) + CHAR(10)+
				 '  ClickHit field OK '+ CHAR(13) + CHAR(10)+
				 'NewActiveWin dictionary ''Project Accounting''  form ''RM_Customer_Maintenance'' window ''RM_Customer_Maintenance'' '+ CHAR(13) + CHAR(10)+
				 'NewActiveWin dictionary ''default''  form ''RM_Customer_Address'' window ''RM_Customer_Address'' '+ CHAR(13) + CHAR(10)+				 
				 --'  MoveTo field ''Contact Person'' ' + CHAR(13) + CHAR(10)+
				 /*'  TypeTo field ''Contact Person'' ,  ''' + RTRIM(UPPER(c.PrimerNombre)) +' '+ RTRIM(UPPER(c.PrimerApellido)) + '''' + CHAR(13) + CHAR(10)+*/
				 '  TypeTo field ''Contact Person'' ,  ''' + replace(RTRIM(UPPER(c.PrimerNombre)),'Ñ',CHAR(165)) +' '+ replace(RTRIM(UPPER(c.PrimerApellido)),'Ñ',CHAR(165)) + '''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Address 1'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Address 1'' , '''+UPPER(SUBSTRING(d.Direccion,0,CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3))))+'''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Address 2'' ' + CHAR(13) + CHAR(10)+
				 /*
				 '  MoveTo field ''Address 1'' ' + CHAR(13) + CHAR(10)+
				 '  CommandExec form BuiLtin command cmdEditCut ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Address 1'' , ''''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Address 2'' ' + CHAR(13) + CHAR(10)+
				 '  CommandExec form BuiLtin command cmdEditPaste ' + CHAR(13) + CHAR(10)+*/
				 '  TypeTo field ''Address 2'' , '''+UPPER(SUBSTRING( SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),0,CHARINDEX(' ', SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),(LEN(d.Direccion)/3))))+'''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Address 3'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Address 3'' , '''+RTRIM(UPPER(SUBSTRING((SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion))),(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1,LEN(d.Direccion))))+'''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field City ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field City , '''+UPPER(RTRIM(d.Municipio))+''''  + CHAR(13) + CHAR(10)+
				 '  MoveTo field State  ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field State  , '''+UPPER(RTRIM(d.Departamento))+''''  + CHAR(13) + CHAR(10)+
				 '  MoveTo field Zip ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Country Code'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Country Code'' , '''+UPPER(RTRIM(c.CodPais))+''''  + CHAR(13) + CHAR(10)+
				 '  MoveTo field Country ' + CHAR(13) + CHAR(10)+				 
				 '  MoveTo field ''UPS Zone'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''UPS Zone'' , '''+RTRIM(COALESCE(c.tipodoc,''))+''''+ CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Shipping Method'' '+ CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Shipping Method'' , ''CLIENTE'''+ CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Tax Schedule ID'' '+ CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Tax Schedule ID'' , ''IVA 13%'''+ CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Location Code'' '+ CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Location Code'' , ''CENTRAL'''+ CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Salesperson ID'' ' + CHAR(13) + CHAR(10)+
				 '  TypeTo field ''Salesperson ID'' , ''SVRMORE''' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Sales Territory'' ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''User Defined 1'' ' + CHAR(13) + CHAR(10)+
				 '  CommandExec dictionary ''default''  form ''RM_Customer_Address'' command ''Save Button_w_RM_Customer_Address_f_RM_Customer_Address'' ' + CHAR(13) + CHAR(10)+
				 'CloseWindow dictionary ''default''  form ''RM_Customer_Address'' window ''RM_Customer_Address'' ' + CHAR(13) + CHAR(10)+
				 'NewActiveWin dictionary ''Project Accounting''  form ''RM_Customer_Maintenance'' window ''RM_Customer_Maintenance'' ' + CHAR(13) + CHAR(10)+
				 '  MoveTo field ''Statement Address Code'' ' + CHAR(13) + CHAR(10)+
				 '  CommandExec dictionary ''Project Accounting''  form ''RM_Customer_Maintenance'' command ''Save Button_w_RM_Customer_Maintenance_f_RM_Customer_Maintenance'' ' + CHAR(13) + CHAR(10)

	FROM SAGRI_MOVIL.dbo.WS_Cliente c  
    inner join SAGRI_MOVIL.dbo.WS_DireccCliente d    
      on c.IdClieCafeina = d.IdClieCafeina
	 and d.Principal <> 1
	 and c.IdClieCafeina = @idClieCaf
	 and deleted = 0
   ORDER BY d.IdDireccionCaf
   ;


   end

  select RTRIM(@CodCli) as codcli, RTRIM(@NombreCliente) AS NombreCliente, RTRIM(@TipoDoc) AS TipoDoc, @Macro AS MACRO;
/*
BEGIN TRY
BEGIN TRANSACTION
BEGIN
DECLARE @Macro varchar(max);
DECLARE @cnt INT = 0;
DECLARE @total_dir INT = 0;
/*Contar cuantas direcciones tiene el cliente */
select @total_dir = COUNT(*)
  from SAGRI_MOVIL.dbo.WS_DireccCliente d
 where d.IdClieCafeina = '23';

WHILE @cnt < @total_dir
BEGIN
   --{...statements...}
   SET @cnt = @cnt + 1;
END;


SELECT @Macro = /*'' C, FORMAT(Enca.FechaCont, 'dd/MM/yyyy') FechaCont,
	    RTRIM(Enca.TextoCabecera) TextoCabecera, RTRIM(Enca.Cuenta) Cuenta, RTRIM(Cta.NombreCuenta) NombreCuenta, 
		RTRIM(Deta.Departamento) Departamento, RTRIM(Deta.Linea) Linea, RTRIM(Deta.CodProveedor) CodProveedor, 
		Deta.CodVendedor, Deta.Equipo, Deta.Zona, RTRIM(Enca.Concepto) Concepto, Deta.Cargo, Deta.Abono,*/
		 '# DEXVERSION=16.00.0033.000 2 2 ' + CHAR(13) + CHAR(10)+
		 'CheckActiveWin dictionary ''Project Accounting''  form ''RM_Customer_Maintenance'' window ''RM_Customer_Maintenance''  ' + CHAR(13) + CHAR(10)+
		 '  TypeTo field ''Customer Number'' , ''SVC'''+ ''''+CAST((SELECT MAX(v_.CORRELATIVO) + 1
															FROM(SELECT cast(SUBSTRING(CUSTNMBR,4,LEN(CUSTNMBR)) as int) CORRELATIVO, CUSTNMBR
															       FROM GPSAG.dbo.RM00101) v_) AS varchar) + ''''+ CHAR(13)  + CHAR(10)+
		 '  MoveTo field Hold  # ''FALSE''' + CHAR(13) + CHAR(10)+
		 '  MoveTo field ''Customer Name'' ' + CHAR(13) + CHAR(10)+
		 '  TypeTo field ''Customer Name'' , ''ERICK ALEXANDER MUÑOZ RIVAS'' ' + CHAR(13)  + CHAR(10)
	FROM SAGRI_MOVIL.dbo.WS_Cliente c
   inner join SAGRI_MOVIL.dbo.WS_DireccCliente d    
      on c.IdClieCafeina = d.IdClieCafeina
	 and d.Principal = 1
   where c.IdClieCafeina = @idClieCaf
   --ORDER BY Deta.LineaMacro 
   ;

   select @Macro;
/*
/*Agregado mpinto 23/06/2020
  Actualizacion Direccion de Cliente en tabla Cliente*/
UPDATE C
   SET  C.CUSTNAME = UPPER(RTRIM(CL.PrimerNombre)) + ' ' + UPPER(RTRIM(CL.PrimerApellido)),
       C.CNTCPRSN = UPPER(RTRIM(CL.PrimerNombre)) + ' ' + UPPER(RTRIM(CL.PrimerApellido)),
	   C.SHRTNAME= UPPER(RTRIM(CL.PrimerNombre)) + ' ' + UPPER(RTRIM(CL.PrimerApellido)),
	   C.ADDRESS1 = UPPER(SUBSTRING(d.Direccion,0,CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))),
	   C.ADDRESS2 = UPPER(SUBSTRING( SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),0,CHARINDEX(' ', SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),(LEN(d.Direccion)/3)))) ,
	   C.ADDRESS3 = UPPER(SUBSTRING((SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion))),(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1,LEN(d.Direccion))),
       C.COUNTRY = CASE WHEN D.PAIS = 'SV' THEN 'EL SALVADOR' END,
	   C.CITY = UPPER(D.Municipio),
	   C.PHONE1 = '503'+rtrim(CL.Telefono),
	   C.COMMENT2 = CL.Dui,
	   C.USERDEF2 = CL.Nit
  from gpsag.dbo.rm00101 c
 inner join SAGRI_MOVIL.dbo.PedidoEncabezado e
    on c.CUSTNMBR = e.CodCliente
 inner join SAGRI_MOVIL.dbo.WS_DireccCliente d
    on e.IdDireccion = d.IdDireccionCaf
   and e.idClieCaf = d.IdClieCafeina
 inner join SAGRI_MOVIL.dbo.WS_Cliente cl
    on e.idClieCaf = cl.IdClieCafeina
   and e.idClieCaf = d.IdClieCafeina
 where e.CodCliente = @Codcliente
   and e.idClieCaf = @idClieCaf
   and e.NumPedido = @NumPedido
   and e.IdDireccion = @idDireccion
;
*/

/*Agregado mpinto 23/06/2020
  Actualizacion Direccion de Cliente en tabla Direccion cliente cuando el id sea PRINCIPAL*/

UPDATE C
   SET C.CNTCPRSN = UPPER(RTRIM(CL.PrimerNombre)) + ' ' + UPPER(RTRIM(CL.PrimerApellido)),
       C.ADDRESS1 = UPPER(SUBSTRING(d.Direccion,0,CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))),
	   C.ADDRESS2 = UPPER(SUBSTRING( SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),0,CHARINDEX(' ', SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),(LEN(d.Direccion)/3)))) ,
	   C.ADDRESS3 = UPPER(SUBSTRING((SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion))),(CHARINDEX(' ',(SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion))),(LEN(d.Direccion)/3)))+1,LEN(d.Direccion))),
       C.COUNTRY = CASE WHEN D.PAIS = 'SV' THEN 'EL SALVADOR' END,
	   C.CITY = UPPER(D.Municipio),
	   C.STATE = UPPER(D.DEPARTAMENTO),
	   C.PHONE1 = '503'+RTRIM(CL.Telefono)
  from gpsag.dbo.rm00102 c
 inner join SAGRI_MOVIL.dbo.PedidoEncabezado e
    on c.CUSTNMBR = e.CodCliente
 inner join SAGRI_MOVIL.dbo.WS_DireccCliente d
    on e.IdDireccion = d.IdDireccionCaf
   and e.idClieCaf = d.IdClieCafeina
 inner join SAGRI_MOVIL.dbo.WS_Cliente cl
   on e.idClieCaf = cl.IdClieCafeina
  and e.idClieCaf = d.IdClieCafeina
where e.CodCliente = @Codcliente
  and e.idClieCaf = @idClieCaf
  and e.NumPedido = @NumPedido
  and e.IdDireccion = @idDireccion
  and c.ADRSCODE ='PRINCIPAL'
;

/*Actualizar Despacho*/
UPDATE C
   SET --C.ADDRESS2 = UPPER(d.Direccion),
       C.CNTCPRSN = UPPER(RTRIM(CL.PrimerNombre)) + ' ' + UPPER(RTRIM(CL.PrimerApellido)),
       C.ADDRESS1 = UPPER(SUBSTRING(d.Direccion,0,CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))),
	   C.ADDRESS2 = UPPER(SUBSTRING( SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),0,CHARINDEX(' ', SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),(LEN(d.Direccion)/3)))) ,
	   C.ADDRESS3 = UPPER(SUBSTRING((SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion))),(CHARINDEX(' ',(SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion))),(LEN(d.Direccion)/3)))+1,LEN(d.Direccion))),
       C.COUNTRY = CASE WHEN D.PAIS = 'SV' THEN 'EL SALVADOR' END,
	   C.CITY = UPPER(D.Municipio),
	   C.STATE = UPPER(D.DEPARTAMENTO),
	   C.PHONE1 = '503'+RTRIM(CL.Telefono)
  from gpsag.dbo.rm00102 c
 inner join SAGRI_MOVIL.dbo.PedidoEncabezado e
    on c.CUSTNMBR = e.CodCliente
 inner join SAGRI_MOVIL.dbo.WS_DireccCliente d
    on e.IdDireccion = d.IdDireccionCaf
   and e.idClieCaf = d.IdClieCafeina
 inner join SAGRI_MOVIL.dbo.WS_Cliente cl
    on e.idClieCaf = cl.IdClieCafeina
   and e.idClieCaf = d.IdClieCafeina
 where e.CodCliente = @Codcliente
   and e.idClieCaf = @idClieCaf
   and e.NumPedido = @NumPedido
   and e.IdDireccion = @idDireccion
   and c.ADRSCODE ='DESPACHO'
;

*/
END		   		      
commit transaction;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS ErrorMessage;

ROLLBACK TRANSACTION;
END CATCH
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_DefaultSVC0809]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 23/06/2020
  Procedimiento para actualizar direcciones tanto en la tabla de clientes como en la tabla de direcciones 
  */
CREATE procedure [SAG].[WS_DefaultSVC0809] 
AS

BEGIN TRY
BEGIN TRANSACTION


/*Agregado mpinto 23/06/2020
  Actualizacion Direccion de Cliente en tabla Cliente*/
UPDATE C
   SET C.ADDRESS2 = '',
       C.COUNTRY = 'EL SALVADOR',
	   C.CITY = 'SAN SALVADOR',
	   C.STATE = 'SAN SALVADOR'
from gpsag.dbo.rm00101 c
where C.CUSTNMBR = 'SVC0809'

;


/*Agregado mpinto 23/06/2020
  Actualizacion Direccion de Cliente en tabla Direccion cliente cuando el id sea PRINCIPAL*/

UPDATE C
  SET C.ADDRESS2 = '',
       C.COUNTRY = 'EL SALVADOR',
	   C.CITY = 'SAN SALVADOR',
	   C.STATE = 'SAN SALVADOR'
from gpsag.dbo.rm00102 c
where C.CUSTNMBR = 'SVC0809'
and c.ADRSCODE ='PRINCIPAL'
;


		      
commit transaction;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS ErrorMessage;

ROLLBACK TRANSACTION;
END CATCH
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_deleteSAGRIMOVIL]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
Creado mpinto 15/05/2020
Procedimiento que servira para eliminar datos de las distintas tablas de la bd SAGRI_MOVIL
a traves de un envio de parametro del id cuando sea eliminacion de un registro o de todos los registros
*/
CREATE PROCEDURE [SAG].[WS_deleteSAGRIMOVIL]    
 @ID nvarchar(25) = null, 
 @Tabla nvarchar(25),
 @Par1 nvarchar(25) = null,
 @Par2 nvarchar(25) = null
AS    
BEGIN    
    
 SET NOCOUNT ON;
 IF @Tabla = 'WS_ListaPrecio' AND @ID IS NOT NULL
	 BEGIN
		DELETE FROM [dbo].[WS_ListaPrecio]
		 WHERE CodLstPrec = @ID;
	 END
	 
 IF @Tabla = 'WS_ListaPrecio' AND @ID IS NULL
	 BEGIN
		DELETE FROM [dbo].[WS_ListaPrecio];			
	 END


 IF @Tabla = 'WS_ClienteListPrecio' AND @ID IS NOT NULL
    AND @Par1 IS NOT NULL AND @Par2 IS NOT NULL 
	 BEGIN
		DELETE FROM [dbo].[WS_ClienteListPrecio]
		 WHERE CodLstPrec = @ID
		   AND CodCliente = @Par1
		   AND CodProd = @Par2;
	 END
	 
 IF @Tabla = 'WS_ClienteListPrecio' AND @ID IS NULL
	AND @Par1 IS NULL AND @Par2 IS NULL  
	 BEGIN
		DELETE FROM [dbo].[WS_ClienteListPrecio];			
	 END
	 

END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_DireccionClienteCCF]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 24/04/2020
  Procedimiento obtener la informacion del cliente para mostrar en pantalla a usuarios de credito y cobros con el fin
  de darle el proceso correspondiente para dar de alta como cliente en sistema GP
  */
CREATE procedure [SAG].[WS_DireccionClienteCCF] 
(
	@IdClieCaf char(10),
	@IdDireccCaf char(10),
	@Nombre char(50),
	@Direccion char(183),
	@Depto char(25),
	@Municipio char(25)	
)as 
BEGIN  

UPDATE C
   SET --C.Nombre = @Nombre,
       C.Direccion = @Direccion,
	   C.DireccionTotal = @Direccion, /*Replicar en campo direccion con mas espacio para caracteres*/
	   c.Municipio = @Municipio,	   
	   c.Departamento = @Depto
  FROM SAGRI_MOVIL.DBO.WS_DireccCliente c
WHERE c.IdClieCafeina = @IdClieCaf
  and c. IdDireccionCaf = @IdDireccCaf
  --and c.CodPais = @CodPais
   ;

END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_DireccionUsuariosCCF]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 24/04/2020
  Procedimiento obtener la informacion del cliente para mostrar en pantalla a usuarios de credito y cobros con el fin
  de darle el proceso correspondiente para dar de alta como cliente en sistema GP
  */
CREATE procedure [SAG].[WS_DireccionUsuariosCCF] 
(
	@IdCliente char(15)
	
)as 
BEGIN  

SELECT --RTRIM([IdClieCafeina]) [IdClieCafeina],
	  RTRIM([IdDireccionCaf]) [IdDireccionCaf]
      ,COALESCE(RTRIM(UPPER([Nombre])),'N/A') [Nombre]
      ,case when RTRIM(UPPER([Principal])) = 1 then 'PRINCIPAL' 
	        ELSE 'ENVIO'+IdDireccionCaf
			END AS [Principal]
      ,COALESCE(RTRIM(UPPER([Direccion])),'N/A') [Direccion]    
      ,COALESCE(RTRIM(UPPER([Departamento])),'N/A') [Departamento]
      ,COALESCE(RTRIM(UPPER([Municipio])),'N/A') [Municipio]      
  FROM [dbo].[WS_DireccCliente] D
 WHERE D.IdClieCafeina = @IdCliente
   ORDER BY IdClieCafeina, IdDireccion
   ;

END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_EliminarListaPrecioCliente]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 06/05/2020
  Procedimiento creado para registrar un nuevo pedido a traves de un json enviado desde el Web Service
  y como se desglosa en el procedimiento, se ocupa la funcion OPENJSON para extraer la información
  */
CREATE procedure [SAG].[WS_EliminarListaPrecioCliente] 
(
	--@CodlPC nchar(10),
	@CodLP nchar(10), /*Codigo del precio de lista*/
	@CodProd nchar(25),  
	@CodCliente nchar(15)
	
)as 
BEGIN TRY
BEGIN TRANSACTION

BEGIN  

declare @contador int = 0;
declare @Operacion char(15)='';

select @contador = count(*) 
  from [dbo].[WS_ClienteListPrecio] 
 where CodLstPrec = @CodLP
   and CodCliente = @CodCliente
   and CodProd =@CodProd
   ;

	
		 DELETE 
		   FROM [SAGRI_MOVIL].dbo.[WS_ClienteListPrecio]
          WHERE CodLstPrec = @CodLP
		    AND CodCliente = @CodCliente
			AND CodProd    = @CodProd
			;			  

Select '1' Result, rtrim(@Operacion) operacion;
END
COMMIT TRANSACTION;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS Result;

ROLLBACK TRANSACTION;
END CATCH
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_EliminarListaPrecioCliente_Agricola]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 06/05/2020
  Procedimiento creado para registrar un nuevo pedido a traves de un json enviado desde el Web Service
  y como se desglosa en el procedimiento, se ocupa la funcion OPENJSON para extraer la información
  */
CREATE procedure [SAG].[WS_EliminarListaPrecioCliente_Agricola] 
(
	--@CodlPC nchar(10),
	--@CodLP nchar(10), /*Codigo del precio de lista*/
	@CodProd nchar(25),  
	@CodCliente nchar(15)
	
)as 
BEGIN TRY
BEGIN TRANSACTION

BEGIN  

declare @contador int = 0;
declare @Operacion char(15)='';

select @contador = count(*) 
  from [dbo].[WS_ClienteListPrecio_AGRI] 
 where CodCliente = @CodCliente
   and CodProd =@CodProd
   ;

	
		 DELETE 
		   FROM [SAGRI_MOVIL].dbo.[WS_ClienteListPrecio_AGRI]
          WHERE CodCliente = @CodCliente
			AND CodProd    = @CodProd
			;			  

Select '1' Result, rtrim(@Operacion) operacion;
END
COMMIT TRANSACTION;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS Result;

ROLLBACK TRANSACTION;
END CATCH
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_GenerarMacroPedido]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*Creado mpinto 17/01/2023
Procedimiento creado para obtener todas los documentos a emitir en linea (FACTURAS, NOTAS DE CREDITO, NOTAS DE DEBITO, ETC..)*/

CREATE     PROCEDURE [SAG].[WS_GenerarMacroPedido] 
(	@Pedido varchar(15),	
	@CodPais varchar(2),
	@bd varchar(25) = null
)as 
BEGIN  



DECLARE @Macro varchar(max) ='';	


select @Macro
END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_GetAllListaPreciosClientes]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE PROCEDURE [SAG].[WS_GetAllListaPreciosClientes]    
 @CodPais nvarchar(2)--, @CodPais nvarchar(2)
AS    
BEGIN    
    
	IF @CodPais ='SV' 
	BEGIN
		SELECT RTRIM(cl.CodCliente) +' - '+ rtrim(rm.CUSTNAME) CUSTNAME,
			   rtrim(iv.ITEMDESC) ITEMDESC, RTRIM(cl.CodCliente) CodCliente,
			   RTRIM(cl.CodProd) CodProd, RTRIM(cl.CodLstPrec) CodLstPrec, 
		       RTRIM(LP.NombreLstPre) NombreLstPre, COALESCE(RTRIM(Cl.DescListPre),'-') DescListPre /*Agregado mpinto -- DescListPre: descripcion de cada oferta*/
		       , cl.PrecioBase, cl.Cantidad, cl.PrecioUOferta
		  FROM SAGRI_MOVIL.DBO.WS_ClienteListPrecio Cl
		 INNER JOIN SAGRI_MOVIL.DBO.WS_ListaPrecio LP
		    ON CL.CodLstPrec = LP.CodLstPrec
		 INNER JOIN GPsag.dbo.RM00101 RM
		   ON CL.CodCliente = RM.CUSTNMBR
		INNER JOIN GPSAG.DBO.IV00101 IV
		   ON CL.CodProd = IV.ITEMNMBR
	    ORDER BY CL.CodCliente, cl.CodProd, cl.CodLstPrec--, LP.NombreLstPr
		--WHERE CL.IdIncrement = @CodListPrecCli
	END
	ELSE IF @CodPais ='GT' 
	BEGIN
		SELECT RTRIM(cl.CodCliente) +' - '+ rtrim(rm.CUSTNAME) CUSTNAME,
			   rtrim(iv.ITEMDESC) ITEMDESC, RTRIM(cl.CodCliente) CodCliente,
			   RTRIM(cl.CodProd) CodProd, RTRIM(cl.CodLstPrec) CodLstPrec, 
		       RTRIM(LP.NombreLstPre) NombreLstPre, COALESCE(RTRIM(Cl.DescListPre),'-') DescListPre /*Agregado mpinto -- DescListPre: descripcion de cada oferta*/
		       , cl.PrecioBase, cl.Cantidad, cl.PrecioUOferta
			   /* RTRIM(cl.CodLstPrec) CodLstPrec, RTRIM(LP.NombreLstPre) NombreLstPre, 
				   RTRIM(cl.CodCliente) CodCliente, rtrim(rm.CUSTNAME) CUSTNAME,
				   RTRIM(cl.CodProd) CodProd, rtrim(iv.ITEMDESC) ITEMDESC, cl.PrecioBase, cl.Cantidad, cl.PrecioUOferta*/
			  FROM SAGRI_MOVIL.DBO.WS_ClienteListPrecio Cl
			 INNER JOIN SAGRI_MOVIL.DBO.WS_ListaPrecio LP
				ON CL.CodLstPrec = LP.CodLstPrec
			 INNER JOIN NUTGT.dbo.RM00101 RM
				ON CL.CodCliente = RM.CUSTNMBR
			 INNER JOIN NUTGT.DBO.IV00101 IV
				ON CL.CodProd = IV.ITEMNMBR
			 ORDER BY CL.CodCliente, cl.CodProd, cl.CodLstPrec
			 --WHERE CL.IdIncrement = @CodListPrecCli
	END			
			

 
END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_GetAllListaPreciosClientes_Agricola]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE PROCEDURE [SAG].[WS_GetAllListaPreciosClientes_Agricola]    
 @CodPais nvarchar(2)--, @CodPais nvarchar(2)
AS    
BEGIN    
    
	IF @CodPais ='SV' 
	BEGIN
		--SELECT CONVERT(nvarchar, RTRIM(cl.CodCliente) +' - '+ rtrim(rm.CUSTNAME)) NOMCLI,
		--SELECT RTRIM(cl.CodCliente) +' - '+ CONVERT(char, rtrim(rm.CUSTNAME)) NOMCLI,
		SELECT --RTRIM(cl.CodCliente) CodCliente , 
		cast(rtrim(rm.CUSTNAME) as char) CUSTNAME,
			   rtrim(iv.ITEMDESC) ITEMDESC, RTRIM(cl.CodCliente) CodCliente,
			   RTRIM(cl.CodProd) CodProd
		       , cl.Precio, RTRIM(Descripcion) Descripcion 
		  FROM SAGRI_MOVIL.DBO.WS_ClienteListPrecio_AGRI Cl		
		 INNER JOIN GPsag.dbo.RM00101 RM
		   ON CL.CodCliente = RM.CUSTNMBR
		INNER JOIN GPSAG.DBO.IV00101 IV
		   ON CL.CodProd = IV.ITEMNMBR
	    ORDER BY CL.CodCliente, cl.CodProd
	END
	ELSE IF @CodPais ='GT' 
	BEGIN
		--SELECT cast(RTRIM(cl.CodCliente) +' - '+ rtrim(rm.CUSTNAME) as char) NOMCLI,
		--SELECT RTRIM(cl.CodCliente) +' - '+ CONVERT(char, rtrim(rm.CUSTNAME)) NOMCLI,
		SELECT --RTRIM(cl.CodCliente) CodCliente , 
		cast(rtrim(rm.CUSTNAME) as char) CUSTNAME,
			   rtrim(iv.ITEMDESC) ITEMDESC, RTRIM(cl.CodCliente) CodCliente,
			   RTRIM(cl.CodProd) CodProd
		       , cl.Precio, RTRIM(Descripcion) Descripcion
			  FROM SAGRI_MOVIL.DBO.WS_ClienteListPrecio_AGRI Cl			
			 INNER JOIN NUTGT.dbo.RM00101 RM
				ON CL.CodCliente = RM.CUSTNMBR
			 INNER JOIN NUTGT.DBO.IV00101 IV
				ON CL.CodProd = IV.ITEMNMBR
			 ORDER BY CL.CodCliente, cl.CodProd
	END		 
END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_GetCliente]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE PROCEDURE [SAG].[WS_GetCliente]    
 @Cliente nvarchar(250),
 @codpais char(2)   
AS    
BEGIN    
    
 SET NOCOUNT ON;    
   
   IF @codpais = 'SV'
   BEGIN
		SELECT * FROM(
 SELECT TOP 15   rtrim(t1.CUSTNMBR) + ' | ' + rtrim(t1.CUSTNAME)  as Nombre    
 FROM GPSAG.DBO.RM00101 as t1  
 WHERE ( t1.CUSTNMBR like '%'+ @Cliente +'%' or t1.CUSTNAME like '%'+ @Cliente +'%' ) 
 group by t1.CUSTNMBR, t1.CUSTNAME
 order by t1.CUSTNMBR )  as  myt
 where Nombre is not null
   END
	ELSE IF @codpais = 'GT'
   BEGIN
	 SELECT * FROM( 
 SELECT TOP 15   rtrim(t1.CUSTNMBR) + ' | ' + rtrim(t1.CUSTNAME)  as Nombre    
 FROM NUTGT.DBO.RM00101 as t1  
 WHERE ( t1.CUSTNMBR like '%'+ @Cliente +'%' or t1.CUSTNAME like '%'+ @Cliente +'%' )
 group by t1.CUSTNMBR, t1.CUSTNAME
 order by t1.CUSTNMBR
 ) as  myt
 where Nombre is not null
   END
   ELSE
	SELECT 'NO DATA' Nombre;

   /*
   SELECT * FROM(
 SELECT TOP 15   rtrim(t1.CUSTNMBR) + ' | ' + rtrim(t1.CUSTNAME)  as Nombre    
 FROM GPSAG.DBO.RM00101 as t1  
 WHERE ( t1.CUSTNMBR like '%'+ @Cliente +'%' or t1.CUSTNAME like '%'+ @Cliente +'%' ) 
 group by t1.CUSTNMBR, t1.CUSTNAME
 order by t1.CUSTNMBR 
 union
 SELECT TOP 15   rtrim(t1.CUSTNMBR) + ' | ' + rtrim(t1.CUSTNAME)  as Nombre    
 FROM NUTGT.DBO.RM00101 as t1  
 WHERE ( t1.CUSTNMBR like '%'+ @Cliente +'%' or t1.CUSTNAME like '%'+ @Cliente +'%' )
 group by t1.CUSTNMBR, t1.CUSTNAME
 order by t1.CUSTNMBR
 ) as  myt
 where Nombre is not null

 */
END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_GetDepto]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 24/04/2020
  Procedimiento creado para registrar cliente nuevo a traves de un json enviado desde el Web Service
  y como se desglosa en el procedimiento, se ocupa la funcion OPENJSON para extraer la información
  */
CREATE procedure [SAG].[WS_GetDepto] 
(
	@Departamento varchar(30)    
	
)as 
--BEGIN TRY
--BEGIN TRANSACTION

BEGIN  
--	select @Departamento;

	select RTRIM(d.Depa) Result 
			 from SAGRI_MOVIL.dbo.WS_Departamentos d
			where d.Depa like '%'+ @Departamento +'%'
			--where UPPER(Depa) like '%'+UPPER(@Departamento)+'%'
			;

	

END
/*
COMMIT TRANSACTION;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS Result;

ROLLBACK TRANSACTION;
END CATCH
*/
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_GetListaPrecios]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE PROCEDURE [SAG].[WS_GetListaPrecios]    
 @ListPrec nvarchar(250),
 @codpais char(2)
AS    
BEGIN    
    
 SET NOCOUNT ON;    
   

   SELECT * FROM(
 SELECT TOP 15   rtrim(t1.CodLstPrec) + ' | ' + rtrim(t1.NombreLstPre)  as Nombre    
 FROM SAGRI_MOVIL.dbo.WS_ListaPrecio as t1  
 WHERE ( t1.CodLstPrec like '%'+ @ListPrec +'%' or t1.NombreLstPre like '%'+ @ListPrec +'%' )
 and t1.CodPais = upper(@codpais)
 group by t1.CodLstPrec, t1.NombreLstPre
 order by t1.CodLstPrec   
 ) as  myt
 where Nombre is not null

END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_GetListaPreciosClientes]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE PROCEDURE [SAG].[WS_GetListaPreciosClientes]    
 @CodListPrecCli nvarchar(250)--, @CodPais nvarchar(2)
AS    
BEGIN    
    

		SELECT RTRIM(cl.CodLstPrec) CodLstPrec, RTRIM(LP.NombreLstPre) NombreLstPre, 
			       RTRIM(cl.CodCliente) CodCliente, rtrim(rm.CUSTNAME) CUSTNAME,
			       RTRIM(cl.CodProd) CodProd, rtrim(iv.ITEMDESC) ITEMDESC, cl.PrecioBase, cl.Cantidad, cl.PrecioUOferta
			  FROM SAGRI_MOVIL.DBO.WS_ClienteListPrecio Cl
			 INNER JOIN SAGRI_MOVIL.DBO.WS_ListaPrecio LP
				ON CL.CodLstPrec = LP.CodLstPrec
			 INNER JOIN GPsag.dbo.RM00101 RM
				ON CL.CodCliente = RM.CUSTNMBR
			 INNER JOIN GPSAG.DBO.IV00101 IV
				ON CL.CodProd = IV.ITEMNMBR
			 WHERE CL.IdIncrement = @CodListPrecCli
	UNION
			SELECT RTRIM(cl.CodLstPrec) CodLstPrec, RTRIM(LP.NombreLstPre) NombreLstPre, 
				   RTRIM(cl.CodCliente) CodCliente, rtrim(rm.CUSTNAME) CUSTNAME,
				   RTRIM(cl.CodProd) CodProd, rtrim(iv.ITEMDESC) ITEMDESC, cl.PrecioBase, cl.Cantidad, cl.PrecioUOferta
			  FROM SAGRI_MOVIL.DBO.WS_ClienteListPrecio Cl
			 INNER JOIN SAGRI_MOVIL.DBO.WS_ListaPrecio LP
				ON CL.CodLstPrec = LP.CodLstPrec
			 INNER JOIN NUTGT.dbo.RM00101 RM
				ON CL.CodCliente = RM.CUSTNMBR
			 INNER JOIN NUTGT.DBO.IV00101 IV
				ON CL.CodProd = IV.ITEMNMBR
			 WHERE CL.IdIncrement = @CodListPrecCli

  /*
	IF @CodPais = 'SV'
		BEGIN
			SELECT RTRIM(cl.CodLstPrec) CodLstPrec, RTRIM(LP.NombreLstPre) NombreLstPre, 
			       RTRIM(cl.CodCliente) CodCliente, rtrim(rm.CUSTNAME) CUSTNAME,
			       RTRIM(cl.CodProd) CodProd, rtrim(iv.ITEMDESC) ITEMDESC, cl.PrecioBase, cl.Cantidad, cl.PrecioUOferta
			  FROM SAGRI_MOVIL.DBO.WS_ClienteListPrecio Cl
			 INNER JOIN SAGRI_MOVIL.DBO.WS_ListaPrecio LP
				ON CL.CodLstPrec = LP.CodLstPrec
			 INNER JOIN GPsag.dbo.RM00101 RM
				ON CL.CodCliente = RM.CUSTNMBR
			 INNER JOIN GPSAG.DBO.IV00101 IV
				ON CL.CodProd = IV.ITEMNMBR
			 WHERE CL.IdIncrement = @CodListPrecCli
		END

		IF @CodPais = 'GT'
		BEGIN
			SELECT RTRIM(cl.CodLstPrec) CodLstPrec, RTRIM(LP.NombreLstPre) NombreLstPre, 
				   RTRIM(cl.CodCliente) CodCliente, rtrim(rm.CUSTNAME) CUSTNAME,
				   RTRIM(cl.CodProd) CodProd, rtrim(iv.ITEMDESC) ITEMDESC, cl.PrecioBase, cl.Cantidad, cl.PrecioUOferta
			  FROM SAGRI_MOVIL.DBO.WS_ClienteListPrecio Cl
			 INNER JOIN SAGRI_MOVIL.DBO.WS_ListaPrecio LP
				ON CL.CodLstPrec = LP.CodLstPrec
			 INNER JOIN NUTGT.dbo.RM00101 RM
				ON CL.CodCliente = RM.CUSTNMBR
			 INNER JOIN NUTGT.DBO.IV00101 IV
				ON CL.CodProd = IV.ITEMNMBR
			 WHERE CL.IdIncrement = @CodListPrecCli
		END

		*/
END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_GetListaPreciosClientesxCli]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE PROCEDURE [SAG].[WS_GetListaPreciosClientesxCli]    
 @CodCliente nvarchar(250)--, @CodPais nvarchar(2)
AS    
BEGIN    
    
 SET NOCOUNT ON;    
 
			SELECT RTRIM(cl.CodLstPrec) CodLstPrec, RTRIM(LP.NombreLstPre) NombreLstPre, 
				   RTRIM(cl.CodCliente) CodCliente, rtrim(rm.CUSTNAME) CUSTNAME,
				   RTRIM(cl.CodProd) CodProd, rtrim(iv.ITEMDESC) ITEMDESC, cl.PrecioBase, cl.Cantidad, cl.PrecioUOferta
			  FROM SAGRI_MOVIL.DBO.WS_ClienteListPrecio Cl
			 INNER JOIN SAGRI_MOVIL.DBO.WS_ListaPrecio LP
				ON CL.CodLstPrec = LP.CodLstPrec
			 INNER JOIN GPsag.dbo.RM00101 RM
				ON CL.CodCliente = RM.CUSTNMBR
			 INNER JOIN GPSAG.DBO.IV00101 IV
				ON CL.CodProd = IV.ITEMNMBR
			 WHERE CL.CodCliente = @CodCliente
	UNION
			SELECT RTRIM(cl.CodLstPrec) CodLstPrec, RTRIM(LP.NombreLstPre) NombreLstPre, 
				   RTRIM(cl.CodCliente) CodCliente, rtrim(rm.CUSTNAME) CUSTNAME,
				   RTRIM(cl.CodProd) CodProd, rtrim(iv.ITEMDESC) ITEMDESC, cl.PrecioBase, cl.Cantidad, cl.PrecioUOferta
			  FROM SAGRI_MOVIL.DBO.WS_ClienteListPrecio Cl
			 INNER JOIN SAGRI_MOVIL.DBO.WS_ListaPrecio LP
				ON CL.CodLstPrec = LP.CodLstPrec
			 INNER JOIN NUTGT.dbo.RM00101 RM
				ON CL.CodCliente = RM.CUSTNMBR
			 INNER JOIN NUTGT.DBO.IV00101 IV
				ON CL.CodProd = IV.ITEMNMBR
			 WHERE CL.IdIncrement = @CodCliente

  /*
   	IF SUBSTRING(@CodCliente,0,3) = 'SV'
		BEGIN
			SELECT IdIncrement, RTRIM(LP.NombreLstPre) NomLista, rtrim(rm.CUSTNAME) NomClient,
				   rtrim(iv.ITEMDESC) NomProduc, cl.PrecioBase Preb, cl.Cantidad Can, cl.PrecioUOferta PreOf
			  FROM SAGRI_MOVIL.DBO.WS_ClienteListPrecio Cl
			 INNER JOIN SAGRI_MOVIL.DBO.WS_ListaPrecio LP
				ON CL.CodLstPrec = LP.CodLstPrec
			 INNER JOIN GPsag.dbo.RM00101 RM
				ON CL.CodCliente = RM.CUSTNMBR
			 INNER JOIN GPSAG.DBO.IV00101 IV
				ON CL.CodProd = IV.ITEMNMBR
			 WHERE CL.CodCliente = @CodCliente
	END

		IF SUBSTRING(@CodCliente,0,3) = 'GT'
		BEGIN
			SELECT RTRIM(cl.CodLstPrec) CodLstPrec, RTRIM(LP.NombreLstPre) NombreLstPre, 
				   RTRIM(cl.CodCliente) CodCliente, rtrim(rm.CUSTNAME) CUSTNAME,
				   RTRIM(cl.CodProd) CodProd, rtrim(iv.ITEMDESC) ITEMDESC, cl.PrecioBase, cl.Cantidad, cl.PrecioUOferta
			  FROM SAGRI_MOVIL.DBO.WS_ClienteListPrecio Cl
			 INNER JOIN SAGRI_MOVIL.DBO.WS_ListaPrecio LP
				ON CL.CodLstPrec = LP.CodLstPrec
			 INNER JOIN NUTGT.dbo.RM00101 RM
				ON CL.CodCliente = RM.CUSTNMBR
			 INNER JOIN NUTGT.DBO.IV00101 IV
				ON CL.CodProd = IV.ITEMNMBR
			 WHERE CL.IdIncrement = @CodCliente
	END*/
END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_GetListaPreciosxPais]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE PROCEDURE [SAG].[WS_GetListaPreciosxPais]    
 @CodPais nvarchar(2)    
AS    
BEGIN    
    
 SET NOCOUNT ON;    
 
   SELECT RTRIM([CodLstPrec]) CodLstPrec, RTRIM([NombreLstPre]) NombreLstPre
     FROM [dbo].[WS_ListaPrecio]
	WHERE CodPais = @CodPais;

END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_GetLPC]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE PROCEDURE [SAG].[WS_GetLPC]    
 @CodListPrecCli nvarchar(250)--, @CodPais nvarchar(2)
AS    
BEGIN    
    
 SET NOCOUNT ON;    
	
			SELECT top(15) RTRIM(LP.NombreLstPre) +' | ' + 
			       RTRIM(cl.CodCliente)+' | ' + rtrim(rm.CUSTNAME)+' | ' + rtrim(iv.ITEMDESC)+' | ' +
				   try_cast(cl.PrecioBase as nvarchar) +' | ' + try_cast( cl.Cantidad as nvarchar)  +' | ' + 
				   try_cast(cl.PrecioUOferta as nvarchar)  Nombre
			  FROM SAGRI_MOVIL.DBO.WS_ClienteListPrecio Cl
			 INNER JOIN SAGRI_MOVIL.DBO.WS_ListaPrecio LP
				ON CL.CodLstPrec = LP.CodLstPrec
			 INNER JOIN GPsag.dbo.RM00101 RM
				ON CL.CodCliente = RM.CUSTNMBR
			 INNER JOIN GPSAG.DBO.IV00101 IV
				ON CL.CodProd = IV.ITEMNMBR
			 WHERE (CL.IdIncrement LIKE '%'+@CodListPrecCli+'%' or cl.CodCliente  LIKE '%'+@CodListPrecCli+'%'
					or rm.CUSTNAME LIKE '%'+@CodListPrecCli+'%' or iv.ITEMDESC LIKE '%'+@CodListPrecCli+'%')
					--or LP.NombreLstPre LIKE '%'+@CodListPrecCli+'%')
		UNION
			SELECT top(15) RTRIM(LP.NombreLstPre) +' | ' + 
			       RTRIM(cl.CodCliente)+' | ' + rtrim(rm.CUSTNAME)+' | ' + rtrim(iv.ITEMDESC)+' | ' +
				   try_cast(cl.PrecioBase as nvarchar) +' | ' + try_cast( cl.Cantidad as nvarchar)  +' | ' + 
				   try_cast(cl.PrecioUOferta as nvarchar)  Nombre
		      FROM SAGRI_MOVIL.DBO.WS_ClienteListPrecio Cl
			 INNER JOIN SAGRI_MOVIL.DBO.WS_ListaPrecio LP
				ON CL.CodLstPrec = LP.CodLstPrec
			 INNER JOIN NUTGT.dbo.RM00101 RM
				ON CL.CodCliente = RM.CUSTNMBR
			 INNER JOIN NUTGT.DBO.IV00101 IV
				ON CL.CodProd = IV.ITEMNMBR
			 WHERE (CL.IdIncrement LIKE '%'+@CodListPrecCli+'%' or cl.CodCliente  LIKE '%'+@CodListPrecCli+'%'
					or rm.CUSTNAME LIKE '%'+@CodListPrecCli+'%' or iv.ITEMDESC LIKE '%'+@CodListPrecCli+'%')
					--or LP.NombreLstPre LIKE '%'+@CodListPrecCli+'%')
	

	/*
	IF @CodPais = 'SV'
		BEGIN
			SELECT RTRIM(LP.NombreLstPre) +' | ' + 
			       RTRIM(cl.CodCliente)+' | ' + rtrim(rm.CUSTNAME)+' | ' + rtrim(iv.ITEMDESC)+' | ' +
				   cl.PrecioBase+' | ' + cl.Cantidad+' | ' + cl.PrecioUOferta Nombre
			  FROM SAGRI_MOVIL.DBO.WS_ClienteListPrecio Cl
			 INNER JOIN SAGRI_MOVIL.DBO.WS_ListaPrecio LP
				ON CL.CodLstPrec = LP.CodLstPrec
			 INNER JOIN GPsag.dbo.RM00101 RM
				ON CL.CodCliente = RM.CUSTNMBR
			 INNER JOIN GPSAG.DBO.IV00101 IV
				ON CL.CodProd = IV.ITEMNMBR
			 WHERE (CL.IdIncrement LIKE '%'+@CodListPrecCli+'%' or cl.CodCliente  LIKE '%'+@CodListPrecCli+'%'
					or rm.CUSTNAME LIKE '%'+@CodListPrecCli+'%' or iv.ITEMDESC LIKE '%'+@CodListPrecCli+'%')
		END

		IF @CodPais = 'GT'
		BEGIN
			SELECT RTRIM(LP.NombreLstPre) +' | ' + 
			       RTRIM(cl.CodCliente)+' | ' + rtrim(rm.CUSTNAME)+' | ' +
			       RTRIM(cl.CodProd) +' | ' + rtrim(iv.ITEMDESC)+' | ' +
				   cl.PrecioBase+' | ' + cl.Cantidad+' | ' + cl.PrecioUOferta Nombre
		      FROM SAGRI_MOVIL.DBO.WS_ClienteListPrecio Cl
			 INNER JOIN SAGRI_MOVIL.DBO.WS_ListaPrecio LP
				ON CL.CodLstPrec = LP.CodLstPrec
			 INNER JOIN NUTGT.dbo.RM00101 RM
				ON CL.CodCliente = RM.CUSTNMBR
			 INNER JOIN NUTGT.DBO.IV00101 IV
				ON CL.CodProd = IV.ITEMNMBR
			 WHERE (CL.IdIncrement LIKE '%'+@CodListPrecCli+'%' or cl.CodCliente  LIKE '%'+@CodListPrecCli+'%'
					or rm.CUSTNAME LIKE '%'+@CodListPrecCli+'%' or iv.ITEMDESC LIKE '%'+@CodListPrecCli+'%')
		END

		*/

END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_GetMunicipio]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 24/04/2020
  Procedimiento creado para registrar cliente nuevo a traves de un json enviado desde el Web Service
  y como se desglosa en el procedimiento, se ocupa la funcion OPENJSON para extraer la información
  */
CREATE procedure [SAG].[WS_GetMunicipio] 
(
	@Municipio varchar(50),	
	@Depto varchar(50)
	
)as 
--BEGIN TRY
--BEGIN TRANSACTION

BEGIN  

	select RTRIM(m.Municipio) Result
			 from SAGRI_MOVIL.dbo.WS_Municipios m
            inner join SAGRI_MOVIL.dbo.WS_Departamentos d
			on m.IdDepartamento = d.idDepto
			--where upper(d.Depa) = @Depto
			where upper(d.Depa) like '%'+  @Depto + '%'
			  and m.Municipio like '%'+@Municipio+'%'
			;


END
/*
COMMIT TRANSACTION;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS Result;

ROLLBACK TRANSACTION;
END CATCH
*/
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_GetPagosDetalleVendedor]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado AMENJIVAR 05/10/2021

  */
CREATE               procedure [SAG].[WS_GetPagosDetalleVendedor] 
(
	@Vendedor varchar(30)    
	
)as 
--BEGIN TRY
--BEGIN TRANSACTION

BEGIN  

declare @VendedorTxt varchar(30)
set @VendedorTxt= ltrim(rtrim(@Vendedor))

	select CodVendedor,NumFactura,CodCliente,
	case
	when TipoCobro='1' then 'Efetivo'
	when TipoCobro='2' then 'Cheque'
	when TipoCobro='3' then 'Transferencia o Remesa'
	when TipoCobro='4' then 'Tarjeta de Credito'
	else '' end TipoCobro,

	'$'+convert(nvarchar,
	convert(numeric(18,2),MontoCancelado)
	) 
	MontoCancelado,
	case
	when Estado='R' then 'Recibido'
	when Estado='A' then 'Aprobado'
	when Estado='P' then 'Pendiente'
	when Estado='C' then 'Cancelado'
	when Estado='X' then 'Anulado'
	when Estado='Y' then 'En Analisis'
	when Estado='Z' then 'En Espera'
	else '' end Estado
	,NumPagoDetalle
	,case
	when Area='A' then 'Agricola'
	when Area='V' then 'Veterinaria'
	when Area='I' then 'Industrial'
	when Area='T' then 'Taller'
	when Area='P' then 'Proyecto'

	else '' end Area
	from SAGRI_MOVIL.dbo.SAGPagosEncabezado a, SAGRI_MOVIL.dbo.SAGPagosDetalle b where a.NumPago=b.NumPago and a.CodVendedor like '%' +@VendedorTxt+ '%'



	

END
/*
COMMIT TRANSACTION;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS Result;

ROLLBACK TRANSACTION;
END CATCH
*/
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_GetProducto]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*Comentario agregago mpinto 08/10/2020
Este procedimiento se utiliza en distintas pantallas por ello los IF dentro del cuerpo del mismo*/
CREATE PROCEDURE [SAG].[WS_GetProducto]
 @ListPrec nvarchar(250), /*Agregado mpinto 08/10/2020 parametro para enviar el texto a buscar*/
 @Division char(1) = null, /*Se agrega parametro ya que segun la divisin	*/ /*Parametro que se utiliza en algunas pantallas, por eso se inicializa a null */
 @codpais char(5)
AS    
BEGIN    
    
 SET NOCOUNT ON;  
 IF @Division IS NULL 
	BEGIN
    IF @codpais = 'SV'
	   BEGIN
				 SELECT * FROM(
	  			 SELECT TOP 15   rtrim(t1.ITEMNMBR) + ' | ' + rtrim(t1.ITEMDESC)  as Nombre    
			       FROM GPSAG.dbo.IV00101 as t1  
			      WHERE ( t1.ITEMNMBR like '%'+ @ListPrec +'%' or t1.ITEMDESC like '%'+ @ListPrec +'%' )
			        /*and SUBSTRING(t1.ITEMNMBR,0,2) = @Division -- Add mpinto 08/10/2020 cuando division es null es porque no se tiene en cuenta, por lo tanto no tomarlo en el where*/
			      group by t1.ITEMNMBR, t1.ITEMDESC
			      order by t1.ITEMNMBR  
		 ) as  myt
		 where Nombre is not null
	   END
	ELSE IF @codpais = 'GT'
	   BEGIN
			  SELECT * FROM(
				 SELECT TOP 15   rtrim(t1.ITEMNMBR) + ' | ' + rtrim(t1.ITEMDESC)  as Nombre    
				   FROM NUTGT.dbo.IV00101 as t1  
				  WHERE ( t1.ITEMNMBR like '%'+ @ListPrec +'%' or t1.ITEMDESC like '%'+ @ListPrec +'%' )
				    /*and SUBSTRING(t1.ITEMNMBR,0,2) = @Division -- Add mpinto 08/10/2020 cuando division es null es porque no se tiene en cuenta, por lo tanto no tomarlo en el where*/
				  group by t1.ITEMNMBR, t1.ITEMDESC
				  order by t1.ITEMNMBR 
			) as  myt
		 where Nombre is not null
	   END
	   ELSE IF @codpais = 'CR'
	   BEGIN
			  SELECT * FROM(
				 SELECT TOP 15   rtrim(t1.ITEMNMBR) + ' | ' + rtrim(t1.ITEMDESC)  as Nombre    
				   FROM NUTCR.dbo.IV00101 as t1  
				  WHERE ( t1.ITEMNMBR like '%'+ @ListPrec +'%' or t1.ITEMDESC like '%'+ @ListPrec +'%' )
				    --and SUBSTRING(t1.ITEMNMBR,0,2) = @Division
				  group by t1.ITEMNMBR, t1.ITEMDESC
				  order by t1.ITEMNMBR 
			) as  myt
		 where Nombre is not null
	   END
   ELSE
	SELECT 'NO DATA | NO DATA' Nombre;
	END
ELSE
	BEGIN		  
    IF @codpais = 'SV'
	   BEGIN
				 SELECT * FROM(
	  			 SELECT TOP 15   rtrim(t1.ITEMNMBR) + ' | ' + rtrim(t1.ITEMDESC)  as Nombre    
			       FROM GPSAG.dbo.IV00101 as t1  
			      WHERE ( t1.ITEMNMBR like '%'+ @ListPrec +'%' or t1.ITEMDESC like '%'+ @ListPrec +'%' )
			        and SUBSTRING(t1.ITEMNMBR,0,2) = @Division
			      group by t1.ITEMNMBR, t1.ITEMDESC
			      order by t1.ITEMNMBR  
		 ) as  myt
		 where Nombre is not null
	   END
	ELSE IF @codpais = 'GT'
	   BEGIN
			  SELECT * FROM(
				 SELECT TOP 15   rtrim(t1.ITEMNMBR) + ' | ' + rtrim(t1.ITEMDESC)  as Nombre    
				   FROM NUTGT.dbo.IV00101 as t1  
				  WHERE ( t1.ITEMNMBR like '%'+ @ListPrec +'%' or t1.ITEMDESC like '%'+ @ListPrec +'%' )
				    and SUBSTRING(t1.ITEMNMBR,0,2) = @Division
				  group by t1.ITEMNMBR, t1.ITEMDESC
				  order by t1.ITEMNMBR 
			) as  myt
		 where Nombre is not null
	   END
	   ELSE IF @codpais = 'CR'
	   BEGIN
			  SELECT * FROM(
				 SELECT TOP 15   rtrim(t1.ITEMNMBR) + ' | ' + rtrim(t1.ITEMDESC)  as Nombre    
				   FROM NUTCR.dbo.IV00101 as t1  
				  WHERE ( t1.ITEMNMBR like '%'+ @ListPrec +'%' or t1.ITEMDESC like '%'+ @ListPrec +'%' )
				    and SUBSTRING(t1.ITEMNMBR,0,2) = @Division
				  group by t1.ITEMNMBR, t1.ITEMDESC
				  order by t1.ITEMNMBR 
			) as  myt
		 where Nombre is not null
	   END
   ELSE
	SELECT 'NO DATA | NO DATA' Nombre;
	END
	

END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_GetProveedor]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*Creado mpinto 08/10/2020
Procedimiento para obtener codigo y nombre de proveedor
*/
CREATE PROCEDURE [SAG].[WS_GetProveedor]
 @texto nvarchar(250), /*Agregado mpinto 08/10/2020 parametro para enviar el texto a buscar*/ 
 @codpais char(5)
AS    
BEGIN
    
 SET NOCOUNT ON;  

    IF @codpais = 'SV'
	   BEGIN
				 SELECT * FROM(
	  			 SELECT TOP 15   rtrim(t1.VENDORID) + ' | ' + rtrim(t1.VENDNAME)  as Nombre    
				   FROM GPSAG.dbo.PM00200 as t1  
				  WHERE ( t1.VENDORID like '%'+ @texto +'%' or t1.VENDNAME like '%'+ @texto +'%' )				    
				  group by t1.VENDORID, t1.VENDNAME
				  order by t1.VENDORID  
		 ) as  myt
		 where Nombre is not null
	   END
	ELSE IF @codpais = 'GT'
	   BEGIN
			  SELECT * FROM(
				 SELECT TOP 15   rtrim(t1.VENDORID) + ' | ' + rtrim(t1.VENDNAME)  as Nombre    
				   FROM NUTGT.dbo.PM00200 as t1  
				  WHERE ( t1.VENDORID like '%'+ @texto +'%' or t1.VENDNAME like '%'+ @texto +'%' )				    
				  group by t1.VENDORID, t1.VENDNAME
				  order by t1.VENDORID  
			) as  myt
		 where Nombre is not null
	   END
	   ELSE IF @codpais = 'CR'
	   BEGIN
			  SELECT * FROM(
				 SELECT TOP 15   rtrim(t1.VENDORID) + ' | ' + rtrim(t1.VENDNAME)  as Nombre    
				   FROM NUTCR.dbo.PM00200 as t1  
				  WHERE ( t1.VENDORID like '%'+ @texto +'%' or t1.VENDNAME like '%'+ @texto +'%' )				    
				  group by t1.VENDORID, t1.VENDNAME
				  order by t1.VENDORID 
			) as  myt
		 where Nombre is not null
	   END
   ELSE
	SELECT 'NO DATA | NO DATA' Nombre;
	
END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_InsertarCliente]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 24/04/2020
  Procedimiento creado para registrar cliente nuevo a traves de un json enviado desde el Web Service
  y como se desglosa en el procedimiento, se ocupa la funcion OPENJSON para extraer la información
  */
CREATE procedure [SAG].[WS_InsertarCliente] 
(
	@JsonCliente nvarchar(max)
	
)as 
BEGIN TRY
BEGIN TRANSACTION

BEGIN  

declare @IdClieCaf char(10);
declare @nrc char(15);


  SELECT @IdClieCaf =  id, @nrc = registry
	  FROM OPENJSON(@JsonCliente)
		   WITH (id char(15), registry char(15))
		   ;

/*INSERCION DATOS PRINCIPALES DEL CLIENTE*/
INSERT INTO [dbo].[WS_Cliente]
           ([IdClieCafeina],[PrimerNombre]
           ,[PrimerApellido],[Dui]
           ,[Nit],[TarjetaIva],[NCR],[TipoDoc],[Correo], [Telefono], 
		   idDireccCaf, Comentarios, billing_name, codpais, AgregadoPor, FechaAgregado
		   ,No_Celular, Receptor_Nombre, Receptor_email, Receptor_Telefono, Receptor_IdPais, Receptor_Pais)
	   SELECT id, name, lastname,DUI, NIT, iva_card, registry,
	          document_type, email, phone, addresss.idDir, additional_data, billing_name, 
			  CASE WHEN country='503' THEN 'SV'
		           WHEN country='502' THEN 'GT'END AS country, 
	          user, getdate(), cel, recipient_name , recipient_email , recipient_phone, pais.idpais, pais.namepais
	  FROM OPENJSON(@JsonCliente)
		   WITH (id char(15), name char(50),
		        lastname char(50), dui char(10),
				nit char(21), iva_card char(25), registry char(15),
				document_type char(3), email nchar(100),
				phone char(15),
		       addresses nvarchar(max) AS JSON, country_info nvarchar(max) AS JSON, additional_data nchar(200), billing_name nchar(50), 
			   country char(3), cel char(15), recipient_name char(50), recipient_email char(50), recipient_phone char(25))
			     CROSS APPLY 
            --OPENJSON (country) /*Agregado mpinto 09/07/2020*/
			OPENJSON (country_info) /*Agregado mpinto 09/07/2020*/
			WITH ( 	
				  idpais char(5) '$.id',
				  namepais char(25) '$.name'
				  )AS pais
		   CROSS APPLY 
            OPENJSON (addresses)
			WITH ( 	
				  idDir nchar(10) '$.id',
				  principal nchar(1) '$.principal'
				  )AS addresss
			 WHERE addresss.principal = 1/*Agregado mpinto 28/05/2020 */
			 ; 
			

INSERT INTO [dbo].[WS_DireccCliente]
           ([IdClieCafeina]
		   ,[IdDireccionCaf]
		   ,[Nombre]
		   ,[Principal]
           ,[Direccion]
		   ,[DireccionTotal]
           /*,[Telefono1]
           ,[Telefono2]*/
		   ,[idCity]
		   ,[Ciudad]
		   ,[idDepartamento]
           ,[Departamento]
           ,[idMunicipio]
		   ,[Municipio]
		   ,[deleted]
		   ,[Pais]
		   /*
           ,[CodPostal]*/) 
    SELECT id,addresss.idDir, addresss.name,addresss.principal, addresss.cityname + ' ' + addresss.address, addresss.cityname + ' ' + addresss.addressT, addresss.idcity, addresss.cityname,
           addresss.state_id, addresss.state, addresss.province_id, addresss.province_name, addresss.deleted,
		  CASE 
		  WHEN country='503' THEN 'SV'
		  WHEN country='502' THEN 'GT'
		  END AS country
		 
	  FROM OPENJSON(@JsonCliente)
		   WITH (id char(15),addresses nvarchar(max) AS JSON, country char(3))
		   CROSS APPLY 
            OPENJSON (addresses)
			WITH ( 			
				  idDir nchar(10) '$.id',
				  name nchar(25),
				  principal bit,
				  address nchar(183), /*mpinto 25062020*/
				  addressT varchar(max) '$.address',
				  deleted bit,
				  state_id nchar(2),
				  idcity nchar(25) '$.city.id',
				  cityname nchar(25) '$.city.name',
				  state nchar(25) '$.state.name',
				  province_id nchar(3),
				  province_name nchar(25) '$.province.name' )AS addresss
				  --,
		   --Departamento nchar(255) '$.addresses.state.name'

EXEC SAG.WS_VerificarCliente_GP @nrc, @IdClieCaf;

Select '1' Result;
END
COMMIT TRANSACTION;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS Result;

ROLLBACK TRANSACTION;
END CATCH
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_InsertarListaPrecioCliente]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 06/05/2020
  Procedimiento creado para registrar un nuevo pedido a traves de un json enviado desde el Web Service
  y como se desglosa en el procedimiento, se ocupa la funcion OPENJSON para extraer la información
  */
CREATE procedure [SAG].[WS_InsertarListaPrecioCliente] 
(
	--@CodlPC nchar(10),
	@CodLP nchar(10), /*Codigo del precio de lista*/
	@CodProd nchar(25),  
	@CodCliente nchar(15),
	@PreB numeric(18,2),
	@Cant int,
	@PreOf numeric(18,2),
	@usuario nchar(10),
	@desclpc char(100),
	@CodPais char(2)
)as 
BEGIN TRY
BEGIN TRANSACTION

BEGIN  

declare @contador int = 0;
declare @Operacion char(15)=''

select @contador = count(*) 
  from [dbo].[WS_ClienteListPrecio] 
 where CodLstPrec = @CodLP
   and CodCliente = @CodCliente
   and CodProd =@CodProd
   ;

	IF @contador <1
	BEGIN
		INSERT INTO [dbo].[WS_ClienteListPrecio]
           (--[CodListPrecCli],
		   [CodLstPrec]
           ,[CodProd]
           ,[CodCliente]
           ,[PrecioBase]
           ,[Cantidad]
		   ,[DescListPre]
           ,[PrecioUOferta]           
           ,[UsuarioCrea]
           ,[FechaCrea]
		   ,[CodPais])
			   select @CodLP, @CodProd,
			   @CodCliente, @PreB, @Cant, @desclpc,@PreOf,
			    @Usuario, getdate(), @CodPais; /*Agregado mpinto 20072020 - se agrega descripcion lista de precio*/

	  select @Operacion = 'Insert' ;
	END
	ELSE
		BEGIN
		UPDATE [dbo].[WS_ClienteListPrecio]
		   SET-- CodListPrecCli = @CodlPc,
			   CodLstPrec = @CodLP,
			   CodProd = @CodProd,
			   CodCliente = @CodCliente,
			   PrecioBase = @PreB,
			   PrecioUOferta = @PreOf,
			   UsuarioModif = @usuario,
			   FechaModif = getdate(),
			   DescListPre = @desclpc,
			   CodPais = @CodPais
		 where CodLstPrec = @CodLP
		   and CodCliente = @CodCliente
		   and CodProd =@CodProd
   ;

   select @Operacion = 'Update' ;
		END

Select '1' Result, rtrim(@Operacion) operacion;
END
COMMIT TRANSACTION;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS Result;

ROLLBACK TRANSACTION;
END CATCH
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_InsertarPedido]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 06/05/2020
  Procedimiento creado para registrar un nuevo pedido a traves de un json enviado desde el Web Service
  y como se desglosa en el procedimiento, se ocupa la funcion OPENJSON para extraer la información
  */
CREATE procedure [SAG].[WS_InsertarPedido] 
(
	@JsonPedido nvarchar(max)--, /*Estructura json para almacenar el encabezado del pedido*/
	/*@JsonPedidoEnca nvarchar(max), /*Estructura json para almacenar el encabezado del pedido*/
	@JsonPedidoDeta nvarchar(max),  /*Estructura json para almacenar el detalle del pedido*/*/
	--@SitioOrigen nvarchar(25) /*Procedencia del pedido HONDA ELSALVADOR, AGRICOLA EL SALVADOR, AGRICOLA GUATEMALA */
)as 

BEGIN TRY
BEGIN TRANSACTION
--BEGIN
	DECLARE @idDirec nchar(10);
	DECLARE @clienteid char(15);
	DECLARE @countDirec int;
	DECLARE @numPedido bigint;
	DECLARE @numPedidoAGVET bigint; /*Agregado mpinto 12/08/2020 Se crea esta varible porque el numero no se calcula sino que viene desde el sitio*/
	--DECLARE @CodCliente char(25) = 'SVC0809'; /*Agregado mpinto 29/05/2020 Se agrega este codigode cliente ya que es generico para pago de contado, que es el metodo unico que se utilizara para honda*/
	DECLARE @CodCliente char(25) = 'SVC0016'; /*Agregado mpinto 24/06/2020 Se agrega este codigode cliente ya que es uno nuevo, generico para pago de contado, que es el metodo unico que se utilizara para honda*/
	DECLARE @CodVend char(25) = 'SVRMORE'; /*Agregado mpinto 29/05/2020 Se agrega este codigo de vendedor ya que es generico, se utiliza para un cliente que no existe en el sistema y que no tiene vendedor asigando*/
	DECLARE @TipoPago char(25) = 'CONTADO'; /*Para productos siempre sera pago contado*/
	DECLARE @Bodega char(15) = 'CENTRAL';
	DECLARE @CodCorrelativo char(15) = 'WEBSV';
	DECLARE @SitioOrigen nvarchar(25);
	DECLARE @Status char(15)='';
	DECLARE @ReqEnvio bit ; /*Agregado mpinto 10/09/2020 Se agrega pantalla */
	DECLARE @CodCliente2 nchar(15);


--SELECT @numPedido = SAGRI_MOVIL.SAG.WS_Func_ObtenerCorrelativo('WEBSV');
 SELECT @numPedido = SAGRI_MOVIL.DBO.Correlativo1.NumSiguiente
    FROM SAGRI_MOVIL.DBO.Correlativo1
   WHERE SAGRI_MOVIL.DBO.Correlativo1.Pais = @CodCorrelativo 
   ;

   /*Actualizar el correlativo al numero siguiente, para cuando realicen un nuevo pedido*/
   UPDATE SAGRI_MOVIL.DBO.Correlativo1
      SET SAGRI_MOVIL.DBO.Correlativo1.NumSiguiente = SAGRI_MOVIL.DBO.Correlativo1.NumSiguiente + 1
   WHERE SAGRI_MOVIL.DBO.Correlativo1.Pais = @CodCorrelativo



 SELECT @SitioOrigen = site
		  FROM OPENJSON(@JsonPedido)
			   WITH (site nchar(30)); 

/***************************************************************************************************/
/***************************INISERCION DE PEDIDOS SITO HONDA SV*************************************/
/***************************************************************************************************/
IF @SitioOrigen = 'HONDASV'
BEGIN

SELECT @Status = UPPER(order_status)
		  FROM OPENJSON(@JsonPedido)
			   WITH (order_status nchar(15)); 
/**************  SI EL PEDIDO VIENEN CON ESTATUS APROBADO  *************/
	IF @Status = 'APROBADA'
	BEGIN
	/*Extraer el valor del id de direccion*/					 
	  SELECT @idDirec = addresss.idDir, @clienteid = client_id
			  FROM OPENJSON(@JsonPedido)
				   WITH (client_id char(15), address nvarchar(max) AS JSON)
				   CROSS APPLY OPENJSON (address)
					WITH ( idDir nchar(10) '$.id')
					   AS addresss;  
			  
		--BEGIN
		INSERT INTO [dbo].[PedidoEncabezado]
				   ([NumPedido],	[CodCliente],	[CodVendedor]
				   ,[Tpago],		[FechaPedido],	[FechaEntrega]
				   ,[Observacion],	[TotalPedido],	[Pais]
				   ,[IdDireccion],[Origen], [idBac],[idClieCaf],[EstadoBac], [orderCaf])
			  SELECT @numPedido,  @CodCliente, /*Agregado mpinto 29/05/2020 Se agrega este codigode cliente ya que es generico para pago de contado, que es el metodo unico que se utilizara para honda*/
					@CodVend, /*Agregado mpinto 29/05/2020 Se agrega este codigo de vendedor ya que es generico, se utiliza para un cliente que no existe en el sistema y que no tiene vendedor asigando*/
					@TipoPago, /*Para productos siempre sera pago contado*/
					created_at,	SAGRI_MOVIL.SAG.WS_ObtenerDiaHabil(created_at,3)
				   /*,'',price/1.13 Comentado mpinto 03/07/2020*/
				   ,'',price
				   ,'EL SALVADOR',idDir, 'WEB',reference_no, client_id, order_status, code--, [IdDireccion] /*Se almacenara el id que maneja Cafeina*/
			  FROM OPENJSON(@JsonPedido)
				   WITH (client_id char(15),created_at datetime, order_status nchar(15),
						  price money,code char(50),reference_no char(50),address nvarchar(max) AS JSON)
				   CROSS APPLY OPENJSON (address)
					WITH ( idDir nchar(10) '$.id')AS addresss
					 

	/*Extraer el valor del id de direccion*/					 
	  SELECT @idDirec = idDir, @clienteid = client_id
		FROM OPENJSON(@JsonPedido)
		WITH (client_id char(15), addresses nvarchar(max) AS JSON)
	   CROSS APPLY 
	OPENJSON (addresses)			
		WITH (idDir nchar(10) '$.id') ;
		--print  @idDirec ;
		--print  @clienteid ;


		--SELECT @idDirec, @clienteid ;

		/*Verificar si ya existe el id extraido en la tabla direcciones del cliente*/
		SELECT @countDirec = COUNT(*)
		  FROM SAGRI_MOVIL.DBO.WS_DireccCliente
		 WHERE IdDireccionCaf = @idDirec
		   AND IdClieCafeina = @clienteid
			;

		/* SI NO EXISTE INSERTAR NUEVA DIRECCION */
		 IF @countDirec = 0 
		 BEGIN 
		
				INSERT INTO [dbo].[WS_DireccCliente]
				   ([IdClieCafeina],[IdDireccionCaf],[Nombre]
				   ,[Principal],[Direccion],[DireccionTotal],[idDepartamento]
				   ,[Departamento],[idMunicipio],[Municipio],[deleted],[Pais],[idCity],[Ciudad])			   
		   SELECT client_id, addresss.idDir, addresss.name,addresss.principal, addresss.cityname + ' ' + addresss.address, addresss.cityname + ' ' + addresss.addressT, addresss.state_id,
				  addresss.state, addresss.province_id, addresss.province_name, addresss.deleted, 'SV', addresss.idcity, addresss.cityname
			  FROM OPENJSON(@JsonPedido)
				   WITH (client_id char(15), address nvarchar(max) AS JSON)
				   CROSS APPLY OPENJSON (address)
					WITH ( idDir nchar(10) '$.id',
						  name nchar(25),
						  principal nchar(25),
						  address nchar(183),
						  addressT varchar(max) '$.address',
						  idcity nchar(25) '$.city.id',
					      cityname nchar(25) '$.city.name',
						  state_id nchar(2),
						  deleted bit,
						  state nchar(25) '$.state.name',
						  province_id nchar(3),
						  province_name nchar(25) '$.province.name' )
					   AS addresss
		END


			INSERT INTO [dbo].[PedidoDetalle]
				   ([NumPedido],	[CodCliente],	[CodProducto]
				   ,	[Cantidad]
				   ,[PrecioUnitario],[PrecioTotal],	[CodVendedor]
				   ,[Bodega],[origen])
			  SELECT @numPedido, @CodCliente,	code
				   , qty 
				   ,price--/1.13 comentado mpinto 03/07/2020
				   ,(qty*price)--/1.13 comentado mpinto 03/07/2020
				   ,@CodVend
				   ,@Bodega, 'WEB'
			  FROM OPENJSON(@JsonPedido)
				   WITH (details nvarchar(max) AS JSON)
			   CROSS APPLY OPENJSON (details)
			   WITH ( code varchar(30),
					  price money,
					  principal nchar(25),
					  qty numeric(18,0))
					  ;

		/*	con el fin de donde provienen los pedidos*/
		INSERT INTO [SAGRI_MOVIL].DBO.[WS_SitioOrigenPedido]
			   ([NumPedido]
			   ,[SitioOrigen]
			   ,[FechaInsert])
		 VALUES(
			   @numPedido,
			   @SitioOrigen,
			   getdate()
			  )
			  ; 

		END /*FIN IF @Status = 'APROBADA'*/ 
  ELSE 
  /**************  SI EL PEDIDO VIENEC CON STATUS RECHAZADO O ERROR  *************/
	BEGIN 
				/*Extraer el valor del id de direccion*/					 
	  SELECT @idDirec = addresss.idDir, @clienteid = client_id
			  FROM OPENJSON(@JsonPedido)
				   WITH (client_id char(15), address nvarchar(max) AS JSON)
				   CROSS APPLY OPENJSON (address)
					WITH ( idDir nchar(10) '$.id')
					   AS addresss;
					   			  
		INSERT INTO [dbo].[PedidoEncabezadoStatusBac]
				   ([NumPedido],	[CodCliente],	[CodVendedor]
				   ,[Tpago],		[FechaPedido],	[FechaEntrega]
				   ,[Observacion],	[TotalPedido],	[Pais]
				   ,[IdDireccion],[Origen], [idBac],[idClieCaf],[EstadoBac], [orderCaf])
			  SELECT @numPedido,  @CodCliente, /*Agregado mpinto 29/05/2020 Se agrega este codigode cliente ya que es generico para pago de contado, que es el metodo unico que se utilizara para honda*/
					@CodVend, /*Agregado mpinto 29/05/2020 Se agrega este codigo de vendedor ya que es generico, se utiliza para un cliente que no existe en el sistema y que no tiene vendedor asigando*/
					@TipoPago, /*Para productos siempre sera pago contado*/
					created_at,	SAGRI_MOVIL.SAG.WS_ObtenerDiaHabil(created_at,3)
				   ,'',price,	
					CASE WHEN @SitioOrigen = 'HONDASV' THEN 'EL SALVADOR' end
					,idDir, 'WEB',reference_no, client_id, order_status, code--, [IdDireccion] /*Se almacenara el id que maneja Cafeina*/
			  FROM OPENJSON(@JsonPedido)
				   WITH (client_id char(15),created_at datetime, order_status nchar(15),
						  price money,code char(50),reference_no char(50),address nvarchar(max) AS JSON)
				   CROSS APPLY OPENJSON (address)
					WITH ( idDir nchar(10) '$.id')AS addresss
					 


			INSERT INTO [dbo].[PedidoDetalleStatusBac]
				   ([NumPedido],	[CodCliente],	[CodProducto]
				   ,	[Cantidad]
				   ,[PrecioUnitario],[PrecioTotal],	[CodVendedor]
				   ,[Bodega])
			  SELECT @numPedido, @CodCliente,	code
				   , qty ,price, qty*price,	@CodVend
				   ,@Bodega
			  FROM OPENJSON(@JsonPedido)
				   WITH (details nvarchar(max) AS JSON)
			   CROSS APPLY OPENJSON (details)
			   WITH ( code varchar(30),
					  price money,
					  principal nchar(25),
					  qty numeric(18,0))
					  ;

		/*	con el fin de donde provienen los pedidos*/
		INSERT INTO [SAGRI_MOVIL].DBO.[WS_SitioOrigenPedido]
			   ([NumPedido]
			   ,[SitioOrigen]
			   ,[FechaInsert])
		 VALUES(
			   @numPedido,
			   @SitioOrigen,
			   getdate()
			  )
			  ; 
	END
	END /*FIN IF "HONDASV"(Es decir proviene de sitio honda */


/***************************************************************************************************/
/*******************INISERCION DE PEDIDOS SITO AGRICOLA VETERINARIA SV******************************/
/***************************************************************************************************/

ELSE IF @SitioOrigen = 'AGVET_SV'
	BEGIN	

SELECT @Status = UPPER(order_status), @ReqEnvio = envio_express, @CodCliente2 = CodCliente --, 
       --@TipoPago = UPPER(TipPago)/*Agregado mpinto obtener tipo de pago del cliente, si es contado dejar "CONTADO" si es credito obtener de la tabla RM00101 el tipo de credito aprobado */
		  FROM OPENJSON(@JsonPedido)
			   WITH (order_status nchar(15), TipPago varchar(30), CodCliente char(15),envio_express bit ); 

	/* Comentado mpinto 18/08/2020 Se comenta ya que el numero de pedido se obtendra 
	   aca en el procedimiento no vendra en el json

	SELECT @numPedidoAGVET = Numpedido
		  FROM OPENJSON(@JsonPedido)
			   WITH (NumPedido numeric(18,0)); 
    */



	IF @Status is NULL /*EN ESTE CASO SERIA PORQUE EL CLIENTE PIDIO CREDITO*/
	BEGIN
		
		INSERT INTO [dbo].[PedidoEncabezado]
				   ([NumPedido],	[CodCliente],	[CodVendedor]
				   ,[Tpago],		[FechaPedido],	[FechaEntrega]
				   ,[Observacion],	[TotalPedido],	[Pais]
				   ,[IdDireccion],[Origen], [idBac],[EstadoBac],
				    [orderCaf], /*Agregado MPINTO 02/09/2020 Campo solicitado por luis Villalta*/
					[PlazoEntregaPedido])
			  --SELECT NumPedido,  CodCliente, CodVendedor, TipPago, 
			  SELECT @numPedido,  CodCliente, CodVendedor, TipPago, 
					FechaPedido, SAGRI_MOVIL.SAG.WS_ObtenerDiaHabil(FechaPedido,3)				   
				   ,Observacion,TotalPedido
				   ,'EL SALVADOR',IdDireccion, 'WEB',reference_no, order_status
				   , code /*Agregado MPINTO 02/09/2020 Campo solicitado por luis Villalta*/
				   , plazo_pedido
			  FROM OPENJSON(@JsonPedido)
				   WITH (/*NumPedido numeric(18,0),*/ CodCliente char(15),FechaPedido datetime, 
				         CodVendedor varchar(15), TipPago varchar(30), order_status nchar(15),
						 TotalPedido money,reference_no char(50), IdDireccion nchar(30), Observacion varchar(250),code char(50), 
						 plazo_pedido int  /*Agregado mpinto 01/10/2020 para registrar el tiempo de plazo del pedido*/
						 )
						

			INSERT INTO [dbo].[PedidoDetalle]
				   ([NumPedido],	[CodCliente],	[CodProducto]
				   ,	[Cantidad]
				   ,[PrecioUnitario],[PrecioTotal],	[CodVendedor]
				   ,[Bodega],[origen], NomProducto)
			  --SELECT NumPedido, CodCliente , CodProducto
			  SELECT @numPedido, CodCliente , CodProducto
				   , Cantidad 
				   ,PrecioUnitario--/1.13 comentado mpinto 03/07/2020
				   ,(Cantidad*PrecioUnitario)--/1.13 comentado mpinto 03/07/2020
				   ,CodVendedor 
				   ,@Bodega /*Bodega siempre sera "CENTRAL" es una constante definida al inicio de este procedimiento*/
				   ,'WEB', NomProducto
			  FROM OPENJSON(@JsonPedido)
				   WITH (/*NumPedido numeric(18,0),*/ CodCliente char(15), CodVendedor varchar(15), productos nvarchar(max) AS JSON)
			   CROSS APPLY OPENJSON (productos)
			   WITH ( CodProducto varchar(30),
					  PrecioUnitario money,
					  principal nchar(25),
					  Cantidad numeric(18,0)
					  ,NomProducto varchar(60))
					  ;

		/*	con el fin de donde provienen los pedidos*/
		INSERT INTO [SAGRI_MOVIL].DBO.[WS_SitioOrigenPedido]
			   ([NumPedido]
			   ,[CodCliente]
			   ,[SitioOrigen]
			   ,[FechaInsert],
			   [RequiereEnvio])
		 VALUES(
			   @numPedido,
			   @CodCliente2,
			   @SitioOrigen,			  
			   getdate(),
			   @ReqEnvio			   
			  )
			  ;

		END /*FIN IF @Status = NULL*/ 

	ELSE IF @Status = 'APROBADA'
	BEGIN
	
		INSERT INTO [dbo].[PedidoEncabezado]
				   ([NumPedido],	[CodCliente],	[CodVendedor]
				   ,[Tpago],		[FechaPedido],	[FechaEntrega]
				   ,[Observacion],	[TotalPedido],	[Pais]
				   ,[IdDireccion],[Origen], [idBac],[EstadoBac],
				    [orderCaf], /*Agregado MPINTO 02/09/2020 Campo solicitado por luis Villalta*/
					[PlazoEntregaPedido])
			  SELECT @numPedido,  CodCliente, CodVendedor, TipPago, 
					FechaPedido, SAGRI_MOVIL.SAG.WS_ObtenerDiaHabil(FechaPedido,3)				   
				   ,Observacion,TotalPedido
				   ,'EL SALVADOR',IdDireccion, 'WEB',reference_no, order_status, code,
				   plazo_pedido
			  FROM OPENJSON(@JsonPedido)
				   WITH (/*NumPedido numeric(18,0), */CodCliente char(15),FechaPedido datetime, 
				         CodVendedor varchar(15), TipPago varchar(30), order_status nchar(15),
						  TotalPedido money,reference_no char(50), IdDireccion nchar(30), Observacion varchar(250)
						  ,code char(50), /*Agregado mpinto 02/09/2020*/
						  plazo_pedido int  /*Agregado mpinto 01/10/2020 para registrar el tiempo de plazo del pedido*/
						   )
						

			INSERT INTO [dbo].[PedidoDetalle]
				   ([NumPedido],	[CodCliente],	[CodProducto]
				   ,	[Cantidad]
				   ,[PrecioUnitario],[PrecioTotal],	[CodVendedor]
				   ,[Bodega],[origen], NomProducto)
			  SELECT @numPedido, CodCliente , CodProducto
				   , Cantidad 
				   ,PrecioUnitario--/1.13 comentado mpinto 03/07/2020
				   ,(Cantidad*PrecioUnitario)--/1.13 comentado mpinto 03/07/2020
				   ,CodVendedor 
				   ,@Bodega /*Bodega siempre sera "CENTRAL" es una constante definida al inicio de este procedimiento*/
				   ,'WEB', NomProducto 
			  FROM OPENJSON(@JsonPedido)
				   WITH (/*NumPedido numeric(18,0), */CodCliente char(15), CodVendedor varchar(15), productos nvarchar(max) AS JSON)
			   CROSS APPLY OPENJSON (productos)
			   WITH ( CodProducto varchar(30),
					  PrecioUnitario money,
					  principal nchar(25),
					  Cantidad numeric(18,0)
					  ,NomProducto varchar(60))
					  ;

		/*	con el fin de donde provienen los pedidos*/
		INSERT INTO [SAGRI_MOVIL].DBO.[WS_SitioOrigenPedido]
			   ([NumPedido]
			   ,[CodCliente]
			   ,[SitioOrigen]
			   ,[FechaInsert],
			   [RequiereEnvio])
		 VALUES(
			   @numPedido,
			   @CodCliente2,
			   @SitioOrigen,			  
			   getdate(),
			   @ReqEnvio			   
			  )
			  ;

		END /*FIN IF @Status = 'APROBADA'*/ 
  ELSE 
  /**************  SI EL PEDIDO VIENEC CON STATUS RECHAZADO O ERROR  *************/
	BEGIN 
			
					   			  
		INSERT INTO [dbo].[PedidoEncabezadoStatusBac]
				   ([NumPedido],	[CodCliente],	[CodVendedor]
				   ,[Tpago],		[FechaPedido],	[FechaEntrega]
				   ,[Observacion],	[TotalPedido],	[Pais]
				   ,[IdDireccion],[Origen], [idBac],[EstadoBac],
				    [orderCaf],   /*Agregado MPINTO 02/09/2020 Campo solicitado por luis Villalta*/
					[PlazoEntregaPedido])
			  SELECT @numPedido,  CodCliente, CodVendedor, TipPago, 
					FechaPedido, SAGRI_MOVIL.SAG.WS_ObtenerDiaHabil(FechaPedido,3)				   
				   ,Observacion,TotalPedido
				   ,'EL SALVADOR',IdDireccion, 'WEB',reference_no, order_status,code,
				   plazo_pedido
			  FROM OPENJSON(@JsonPedido)
				   WITH (/*NumPedido numeric(18,0),*/ CodCliente char(15),FechaPedido datetime, 
				         CodVendedor varchar(15), TipPago varchar(30), order_status nchar(15),
						  TotalPedido money,reference_no char(50), IdDireccion nchar(30), Observacion varchar(250) 
						  ,code char(50), /*Agregado mpinto 02/09/2020*/
						  plazo_pedido int  /*Agregado mpinto 01/10/2020 para registrar el tiempo de plazo del pedido*/
						   )

			INSERT INTO [dbo].[PedidoDetalleStatusBac]
				   ([NumPedido],	[CodCliente],	[CodProducto]
				   ,	[Cantidad]
				   ,[PrecioUnitario],[PrecioTotal],	[CodVendedor]
				   ,[Bodega], [Origen], NomProducto )
			  SELECT @numPedido, CodCliente , CodProducto
				   , Cantidad 
				   ,PrecioUnitario--/1.13 comentado mpinto 03/07/2020
				   ,(Cantidad*PrecioUnitario)--/1.13 comentado mpinto 03/07/2020
				   ,CodVendedor 
				   ,@Bodega /*Bodega siempre sera "CENTRAL" es una constante definida al inicio de este procedimiento*/
				   ,'WEB',NomProducto 
			  FROM OPENJSON(@JsonPedido)
				   WITH (/*NumPedido numeric(18,0), */CodCliente char(15), CodVendedor varchar(15), productos nvarchar(max) AS JSON)
			   CROSS APPLY OPENJSON (productos)
			   WITH ( CodProducto varchar(30),
					  PrecioUnitario money,
					  principal nchar(25),
					  Cantidad numeric(18,0)
					  ,NomProducto varchar(60))
					  ;

		/*	con el fin de donde provienen los pedidos*/
	INSERT INTO [SAGRI_MOVIL].DBO.[WS_SitioOrigenPedido]
			   ([NumPedido]
			   ,[CodCliente]
			   ,[SitioOrigen]
			   ,[FechaInsert],
			   [RequiereEnvio])
		 VALUES(
			   @numPedido,
			   @CodCliente2,
			   @SitioOrigen,			  
			   getdate(),
			   @ReqEnvio			   
			  )
			  ;
	END
	END


	/*MODIF. MPINTO 13/10/2020
	Se agrega parte de Guatemala para insertar pedidos, se manejaran solo ventas al credito pero se deja parte de 
	contado en el codigo por si mas adelante es agregada esta modalidad, para venta creditos estatus debe ir NULL*/
	ELSE IF @SitioOrigen = 'AGVET_GT'
	BEGIN	

		SELECT @Status = UPPER(order_status), @ReqEnvio = envio_express, @CodCliente2 = CodCliente --, 
		  FROM OPENJSON(@JsonPedido)
		  WITH (order_status nchar(15), TipPago varchar(30), CodCliente char(15),envio_express bit ); 
		  
	IF @Status is NULL /*EN ESTE CASO SERIA PORQUE EL CLIENTE PIDIO CREDITO*/
	BEGIN
		
		INSERT INTO [dbo].[PedidoEncabezado]
				   ([NumPedido],	[CodCliente],	[CodVendedor]
				   ,[Tpago],		[FechaPedido],	[FechaEntrega]
				   ,[Observacion],	[TotalPedido],	[Pais]
				   ,[IdDireccion],[Origen], [idBac],[EstadoBac],
				    [orderCaf], /*Agregado MPINTO 02/09/2020 Campo solicitado por luis Villalta*/
					[PlazoEntregaPedido])
			  --SELECT NumPedido,  CodCliente, CodVendedor, TipPago, 
			  SELECT @numPedido,  CodCliente, CodVendedor, TipPago, 
					FechaPedido, SAGRI_MOVIL.SAG.WS_ObtenerDiaHabil(FechaPedido,3)				   
				   ,Observacion,TotalPedido
				   ,'GUATEMALA',IdDireccion, 'WEB',reference_no, order_status
				   , code /*Agregado MPINTO 02/09/2020 Campo solicitado por luis Villalta*/
				   , plazo_pedido
			  FROM OPENJSON(@JsonPedido)
				   WITH (/*NumPedido numeric(18,0),*/ CodCliente char(15),FechaPedido datetime, 
				         CodVendedor varchar(15), TipPago varchar(30), order_status nchar(15),
						 TotalPedido money,reference_no char(50), IdDireccion nchar(30), Observacion varchar(250),code char(50), 
						 plazo_pedido int  /*Agregado mpinto 01/10/2020 para registrar el tiempo de plazo del pedido*/
						 )
						

			INSERT INTO [dbo].[PedidoDetalle]
				   ([NumPedido],	[CodCliente],	[CodProducto]
				   ,	[Cantidad]
				   ,[PrecioUnitario],[PrecioTotal],	[CodVendedor]
				   ,[Bodega],[origen], NomProducto)
			  --SELECT NumPedido, CodCliente , CodProducto
			  SELECT @numPedido, CodCliente , CodProducto
				   , Cantidad 
				   ,PrecioUnitario--/1.13 comentado mpinto 03/07/2020
				   ,(Cantidad*PrecioUnitario)--/1.13 comentado mpinto 03/07/2020
				   ,CodVendedor 
				   ,@Bodega /*Bodega siempre sera "CENTRAL" es una constante definida al inicio de este procedimiento*/
				   ,'WEB', NomProducto
			  FROM OPENJSON(@JsonPedido)
				   WITH (/*NumPedido numeric(18,0),*/ CodCliente char(15), CodVendedor varchar(15), productos nvarchar(max) AS JSON)
			   CROSS APPLY OPENJSON (productos)
			   WITH ( CodProducto varchar(30),
					  PrecioUnitario money,
					  principal nchar(25),
					  Cantidad numeric(18,0)
					  ,NomProducto varchar(60))
					  ;

		/*	con el fin de donde provienen los pedidos*/
		INSERT INTO [SAGRI_MOVIL].DBO.[WS_SitioOrigenPedido]
			   ([NumPedido],[CodCliente],[SitioOrigen]
			   ,[FechaInsert],[RequiereEnvio])
		 VALUES(@numPedido,@CodCliente2,@SitioOrigen,			  
			   getdate(),@ReqEnvio)
			  ;

		END /*FIN IF @Status = NULL*/ 

	ELSE IF @Status = 'APROBADA'
	BEGIN
	
		INSERT INTO [dbo].[PedidoEncabezado]
				   ([NumPedido],	[CodCliente],	[CodVendedor]
				   ,[Tpago],		[FechaPedido],	[FechaEntrega]
				   ,[Observacion],	[TotalPedido],	[Pais]
				   ,[IdDireccion],[Origen], [idBac],[EstadoBac],
				    [orderCaf], /*Agregado MPINTO 02/09/2020 Campo solicitado por luis Villalta*/
					[PlazoEntregaPedido])
			  SELECT @numPedido,  CodCliente, CodVendedor, TipPago, 
					FechaPedido, SAGRI_MOVIL.SAG.WS_ObtenerDiaHabil(FechaPedido,3)				   
				   ,Observacion,TotalPedido
				   ,'GUATEMALA',IdDireccion, 'WEB',reference_no, order_status, code,
				   plazo_pedido
			  FROM OPENJSON(@JsonPedido)
				   WITH (/*NumPedido numeric(18,0), */CodCliente char(15),FechaPedido datetime, 
				         CodVendedor varchar(15), TipPago varchar(30), order_status nchar(15),
						  TotalPedido money,reference_no char(50), IdDireccion nchar(30), Observacion varchar(250)
						  ,code char(50), /*Agregado mpinto 02/09/2020*/
						  plazo_pedido int  /*Agregado mpinto 01/10/2020 para registrar el tiempo de plazo del pedido*/
						   )
						

			INSERT INTO [dbo].[PedidoDetalle]
				   ([NumPedido],	[CodCliente],	[CodProducto]
				   ,	[Cantidad]
				   ,[PrecioUnitario],[PrecioTotal],	[CodVendedor]
				   ,[Bodega],[origen], NomProducto)
			  SELECT @numPedido, CodCliente , CodProducto
				   , Cantidad 
				   ,PrecioUnitario--/1.13 comentado mpinto 03/07/2020
				   ,(Cantidad*PrecioUnitario)--/1.13 comentado mpinto 03/07/2020
				   ,CodVendedor 
				   ,@Bodega /*Bodega siempre sera "CENTRAL" es una constante definida al inicio de este procedimiento*/
				   ,'WEB', NomProducto 
			  FROM OPENJSON(@JsonPedido)
				   WITH (/*NumPedido numeric(18,0), */CodCliente char(15), CodVendedor varchar(15), productos nvarchar(max) AS JSON)
			   CROSS APPLY OPENJSON (productos)
			   WITH ( CodProducto varchar(30),
					  PrecioUnitario money,
					  principal nchar(25),
					  Cantidad numeric(18,0)
					  ,NomProducto varchar(60))
					  ;

		/*	con el fin de donde provienen los pedidos*/
		INSERT INTO [SAGRI_MOVIL].DBO.[WS_SitioOrigenPedido]
			   ([NumPedido],[CodCliente],[SitioOrigen]
			   ,[FechaInsert],[RequiereEnvio])
		 VALUES(@numPedido,@CodCliente2,@SitioOrigen,			  
			   getdate(),@ReqEnvio)
			  ;

		END /*FIN IF @Status = 'APROBADA'*/ 
  ELSE 
  /**************  SI EL PEDIDO VIENEC CON STATUS RECHAZADO O ERROR  *************/
	BEGIN 
			
					   			  
		INSERT INTO [dbo].[PedidoEncabezadoStatusBac]
				   ([NumPedido],	[CodCliente],	[CodVendedor]
				   ,[Tpago],		[FechaPedido],	[FechaEntrega]
				   ,[Observacion],	[TotalPedido],	[Pais]
				   ,[IdDireccion],[Origen], [idBac],[EstadoBac],
				    [orderCaf],   /*Agregado MPINTO 02/09/2020 Campo solicitado por luis Villalta*/
					[PlazoEntregaPedido])
			  SELECT @numPedido,  CodCliente, CodVendedor, TipPago, 
					FechaPedido, SAGRI_MOVIL.SAG.WS_ObtenerDiaHabil(FechaPedido,3)				   
				   ,Observacion,TotalPedido
				   ,'GUATEMALA',IdDireccion, 'WEB',reference_no, order_status,code,
				   plazo_pedido
			  FROM OPENJSON(@JsonPedido)
				   WITH (/*NumPedido numeric(18,0),*/ CodCliente char(15),FechaPedido datetime, 
				         CodVendedor varchar(15), TipPago varchar(30), order_status nchar(15),
						  TotalPedido money,reference_no char(50), IdDireccion nchar(30), Observacion varchar(250) 
						  ,code char(50), /*Agregado mpinto 02/09/2020*/
						  plazo_pedido int  /*Agregado mpinto 01/10/2020 para registrar el tiempo de plazo del pedido*/
						   )

			INSERT INTO [dbo].[PedidoDetalleStatusBac]
				   ([NumPedido],	[CodCliente],	[CodProducto]
				   ,	[Cantidad]
				   ,[PrecioUnitario],[PrecioTotal],	[CodVendedor]
				   ,[Bodega], [Origen], NomProducto )
			  SELECT @numPedido, CodCliente , CodProducto
				   , Cantidad 
				   ,PrecioUnitario--/1.13 comentado mpinto 03/07/2020
				   ,(Cantidad*PrecioUnitario)--/1.13 comentado mpinto 03/07/2020
				   ,CodVendedor 
				   ,@Bodega /*Bodega siempre sera "CENTRAL" es una constante definida al inicio de este procedimiento*/
				   ,'WEB',NomProducto 
			  FROM OPENJSON(@JsonPedido)
				   WITH (/*NumPedido numeric(18,0), */CodCliente char(15), CodVendedor varchar(15), productos nvarchar(max) AS JSON)
			   CROSS APPLY OPENJSON (productos)
			   WITH ( CodProducto varchar(30),
					  PrecioUnitario money,
					  principal nchar(25),
					  Cantidad numeric(18,0)
					  ,NomProducto varchar(60))
					  ;

		/*	con el fin de donde provienen los pedidos*/
	INSERT INTO [SAGRI_MOVIL].DBO.[WS_SitioOrigenPedido]
			   ([NumPedido]
			   ,[CodCliente]
			   ,[SitioOrigen]
			   ,[FechaInsert],
			   [RequiereEnvio])
		 VALUES(
			   @numPedido,
			   @CodCliente2,
			   @SitioOrigen,			  
			   getdate(),
			   @ReqEnvio			   
			  )
			  ;
	END
	END

	/*
	INSERT INTO [dbo].[PedidoEncabezado]
           ([NumPedido],	[CodCliente],	[CodVendedor]
           ,[Tpago],		[FechaPedido],	[FechaEntrega]
           ,[Observacion],	[TotalPedido],	[Pais]
           ,[IdDireccion])
	  SELECT [NumPedido],	[CodCliente],	[CodVendedor]
           ,[Tpago],		[FechaPedido],	[FechaEntrega]
           ,[Observacion],	[TotalPedido],	[Pais]
           ,[IdDireccion]
	  FROM OPENJSON(@JsonPedidoEnca)
		   WITH (NumPedido numeric(18, 0), CodCliente varchar(10), CodVendedor varchar(15),
				 Tpago varchar(30),		   FechaPedido datetime,   FechaEntrega datetime,
				 Observacion varchar(250), TotalPedido money,	   Pais nchar(30),
				 IdDireccion nchar(30))
				 ; 

	INSERT INTO [dbo].[PedidoDetalle]
           ([NumPedido],	[CodCliente],	[CodProducto]
           ,[NomProducto],	[Presentacion],	[Cantidad]
           ,[PrecioUnitario],[PrecioTotal],	[CodVendedor]
           ,[Bodega])
	  SELECT [NumPedido],	[CodCliente],	[CodProducto]
           ,[NomProducto],	[Presentacion],	[Cantidad]
           ,[PrecioUnitario],[PrecioTotal],	[CodVendedor]
           ,[Bodega]
	  FROM OPENJSON(@JsonPedidoDeta)
		   WITH (NumPedido varchar(10),		CodCliente varchar(10),		CodProducto varchar(30),
				 NomProducto varchar(60),	Presentacion varchar(30),	Cantidad numeric(18, 0),
				 PrecioUnitario money, PrecioTotal money, CodVendedor varchar(15), Bodega varchar(30))
				 ; 
	*/


				 
--END	
Select '1' Result;
commit transaction;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() as Result;--AS ErrorMessage;

ROLLBACK TRANSACTION;
END CATCH
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_InsertarPrecioClienteAgricola]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 23/07/2020
  Procedimiento creado para registras lista de prodcutos para clientes de la división de Agricola
  */
CREATE procedure [SAG].[WS_InsertarPrecioClienteAgricola] 
(
	--@CodlPC nchar(10),
	--@CodLP nchar(10), /*Codigo del precio de lista*/
	@CodProd nchar(25),  
	@CodCliente nchar(15),
	@Precio numeric(18,2),
	--@Cant int,
	--@PreOf numeric(18,2),
	@usuario nchar(10),
	@desclpc char(100),
	@CodPais char(2)
)as 
BEGIN TRY
BEGIN TRANSACTION

BEGIN  

declare @contador int = 0;
declare @Operacion char(15)=''

select @contador = count(*) 
  from [dbo].[WS_ClienteListPrecio_AGRI] 
 where CodCliente = @CodCliente
   and CodProd =@CodProd
   ;

	IF @contador <1
	BEGIN
	INSERT INTO [SAGRI_MOVIL].dbo.[WS_ClienteListPrecio_AGRI]
           ([CodProd]
           ,[CodCliente]
           ,[Precio]
		   ,[Descripcion]
           ,[CodPais]
           ,[UsuarioCrea]
           ,[FechaCrea])
			   select @CodProd,
			   @CodCliente, @Precio, @desclpc, @CodPais,
			    @Usuario, getdate(); 

	  select @Operacion = 'Insert' ;
	END
	ELSE
		BEGIN
		UPDATE [SAGRI_MOVIL].dbo.[WS_ClienteListPrecio_AGRI]
		   SET CodProd = @CodProd,
			   CodCliente = @CodCliente,
			   Precio = @Precio,			   
			   UsuarioModif = @usuario,
			   FechaModif = getdate(),
			   Descripcion = @desclpc,
			   CodPais = @CodPais
		 where CodCliente = @CodCliente
		   and CodProd =@CodProd
   ;

   select @Operacion = 'Update' ;
		END

Select '1' Result, rtrim(@Operacion) operacion;
END
COMMIT TRANSACTION;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS Result;

ROLLBACK TRANSACTION;
END CATCH
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ObtenerCliente]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 24/04/2020
  Procedimiento obtener la informacion del cliente en formato json con la misma estructura que se
  envia para insertar.
  */
CREATE procedure [SAG].[WS_ObtenerCliente] 
(
	@CodCliente varchar(5)
	
)as 
BEGIN  

DECLARE @CodPais nchar(2) = '';


SELECT @CodPais = D_.PAIS
  from SAGRI_MOVIL.dbo.WS_DireccCliente D_  
  where d_.IdClieCafeina = @CodCliente
  group by d_.pais
	;

	  /*CLIENTE*/
SELECT /*RTRIM(C.CodCliente) CodCliente, */
	   RTRIM(C.IdClieCafeina) id, RTRIM(C.PrimerNombre) as "name", RTRIM(C.Correo) email, RTRIM(C.PrimerApellido) lastname,
	   RTRIM(C.Telefono) phone,--STRING_ESCAPE(RTRIM(Telefono),'json') phone,
	   RTRIM(C.billing_name) billing_name, RTRIM(C.dui) dui, RTRIM(C.TarjetaIva) iva_card, rtrim(C.ncr) registry,
	   RTRIM(C.Comentarios) additional_data, C.TipoDoc document_type, RTRIM(C.NIT) nit,
	    CASE
		WHEN @CodPais= 'SV' THEN '503'
		WHEN @CodPais = 'GT' THEN '502'
		END AS country, -- D_.Pais country,	   
	   (
	   SELECT
		   RTRIM(D.IdDireccionCaf) 'id', RTRIM(D.Nombre) 'name', RTRIM(D.Principal) 'principal', RTRIM(D.Direccion) 'address', 
		   RTRIM(D.idDepartamento) 'state_id', RTRIM(D.idMunicipio) 'province_id',
		   RTRIM(D.Departamento) 'state.name', RTRIM(D.idMunicipio) 'province.id',
		   RTRIM(D.Municipio) 'province.name'
	   FROM SAGRI_MOVIL.dbo.WS_DireccCliente D
	  WHERE C.IdClieCafeina = D.IdClieCafeina
	  FOR JSON PATH
	   ) addresses
  FROM SAGRI_MOVIL.dbo.WS_Cliente C
 -- inner join SAGRI_MOVIL.dbo.WS_DireccCliente D_
 -- ON C.IdClieCafeina = D_.IdClieCafeina
  where C.IdClieCafeina = @CodCliente
  --group by d_.pais
  FOR JSON PATH, INCLUDE_NULL_VALUES;
END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ObtenerCorrelativo]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
CREADO MPINTO 29/05/2020
Procedimiento Creado para obtener el numero de pedido segun el pais para las ventas en linea(SITIO WEB)
*/
CREATE PROCEDURE [SAG].[WS_ObtenerCorrelativo]    
 @CodCorrelativo nvarchar(25)
AS    
BEGIN    
    
 SET NOCOUNT ON;

  /*Obtener el numero actual de correlativo*/
  SELECT SAGRI_MOVIL.DBO.Correlativo1.NumSiguiente
    FROM SAGRI_MOVIL.DBO.Correlativo1
   WHERE SAGRI_MOVIL.DBO.Correlativo1.Pais = @CodCorrelativo
   FOR JSON PATH
   ;

   /*Actualizar el correlativo al numero siguiente, para cuando realicen un nuevo pedido*/
   UPDATE SAGRI_MOVIL.DBO.Correlativo1
      SET SAGRI_MOVIL.DBO.Correlativo1.NumSiguiente = SAGRI_MOVIL.DBO.Correlativo1.NumSiguiente + 1
   WHERE SAGRI_MOVIL.DBO.Correlativo1.Pais = @CodCorrelativo

END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ObtenerDetallePedidos]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
CREATE           PROCEDURE [SAG].[WS_ObtenerDetallePedidos] 
(	@Pedido varchar(15),	
	@CodPais varchar(2),
	@bd varchar(25) = null
)as 
BEGIN  
DECLARE @NumCorrelativo bigint;
DECLARE @Correlativo varchar(15);
DECLARE @LENCorrelativo int;

SET NOCOUNT ON;
SET @bd = 'GPSAG';

 IF @bd = 'GPSAG'
	 BEGIN


SELECT NumPedido, CodCliente, CodProducto, NomProducto, Presentacion, Cantidad, PrecioUnitario, PrecioTotal, CodVendedor, Bodega, rtrim(b.UOMSCHDL) as Unidad  FROM dbo.PedidoDetalle  a   
inner join gpsag.dbo.iv00101 b on a.CodProducto = b.itemnmbr  WHERE (NumPedido = @Pedido)  order by a.CodProducto


	 END	
END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ObtenerDetallePedidos_PRU]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*Creado mpinto 17/01/2023
Procedimiento creado para obtener todas los documentos a emitir en linea (FACTURAS, NOTAS DE CREDITO, NOTAS DE DEBITO, ETC..)*/

CREATE         PROCEDURE [SAG].[WS_ObtenerDetallePedidos_PRU] 
(	@Pedido varchar(15),	
	@CodPais varchar(2),
	@bd varchar(25) = null
)as 
BEGIN  
DECLARE @NumCorrelativo bigint;
DECLARE @Correlativo varchar(15);
DECLARE @LENCorrelativo int;

SET NOCOUNT ON;
SET @bd = 'GPSAG';

 IF @bd = 'GPSAG'
	 BEGIN


SELECT NumPedido, CodCliente, CodProducto, NomProducto, Presentacion, Cantidad, PrecioUnitario, PrecioTotal, CodVendedor, Bodega, rtrim(b.UOMSCHDL) as Unidad  FROM dbo.PedidoDetalleH  a   
inner join gpsag.dbo.iv00101 b on a.CodProducto = b.itemnmbr  WHERE (NumPedido = @Pedido)  order by a.CodProducto


	 END	
END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ObtenerDeudaCliente]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*Creado MPINTO 24/04/2020
  Procedimiento creado para obtener los datos de la deduda que tiene un cliente
  WSCeL : Web Service Compras en Linea*/
CREATE procedure [SAG].[WS_ObtenerDeudaCliente] 
(
	@CodCliente nvarchar(25)
	--, @CodPais nchar(2)
)as 
BEGIN  


SELECT [FAC],[NomCliente],[Saldo],[SLPRSNID],[FechaVence]
      ,[DiasVencido],[De0a30Dias],[De31a60Dias]
      ,[De61a90Dias],[De91a120Dias],[MasDe120Dias]
      ,[DIV],[Pais],[UltimoPago],[FUltimoPAgo]
      ,[PDiasPago],[UltimaFactura],[FUltimaFactura],[TCredito]
  FROM [dbo].[SAGSaldosCXCMovilSV]
 WHERE CodCliente = @CodCliente
  -- AND Pais = @CodPais


END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ObtenerDeudaClienteDatos]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*Creado MPINTO 22/07/2020
  Procedimiento que enviara los datos del cliente que adeuda a la empresa */
CREATE procedure [SAG].[WS_ObtenerDeudaClienteDatos] 
(
	@CodCliente nvarchar(25)
)as 
BEGIN  

SELECT [CodCliente]
      ,[NomCliente]
      ,[UltimoPago]
      ,fORMAT ([FUltimoPAgo], 'dd-MM-yyyy') [FechaUltimoPago]
      ,[PDiasPago] DiasPago
      ,[UltimaFactura] MontoUltimaFactura
      ,fORMAT ([FUltimaFactura], 'dd-MM-yyyy') [FechaUltimaFactura] 
      ,[DiasC] TerminoCred
  FROM [SAGRI_MOVIL].[dbo].[SAGDatosClientesWEB]
 WHERE CodCliente = @CodCliente
  -- AND Pais = @CodPais


END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ObtenerDeudaClienteDetalle]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*Creado MPINTO 22/07/2020
  Procedimiento que enviara informacion resumida de 
  la deuda del cliente  */
CREATE procedure [SAG].[WS_ObtenerDeudaClienteDetalle] 
(
	@CodCliente nvarchar(25)
)as 
BEGIN  

SELECT [CodCliente]
      ,[FAC]
      ,[De0a30Dias]
      ,[De31a60Dias]
      ,[De61a90Dias]
      ,[De91a120Dias]
      ,[MasDe120Dias]
      ,[Saldo]
      ,fORMAT ([FechaVence], 'dd-MM-yyyy') [FechaVence]  
  FROM [SAGRI_MOVIL].[dbo].[SAGDetalleDeudaClienteWEB]
 WHERE CodCliente = @CodCliente
  -- AND Pais = @CodPais


END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ObtenerDeudaClienteResumen]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*Creado MPINTO 22/07/2020
  Procedimiento que enviara informacion resumida de 
  la deuda del cliente  */
CREATE procedure [SAG].[WS_ObtenerDeudaClienteResumen] 
(
	@CodCliente nvarchar(25)
)as 
BEGIN  


SELECT [CodCliente]
      ,[NomCliente]
      ,[0a30 dias] [0a30dias]
      ,[31a60 dias] [31a60dias]
      ,[61a90 dias] [61a90dias]
      ,[91a120 dias] [91a120dias]
      ,[Mas 120 dias] [Mas120dias]
      ,[TotalDeuda]
      ,[Pais]
  FROM [SAGRI_MOVIL].[dbo].[SAGResumenDeudaClienteWEB]
 WHERE CodCliente = @CodCliente
  -- AND Pais = @CodPais


END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ObtenerFacturaProyecto_PRU]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*Creado mpinto 17/01/2023
Procedimiento creado para obtener todas los documentos a emitir en linea (FACTURAS, NOTAS DE CREDITO, NOTAS DE DEBITO, ETC..)*/
--exec SAGRI_MOVIL.SAG.[WS_ObtenerPedidosaGenerar_PRU] 'SV'
CREATE         PROCEDURE [SAG].[WS_ObtenerFacturaProyecto_PRU] 
(		
	@CodPais varchar(2),
	@bd varchar(25) = null
)as 
BEGIN  
DECLARE @NumCorrelativo bigint;
DECLARE @Correlativo varchar(15);
DECLARE @LENCorrelativo int;

SET NOCOUNT ON;
SET @bd = 'GPSAG';

 IF @bd = 'GPSAG'
	 BEGIN

select '1' NumPedido, '22SD000U03000' 'CodCliente', 'IMOGA0033' NombreCliente ,'ITEM 8 2.06 SUMINISTRO DE MOTOR ELECTRICO TIPO VERTICAR DE 75 HP.
TRIFASICO, 230/460V, 1800 +/- 5% VARIACION RPM, EFEICIENCIA PREMLIM, 60HP
ACTA DE RECEPCION PARCIAL NO. 6 REGIONAL ORIENTA $7,350.96
MAROTIZACION 30$ 																	 $2,205.29
SUB TOTAL																				 $ 5,145.67
total' CodVendedor, '1' FechaPedido, '$7,350.96' FechaEntrega,'$ 5,145.67' TotalPedido
,'' Observacion,'' Pais,'' Tpago,''IdDireccion,'' Filas
union all 

select '2' NumPedido, '22SD000U03000' 'CodCliente', 'IMOGA0033' NombreCliente ,'TEM 8 2.06 SUMINISTRO DE MOTOR ELECTRICO TIPO VERTICAR DE 75 HP.
TRIFASICO, 230/460V, 1800 +/- 5% VARIACION RPM, EFEICIENCIA PREMLIM, 60HP
ACTA DE RECEPCION PARCIAL NO. 6 REGIONAL ORIENTA $7,350.96
MAROTIZACION 30$ 																	 $2,205.29
SUB TOTAL																				 $ 5,145.67' CodVendedor, '1' FechaPedido, '$7,350.96' FechaEntrega,'$ 5,145.67' TotalPedido
,'' Observacion,'' Pais,'' Tpago,''IdDireccion,'' Filas
	 END	
END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ObtenerHistorialPedidosCliente]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 24/04/2020
  Procedimiento obtener la informacion historica de los pedidos WEB del un cliente especifico
  */
CREATE procedure [SAG].[WS_ObtenerHistorialPedidosCliente] 
(
	@CodCliente varchar(15)
	
)as 
BEGIN TRY
BEGIN TRANSACTION 
--BEGIN  

DECLARE @CodPais nchar(2) = '';
DECLARE @json VARCHAR(MAX) = '';

select @CodPais = SUBSTRING(@CodCliente,0,3);



IF @CodPais = 'SV'
	BEGIN	
		SELECT @json = COALESCE((
		--select @json = (
		SELECT * from
		(
			  SELECT
			   RTRIM(C.NumPedido) NumPedido, RTRIM(C.CodCliente) as CodCliente, RTRIM(C.CodVendedor) CodVendedor, 
			   RTRIM(C.Tpago) TipPago,RTRIM(FORMAT(C.FechaPedido, 'dd-MM-yyyy')) FechaPedido,  RTRIM(FORMAT(C.FechaEntrega, 'dd-MM-yyyy')) FechaEntrega,
			   RTRIM(C.Observacion) Observacion, RTRIM(C.TotalPedido) TotalPedido, RTRIM(C.Pais) Pais, rtrim(C.IdDireccion) IdDireccion, 
			   'PENDIENTE' ESTADO, /*Agregado mpinto 13/08/2020 Para verificar si el producto esta pendiente o facturado*/
			   RTRIM(C.[orderCaf]) code, /*Agregado mpinto 03/09/2020 Codigo incluido por cafeina para la transaccion del banco*/
			   C.PlazoEntregaPedido plazo_pedido,
			   (
			   SELECT
				   RTRIM(D.CodProducto) CodProducto, RTRIM(D.NomProducto) NomProducto, RTRIM(D.Cantidad) Cantidad, RTRIM(D.PrecioUnitario) PrecioUnitario, 
				   RTRIM(D.PrecioTotal) PrecioTotal
			   FROM SAGRI_MOVIL.dbo.PedidoDetalle D
			  WHERE C.NumPedido = D.NumPedido
				AND C.Origen = D.Origen
			  FOR JSON PATH
			   ) productos
		  FROM SAGRI_MOVIL.dbo.PedidoEncabezado C 
		  --where C.CodCliente = 'SVC0158'
		  where C.CodCliente = @CodCliente
		   AND C.Origen = 'WEB'
		  --FOR JSON PATH, INCLUDE_NULL_VALUES
		  UNION
		  SELECT
			   RTRIM(C.NumPedido) NumPedido, RTRIM(C.CodCliente) as CodCliente, RTRIM(C.CodVendedor) CodVendedor, 
			   RTRIM(C.Tpago) TipPago,RTRIM(FORMAT(C.FechaPedido, 'dd-MM-yyyy')) FechaPedido,  RTRIM(FORMAT(C.FechaEntrega, 'dd-MM-yyyy')) FechaEntrega,
			   RTRIM(C.Observacion) Observacion, RTRIM(C.TotalPedido) TotalPedido, RTRIM(C.Pais) Pais, rtrim(C.IdDireccion) IdDireccion,
			   case when S.REFRENCE IS null then 'PENDIENTE'
			   --ELSE 'FACTURADO' END AS EstadoPedido,
			   ELSE 'FACTURADO' END AS Estado,
			   RTRIM(C.[orderCaf]) code, /*Agregado mpinto 03/09/2020 Codigo incluido por cafeina para la transaccion del banco*/
				 C.PlazoEntregaPedido plazo_pedido,
			   (
			   SELECT
				   RTRIM(D.CodProducto) CodProducto, RTRIM(D.NomProducto) NomProducto, RTRIM(D.Cantidad) Cantidad, RTRIM(D.PrecioUnitario) PrecioUnitario, 
				   RTRIM(D.PrecioTotal) PrecioTotal
			   FROM SAGRI_MOVIL.dbo.PedidoDetalleH D
			  WHERE C.NumPedido = D.NumPedido
				AND C.Origen = D.Origen
			  FOR JSON PATH
			   ) productos
		  FROM SAGRI_MOVIL.dbo.PedidoEncabezadoH C 
		   LEFT JoIN GPSAG.dbo.SOP30200 S
			  on 'WEB'+CAST(c.numpedido AS char(31)) = s.refrence
		  where C.CodCliente = @CodCliente
		   AND C.Origen = 'WEB') AS J
		   FOR JSON PATH, INCLUDE_NULL_VALUES   
		), '');
	END
	
ELSE IF @CodPais = 'GT'
	BEGIN	
		SELECT @json = COALESCE((
		--select @json = (
		SELECT * from
		(
			  SELECT
			   RTRIM(C.NumPedido) NumPedido, RTRIM(C.CodCliente) as CodCliente, RTRIM(C.CodVendedor) CodVendedor, 
			   RTRIM(C.Tpago) TipPago,RTRIM(FORMAT(C.FechaPedido, 'dd-MM-yyyy')) FechaPedido,  RTRIM(FORMAT(C.FechaEntrega, 'dd-MM-yyyy')) FechaEntrega,
			   RTRIM(C.Observacion) Observacion, RTRIM(C.TotalPedido) TotalPedido, RTRIM(C.Pais) Pais, rtrim(C.IdDireccion) IdDireccion, 
			   'PENDIENTE' ESTADO, /*Agregado mpinto 13/08/2020 Para verificar si el producto esta pendiente o facturado*/
			   RTRIM(C.[orderCaf]) code, /*Agregado mpinto 03/09/2020 Codigo incluido por cafeina para la transaccion del banco*/
			   C.PlazoEntregaPedido plazo_pedido,
			   (
			   SELECT
				   RTRIM(D.CodProducto) CodProducto, RTRIM(D.NomProducto) NomProducto, RTRIM(D.Cantidad) Cantidad, RTRIM(D.PrecioUnitario) PrecioUnitario, 
				   RTRIM(D.PrecioTotal) PrecioTotal
			   FROM SAGRI_MOVIL.dbo.PedidoDetalle D
			  WHERE C.NumPedido = D.NumPedido
				AND C.Origen = D.Origen
			  FOR JSON PATH
			   ) productos
		  FROM SAGRI_MOVIL.dbo.PedidoEncabezado C 		  
		  where C.CodCliente = @CodCliente
		   AND C.Origen = 'WEB'		  
		  UNION
		  SELECT
			   RTRIM(C.NumPedido) NumPedido, RTRIM(C.CodCliente) as CodCliente, RTRIM(C.CodVendedor) CodVendedor, 
			   RTRIM(C.Tpago) TipPago,RTRIM(FORMAT(C.FechaPedido, 'dd-MM-yyyy')) FechaPedido,  RTRIM(FORMAT(C.FechaEntrega, 'dd-MM-yyyy')) FechaEntrega,
			   RTRIM(C.Observacion) Observacion, RTRIM(C.TotalPedido) TotalPedido, RTRIM(C.Pais) Pais, rtrim(C.IdDireccion) IdDireccion,
			   case when S.REFRENCE IS null then 'PENDIENTE'
			   --ELSE 'FACTURADO' END AS EstadoPedido,
			   ELSE 'FACTURADO' END AS Estado,
			   RTRIM(C.[orderCaf]) code, /*Agregado mpinto 03/09/2020 Codigo incluido por cafeina para la transaccion del banco*/
				 C.PlazoEntregaPedido plazo_pedido,
			   (
			   SELECT
				   RTRIM(D.CodProducto) CodProducto, RTRIM(D.NomProducto) NomProducto, RTRIM(D.Cantidad) Cantidad, RTRIM(D.PrecioUnitario) PrecioUnitario, 
				   RTRIM(D.PrecioTotal) PrecioTotal
			   FROM SAGRI_MOVIL.dbo.PedidoDetalleH D
			  WHERE C.NumPedido = D.NumPedido
				AND C.Origen = D.Origen
			  FOR JSON PATH
			   ) productos
		  FROM SAGRI_MOVIL.dbo.PedidoEncabezadoH C 
		   LEFT JoIN NUTGT.dbo.SOP30200 S
			  on 'WEB'+CAST(c.numpedido AS char(31)) = s.refrence
		  where C.CodCliente = @CodCliente
		   AND C.Origen = 'WEB') AS J
		   FOR JSON PATH, INCLUDE_NULL_VALUES   
		), '');
	END

--)


  /*
  SELECT @json = @json + COALESCE((
	  /*Pedido Transferido (Historico)*/
SELECT
	   RTRIM(C.NumPedido) NumPedido, RTRIM(C.CodCliente) as CodCliente, RTRIM(C.CodVendedor) CodVendedor, 
	   RTRIM(C.Tpago) TipPago,RTRIM(FORMAT(C.FechaPedido, 'dd-MM-yyyy')) FechaPedido,  RTRIM(FORMAT(C.FechaEntrega, 'dd-MM-yyyy')) FechaEntrega,
	   RTRIM(C.Observacion) Observacion, RTRIM(C.TotalPedido) TotalPedido, RTRIM(C.Pais) Pais, rtrim(C.IdDireccion) IdDireccion,
	   case when S.REFRENCE IS null then 'PENDIENTE'
	   ELSE 'FACTURADO' END AS EstadoPedido,
	   (
	   SELECT
		   RTRIM(D.CodProducto) CodProducto, RTRIM(D.NomProducto) NomProducto, RTRIM(D.Cantidad) Cantidad, RTRIM(D.PrecioUnitario) PrecioUnitario, 
		   RTRIM(D.PrecioTotal) PrecioTotal
	   FROM SAGRI_MOVIL.dbo.PedidoDetalleH D
	  WHERE C.NumPedido = D.NumPedido
	    AND C.Origen = D.Origen
	  FOR JSON PATH
	   ) productos
  FROM SAGRI_MOVIL.dbo.PedidoEncabezadoH C 
   LEFT JoIN GPSAG.dbo.SOP30200 S
	  on 'WEB'+CAST(c.numpedido AS char(31)) = s.refrence
  where C.CodCliente = @CodCliente
   AND C.Origen = 'WEB'
  FOR JSON PATH, INCLUDE_NULL_VALUES
  ),'');*/

  SELECT @json Result;
  --select j Result from @json ;
commit transaction;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() as Result;--AS ErrorMessage;

ROLLBACK TRANSACTION;
END CATCH
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ObtenerInfoCliente_AG_VET]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 28/07/2020
  Obtener la informacion del cliente para el sitio WEB de AGRICOLA Y VETERINARIA 


  Modif MPINTO 13/10/2020
  Se modifica procedimiento para agregar consulta para obtener los clientes de GT
  */
CREATE procedure [SAG].[WS_ObtenerInfoCliente_AG_VET] 
(
	@correo char(255)	
)as 
BEGIN TRY
BEGIN TRANSACTION 

DECLARE @CodPais nchar(2) = '';


SELECT @CodPais = coalesce(SUBSTRING(D_.CodCliente,0,3),'N/A')
  from SAGRI_MOVIL.dbo.WS_Cliente D_  
  where d_.Correo = @correo  
	;

	IF @CodPais = 'SV'
	BEGIN
/*INFORMACION CLIENTE*/
SELECT COALESCE(
		(
		SELECT * FROM
		(SELECT 
			   RTRIM(C.CodCliente) codcliente, RTRIM(R.CUSTNAME) as nombre,
			   UPPER(SUBSTRING(R.CNTCPRSN,0,CHARINDEX(' ',R.CNTCPRSN,(LEN(R.CNTCPRSN)/2)))) Nombres,
			   UPPER(SUBSTRING( SUBSTRING(R.CNTCPRSN,(CHARINDEX(' ',R.CNTCPRSN,(LEN(R.CNTCPRSN)/2)))+1, len(R.CNTCPRSN)),0,CHARINDEX(' ', SUBSTRING(R.CNTCPRSN,(CHARINDEX(' ',R.CNTCPRSN,(LEN(R.CNTCPRSN)/2)))+1, len(R.CNTCPRSN)),(LEN(R.CNTCPRSN)/2)))) Apellidos,
			   RTRIM(C.Correo) correo,
			   RTRIM(R.PHONE1) telefono1, RTRIM(R.PHONE2) telefono2, RTRIM(R.PHONE3) telefono3,--STRING_ESCAPE(RTRIM(Telefono),'json') phone,
			   RTRIM(R.CNTCPRSN) PersonaContacto, RTRIM(R.COMMENT2) dui, 
			   CASE WHEN R.USERDEF1 = 'CCF' THEN RTRIM(R.USERDEF2) ELSE '' END iva_card,
			   CASE WHEN R.USERDEF1 = 'CCF' THEN RTRIM(R.TXRGNNUM) ELSE '' END registry,
			   RTRIM(C.Comentarios) additional_data, RTRIM(R.USERDEF1) tipo_doc, 
			   CASE WHEN R.USERDEF1 = 'FAC' THEN RTRIM(R.USERDEF2) ELSE '' END nit,
			   rtrim(r.COUNTRY) pais, RTRIM(R.SLPRSNID) CodVendedor,
			    CASE 
					WHEN LA.CLASECLIENTE = 'CLINICAS VETERINARIAS' THEN 1
					--WHEN LA.CLASECLIENTE = 'CLINICAS VETERINARIAS' OR C.CODCLIENTE = 'SVC0158' OR C.CODCLIENTE = 'SVC0747'  THEN 1
			       ELSE 0 END AS Envio,
			   (
			   SELECT
				   RTRIM(D.ADRSCODE) 'id', RTRIM(D.ADDRESS2) 'address', 
				   RTRIM(D.STATE) 'state', RTRIM(D.CITY) 'province'		  
				    -- CASE WHEN C.CodCliente = 'SVC0158' THEN 'SAN SALVADOR' ELSE RTRIM(D.STATE) END 'state', 
				  --  CASE WHEN C.CodCliente = 'SVC0158' THEN 'SAN SALVADOR' ELSE RTRIM(D.CITY) END 'province'
			   FROM GPSAG.dbo.RM00102 D
			  WHERE C.CodCliente = D.CUSTNMBR
			  FOR JSON PATH
			   ) addresses
		  FROM SAGRI_MOVIL.dbo.WS_Cliente C
		 INNER JOIN GPSAG.dbo.RM00101 R
			ON C.CodCliente = R.CUSTNMBR
			/*Agregado mpinto 08/09/2020 */
		 INNER JOIN SAGRI_MOVIL.DBO.[SAGPreciosEnLineaAgrop] LA /*VETERINARIA*/
			ON C.CODCLIENTE = LA.CODCLIENTE
		  where C.Correo = @correo
		  UNION
		  SELECT 
			   RTRIM(C.CodCliente) codcliente, RTRIM(R.CUSTNAME) as nombre,
			   UPPER(SUBSTRING(R.CNTCPRSN,0,CHARINDEX(' ',R.CNTCPRSN,(LEN(R.CNTCPRSN)/2)))) Nombres,
			   UPPER(SUBSTRING( SUBSTRING(R.CNTCPRSN,(CHARINDEX(' ',R.CNTCPRSN,(LEN(R.CNTCPRSN)/2)))+1, len(R.CNTCPRSN)),0,CHARINDEX(' ', SUBSTRING(R.CNTCPRSN,(CHARINDEX(' ',R.CNTCPRSN,(LEN(R.CNTCPRSN)/2)))+1, len(R.CNTCPRSN)),(LEN(R.CNTCPRSN)/2)))) Apellidos,
			   RTRIM(C.Correo) correo,
			   RTRIM(R.PHONE1) telefono1, RTRIM(R.PHONE2) telefono2, RTRIM(R.PHONE3) telefono3,--STRING_ESCAPE(RTRIM(Telefono),'json') phone,
			   RTRIM(R.CNTCPRSN) PersonaContacto, RTRIM(R.COMMENT2) dui, 
			   CASE WHEN R.USERDEF1 = 'CCF' THEN RTRIM(R.USERDEF2) ELSE '' END iva_card,
			   CASE WHEN R.USERDEF1 = 'CCF' THEN RTRIM(R.TXRGNNUM) ELSE '' END registry,
			   RTRIM(C.Comentarios) additional_data, RTRIM(R.USERDEF1) tipo_doc, 
			   CASE WHEN R.USERDEF1 = 'FAC' THEN RTRIM(R.USERDEF2) ELSE '' END nit,
			   rtrim(r.COUNTRY) pais, RTRIM(R.SLPRSNID) CodVendedor,
			    CASE 
					WHEN LA.CLASECLIENTE = 'CLINICAS VETERINARIAS' THEN 1
					--WHEN LA.CLASECLIENTE = 'CLINICAS VETERINARIAS' OR C.CODCLIENTE = 'SVC0158' OR C.CODCLIENTE = 'SVC0747' THEN 1
			       ELSE 0 END AS Envio,
			   (
			   SELECT
				   RTRIM(D.ADRSCODE) 'id', RTRIM(D.ADDRESS2) 'address', 
				   RTRIM(D.STATE) 'state', RTRIM(D.CITY) 'province'		  
				   --  CASE WHEN C.CodCliente = 'SVC0158' OR C.CODCLIENTE = 'SVC0747' THEN 'SAN SALVADOR' ELSE RTRIM(D.STATE) END 'state', 
				    --CASE WHEN C.CodCliente = 'SVC0158' OR C.CODCLIENTE = 'SVC0747' THEN 'SAN SALVADOR' ELSE RTRIM(D.CITY) END 'province'
			   FROM GPSAG.dbo.RM00102 D
			  WHERE C.CodCliente = D.CUSTNMBR
			  FOR JSON PATH
			   ) addresses
		  FROM SAGRI_MOVIL.dbo.WS_Cliente C
		 INNER JOIN GPSAG.dbo.RM00101 R
			ON C.CodCliente = R.CUSTNMBR
			/*Agregado mpinto 08/09/2020 */
		 INNER JOIN SAGRI_MOVIL.DBO.[SAGPreciosEnLineaAgropA] LA /*AGROPECUARIA*/
			ON C.CODCLIENTE = LA.CODCLIENTE
		  where C.Correo = @correo) AS C
		  FOR JSON PATH, INCLUDE_NULL_VALUES
		  ), '') Result;
	END
	ELSE IF @CodPais = 'GT'
	BEGIN
/*INFORMACION CLIENTE*/
SELECT COALESCE(
		(
		SELECT * FROM
		(SELECT 
			   RTRIM(C.CodCliente) codcliente, RTRIM(R.CUSTNAME) as nombre,
			   UPPER(SUBSTRING(R.CNTCPRSN,0,CHARINDEX(' ',R.CNTCPRSN,(LEN(R.CNTCPRSN)/2)))) Nombres,
			   UPPER(SUBSTRING( SUBSTRING(R.CNTCPRSN,(CHARINDEX(' ',R.CNTCPRSN,(LEN(R.CNTCPRSN)/2)))+1, len(R.CNTCPRSN)),0,CHARINDEX(' ', SUBSTRING(R.CNTCPRSN,(CHARINDEX(' ',R.CNTCPRSN,(LEN(R.CNTCPRSN)/2)))+1, len(R.CNTCPRSN)),(LEN(R.CNTCPRSN)/2)))) Apellidos,
			   RTRIM(C.Correo) correo,
			   RTRIM(R.PHONE1) telefono1, RTRIM(R.PHONE2) telefono2, RTRIM(R.PHONE3) telefono3,--STRING_ESCAPE(RTRIM(Telefono),'json') phone,
			   RTRIM(R.CNTCPRSN) PersonaContacto, RTRIM(R.COMMENT2) dui, 
			   CASE WHEN R.USERDEF1 = 'CCF' THEN RTRIM(R.USERDEF2) ELSE '' END iva_card,
			   CASE WHEN R.USERDEF1 = 'CCF' THEN RTRIM(R.TXRGNNUM) ELSE '' END registry,
			   RTRIM(C.Comentarios) additional_data, RTRIM(R.USERDEF1) tipo_doc, 
			   CASE WHEN R.USERDEF1 = 'FAC' THEN RTRIM(R.USERDEF2) ELSE '' END nit,
			   rtrim(r.COUNTRY) pais, RTRIM(R.SLPRSNID) CodVendedor,
			    CASE 
					WHEN LA.CLASECLIENTE = 'CLINICAS VETERINARIAS' THEN 1
					--WHEN LA.CLASECLIENTE = 'CLINICAS VETERINARIAS' OR C.CODCLIENTE = 'SVC0158' OR C.CODCLIENTE = 'SVC0747'  THEN 1
			       ELSE 0 END AS Envio,
			   (
			   SELECT
				   RTRIM(D.ADRSCODE) 'id', RTRIM(D.ADDRESS2) 'address', 
				   RTRIM(D.STATE) 'state', RTRIM(D.CITY) 'province'		  
				    -- CASE WHEN C.CodCliente = 'SVC0158' THEN 'SAN SALVADOR' ELSE RTRIM(D.STATE) END 'state', 
				  --  CASE WHEN C.CodCliente = 'SVC0158' THEN 'SAN SALVADOR' ELSE RTRIM(D.CITY) END 'province'
			   FROM NUTGT.dbo.RM00102 D
			  WHERE C.CodCliente = D.CUSTNMBR
			  FOR JSON PATH
			   ) addresses
		  FROM SAGRI_MOVIL.dbo.WS_Cliente C
		 INNER JOIN NUTGT.dbo.RM00101 R
			ON C.CodCliente = R.CUSTNMBR
			/*Agregado mpinto 08/09/2020 */
		 INNER JOIN SAGRI_MOVIL.DBO.[SAGPreciosEnLineaAgrop] LA /*VETERINARIA*/
			ON C.CODCLIENTE = LA.CODCLIENTE
		  where C.Correo = @correo
		  UNION
		  SELECT 
			   RTRIM(C.CodCliente) codcliente, RTRIM(R.CUSTNAME) as nombre,
			   UPPER(SUBSTRING(R.CNTCPRSN,0,CHARINDEX(' ',R.CNTCPRSN,(LEN(R.CNTCPRSN)/2)))) Nombres,
			   UPPER(SUBSTRING( SUBSTRING(R.CNTCPRSN,(CHARINDEX(' ',R.CNTCPRSN,(LEN(R.CNTCPRSN)/2)))+1, len(R.CNTCPRSN)),0,CHARINDEX(' ', SUBSTRING(R.CNTCPRSN,(CHARINDEX(' ',R.CNTCPRSN,(LEN(R.CNTCPRSN)/2)))+1, len(R.CNTCPRSN)),(LEN(R.CNTCPRSN)/2)))) Apellidos,
			   RTRIM(C.Correo) correo,
			   RTRIM(R.PHONE1) telefono1, RTRIM(R.PHONE2) telefono2, RTRIM(R.PHONE3) telefono3,--STRING_ESCAPE(RTRIM(Telefono),'json') phone,
			   RTRIM(R.CNTCPRSN) PersonaContacto, RTRIM(R.COMMENT2) dui, 
			   CASE WHEN R.USERDEF1 = 'CCF' THEN RTRIM(R.USERDEF2) ELSE '' END iva_card,
			   CASE WHEN R.USERDEF1 = 'CCF' THEN RTRIM(R.TXRGNNUM) ELSE '' END registry,
			   RTRIM(C.Comentarios) additional_data, RTRIM(R.USERDEF1) tipo_doc, 
			   CASE WHEN R.USERDEF1 = 'FAC' THEN RTRIM(R.USERDEF2) ELSE '' END nit,
			   rtrim(r.COUNTRY) pais, RTRIM(R.SLPRSNID) CodVendedor,
			    CASE 
					WHEN LA.CLASECLIENTE = 'CLINICAS VETERINARIAS' THEN 1
					--WHEN LA.CLASECLIENTE = 'CLINICAS VETERINARIAS' OR C.CODCLIENTE = 'SVC0158' OR C.CODCLIENTE = 'SVC0747' THEN 1
			       ELSE 0 END AS Envio,
			   (
			   SELECT
				   RTRIM(D.ADRSCODE) 'id', RTRIM(D.ADDRESS2) 'address', 
				   RTRIM(D.STATE) 'state', RTRIM(D.CITY) 'province'		  
				   --  CASE WHEN C.CodCliente = 'SVC0158' OR C.CODCLIENTE = 'SVC0747' THEN 'SAN SALVADOR' ELSE RTRIM(D.STATE) END 'state', 
				    --CASE WHEN C.CodCliente = 'SVC0158' OR C.CODCLIENTE = 'SVC0747' THEN 'SAN SALVADOR' ELSE RTRIM(D.CITY) END 'province'
			   FROM NUTGT.dbo.RM00102 D
			  WHERE C.CodCliente = D.CUSTNMBR
			  FOR JSON PATH
			   ) addresses
		  FROM SAGRI_MOVIL.dbo.WS_Cliente C
		 INNER JOIN NUTGT.dbo.RM00101 R
			ON C.CodCliente = R.CUSTNMBR
			/*Agregado mpinto 08/09/2020 */
		 INNER JOIN SAGRI_MOVIL.DBO.[SAGPreciosEnLineaAgropA] LA /*AGROPECUARIA*/
			ON C.CODCLIENTE = LA.CODCLIENTE
		  where C.Correo = @correo) AS C
		  FOR JSON PATH, INCLUDE_NULL_VALUES
		  ), '') Result;
	END
	ELSE
	SELECT 'NO DATA' Result;
commit transaction;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() as Result;--AS ErrorMessage;

ROLLBACK TRANSACTION;
END CATCH
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ObtenerPedidosaGenerar]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*Creado mpinto 17/01/2023
Procedimiento creado para obtener todas los documentos a emitir en linea (FACTURAS, NOTAS DE CREDITO, NOTAS DE DEBITO, ETC..)*/
--exec SAGRI_MOVIL.SAG.[WS_ObtenerPedidosaGenerar_PRU] 'SV'
CREATE             PROCEDURE [SAG].[WS_ObtenerPedidosaGenerar] 
(		
	@CodPais varchar(2),
	@bd varchar(25) = null
)as 
BEGIN  
DECLARE @NumCorrelativo bigint;
DECLARE @Correlativo varchar(15);
DECLARE @LENCorrelativo int;

SET NOCOUNT ON;
SET @bd = 'GPSAG';

 IF @bd = 'GPSAG'
	 BEGIN


SELECT top 100 dbo.PedidoEncabezado.NumPedido, dbo.PedidoEncabezado.CodCliente,(select top 1rtrim(ltrim(CUSTNAME)) FROM GPSAG.dbo.RM00101 where CUSTNMBR=dbo.PedidoEncabezado.CodCliente) NombreCliente, dbo.PedidoEncabezado.CodVendedor
,convert(nvarchar, dbo.PedidoEncabezado.FechaPedido,103) FechaPedido, convert(nvarchar, dbo.PedidoEncabezado.FechaEntrega,103)  FechaEntrega, dbo.PedidoEncabezado.TotalPedido
, dbo.PedidoEncabezado.Observacion, dbo.PedidoEncabezado.Pais, dbo.PedidoEncabezado.Tpago, dbo.PedidoEncabezado.IdDireccion
, COUNT(dbo.PedidoDetalle.CodProducto) AS Filas 
FROM dbo.PedidoEncabezado 
INNER JOIN dbo.PedidoDetalle ON dbo.PedidoEncabezado.NumPedido = dbo.PedidoDetalle.NumPedido
Where (Rtrim(Pais)='EL SALVADOR') 
and  dbo.PedidoEncabezado.FechaPedido>='2023-03-01'
GROUP BY dbo.PedidoEncabezado.NumPedido, dbo.PedidoEncabezado.CodCliente
, dbo.PedidoEncabezado.CodVendedor, dbo.PedidoEncabezado.FechaPedido
, dbo.PedidoEncabezado.FechaEntrega, dbo.PedidoEncabezado.TotalPedido
, dbo.PedidoEncabezado.Observacion, dbo.PedidoEncabezado.Pais
, dbo.PedidoEncabezado.Tpago, dbo.PedidoEncabezado.IdDireccion 

ORDER BY dbo.PedidoEncabezado.NumPedido desc, dbo.PedidoEncabezado.FechaPedido, dbo.PedidoEncabezado.CodCliente

	 END	
END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ObtenerPedidosaGenerar_PRU]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*Creado mpinto 17/01/2023
Procedimiento creado para obtener todas los documentos a emitir en linea (FACTURAS, NOTAS DE CREDITO, NOTAS DE DEBITO, ETC..)*/
--exec SAGRI_MOVIL.SAG.[WS_ObtenerPedidosaGenerar_PRU] 'SV'
CREATE                 PROCEDURE [SAG].[WS_ObtenerPedidosaGenerar_PRU] 
(		
	@CodPais varchar(2),
	@bd varchar(25) = null
)as 
BEGIN  
DECLARE @NumCorrelativo bigint;
DECLARE @Correlativo varchar(15);
DECLARE @LENCorrelativo int;

SET NOCOUNT ON;
SET @bd = 'GPSAG';

 IF @bd = 'GPSAG'
	 BEGIN


SELECT top 100 dbo.PedidoEncabezadoH.NumPedido, dbo.PedidoEncabezadoH.CodCliente,(select top 1rtrim(ltrim(CUSTNAME)) FROM GPSAG.dbo.RM00101 where CUSTNMBR=dbo.PedidoEncabezadoH.CodCliente) NombreCliente, dbo.PedidoEncabezadoH.CodVendedor
,convert(nvarchar, dbo.PedidoEncabezadoH.FechaPedido,103) FechaPedido, convert(nvarchar, dbo.PedidoEncabezadoH.FechaEntrega,103)  FechaEntrega, dbo.PedidoEncabezadoH.TotalPedido
, dbo.PedidoEncabezadoH.Observacion, dbo.PedidoEncabezadoH.Pais, dbo.PedidoEncabezadoH.Tpago, dbo.PedidoEncabezadoH.IdDireccion
, COUNT(dbo.PedidoDetalleH.CodProducto) AS Filas 
FROM dbo.PedidoEncabezadoH 
INNER JOIN dbo.PedidoDetalleH ON dbo.PedidoEncabezadoH.NumPedido = dbo.PedidoDetalleH.NumPedido
Where (Rtrim(Pais)='EL SALVADOR') 
and  dbo.PedidoEncabezadoH.FechaPedido>='2023-03-01'
and  dbo.PedidoEncabezadoH.NumPedido='147794'
GROUP BY dbo.PedidoEncabezadoH.NumPedido, dbo.PedidoEncabezadoH.CodCliente
, dbo.PedidoEncabezadoH.CodVendedor, dbo.PedidoEncabezadoH.FechaPedido
, dbo.PedidoEncabezadoH.FechaEntrega, dbo.PedidoEncabezadoH.TotalPedido
, dbo.PedidoEncabezadoH.Observacion, dbo.PedidoEncabezadoH.Pais
, dbo.PedidoEncabezadoH.Tpago, dbo.PedidoEncabezadoH.IdDireccion 

ORDER BY dbo.PedidoEncabezadoH.NumPedido desc, dbo.PedidoEncabezadoH.FechaPedido, dbo.PedidoEncabezadoH.CodCliente

	 END	
END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ObtenerProdHondaSensitive]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*Creado mpinto 21/05/2020
  Proccedimiento para obtener uno o varios productos a traves de una busqueda sensitiva */
CREATE PROCEDURE [SAG].[WS_ObtenerProdHondaSensitive]  
@CodOrNomProd nvarchar(25)
AS    
BEGIN    
    
 SET NOCOUNT ON;    
   
SELECT [CodProducto]
      ,[NomProducto]
	  ,CONVERT(INT,[Existencia]) [Existencia]
	  ,[Peso]
      ,convert(numeric(8,2),round([PrecioVenta],2)) PrecioVenta
      ,[Pais]      
  FROM SAGRI_MOVIL.[dbo].[SAGPreciosEnLinea]
  where (CodProducto LIKE '%'+ @CodOrNomProd+ '%' OR  NomProducto  LIKE '%'+ @CodOrNomProd+ '%')

END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ObtenerProductosAgricola]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*Creado mpinto 27/07/2020
  Proccedimiento para obtener todos los productos de la division Agricola*/
CREATE PROCEDURE [SAG].[WS_ObtenerProductosAgricola]
@codpais char(2)
AS    
BEGIN    
/*OBTENER PRECIOS DE EL SALVADOR*/
    IF @codpais = 'SV'
	BEGIN
		SELECT [CodCliente] /*La informacion del cliente se devolvera en otra funcion*/
			  ,[CodProd]
			  ,RTRIM(IV.ITEMDESC) DescProducto
			  ,[Precio]
			  ,COALESCE([Descripcion],'-') Descripcion		
		 FROM [SAGRI_MOVIL].[dbo].[WS_ClienteListPrecio_AGRI] LAG
	    INNER JOIN GPSAG.DBO.IV00101 IV
	       ON LAG.CodProd = IV.ITEMNMBR
	    WHERE LAG.CodPais = @codpais
	;
	END
	/*OBTENER PRECIOS DE GUATEMALA*/
	ELSE IF @codpais = 'GT'
	BEGIN
		SELECT [CodCliente] /*La informacion del cliente se devolvera en otra funcion*/
			  ,[CodProd]
			  ,RTRIM(IV.ITEMDESC) DescProducto
			  ,[Precio]
			  ,COALESCE([Descripcion],'-') Descripcion		
		 FROM [SAGRI_MOVIL].[dbo].[WS_ClienteListPrecio_AGRI] LAG
	    INNER JOIN NUTGT.DBO.IV00101 IV
	       ON LAG.CodProd = IV.ITEMNMBR
	    WHERE LAG.CodPais = @codpais
	;
	END

--ELSE IF @codpais = 'GT'
--	BEGIN
--		SELECT 'NO DATA';
--	END

END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ObtenerProductosAgricolaxCli]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*Creado mpinto 27/07/2020
  Procedimiento para obtener la informacion de las listas de precio de un Cliente 
  de la división de Agricola */

/*Modificado mpinto 11/08/2020
Se agrega campo peso, ya que se tomara en cuenta para envios a domicilio

Modificado mpinto 14/10/2020
Se agrega consulta para obtener datos de GT*/
CREATE PROCEDURE [SAG].[WS_ObtenerProductosAgricolaxCli]  

@codcli char(15),
@codpais char(2)
AS    
BEGIN    
    
 SET NOCOUNT ON;  
 /*OBTENER PRECIOS DE EL SALVADOR*/
IF @codpais = 'SV'
	BEGIN
		SELECT [CodCliente] /*La informacion del cliente se devolvera en otra funcion*/
			  ,[CodProd]
			  ,RTRIM(IV.ITEMDESC) DescProducto
			  ,[Precio]
			  ,COALESCE([Descripcion],'-') Descripcion
			  , cast(inv.existencia as int) Inventario
			  , INV.Peso 
			--  ,[CodPais]   
		  FROM [SAGRI_MOVIL].[dbo].[WS_ClienteListPrecio_AGRI] LAG
		 INNER JOIN GPSAG.DBO.IV00101 IV
			on LAG.CodProd = IV.ITEMNMBR
			/*INICIA AGREGADO MPINTO 10/08/2020 */
	INNER JOIN [SAGRI_MOVIL].[dbo].SAGExistenciasAgropecuariaWEB INV
		  ON lag.CodProd = INV.CodProducto
		  /*FIN AGREGADO MPINTO 10/08/2020 */
		 where CodCliente = @codcli
	END
	/*OBTENER PRECIOS DE GUATEMALA*/
ELSE IF @codpais = 'GT'
	BEGIN
	/*Agregado mpinto 14/10/2020 */
		SELECT [CodCliente]
			  ,[CodProd]
			  ,RTRIM(IV.ITEMDESC) DescProducto
			  ,[Precio]
			  ,COALESCE([Descripcion],'-') Descripcion
			  , cast(inv.existencia as int) Inventario
			  , INV.Peso 
		  FROM [SAGRI_MOVIL].[dbo].[WS_ClienteListPrecio_AGRI] LAG
		 INNER JOIN NUTGT.DBO.IV00101 IV
			on LAG.CodProd = IV.ITEMNMBR			
	INNER JOIN [SAGRI_MOVIL].[dbo].SAGExistenciasAgropecuariaWEB INV
		  ON lag.CodProd = INV.CodProducto		  
		 where CodCliente = @codcli
	END
	--ELSE IF @codpais = 'GT'
	--BEGIN
	--	SELECT 'NO DATA';
	--END


END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ObtenerProductosAgricolaxClixProd]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*Creado mpinto 27/05/72020
  Procedimiento para obtener la informacion de las listas de precio de un Cliente 
  de la división de Agricola */

  /*Modificado mpinto 11/08/2020
Se agrega campo peso, ya que se tomara en cuenta para envios a domicilio*/
CREATE PROCEDURE [SAG].[WS_ObtenerProductosAgricolaxClixProd]  
@codcli char(15),
@codpais char(2),
@codprod char(15)
AS    
BEGIN TRY
BEGIN TRANSACTION 
    
 SET NOCOUNT ON;  
 /*OBTENER PRECIOS DE EL SALVADOR*/
IF @codpais = 'SV'
	BEGIN
		SELECT LAG.[CodCliente] /*La informacion del cliente se devolvera en otra funcion*/
			  ,LAG.[CodProd]
			  ,RTRIM(IV.ITEMDESC) DescProducto
			  --,RTRIM(cast([Precio] as char(20))) [Precio]
			  ,LAG.[Precio]
			  ,COALESCE([Descripcion],'-') Descripcion
			  , cast(inv.existencia as int) Inventario
			  , INV.Peso
			  --, RTRIM(aga.ClaseCliente) ClaseCliente /*Agregado mpinto 08/09/2020 Para identificar el establecimiento del cliente*/
			--  ,[CodPais]    
		  FROM [SAGRI_MOVIL].[dbo].[WS_ClienteListPrecio_AGRI] LAG
		 INNER JOIN GPSAG.DBO.IV00101 IV
			on LAG.CodProd = IV.ITEMNMBR
			   /*INICIA AGREGADO MPINTO 10/08/2020 */
	     INNER JOIN [SAGRI_MOVIL].[dbo].SAGExistenciasAgropecuariaWEB INV
		    ON lag.CodProd = INV.CodProducto
	   /*  INNER JOIN [SAGRI_MOVIL].[dbo].SAGPreciosEnLineaAgropA AGA
	    	ON LAG.CodCliente = AGA.CodCliente
		   AND LAG.CodProd = AGA.CodProd*/
		  /*FIN AGREGADO MPINTO 10/08/2020 */
		 where LAG.CodCliente = @codcli
		   and LAG.CodProd = @codprod
		   --FOR JSON PATH, INCLUDE_NULL_VALUES;
	END
	/*OBTENER PRECIOS DE GUATEMALA*/
ELSE IF @codpais = 'GT'
	BEGIN
	/*Agregado mpinto 14/10/2020 */
		SELECT LAG.[CodCliente] /*La informacion del cliente se devolvera en otra funcion*/
			  ,LAG.[CodProd]
			  ,RTRIM(IV.ITEMDESC) DescProducto			  
			  ,LAG.[Precio]
			  ,COALESCE([Descripcion],'-') Descripcion
			  , cast(inv.existencia as int) Inventario
			  , INV.Peso
		  FROM [SAGRI_MOVIL].[dbo].[WS_ClienteListPrecio_AGRI] LAG
		 INNER JOIN NUTGT.DBO.IV00101 IV
			on LAG.CodProd = IV.ITEMNMBR			   
	     INNER JOIN [SAGRI_MOVIL].[dbo].SAGExistenciasAgropecuariaWEB INV
		    ON lag.CodProd = INV.CodProducto	   
		 where LAG.CodCliente = @codcli
		   and LAG.CodProd = @codprod
	END
ELSE 
	SELECT 'NO DATA' Result;

commit transaction;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() as Result;--AS ErrorMessage;

ROLLBACK TRANSACTION;
END CATCH
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ObtenerProductosHonda]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*Creado mpinto 12/05/2020
  Proccedimiento para obtener todos los productos honda*/
CREATE PROCEDURE [SAG].[WS_ObtenerProductosHonda]  
AS    
BEGIN    
    
 SET NOCOUNT ON;    
   
SELECT [CodProducto]
      ,[NomProducto]
      /*,[Bodega]*/
      ,case when existencia >=0 then CONVERT(INT,[Existencia]) else 0 end as [Existencia]
      /*,[Pbase]*/
      /*,[Costo]*/
      ,[Peso]
      /*,[ListaPrecio]*/
      /*,[UOMPRICE]*/
      --,convert(numeric(8,2),round([PrecioVenta],2)) PrecioVenta
	  --,convert(numeric(8,2),round([PrecioVenta],2)) PrecioVenta
	  /*Agregado mpinto 03/07/2020 Se enviaran datos con la cantidad de decimales que corresponden para mayor exactitud de calculo */
	  /*,CASE WHEN CantDecimales >= 5 then convert(numeric(15,5),round([PrecioVenta],5))
	        WHEN CantDecimales = 4 then convert(numeric(15,4),round([PrecioVenta],4))
			WHEN CantDecimales = 3 then convert(numeric(15,3),round([PrecioVenta],3))
			WHEN CantDecimales = 2 then convert(numeric(15,2),round([PrecioVenta],2))
			WHEN CantDecimales = 1 then convert(numeric(15,1),round([PrecioVenta],1))
			END AS numeric*/
			,CASE WHEN CantDecimales >= 5 then convert(float,round([PrecioVenta],5))
	        WHEN CantDecimales = 4 then convert(float,round([PrecioVenta],4))
			WHEN CantDecimales = 3 then convert(float,round([PrecioVenta],3))
			WHEN CantDecimales = 2 then convert(float,round([PrecioVenta],2))
			WHEN CantDecimales = 1 then convert(float,round([PrecioVenta],1))
			END AS PrecioVenta
	  /*,CASE WHEN CantDecimales >= 5 then STR(convert(numeric(15,5),round([PrecioVenta],5)),len(convert(numeric(15,5),round([PrecioVenta],5))),5)
	        WHEN CantDecimales = 4 then STR(convert(numeric(15,4),round([PrecioVenta],4)),len(convert(numeric(15,4),round([PrecioVenta],2))),4)
	        WHEN CantDecimales = 3 then STR(convert(numeric(15,3),round([PrecioVenta],3)),len(convert(numeric(15,3),round([PrecioVenta],3))),3)
	        WHEN CantDecimales = 2 then STR(convert(numeric(15,2),round([PrecioVenta],2)),len(convert(numeric(15,2),round([PrecioVenta],2))),2)
	        WHEN CantDecimales = 1 then STR(convert(numeric(15,1),round([PrecioVenta],1)),len(convert(numeric(15,1),round([PrecioVenta],1))),1)
	   END as string
	  ,CantDecimales*/
	  --,len(convert(numeric(15,5),round([PrecioVenta],5)))
      ,[Pais]
      /*,[TodoPublico]
      ,[Oferta]*/
  FROM [dbo].[SAGPreciosEnLinea]

END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ObtenerProductosHondaxCod]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*Creado mpinto 12/05/2020
  Proccedimiento para obtener un producto honda por codigo*/
CREATE PROCEDURE [SAG].[WS_ObtenerProductosHondaxCod]  
@CodProd nvarchar(25)
AS    
BEGIN    
    
 SET NOCOUNT ON;    
   
SELECT [CodProducto]
      ,[NomProducto]
      /*,[Bodega]*/
      ,CONVERT(INT,[Existencia]) [Existencia]
      /*,[Pbase]*/
      /*,[Costo]*/
      ,[Peso]
      /*,[ListaPrecio]*/
      /*,[UOMPRICE]*/
      ,convert(numeric(8,2),round([PrecioVenta],2)) PrecioVenta
      ,[Pais]
      /*,[TodoPublico]
      ,[Oferta]*/
  FROM SAGRI_MOVIL.[dbo].[SAGPreciosEnLinea]
  where CodProducto = @CodProd
  

END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ObtenerProductosVeterinaria]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*Creado mpinto 22/07/2020
  Procedimiento para obtner todas las listas de precio de Veterinaria*/
CREATE PROCEDURE [SAG].[WS_ObtenerProductosVeterinaria]  
@codpais char(2)
AS    
BEGIN    
    
 SET NOCOUNT ON;  
 /*OBTENER PRECIOS DE EL SALVADOR*/  
IF @codpais = 'SV'
	BEGIN
	 SELECT[CodCliente] /*La informaciona del cliente se obtendra en otra funcion*/
		  ,[CUSTNAME] NombreCli
		  ,[CodProd]
		  ,[Cantidad]
		  ,[PrecioUOferta]
		 -- ,[CodPais]
		  ,[Clase]
		  ,COALESCE([DescListPre],'-') [DescListPre]
	  FROM [SAGRI_MOVIL].[dbo].[SAGPreciosEnLineaAgrop];
	END

	/*OBTENER PRECIOS DE GUATEMALA*/
ELSE IF @codpais = 'GT'
	BEGIN
		SELECT 'NO DATA';
	END

END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ObtenerProductosVeterinariaxCli]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*Creado mpinto 27/05/72020
  Procedimiento para obtener la informacion de las listas de precio de Cliente 
  de la división de veterinaria 
  
  Modificado mpinto 30/07/2020 
  - Se realiza cast al json, ya que esta devolviendo el texto incompleto debido a la cantidad maxima de caracteres
  - Ademas se agrega una variable del tipo varchar(max) para almacenar el json devuelto y si este es null devuela la respuesta "NO DATA" para evitar excepciones en el webservice

  Modificado mpinto 13/10/2020
  - Modificacion de procedimiento [WS_ObtenerProductosVeterinariaxCli] el cual se deja un solo query ya que la vista que esta consultando se manejan los dos paises GT Y SV
  */


CREATE PROCEDURE [SAG].[WS_ObtenerProductosVeterinariaxCli]  
@codcli char(15),
@codpais char(2)
AS    
BEGIN    
    
 SET NOCOUNT ON;  
 DECLARE @json varchar(max);
-- /*OBTENER PRECIOS DE EL SALVADOR*/  
--IF @codpais = 'SV'
--	BEGIN
--	/*Inicia Agregado mpinto 29/07/2020  enviar json estructurado solo como dato principal cod producto y anidadas listas de precio*/
--	select @json= CAST(( /*Agregado mpitno 30072020*/
--		SELECT RTRIM(C.[CodProd]) [CodProd],
--			   (  SELECT D.[Cantidad],D.[PrecioUOferta] PrecioOferta,RTRIM([CodLstPrec]) [CodLstPrec],
--						 RTRIM(D.[Clase]) [Clase],COALESCE(RTRIM(D.[DescListPre]),'-') [DescListPre]
--					FROM [SAGRI_MOVIL].[dbo].[SAGPreciosEnLineaAgrop] D
--				   Where D.CodCliente = C.CODCLIENTE   
--					 AND D.CodProd = C.CodProd
--					 FOR JSON PATH
--				) ListasdePrecio		 
--		FROM [SAGRI_MOVIL].[dbo].[SAGPreciosEnLineaAgrop] C
--		where CodCliente = @codcli
--		group by CodCliente, CodProd
--		 FOR JSON PATH, INCLUDE_NULL_VALUES
--		 	) as varchar(max));
--  /*Fin Agregado mpinto 29/07/2020  enviar json estructurado solo como dato principal cod producto y anidadas listas de precio*/

--	/* COMENTADO MPINTO 29072020
--		 SELECT[CodCliente]
--		  ,[CUSTNAME] NombreCli
--		  ,[CodProd]
--		  ,[Cantidad]
--		  ,[PrecioUOferta]
--		 -- ,[CodPais]
--		  ,[Clase]
--		  ,COALESCE([DescListPre],'-') [DescListPre]
--	  FROM [SAGRI_MOVIL].[dbo].[SAGPreciosEnLineaAgrop]
--	  where CodCliente = @codcli;
--	  */
--	  SELECT coalesce(@json,'NO DATA');
--	END
	
--	/*OBTENER PRECIOS DE GUATEMALA*/
--ELSE IF @codpais = 'GT'
--	BEGIN
--	/*Inicia Agregado mpinto 13/10/2020  enviar json estructurado solo como dato principal cod producto y anidadas listas de precio para GT*/
--	select @json= CAST((
--		SELECT RTRIM(C.[CodProd]) [CodProd],
--			   (  SELECT D.[Cantidad],D.[PrecioUOferta] PrecioOferta,RTRIM([CodLstPrec]) [CodLstPrec],
--						 RTRIM(D.[Clase]) [Clase],COALESCE(RTRIM(D.[DescListPre]),'-') [DescListPre]
--					FROM [SAGRI_MOVIL].[dbo].[SAGPreciosEnLineaAgrop] D
--				   Where D.CodCliente = C.CODCLIENTE   
--					 AND D.CodProd = C.CodProd
--					 FOR JSON PATH
--				) ListasdePrecio		 
--		FROM [SAGRI_MOVIL].[dbo].[SAGPreciosEnLineaAgrop] C
--		where CodCliente = @codcli
--		group by CodCliente, CodProd
--		 FOR JSON PATH, INCLUDE_NULL_VALUES
--		 	) as varchar(max));
  
--	  SELECT coalesce(@json,'NO DATA');
--	END
--ELSE 
--	BEGIN
--		SELECT 'NO DATA';
--	END


select @json= CAST((
		SELECT RTRIM(C.[CodProd]) [CodProd],
			   (  SELECT D.[Cantidad],D.[PrecioUOferta] PrecioOferta,RTRIM([CodLstPrec]) [CodLstPrec],
						 RTRIM(D.[Clase]) [Clase],COALESCE(RTRIM(D.[DescListPre]),'-') [DescListPre]
					FROM [SAGRI_MOVIL].[dbo].[SAGPreciosEnLineaAgrop] D
				   Where D.CodCliente = C.CODCLIENTE   
					 AND D.CodProd = C.CodProd
					 FOR JSON PATH
				) ListasdePrecio		 
		FROM [SAGRI_MOVIL].[dbo].[SAGPreciosEnLineaAgrop] C
		where CodCliente = @codcli
		group by CodCliente, CodProd
		 FOR JSON PATH, INCLUDE_NULL_VALUES
		 	) as varchar(max));
  
	  SELECT coalesce(@json,'NO DATA');




END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ObtenerProductosVeterinariaxClixProd]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*Creado mpinto 29/07/72020
  Procedimiento para enviar la informacion de lista de precio para un producto y cliente en especifico, junto al inventario disponible*/

  /*Modificado mpinto 11/08/2020
Se agrega campo peso, ya que se tomara en cuenta para envios a domicilio

	Modificado mpinto 13/10/2020
Se agrega query para pais GT	
	*/
CREATE PROCEDURE [SAG].[WS_ObtenerProductosVeterinariaxClixProd]  
@codcli char(15),
@codpais char(2),
@codprod char(15)
AS    
BEGIN    
    
 SET NOCOUNT ON;  
 /*OBTENER PRECIOS EL SALVADOR*/  
IF @codpais = 'SV'
	BEGIN
	/*Inicia Agregado mpinto 29/07/2020  enviar json estructurado solo como dato principal cod producto y anidadas listas de precio*/
		SELECT RTRIM(C.[CodProd]) [CodProd], RTRIM(IV.ITEMDESC) ITEMDESC,  cast(inv.existencia as int) Inventario, INV.Peso,
		RTRIM(C.ClaseCliente) ClaseCliente, /*Agregado mpinto 08/09/2020 Para identificar el establecimiento del cliente*/
			   (  SELECT D.[Cantidad],D.[PrecioUOferta] PrecioOferta,RTRIM([CodLstPrec]) [CodLstPrec],
						 RTRIM(D.[Clase]) [Clase],COALESCE(RTRIM(D.[DescListPre]),'-') [DescListPre]						 
					FROM [SAGRI_MOVIL].[dbo].[SAGPreciosEnLineaAgrop] D					
				   Where D.CodCliente = C.CODCLIENTE   
					 AND D.CodProd = C.CodProd
					 FOR JSON PATH
				) ListasdePrecio		 
		FROM [SAGRI_MOVIL].[dbo].[SAGPreciosEnLineaAgrop] C
	   INNER JOIN GPSAG.dbo.IV00101 IV
	      ON C.CodProd = IV.ITEMNMBR
	   INNER JOIN [SAGRI_MOVIL].[dbo].SAGExistenciasAgropecuariaWEB INV
		  ON C.CodProd = INV.CodProducto	   
	   where c.CodCliente = @codcli
		 and c.CodProd = @codprod
	   group by C.CodCliente, C.CodProd, IV.ITEMDESC, INV.Existencia, INV.Peso, C.ClaseCliente /*Agregado mpinto 08/09/2020 Para identificar el establecimiento del cliente*/
		 FOR JSON PATH, INCLUDE_NULL_VALUES;
  /*Fin Agregado mpinto 29/07/2020  enviar json estructurado solo como dato principal cod producto y anidadas listas de precio*/

	/* COMENTADO MPINTO 29072020
		 SELECT[CodCliente]
		  ,[CUSTNAME] NombreCli
		  ,[CodProd]
		  ,[Cantidad]
		  ,[PrecioUOferta]
		 -- ,[CodPais]
		  ,[Clase]
		  ,COALESCE([DescListPre],'-') [DescListPre]
	  FROM [SAGRI_MOVIL].[dbo].[SAGPreciosEnLineaAgrop]
	  where CodCliente = @codcli;
	  */
	END

	/*OBTENER PRECIOS DE GUATEMALA*/
ELSE IF @codpais = 'GT'
	/*Agregado mpinto 13/10/2020 Se agrega consulta para GT*/
	BEGIN
	SELECT RTRIM(C.[CodProd]) [CodProd], RTRIM(IV.ITEMDESC) ITEMDESC,  cast(inv.existencia as int) Inventario, INV.Peso,
		RTRIM(C.ClaseCliente) ClaseCliente, /*Agregado mpinto 08/09/2020 Para identificar el establecimiento del cliente*/
			   (  SELECT D.[Cantidad],D.[PrecioUOferta] PrecioOferta,RTRIM([CodLstPrec]) [CodLstPrec],
						 RTRIM(D.[Clase]) [Clase],COALESCE(RTRIM(D.[DescListPre]),'-') [DescListPre]						 
					FROM [SAGRI_MOVIL].[dbo].[SAGPreciosEnLineaAgrop] D					
				   Where D.CodCliente = C.CODCLIENTE   
					 AND D.CodProd = C.CodProd
					 FOR JSON PATH
				) ListasdePrecio		 
		FROM [SAGRI_MOVIL].[dbo].[SAGPreciosEnLineaAgrop] C
	   INNER JOIN NUTGT.dbo.IV00101 IV
	      ON C.CodProd = IV.ITEMNMBR
	   INNER JOIN [SAGRI_MOVIL].[dbo].SAGExistenciasAgropecuariaWEB INV
		  ON C.CodProd = INV.CodProducto	   
	   where c.CodCliente = @codcli
		 and c.CodProd = @codprod
	   group by C.CodCliente, C.CodProd, IV.ITEMDESC, INV.Existencia, INV.Peso, C.ClaseCliente /*Agregado mpinto 08/09/2020 Para identificar el establecimiento del cliente*/
		 FOR JSON PATH, INCLUDE_NULL_VALUES;
		
	END

ELSE
	BEGIN
		SELECT 'NO DATA';
	END


END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ObtenerUsuariosAGR_VET]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 07/10/2020
  Procedimiento obtener la informacion del cliente para dar mantenimiento solamente a la contraseña 
  */
CREATE procedure [SAG].[WS_ObtenerUsuariosAGR_VET] 
(
	@CodPais char(15) = NULL 
	
)as 
BEGIN  

 SELECT RTRIM(C.CodCliente) codcliente, RTRIM(R.CUSTNAME) as nombre, RTRIM(C.CodCliente) +' ' + RTRIM(R.CUSTNAME) as CodyNom,
		UPPER(SUBSTRING(R.CNTCPRSN,0,CHARINDEX(' ',R.CNTCPRSN,(LEN(R.CNTCPRSN)/2)))) Nombres,
		UPPER(SUBSTRING( SUBSTRING(R.CNTCPRSN,(CHARINDEX(' ',R.CNTCPRSN,(LEN(R.CNTCPRSN)/2)))+1, len(R.CNTCPRSN)),0,CHARINDEX(' ', SUBSTRING(R.CNTCPRSN,(CHARINDEX(' ',R.CNTCPRSN,(LEN(R.CNTCPRSN)/2)))+1, len(R.CNTCPRSN)),(LEN(R.CNTCPRSN)/2)))) Apellidos,
		 CASE WHEN RTRIM(C.Correo)='' or RTRIM(C.Correo)IS NULL  THEN '-' ELSE RTRIM(C.Correo) END AS  correo,
		RTRIM(R.PHONE1) telefono1, RTRIM(R.PHONE2) telefono2, RTRIM(R.PHONE3) telefono3,--STRING_ESCAPE(RTRIM(Telefono),'json') phone,
		RTRIM(R.CNTCPRSN) PersonaContacto,
		CASE WHEN RTRIM(R.COMMENT2)=''THEN '-' ELSE RTRIM(R.COMMENT2) END AS dui, 
		CASE WHEN RTRIM(R.USERDEF2)=''THEN '-' ELSE RTRIM(R.USERDEF2) END AS iva_card, 
		--CASE WHEN R.USERDEF1 = 'CCF' THEN RTRIM(R.USERDEF2) ELSE '' END iva_card,
		CASE WHEN R.USERDEF1 = 'CCF' THEN RTRIM(R.TXRGNNUM) ELSE '' END registry,
		RTRIM(C.Comentarios) additional_data, RTRIM(R.USERDEF1) tipo_doc, 
		CASE WHEN R.USERDEF1 = 'FAC' THEN RTRIM(R.USERDEF2) ELSE '' END nit,
		rtrim(r.COUNTRY) pais, RTRIM(R.SLPRSNID) CodVendedor			  
   FROM SAGRI_MOVIL.dbo.WS_Cliente C
  INNER JOIN GPSAG.dbo.RM00101 R
	 ON C.CodCliente = R.CUSTNMBR
  WHERE C.CodCliente IS NOT NULL
   ;

END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_ObtenerUsuariosCCF]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 24/04/2020
  Procedimiento obtener la informacion del cliente para mostrar en pantalla a usuarios de credito y cobros con el fin
  de darle el proceso correspondiente para dar de alta como cliente en sistema GP
  */
CREATE procedure [SAG].[WS_ObtenerUsuariosCCF] 
(
	@CodPais char(15)
	
)as 
BEGIN  

SELECT RTRIM([IdClieCafeina]) [IdClieCafeina]
      ,UPPER(RTRIM([PrimerNombre]))  + ' '+ UPPER(RTRIM([PrimerApellido])) Nombre
	  ,UPPER(RTRIM([PrimerNombre])) [PrimerNombre]
	  ,UPPER(RTRIM([PrimerApellido]))[PrimerApellido]
      ,upper(RTRIM([Billing_Name])) [Billing_Name]
      /*,COALESCE(RTRIM([Dui]),'N/A') [Dui]
      ,COALESCE(RTRIM([Nit]),'N/A') [Nit]*/
      ,RTRIM(TarjetaIva) TarjetaIva  /*Agregado mpinto 23/06/2020 */      
	  ,RTRIM(NCR) NCR  /*Agregado mpinto 23/06/2020 */      
      ,RTRIM([Correo]) [Correo]
	  ,COALESCE(RTRIM([RutaCCF]),'') [RutaCCF]
	  ,COALESCE(RTRIM([Telefono]),'') [Telefono]
	  ,COALESCE(RTRIM([No_Celular]),'') [No_Celular]
	  ,COALESCE(RTRIM([Comentarios]),'') [Comentarios]
  FROM sagri_movil.[dbo].[WS_Cliente] C
 WHERE c.TipoDoc = 'CCF'
   AND C.CodCliente IS NULL
   AND c.CodPais = @CodPais
   ORDER BY IdClieCafeina
   ;

END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_PCrearMacroPedidos]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 08/05/2021
  Procedimiento para crear macro de ORDEN DE COMPRA en modulo de presupuestos y solicitudes
  */


CREATE                 procedure [SAG].[WS_PCrearMacroPedidos]
(
	@Pedido varchar(15),
	@CodPais varchar(2),
	@Direccon varchar(100), 
	@IdCliente varchar(15),
	@CodVendeor varchar(15)
)as 
BEGIN TRY
BEGIN TRANSACTION
BEGIN


DECLARE @Macro varchar(max) ='';

DECLARE @Count_Prov INT = 0;
DECLARE @Count_Analitica INT = 0;
DECLARE @ContadorLoop INT = 1;
DECLARE @codprov varchar(15);
   
   
   






	SELECT @Macro = @Macro + 

					'# DEXVERSION=16.00.0033.000 2 2'+ CHAR(13) + CHAR(10)+
					'CheckActiveWin dictionary ''default''  form ''SOP_Entry'' window ''SOP_Entry''' + CHAR(13) + CHAR(10)+
        '  TypeTo field ''Customer Number'' , ''' +@IdCliente  + ''''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Customer Name'''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Primary Shipto Address Code'''+ CHAR(13) + CHAR(10)+
        '  TypeTo field ''Primary Shipto Address Code'' , ''' +@Direccon  + ''''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Document Date'''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Location Code'''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Customer PO Number'''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Currency ID'''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Expansion Button 1'''+ CHAR(13) + CHAR(10)+
        '  ClickHit field ''Expansion Button 1'''+ CHAR(13) + CHAR(10)+
        'NewActiveWin dictionary ''default''  form ''SOP_Document_Detail_Entry'' window ''SOP_Document_Detail_Entry'''+ CHAR(13) + CHAR(10)+
        '  TypeTo field Reference , ''' +@Pedido  + ''''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''OK Button'''+ CHAR(13) + CHAR(10)+
        '  ClickHit field ''OK Button'''+ CHAR(13) + CHAR(10)+
        'NewActiveWin dictionary ''default''  form ''SOP_Entry'' window ''SOP_Entry'''+ CHAR(13) + CHAR(10)+
        'ActivateWindow dictionary ''default''  form ''SOP_Entry'' window ''SOP_Entry'''+ CHAR(13) + CHAR(10)+
			'# Key 1: '+ CHAR(13) + CHAR(10);
		
		
		
	 
SELECT  @Macro= @Macro + 
			'  MoveTo line ' + CONVERT(nvarchar(18),ROW_NUMBER() OVER(ORDER BY CodProducto ASC)) + ' scrollwin ''Line_Scroll'' field ''Item Number'''+ CHAR(13) + CHAR(10) +
            '# Key 1: '''', ''0'', ''0'', ''0'''+ CHAR(13) + CHAR(10) +
            '  TypeTo line ' + CONVERT(nvarchar(18),ROW_NUMBER() OVER(ORDER BY CodProducto ASC)) + ' scrollwin ''Line_Scroll'' field ''Item Number'' , ''' +CodProducto  + ''''+ CHAR(13) + CHAR(10) +
            '# Key 1: '''', ''0'', ''0'', ''0'''+ CHAR(13) + CHAR(10) +
            '  MoveTo line ' + CONVERT(nvarchar(18),ROW_NUMBER() OVER(ORDER BY CodProducto ASC)) + ' scrollwin ''Line_Scroll'' field ''(L) Dropship''  # ''FALSE'''+ CHAR(13) + CHAR(10) +
            '# Key 1: '''', ''0'', ''0'', ''0'''+ CHAR(13) + CHAR(10) +
            '  TypeTo line ' + CONVERT(nvarchar(18),ROW_NUMBER() OVER(ORDER BY CodProducto ASC)) + ' scrollwin ''Line_Scroll'' field QTY , ''' + 
			case when rtrim(b.UOMSCHDL) <> 'UNID' then convert(nvarchar(15),convert(numeric(18,2),Cantidad)) else 
			convert(nvarchar(15),Cantidad) end
			
			+ ''''+ CHAR(13) + CHAR(10) +
            '# Key 1: '''', ''0'', ''0'', ''0'''+ CHAR(13) + CHAR(10) +
            '  MoveTo line ' + CONVERT(nvarchar(18),ROW_NUMBER() OVER(ORDER BY CodProducto ASC)) + ' scrollwin ''Line_Scroll'' field ''(L) Unit Price'''+ CHAR(13) + CHAR(10) +
            '# Key 1: '''', ''0'', ''0'', ''0'''+ CHAR(13) + CHAR(10) +
            '  TypeTo line ' + CONVERT(nvarchar(18),ROW_NUMBER() OVER(ORDER BY CodProducto ASC)) + ' scrollwin ''Line_Scroll'' field ''(L) Unit Price'' , ''' + convert(nvarchar(15),convert(numeric(18,2),(SELECT CASE 
			 WHEN  (SELECT  ROUND(LISTPRCE,2)  FROM GPSAG.dbo.IV00105 WHERE (RTRIM(ITEMNMBR) = CodProducto))=PrecioUnitario THEN PrecioUnitario-0.01
             WHEN  (SELECT  PrecioMínimo FROM  GPSAG.dbo.SAGVPreciosMínimos WHERE (IdProducto = CodProducto))=PrecioUnitario THEN PrecioUnitario+0.01
			 ELSE PrecioUnitario END))) + ''''+ CHAR(13) + CHAR(10) +
            '# Key 1: '''', ''0'', ''0'', ''0'''+ CHAR(13) + CHAR(10) +
            '  MoveTo line ' + CONVERT(nvarchar(18),ROW_NUMBER() OVER(ORDER BY CodProducto ASC)) + ' scrollwin ''Line_Scroll'' field ''(L) Extended Price'''+ CHAR(13) + CHAR(10) +
            'NewActiveWin dictionary ''default''  form DiaLog window DiaLog'+ CHAR(13) + CHAR(10) +
            '  TypeTo field ANSWER , ''RA060986'''+ CHAR(13) + CHAR(10) +
            '  MoveTo field OK'+ CHAR(13) + CHAR(10) +
            '  ClickHit field OK'+ CHAR(13) + CHAR(10) +
            'NewActiveWin dictionary ''default''  form ''SOP_Entry'' window ''SOP_Entry'''+ CHAR(13) + CHAR(10) +
            '  MoveTo field ''Show Detail Button'''+ CHAR(13) + CHAR(10) +
            '  ClickHit field ''Show Detail Button'''+ CHAR(13) + CHAR(10) +
            '# Key 1: '''', ''0'', ''0'', ''0'''+ CHAR(13) + CHAR(10) +

            '  MoveTo line 1 scrollwin ''Line_Scroll'' field ''Location Code'''+ CHAR(13) + CHAR(10) +
            '# Key 1: '''', ''0'', ''0'', ''0'''+ CHAR(13) + CHAR(10) +
            '  TypeTo line 1 scrollwin ''Line_Scroll'' field ''Location Code'' , '''+Bodega+''''+ CHAR(13) + CHAR(10) +
            '# Key 1: '''', ''0'', ''0'', ''0'''+ CHAR(13) + CHAR(10) +
            '  MoveTo line 1 scrollwin ''Line_Scroll'' field PriceLevel'+ CHAR(13) + CHAR(10) +
            '# Key 1: '''', ''0'', ''0'', ''0'''+ CHAR(13) + CHAR(10) +
            '  MoveTo line 1 scrollwin ''Line_Scroll'' field ''Scroll Next Button'''+ CHAR(13) + CHAR(10) +
            '# Key 1: '''', ''0'', ''0'', ''0'''+ CHAR(13) + CHAR(10) +
            '  ClickHit line 1 scrollwin ''Line_Scroll'' field ''Scroll Next Button'''+ CHAR(13) + CHAR(10) +
            '  MoveTo field ''Show Summary Button'''+ CHAR(13) + CHAR(10) +
            '  ClickHit field ''Show Summary Button'''+ CHAR(13) + CHAR(10) +
            '# Key 1: '''', ''0'', ''0'', ''0'''+ CHAR(13) + CHAR(10) +
            '  MoveTo line 2 scrollwin ''Line_Scroll'' field ''Item Number'''+ CHAR(13) + CHAR(10) 

FROM dbo.PedidoDetalle  a   
inner join gpsag.dbo.iv00101 b on a.CodProducto = b.itemnmbr  WHERE (NumPedido = @Pedido)

		
		SELECT @Macro = @Macro + 
		'CheckActiveWin dictionary ''default''  form ''SOP_Entry'' window ''SOP_Entry'''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Expansion Button 4'''+ CHAR(13) + CHAR(10)+
        '  ClickHit field ''Expansion Button 4'''+ CHAR(13) + CHAR(10)+
        'NewActiveWin dictionary ''default''  form ''SOP_Customer_Detail_Entry'' window ''SOP_Customer_Detail_Entry'''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Salesperson ID'''+ CHAR(13) + CHAR(10)+
        '  TypeTo field ''Salesperson ID'' , '''+@CodVendeor+''''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Sales Territory'''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''OK Button'''+ CHAR(13) + CHAR(10)+
        '  ClickHit field ''OK Button'''+ CHAR(13) + CHAR(10)+
        'ActivateWindow dictionary ''default''  form ''SOP_Entry'' window ''SOP_Entry'''+ CHAR(13) + CHAR(10)+
        'ActivateWindow dictionary ''default''  form ''SOP_Entry'' window ''SOP_Entry'''+ CHAR(13) + CHAR(10)+
        'ActivateWindow dictionary ''default''  form ''SOP_Entry'' window ''SOP_Entry'''+ CHAR(13) + CHAR(10)
					;




SELECT '1' Result, @Macro Macro;
END		   		      
commit transaction;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS Result,
	@Macro Macro;

ROLLBACK TRANSACTION;
END CATCH
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_PCrearMacroPedidos_PRU]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 08/05/2021
  Procedimiento para crear macro de ORDEN DE COMPRA en modulo de presupuestos y solicitudes
  */


CREATE               procedure [SAG].[WS_PCrearMacroPedidos_PRU]
(
	@Pedido varchar(15),
	@CodPais varchar(2),
	@Direccon varchar(100), 
	@IdCliente varchar(15),
	@CodVendeor varchar(15)
)as 
BEGIN TRY
BEGIN TRANSACTION
BEGIN


DECLARE @Macro varchar(max) ='';

DECLARE @Count_Prov INT = 0;
DECLARE @Count_Analitica INT = 0;
DECLARE @ContadorLoop INT = 1;
DECLARE @codprov varchar(15);





	SELECT @Macro = @Macro + 

					'# DEXVERSION=10.0.332.0 2 2'+ CHAR(13) + CHAR(10)+
					'CheckActiveWin dictionary ''default''  form ''SOP_Entry'' window ''SOP_Entry''' + CHAR(13) + CHAR(10)+
        '  TypeTo field ''Customer Number'' , ''' +@IdCliente  + ''''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Customer Name'''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Primary Shipto Address Code'''+ CHAR(13) + CHAR(10)+
        '  TypeTo field ''Primary Shipto Address Code'' , ''' +@Direccon  + ''''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Document Date'''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Location Code'''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Customer PO Number'''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Currency ID'''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Expansion Button 1'''+ CHAR(13) + CHAR(10)+
        '  ClickHit field ''Expansion Button 1'''+ CHAR(13) + CHAR(10)+
        'NewActiveWin dictionary ''default''  form ''SOP_Document_Detail_Entry'' window ''SOP_Document_Detail_Entry'''+ CHAR(13) + CHAR(10)+
        '  TypeTo field Reference , ''' +@Pedido  + ''''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''OK Button'''+ CHAR(13) + CHAR(10)+
        '  ClickHit field ''OK Button'''+ CHAR(13) + CHAR(10)+
        'NewActiveWin dictionary ''default''  form ''SOP_Entry'' window ''SOP_Entry'''+ CHAR(13) + CHAR(10)+
        'ActivateWindow dictionary ''default''  form ''SOP_Entry'' window ''SOP_Entry'''+ CHAR(13) + CHAR(10)+
			'# Key 1: '+ CHAR(13) + CHAR(10);
		
		
		
	 
SELECT  @Macro= @Macro + 
			'  MoveTo line ' + CONVERT(nvarchar(18),ROW_NUMBER() OVER(ORDER BY CodProducto ASC)) + ' scrollwin ''Line_Scroll'' field ''Item Number'''+ CHAR(13) + CHAR(10) +
            '# Key 1: '''', ''0'', ''0'', ''0'''+ CHAR(13) + CHAR(10) +
            '  TypeTo line ' + CONVERT(nvarchar(18),ROW_NUMBER() OVER(ORDER BY CodProducto ASC)) + ' scrollwin ''Line_Scroll'' field ''Item Number'' , ''' +CodProducto  + ''''+ CHAR(13) + CHAR(10) +
            '# Key 1: '''', ''0'', ''0'', ''0'''+ CHAR(13) + CHAR(10) +
            '  MoveTo line ' + CONVERT(nvarchar(18),ROW_NUMBER() OVER(ORDER BY CodProducto ASC)) + ' scrollwin ''Line_Scroll'' field ''(L) Dropship''  # ''FALSE'''+ CHAR(13) + CHAR(10) +
            '# Key 1: '''', ''0'', ''0'', ''0'''+ CHAR(13) + CHAR(10) +
            '  TypeTo line ' + CONVERT(nvarchar(18),ROW_NUMBER() OVER(ORDER BY CodProducto ASC)) + ' scrollwin ''Line_Scroll'' field QTY , ''' + convert(nvarchar(15),Cantidad) + ''''+ CHAR(13) + CHAR(10) +
            '# Key 1: '''', ''0'', ''0'', ''0'''+ CHAR(13) + CHAR(10) +
            '  MoveTo line ' + CONVERT(nvarchar(18),ROW_NUMBER() OVER(ORDER BY CodProducto ASC)) + ' scrollwin ''Line_Scroll'' field ''(L) Unit Price'''+ CHAR(13) + CHAR(10) +
            '# Key 1: '''', ''0'', ''0'', ''0'''+ CHAR(13) + CHAR(10) +
            '  TypeTo line ' + CONVERT(nvarchar(18),ROW_NUMBER() OVER(ORDER BY CodProducto ASC)) + ' scrollwin ''Line_Scroll'' field ''(L) Unit Price'' , ''' + convert(nvarchar(15),PrecioUnitario) + ''''+ CHAR(13) + CHAR(10) +
            '# Key 1: '''', ''0'', ''0'', ''0'''+ CHAR(13) + CHAR(10) +
            '  MoveTo line ' + CONVERT(nvarchar(18),ROW_NUMBER() OVER(ORDER BY CodProducto ASC)) + ' scrollwin ''Line_Scroll'' field ''(L) Extended Price'''+ CHAR(13) + CHAR(10) +
            'NewActiveWin dictionary ''default''  form DiaLog window DiaLog'+ CHAR(13) + CHAR(10) +
            '  TypeTo field ANSWER , ''RA060986'''+ CHAR(13) + CHAR(10) +
            '  MoveTo field OK'+ CHAR(13) + CHAR(10) +
            '  ClickHit field OK'+ CHAR(13) + CHAR(10) +
            'NewActiveWin dictionary ''default''  form ''SOP_Entry'' window ''SOP_Entry'''+ CHAR(13) + CHAR(10) +
            '  MoveTo field ''Show Detail Button'''+ CHAR(13) + CHAR(10) +
            '  ClickHit field ''Show Detail Button'''+ CHAR(13) + CHAR(10) +
            '# Key 1: '''', ''0'', ''0'', ''0'''+ CHAR(13) + CHAR(10) +

            '  MoveTo line 1 scrollwin ''Line_Scroll'' field ''Location Code'''+ CHAR(13) + CHAR(10) +
            '# Key 1: '''', ''0'', ''0'', ''0'''+ CHAR(13) + CHAR(10) +
            '  TypeTo line 1 scrollwin ''Line_Scroll'' field ''Location Code'' , '''+Bodega+''''+ CHAR(13) + CHAR(10) +
            '# Key 1: '''', ''0'', ''0'', ''0'''+ CHAR(13) + CHAR(10) +
            '  MoveTo line 1 scrollwin ''Line_Scroll'' field PriceLevel'+ CHAR(13) + CHAR(10) +
            '# Key 1: '''', ''0'', ''0'', ''0'''+ CHAR(13) + CHAR(10) +
            '  MoveTo line 1 scrollwin ''Line_Scroll'' field ''Scroll Next Button'''+ CHAR(13) + CHAR(10) +
            '# Key 1: '''', ''0'', ''0'', ''0'''+ CHAR(13) + CHAR(10) +
            '  ClickHit line 1 scrollwin ''Line_Scroll'' field ''Scroll Next Button'''+ CHAR(13) + CHAR(10) +
            '  MoveTo field ''Show Summary Button'''+ CHAR(13) + CHAR(10) +
            '  ClickHit field ''Show Summary Button'''+ CHAR(13) + CHAR(10) +
            '# Key 1: '''', ''0'', ''0'', ''0'''+ CHAR(13) + CHAR(10) +
            '  MoveTo line 2 scrollwin ''Line_Scroll'' field ''Item Number'''+ CHAR(13) + CHAR(10) 

FROM dbo.PedidoDetalleH  a   
inner join gpsag.dbo.iv00101 b on a.CodProducto = b.itemnmbr  WHERE (NumPedido = @Pedido)

		
		SELECT @Macro = @Macro + 
		'CheckActiveWin dictionary ''default''  form ''SOP_Entry'' window ''SOP_Entry'''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Expansion Button 4'''+ CHAR(13) + CHAR(10)+
        '  ClickHit field ''Expansion Button 4'''+ CHAR(13) + CHAR(10)+
        'NewActiveWin dictionary ''default''  form ''SOP_Customer_Detail_Entry'' window ''SOP_Customer_Detail_Entry'''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Salesperson ID'''+ CHAR(13) + CHAR(10)+
        '  TypeTo field ''Salesperson ID'' , '''+@CodVendeor+''''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''Sales Territory'''+ CHAR(13) + CHAR(10)+
        '  MoveTo field ''OK Button'''+ CHAR(13) + CHAR(10)+
        '  ClickHit field ''OK Button'''+ CHAR(13) + CHAR(10)+
        'ActivateWindow dictionary ''default''  form ''SOP_Entry'' window ''SOP_Entry'''+ CHAR(13) + CHAR(10)+
        'ActivateWindow dictionary ''default''  form ''SOP_Entry'' window ''SOP_Entry'''+ CHAR(13) + CHAR(10)+
        'ActivateWindow dictionary ''default''  form ''SOP_Entry'' window ''SOP_Entry'''+ CHAR(13) + CHAR(10)
					;




SELECT '1' Result, @Macro Macro;
END		   		      
commit transaction;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS Result,
	@Macro Macro;

ROLLBACK TRANSACTION;
END CATCH
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_UpdDireccion_Pedido]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 23/06/2020
  Procedimiento para actualizar direccion de despacho con la que el cliente existente realizo el pedido 
  */
CREATE procedure [SAG].[WS_UpdDireccion_Pedido] 
(
	@Codcliente char(15),
	@idClieCaf char(15),
	@NumPedido char(15),
	@idDireccion char(15)
	
)as 
BEGIN TRY
BEGIN TRANSACTION
BEGIN


/*Actualizar Despacho*/
UPDATE C
   SET --C.ADDRESS2 = UPPER(d.Direccion),
       C.CNTCPRSN = UPPER(RTRIM(CL.PrimerNombre)) + ' ' + UPPER(RTRIM(CL.PrimerApellido)),
       C.ADDRESS1 = UPPER(SUBSTRING(d.Direccion,0,CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))),
	   C.ADDRESS2 = UPPER(SUBSTRING( SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),0,CHARINDEX(' ', SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),(LEN(d.Direccion)/3)))) ,
	   C.ADDRESS3 = UPPER(SUBSTRING((SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion))),(CHARINDEX(' ',(SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion))),(LEN(d.Direccion)/3)))+1,LEN(d.Direccion))),
       C.COUNTRY = CASE WHEN D.PAIS = 'SV' THEN 'EL SALVADOR' END,
	   C.CITY = UPPER(D.Municipio),
	   C.STATE = UPPER(D.DEPARTAMENTO),
	   C.PHONE1 = '503'+replace(substring(cl.Telefono,5,LEN(cl.telefono)), '-',''),
	   C.PHONE2 = '503'+replace(substring(cl.No_Celular,5,LEN(cl.No_Celular)), '-','')
  from gpsag.dbo.rm00102 c
 inner join SAGRI_MOVIL.dbo.PedidoEncabezado e
    on c.CUSTNMBR = e.CodCliente
 inner join SAGRI_MOVIL.dbo.WS_DireccCliente d
    on e.IdDireccion = d.IdDireccionCaf
   and e.idClieCaf = d.IdClieCafeina
 inner join SAGRI_MOVIL.dbo.WS_Cliente cl
    on e.idClieCaf = cl.IdClieCafeina
   and e.idClieCaf = d.IdClieCafeina
 where e.CodCliente = @Codcliente
   and e.idClieCaf = @idClieCaf
   and e.NumPedido = @NumPedido
   and e.IdDireccion = @idDireccion
   and c.ADRSCODE ='DESPACHO'
;


END		   		      
commit transaction;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS ErrorMessage;

ROLLBACK TRANSACTION;
END CATCH
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_UpdDireccionSVC0016_Pedido]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 23/06/2020
  Procedimiento para actualizar direcciones tanto en la tabla de clientes como en la tabla de direcciones 
  */
CREATE procedure [SAG].[WS_UpdDireccionSVC0016_Pedido] 
(
	@Codcliente varchar(15),
	@idClieCaf varchar(15),
	@NumPedido varchar(15),
	@idDireccion varchar(15)
	
)as 
BEGIN TRY
BEGIN TRANSACTION
BEGIN

--select @Codcliente, @idClieCaf, @NumPedido, @idDireccion ;
/*
SELECT COUNT(*) UPD1
from gpsag.dbo.rm00101 c
 inner join SAGRI_MOVIL.dbo.PedidoEncabezado e
    on c.CUSTNMBR = e.CodCliente
 inner join SAGRI_MOVIL.dbo.WS_DireccCliente d
    on e.IdDireccion = d.IdDireccionCaf
   and e.idClieCaf = d.IdClieCafeina
 inner join SAGRI_MOVIL.dbo.WS_Cliente cl
    on e.idClieCaf = cl.IdClieCafeina
   and e.idClieCaf = d.IdClieCafeina
 where e.CodCliente = @Codcliente
   and e.idClieCaf = @idClieCaf
   and e.NumPedido = @NumPedido
   and e.IdDireccion = @idDireccion
;
*/
/*Agregado mpinto 23/06/2020
  Actualizacion Direccion de Cliente en tabla Cliente*/

--UPDATE C
--   SET  C.CUSTNAME = COALESCE(UPPER(RTRIM(CL.PrimerNombre)) + ' ' + UPPER(RTRIM(CL.PrimerApellido)),''),
--       C.CNTCPRSN = COALESCE(UPPER(RTRIM(CL.PrimerNombre)) + ' ' + UPPER(RTRIM(CL.PrimerApellido)),''),
--	   C.SHRTNAME= COALESCE(UPPER(RTRIM(CL.PrimerNombre)) + ' ' + UPPER(RTRIM(CL.PrimerApellido)),''),
--	   C.ADDRESS1 = COALESCE(UPPER(SUBSTRING(d.Direccion,0,CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))),''),
--	   C.ADDRESS2 = COALESCE(UPPER(SUBSTRING( SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),0,CHARINDEX(' ', SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),(LEN(d.Direccion)/3)))) ,''),
--	   C.ADDRESS3 = COALESCE( UPPER(SUBSTRING((SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion))),(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1,LEN(d.Direccion))),''),
--       C.COUNTRY = CASE WHEN D.PAIS = 'SV' THEN 'EL SALVADOR' ELSE '' END,
--	   C.CITY = COALESCE(UPPER(D.Municipio),''),
--	   --C.PHONE1 = '503'+rtrim(CL.Telefono),
--	   C.PHONE1 = COALESCE('503'+replace(substring(cl.Telefono,5,LEN(cl.telefono)), '-',''),''),
--	   C.PHONE2 = coalesce('503'+replace(substring(cl.No_Celular,5,LEN(cl.No_Celular)), '-',''),''),
--	   C.COMMENT2 = COALESCE(CL.Dui,''),
--	   C.USERDEF2 = COALESCE(CL.Nit,''),
--	   C.STATE = COALESCE(UPPER(D.DEPARTAMENTO),'')
--	    /*C.CUSTNAME = UPPER(RTRIM(CL.PrimerNombre)) + ' ' + UPPER(RTRIM(CL.PrimerApellido)),
--		/*C.ADDRESS2 = UPPER(d.Direccion),*/
--	   C.ADDRESS1 = UPPER(SUBSTRING(d.Direccion,0,CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))),
--	   C.ADDRESS2 = UPPER(SUBSTRING( SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),0,CHARINDEX(' ', SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),(LEN(d.Direccion)/3)))) ,
--	   C.ADDRESS3 = UPPER(SUBSTRING((SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion))),(CHARINDEX(' ',(SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion))),(LEN(d.Direccion)/3)))+1,LEN(d.Direccion))),
--       C.COUNTRY = CASE WHEN D.PAIS = 'SV' THEN 'EL SALVADOR' END,
--	   C.CITY = UPPER(D.Municipio),
--	   C.STATE = UPPER(D.DEPARTAMENTO)*/
--  from gpsag.dbo.rm00101 c
-- inner join SAGRI_MOVIL.dbo.PedidoEncabezado e
--    on c.CUSTNMBR = e.CodCliente
-- inner join SAGRI_MOVIL.dbo.WS_DireccCliente d
--    on e.IdDireccion = d.IdDireccionCaf
--   and e.idClieCaf = d.IdClieCafeina
-- inner join SAGRI_MOVIL.dbo.WS_Cliente cl
--    on e.idClieCaf = cl.IdClieCafeina
--   and e.idClieCaf = d.IdClieCafeina
-- where e.CodCliente = @Codcliente
--   and e.idClieCaf = @idClieCaf
--   and e.NumPedido = @NumPedido
--   and e.IdDireccion = @idDireccion
--;



UPDATE C
   SET  C.CUSTNAME = COALESCE(UPPER(RTRIM(CL.PrimerNombre)) + ' ' + UPPER(RTRIM(CL.PrimerApellido)),''),
       C.CNTCPRSN = COALESCE(UPPER(RTRIM(CL.PrimerNombre)) + ' ' + UPPER(RTRIM(CL.PrimerApellido)),''),
	   --C.SHRTNAME= COALESCE(UPPER(RTRIM(CL.PrimerNombre)) + ' ' + UPPER(RTRIM(CL.PrimerApellido)),''), /*COMENT MPINTO 01/06/2021 SOBREPASA EL TAMAÑO DEL CAMPO*/
	   C.SHRTNAME= COALESCE(UPPER(RTRIM(CL.PrimerNombre)),''), /*COMENT MPINTO 01/06/2021 PARA NO SOBREPASAR EL TAMAÑO DEL CAMPO*/
	   C.ADDRESS1 = COALESCE(UPPER(SUBSTRING(d.Direccion,0,CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))),''),
	   C.ADDRESS2 = COALESCE(UPPER(SUBSTRING( SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),0,CHARINDEX(' ', SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),(LEN(d.Direccion)/3)))) ,''),
	   C.ADDRESS3 = COALESCE( UPPER(SUBSTRING((SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion))),(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1,LEN(d.Direccion))),''),
       C.COUNTRY = CASE WHEN D.PAIS = 'SV' THEN 'EL SALVADOR' ELSE '' END,
	   C.CITY = COALESCE(UPPER(D.Municipio),''),
	   --C.PHONE1 = '503'+rtrim(CL.Telefono),
	   C.PHONE1 = COALESCE('503'+replace(substring(cl.Telefono,5,LEN(cl.telefono)), '-',''),''),
	   C.PHONE2 = coalesce('503'+replace(substring(cl.No_Celular,5,LEN(cl.No_Celular)), '-',''),''),
	   C.COMMENT2 = COALESCE(CL.Dui,''),
	   C.USERDEF2 = COALESCE(CL.Nit,''),
	   C.STATE = COALESCE(UPPER(D.DEPARTAMENTO),'')
	    /*C.CUSTNAME = UPPER(RTRIM(CL.PrimerNombre)) + ' ' + UPPER(RTRIM(CL.PrimerApellido)),
		/*C.ADDRESS2 = UPPER(d.Direccion),*/
	   C.ADDRESS1 = UPPER(SUBSTRING(d.Direccion,0,CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))),
	   C.ADDRESS2 = UPPER(SUBSTRING( SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),0,CHARINDEX(' ', SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),(LEN(d.Direccion)/3)))) ,
	   C.ADDRESS3 = UPPER(SUBSTRING((SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion))),(CHARINDEX(' ',(SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion))),(LEN(d.Direccion)/3)))+1,LEN(d.Direccion))),
       C.COUNTRY = CASE WHEN D.PAIS = 'SV' THEN 'EL SALVADOR' END,
	   C.CITY = UPPER(D.Municipio),
	   C.STATE = UPPER(D.DEPARTAMENTO)*/
  from gpsag.dbo.rm00101 c
 left join (/*add mpinto 01062021 union agregado para tomar ya sea de encabezao o encabezado historico*/
 			select * 
			  from SAGRI_MOVIL.dbo.PedidoEncabezadoH
			 union
			 select * 
			  from SAGRI_MOVIL.dbo.PedidoEncabezado
			) e
    on rtrim(c.CUSTNMBR) = rtrim(e.CodCliente)
 left join SAGRI_MOVIL.dbo.WS_DireccCliente d
    on e.IdDireccion = d.IdDireccionCaf
   and e.idClieCaf = d.IdClieCafeina
 left join SAGRI_MOVIL.dbo.WS_Cliente cl
    on e.idClieCaf = cl.IdClieCafeina
   and e.idClieCaf = d.IdClieCafeina
 where e.CodCliente = @Codcliente
   and e.idClieCaf = @idClieCaf
   and e.NumPedido = @NumPedido
   and e.IdDireccion = @idDireccion
;





/*
SELECT COUNT(*) UPD_PPAL
 from gpsag.dbo.rm00102 c
 inner join SAGRI_MOVIL.dbo.PedidoEncabezado e
    on c.CUSTNMBR = e.CodCliente
 inner join SAGRI_MOVIL.dbo.WS_DireccCliente d
    on e.IdDireccion = d.IdDireccionCaf
   and e.idClieCaf = d.IdClieCafeina
 inner join SAGRI_MOVIL.dbo.WS_Cliente cl
   on e.idClieCaf = cl.IdClieCafeina
  and e.idClieCaf = d.IdClieCafeina
where e.CodCliente = @Codcliente
  and e.idClieCaf = @idClieCaf
  and e.NumPedido = @NumPedido
  and e.IdDireccion = @idDireccion
  and c.ADRSCODE ='PRINCIPAL'
;
*/
/*Agregado mpinto 23/06/2020
  Actualizacion Direccion de Cliente en tabla Direccion cliente cuando el id sea PRINCIPAL*/

--UPDATE C
--   SET C.CNTCPRSN = COALESCE(UPPER(RTRIM(CL.PrimerNombre)) + ' ' + UPPER(RTRIM(CL.PrimerApellido)),''),
--       C.ADDRESS1 = COALESCE(UPPER(SUBSTRING(d.Direccion,0,CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))),''),
--	   C.ADDRESS2 = COALESCE(UPPER(SUBSTRING( SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),0,CHARINDEX(' ', SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),(LEN(d.Direccion)/3)))) ,''),
--	   C.ADDRESS3 = COALESCE(UPPER(SUBSTRING((SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion))),(CHARINDEX(' ',(SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion))),(LEN(d.Direccion)/3)))+1,LEN(d.Direccion))),''),
--       C.COUNTRY = CASE WHEN D.PAIS = 'SV' THEN 'EL SALVADOR' ELSE '' END,
--	   C.CITY = COALESCE(UPPER(D.Municipio),''),
--	   C.STATE = COALESCE(UPPER(D.DEPARTAMENTO),''),
--	   --C.PHONE1 = '503'+RTRIM(CL.Telefono)
--	   -- C.PHONE1 = '503'+replace(substring(cl.Telefono,5,LEN(cl.telefono)), '-',''),
--	   --C.PHONE2 = '503'+replace(substring(cl.No_Celular,5,LEN(cl.No_Celular)), '-','')
--	     C.PHONE1 = COALESCE('503'+replace(substring(cl.Telefono,5,LEN(cl.telefono)), '-',''),''),
--	   C.PHONE2 = coalesce('503'+replace(substring(cl.No_Celular,5,LEN(cl.No_Celular)), '-',''),'')
--  from gpsag.dbo.rm00102 c
-- inner join SAGRI_MOVIL.dbo.PedidoEncabezado e
--    on c.CUSTNMBR = e.CodCliente
-- inner join SAGRI_MOVIL.dbo.WS_DireccCliente d
--    on e.IdDireccion = d.IdDireccionCaf
--   and e.idClieCaf = d.IdClieCafeina
-- inner join SAGRI_MOVIL.dbo.WS_Cliente cl
--   on e.idClieCaf = cl.IdClieCafeina
--  and e.idClieCaf = d.IdClieCafeina
--where e.CodCliente = @Codcliente
--  and e.idClieCaf = @idClieCaf
--  and e.NumPedido = @NumPedido
--  and e.IdDireccion = @idDireccion
--  and c.ADRSCODE ='PRINCIPAL'
--;




--UPDATE C
--   SET C.CNTCPRSN = COALESCE(UPPER(RTRIM(CL.PrimerNombre)) + ' ' + UPPER(RTRIM(CL.PrimerApellido)),''),
--       C.ADDRESS1 = COALESCE(UPPER(SUBSTRING(d.Direccion,0,CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))),''),
--	   C.ADDRESS2 = COALESCE(UPPER(SUBSTRING( SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),0,CHARINDEX(' ', SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),(LEN(d.Direccion)/3)))) ,''),
--	   C.ADDRESS3 = COALESCE(UPPER(SUBSTRING((SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion))),(CHARINDEX(' ',(SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion))),(LEN(d.Direccion)/3)))+1,LEN(d.Direccion))),''),
--       C.COUNTRY = CASE WHEN D.PAIS = 'SV' THEN 'EL SALVADOR' ELSE '' END,
--	   C.CITY = COALESCE(UPPER(D.Municipio),''),
--	   C.STATE = COALESCE(UPPER(D.DEPARTAMENTO),''),
--	   --C.PHONE1 = '503'+RTRIM(CL.Telefono)
--	   -- C.PHONE1 = '503'+replace(substring(cl.Telefono,5,LEN(cl.telefono)), '-',''),
--	   --C.PHONE2 = '503'+replace(substring(cl.No_Celular,5,LEN(cl.No_Celular)), '-','')
--	     C.PHONE1 = COALESCE('503'+replace(substring(cl.Telefono,5,LEN(cl.telefono)), '-',''),''),
--	   C.PHONE2 = coalesce('503'+replace(substring(cl.No_Celular,5,LEN(cl.No_Celular)), '-',''),'')
--  from gpsag.dbo.rm00102 c
-- left join (/*add mpinto 01062021 */
-- 			select * 
--			  from SAGRI_MOVIL.dbo.PedidoEncabezadoH
--			 union
--			 select * 
--			  from SAGRI_MOVIL.dbo.PedidoEncabezado
--			) e
--    on c.CUSTNMBR = e.CodCliente
-- left join SAGRI_MOVIL.dbo.WS_DireccCliente d
--    on e.IdDireccion = d.IdDireccionCaf
--   and e.idClieCaf = d.IdClieCafeina
-- left join SAGRI_MOVIL.dbo.WS_Cliente cl
--   on e.idClieCaf = cl.IdClieCafeina
--  and e.idClieCaf = d.IdClieCafeina
--where e.CodCliente = @Codcliente
--  and e.idClieCaf = @idClieCaf
--  and e.NumPedido = @NumPedido
--  and e.IdDireccion = @idDireccion
--  and c.ADRSCODE ='PRINCIPAL'
--;






UPDATE C
   SET C.CNTCPRSN = COALESCE(UPPER(RTRIM(CL.PrimerNombre)) + ' ' + UPPER(RTRIM(CL.PrimerApellido)),''),
       C.ADDRESS1 = COALESCE(UPPER(SUBSTRING(d.Direccion,0,CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))),''),
	   C.ADDRESS2 = COALESCE(UPPER(SUBSTRING( SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),0,CHARINDEX(' ', SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),(LEN(d.Direccion)/3)))) ,''),
	   C.ADDRESS3 = COALESCE(UPPER(SUBSTRING((SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion))),(CHARINDEX(' ',(SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion))),(LEN(d.Direccion)/3)))+1,LEN(d.Direccion))),''),
       C.COUNTRY = CASE WHEN D.PAIS = 'SV' THEN 'EL SALVADOR' ELSE '' END,
	   C.CITY = COALESCE(UPPER(D.Municipio),''),
	   C.STATE = COALESCE(UPPER(D.DEPARTAMENTO),''),
	   --C.PHONE1 = '503'+RTRIM(CL.Telefono)
	   -- C.PHONE1 = '503'+replace(substring(cl.Telefono,5,LEN(cl.telefono)), '-',''),
	   --C.PHONE2 = '503'+replace(substring(cl.No_Celular,5,LEN(cl.No_Celular)), '-','')
	     C.PHONE1 = COALESCE('503'+replace(substring(cl.Telefono,5,LEN(cl.telefono)), '-',''),''),
	   C.PHONE2 = coalesce('503'+replace(substring(cl.No_Celular,5,LEN(cl.No_Celular)), '-',''),'')
  from gpsag.dbo.rm00102 c
 left join (/*add mpinto 01062021 */
 			select * 
			  from SAGRI_MOVIL.dbo.PedidoEncabezadoH
			 union
			 select * 
			  from SAGRI_MOVIL.dbo.PedidoEncabezado
			) e
    on c.CUSTNMBR = e.CodCliente
 left join SAGRI_MOVIL.dbo.WS_DireccCliente d
    on e.IdDireccion = d.IdDireccionCaf
   and e.idClieCaf = d.IdClieCafeina
 left join SAGRI_MOVIL.dbo.WS_Cliente cl
   on e.idClieCaf = cl.IdClieCafeina
  and e.idClieCaf = d.IdClieCafeina
where e.CodCliente = @Codcliente
  and e.idClieCaf = @idClieCaf
  and e.NumPedido = @NumPedido
  and e.IdDireccion = @idDireccion
  and c.ADRSCODE ='PRINCIPAL'
;



/*

SELECT COUNT(*) UPD_DESP
  from gpsag.dbo.rm00102 c
 inner join SAGRI_MOVIL.dbo.PedidoEncabezado e
    on c.CUSTNMBR = e.CodCliente
 inner join SAGRI_MOVIL.dbo.WS_DireccCliente d
    on e.IdDireccion = d.IdDireccionCaf
   and e.idClieCaf = d.IdClieCafeina
 inner join SAGRI_MOVIL.dbo.WS_Cliente cl
    on e.idClieCaf = cl.IdClieCafeina
   and e.idClieCaf = d.IdClieCafeina
 where e.CodCliente = @Codcliente
   and e.idClieCaf = @idClieCaf
   and e.NumPedido = @NumPedido
   and e.IdDireccion = @idDireccion
   and c.ADRSCODE ='DESPACHO'
;
*/

/*Actualizar Despacho*/
UPDATE C
   SET C.CNTCPRSN = COALESCE(UPPER(RTRIM(CL.PrimerNombre)) + ' ' + UPPER(RTRIM(CL.PrimerApellido)),''),
       C.ADDRESS1 = COALESCE(UPPER(SUBSTRING(d.Direccion,0,CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))),''),
	   C.ADDRESS2 = COALESCE(UPPER(SUBSTRING( SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),0,CHARINDEX(' ', SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion)),(LEN(d.Direccion)/3)))) ,''),
	   C.ADDRESS3 = COALESCE(UPPER(SUBSTRING((SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion))),(CHARINDEX(' ',(SUBSTRING(d.Direccion,(CHARINDEX(' ',d.Direccion,(LEN(d.Direccion)/3)))+1, len(d.Direccion))),(LEN(d.Direccion)/3)))+1,LEN(d.Direccion))),''),
       C.COUNTRY = CASE WHEN D.PAIS = 'SV' THEN 'EL SALVADOR' ELSE '' END,
	   C.CITY = COALESCE(UPPER(D.Municipio),''),
	   C.STATE = COALESCE(UPPER(D.DEPARTAMENTO),''),
	   --C.PHONE1 = '503'+RTRIM(CL.Telefono)
	   -- C.PHONE1 = '503'+replace(substring(cl.Telefono,5,LEN(cl.telefono)), '-',''),
	   --C.PHONE2 = '503'+replace(substring(cl.No_Celular,5,LEN(cl.No_Celular)), '-','')
	     C.PHONE1 = COALESCE('503'+replace(substring(cl.Telefono,5,LEN(cl.telefono)), '-',''),''),
	   C.PHONE2 = coalesce('503'+replace(substring(cl.No_Celular,5,LEN(cl.No_Celular)), '-',''),'')
  from gpsag.dbo.rm00102 c
 left join (/*add mpinto 01062021 union agregado para tomar ya sea de encabezao o encabezado historico*/
 			select * 
			  from SAGRI_MOVIL.dbo.PedidoEncabezadoH
			 union
			 select * 
			  from SAGRI_MOVIL.dbo.PedidoEncabezado
			) e
    on rtrim(c.CUSTNMBR) = rtrim(e.CodCliente)
 left join SAGRI_MOVIL.dbo.WS_DireccCliente d
    on e.IdDireccion = d.IdDireccionCaf
   and e.idClieCaf = d.IdClieCafeina
 left join SAGRI_MOVIL.dbo.WS_Cliente cl
    on e.idClieCaf = cl.IdClieCafeina
   and e.idClieCaf = d.IdClieCafeina
 where e.CodCliente = @Codcliente
   and e.idClieCaf = @idClieCaf
   and e.NumPedido = @NumPedido
   and e.IdDireccion = @idDireccion
   and c.ADRSCODE ='DESPACHO'
;


END		   		      
commit transaction;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS ErrorMessage;

ROLLBACK TRANSACTION;
END CATCH
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_UpdDireccionSVC0809_Pedido]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 23/06/2020
  Procedimiento para actualizar direcciones tanto en la tabla de clientes como en la tabla de direcciones 
  */
CREATE procedure [SAG].[WS_UpdDireccionSVC0809_Pedido] 
(
	@Codcliente char(15),
	@idClieCaf char(15),
	@NumPedido char(15),
	@idDireccion char(15)
	
)as 
BEGIN TRY
BEGIN TRANSACTION
BEGIN


/*Agregado mpinto 23/06/2020
  Actualizacion Direccion de Cliente en tabla Cliente*/
UPDATE C
   SET C.CUSTNAME = UPPER(RTRIM(CL.PrimerNombre)) + ' ' + UPPER(RTRIM(CL.PrimerApellido)),
		C.ADDRESS2 = UPPER(d.Direccion),
       C.COUNTRY = CASE WHEN D.PAIS = 'SV' THEN 'EL SALVADOR' END,
	   C.CITY = UPPER(D.Municipio),
	   C.STATE = UPPER(D.DEPARTAMENTO)
from gpsag.dbo.rm00101 c
inner join SAGRI_MOVIL.dbo.PedidoEncabezado e
on c.CUSTNMBR = e.CodCliente
inner join SAGRI_MOVIL.dbo.WS_DireccCliente d
on e.IdDireccion = d.IdDireccionCaf
and e.idClieCaf = d.IdClieCafeina
 inner join SAGRI_MOVIL.dbo.WS_Cliente cl
   on e.idClieCaf = cl.IdClieCafeina
   and e.idClieCaf = d.IdClieCafeina
where e.CodCliente = @Codcliente
and e.idClieCaf = @idClieCaf
and e.NumPedido = @NumPedido
and e.IdDireccion = @idDireccion
;


/*Agregado mpinto 23/06/2020
  Actualizacion Direccion de Cliente en tabla Direccion cliente cuando el id sea PRINCIPAL*/

UPDATE C
   SET C.ADDRESS2 = UPPER(d.Direccion),
       C.COUNTRY = CASE WHEN D.PAIS = 'SV' THEN 'EL SALVADOR' END,
	   C.CITY = UPPER(D.Municipio),
	   C.STATE = UPPER(D.DEPARTAMENTO)
from gpsag.dbo.rm00102 c
inner join SAGRI_MOVIL.dbo.PedidoEncabezado e
on c.CUSTNMBR = e.CodCliente
inner join SAGRI_MOVIL.dbo.WS_DireccCliente d
on e.IdDireccion = d.IdDireccionCaf
and e.idClieCaf = d.IdClieCafeina
where e.CodCliente = @Codcliente
and e.idClieCaf = @idClieCaf
and e.NumPedido = @NumPedido
and e.IdDireccion = @idDireccion
and c.ADRSCODE ='PRINCIPAL'
;

/*Actualizar Despacho*/
UPDATE C
   SET C.ADDRESS2 = UPPER(d.Direccion),
       C.COUNTRY = CASE WHEN D.PAIS = 'SV' THEN 'EL SALVADOR' END,
	   C.CITY = UPPER(D.Municipio),
	   C.STATE = UPPER(D.DEPARTAMENTO)
from gpsag.dbo.rm00102 c
inner join SAGRI_MOVIL.dbo.PedidoEncabezado e
on c.CUSTNMBR = e.CodCliente
inner join SAGRI_MOVIL.dbo.WS_DireccCliente d
on e.IdDireccion = d.IdDireccionCaf
and e.idClieCaf = d.IdClieCafeina
where e.CodCliente = @Codcliente
and e.idClieCaf = @idClieCaf
and e.NumPedido = @NumPedido
and e.IdDireccion = @idDireccion
and c.ADRSCODE ='DESPACHO'
;


END		   		      
commit transaction;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS ErrorMessage;

ROLLBACK TRANSACTION;
END CATCH
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_validarUsuario]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*Creado MPINTO 24/04/2020
  Procedimiento que se utilizara para validar las credenciales del usuario a las registradas en la bd
  para luego poder consumir los servicios*/
CREATE procedure [SAG].[WS_validarUsuario] 
(
	@Usuario nvarchar(25), 
	@Password nvarchar(25)
	--, @CodPais nchar(2)
)as 
BEGIN  


SELECT COUNT(*)
  FROM [dbo].WS_USUARIOS
 WHERE usuario = @Usuario
   AND Password = @Password


END
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_VerificarCliente]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 24/04/2020
  Procedimiento obtener la informacion del cliente en formato json con la misma estructura que se
  envia para insertar.
  */
CREATE procedure [SAG].[WS_VerificarCliente] 
(
	@CodCliente varchar(5)
	
)as 
BEGIN TRY
BEGIN TRANSACTION 

declare @count int = 0;
	  /*CLIENTE*/
SELECT @count = count(*)
  FROM SAGRI_MOVIL.DBO.WS_Cliente C
 WHERE C.IdClieCafeina =  @CodCliente
 ;


 IF @count < 1
	BEGIN
		SELECT 0;
	END
 ELSE 
	BEGIN
		SELECT 1;
	END


commit transaction;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() as Result;--AS ErrorMessage;

ROLLBACK TRANSACTION;
END CATCH
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WS_VerificarCliente_GP]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 01/07/2020
  Procedimiento creado para verificar por medio del NRC si el cliente nuevo existe en GP, si encuentra coincidencia
  actualizar registro de la tabla WS_Cliente con el codigo de cliente GP
  */
CREATE procedure [SAG].[WS_VerificarCliente_GP] 
(
	@NRC nvarchar(30),
	@idClieCaf varCHAR(10),
	@codpais varchar(2) = NULL
	
	
)as 
BEGIN TRY
BEGIN TRANSACTION
BEGIN

DECLARE @COUNT INT = 0;
DECLARE @CodCliGP char(15) =NULL;
DECLARE @CountCliWeb int =0;

SELECT @COUNT = COUNT(*)
  FROM GPSAG.dbo.RM00101 R
 INNER JOIN SAGRI_MOVIL.DBO.WS_Cliente C
    ON REPLACE(R.TXRGNNUM,'-','') = REPLACE(c.NCR,'-','')
 WHERE C.IdClieCafeina = @idClieCaf
 ;
 /*Si Encuentra coincidencia --> actualizar*/
IF @COUNT >0
 BEGIN
	SELECT @CodCliGP =RTRIM(R.CUSTNMBR)
	  FROM GPSAG.dbo.RM00101 R
	 INNER JOIN SAGRI_MOVIL.DBO.WS_Cliente C
		ON REPLACE(R.TXRGNNUM,'-','') = REPLACE(c.NCR,'-','')
	 WHERE C.IdClieCafeina = @idClieCaf
	 ;

	 
UPDATE cl
   SET cl.CodCliente = @CodCliGP
  from SAGRI_MOVIL.dbo.WS_Cliente cl  
 where cl.IdClieCafeina = @idClieCaf 
  ;

select @CountCliWeb = COUNT((cl.CodCliente))
  from SAGRI_MOVIL.dbo.WS_Cliente cl  
 where cl.IdClieCafeina = @idClieCaf 
  ;

 END



Select '1' Result, @CountCliWeb CountCliWeb ;
END
COMMIT TRANSACTION;
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS Result
	 ;

ROLLBACK TRANSACTION;
END CATCH
GO
SET QUOTED_IDENTIFIER ON
/****** Object:  StoredProcedure [SAG].[WSCel_InsertarListaPrecio]    Script Date: 9/2/2026 10:15:29 AM ******/
SET ANSI_NULLS ON
/*
  Creado MPINTO 06/05/2020
  Procedimiento creado para registrar un nuevo pedido a traves de un json enviado desde el Web Service
  y como se desglosa en el procedimiento, se ocupa la funcion OPENJSON para extraer la información
  */
CREATE procedure [SAG].[WSCel_InsertarListaPrecio] 
(
	@CodLP nvarchar(10), /*Codigo del precio de lista*/
	@DescLP nvarchar(100),  /*Descripcion del precio  de lista*/
	@Usuario nvarchar(10), 
	@CodPais nchar(2)
)as 
BEGIN  
declare @contador int = 0;

select @contador = count(*) from [dbo].[WS_ListaPrecio] where  CodLstPrec = @CodLP;

	IF @contador <1
	BEGIN
		INSERT INTO [dbo].[WS_ListaPrecio]
			   ([CodLstPrec]
			   ,[NombreLstPre]
			   ,[CodPais]
			   ,[UsuarioCrea]
			   ,[FechaCrea]
			   )
			   select @CodLP, @DescLP, @CodPais, @Usuario, getdate();
	END
	ELSE
		BEGIN
		UPDATE [dbo].[WS_ListaPrecio]
		   SET CodLstPrec = @CodLP,
		       NombreLstPre = @DescLP,
			   UsuarioModif = UsuarioModif,
			   FechaModif = getdate();
		END
				  

				 
END
GO
