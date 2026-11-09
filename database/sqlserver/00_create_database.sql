/*
    SAGRISA - creación de base SQL Server

    EJECUCIÓN:
    - SQL Server local: ejecutar conectado a master.
    - Azure SQL Database: NO ejecutar este archivo. Crear la base desde Azure
      y ejecutar únicamente 01_sagrisa_schema.sql dentro de esa base.

    Este archivo no modifica ni importa movil.sql.
*/

USE [master];
GO

IF DB_ID(N'SagrisaStaging') IS NULL
BEGIN
    CREATE DATABASE [SagrisaStaging];
END;
GO

ALTER DATABASE [SagrisaStaging] SET RECOVERY SIMPLE;
GO

