/* SAGRISA legacy Movil - functions. Generado desde movil.sql. Conectarse a la base destino antes de ejecutar. */

SET QUOTED_IDENTIFIER ON
/****** Object:  UserDefinedFunction [SAG].[WS_ObtenerDiaHabil]    Script Date: 9/2/2026 10:15:28 AM ******/
SET ANSI_NULLS ON
CREATE FUNCTION [SAG].[WS_ObtenerDiaHabil](@DATE  DATE,@NDAYS INT)
returns DATE
  BEGIN
      IF @DATE IS NULL
        BEGIN
            RETURN NULL;
        END
          DECLARE @STARTDATE INT = 0
      DECLARE @COUNT INT = 0
      DECLARE @NEWDATE DATE=Dateadd(day, 1, @DATE)

      WHILE @COUNT < @NDAYS
        BEGIN
            IF Datepart(weekday, @NEWDATE) NOT IN ( 1 ) AND Datepart(weekday, @NEWDATE) NOT IN ( 7 )
               AND @NEWDATE NOT IN (SELECT Dia
                                    FROM   SAGRI_MOVIL.dbo.WS_DiasFestivos)
              SET @COUNT += 1;

            SELECT @NEWDATE = Dateadd(day, 1, @NEWDATE),
                   @STARTDATE += 1;
        END

      RETURN Dateadd(day, @STARTDATE, @DATE);
  END
GO
