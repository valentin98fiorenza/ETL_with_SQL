CREATE DATABASE DW_COMERCIAL;

USE DW_COMERCIAL;


/* Las tablas de Staging fueron cargadas con la opción Import Data de SQL SERVER
en lugar de crear tablas previas y luego realizar inserts. De todos modos, si se quisieran crear
dichas tablas, se puede realizar mediante los siguientes códigos:


-- Creación tabla STG_DIM_CATEGORIA

CREATE TABLE [dbo].[STG_DIM_CATEGORIA] (
[DESC_CATEGORIA] VARCHAR(500),
[COD_CATEGORIA] VARCHAR(500)
);


-- Creación tabla STG_DIM_CLIENTE

CREATE TABLE [dbo].[STG_DIM_CLIENTE] (
[DESC_CLIENTE] VARCHAR(500),
[COD_CLIENTE] VARCHAR(500)
);



-- Creación tabla STG_DIM_PAIS

CREATE TABLE [dbo].[STG_DIM_PAIS] (
[DESC_PAIS] VARCHAR(500),
[COD_PAIS] VARCHAR(500)
);



-- Creación tabla STG_DIM_PRODUCTO

CREATE TABLE [dbo].[STG_DIM_PRODUCTO] (
[DESC_PRODUCTO] VARCHAR(500),
[COD_PRODUCTO] VARCHAR(500)
);



-- Creación tabla STG_DIM_SUCURSAL

CREATE TABLE [dbo].[STG_DIM_SUCURSAL] (
[DESC_SUCURSAL] VARCHAR(500),
[COD_SUCURSAL] VARCHAR(500)
);



-- Creación tabla STG_DIM_VENDEDOR

CREATE TABLE [dbo].[STG_DIM_VENDEDOR] (
[DESC_VENDEDOR] VARCHAR(500),
[COD_VENDEDOR] VARCHAR(500)
);



-- Creación tabla STG_FACT_VENTAS

CREATE TABLE [dbo].[STG_FACT_VENTAS] (
[COD_PRODUCTO] VARCHAR(500),
[COD_CATEGORIA] VARCHAR(500),
[COD_CLIENTE] VARCHAR(500),
[COD_PAIS] VARCHAR(500),
[COD_VENDEDOR] VARCHAR(500),
[COD_SUCURSAL] VARCHAR(500),
[FECHA] VARCHAR(500),
[CANTIDAD_VENDIDA] VARCHAR(500),
[MONTO_VENDIDO]VARCHAR(500),
[PRECIO] VARCHAR(500),
[COMISION_COMERCIAL] VARCHAR(500)
);


*/


--- Creación tablas INT ---

-- Creación INT de categoria
 
CREATE TABLE [dbo].[INT_DIM_CATEGORIA](
	[COD_CATEGORIA] [varchar](500) NULL,
	[DESC_CATEGORIA] [varchar](500) NULL	
);


-- Creación INT de Cliente

CREATE TABLE [dbo].[INT_DIM_CLIENTE](
	[COD_CLIENTE] [varchar](500) NULL,
	[NOMBRE] [varchar](500) NULL,
	[APELLIDO] [varchar](500) NULL
	);


-- Creación INT de Pais

CREATE TABLE [dbo].[INT_DIM_PAIS](
	[COD_PAIS] [varchar](3) NULL,
	[DESC_PAIS] [varchar](500) NULL
);


-- Creación INT de Producto

CREATE TABLE [dbo].[INT_DIM_PRODUCTO](
	[COD_PRODUCTO] [varchar](500) NULL,
	[DESC_PRODUCTO] [varchar](500) NULL	
);


-- Creación INT de Sucursal

CREATE TABLE [dbo].[INT_DIM_SUCURSAL](
	[COD_SUCURSAL] [varchar](500) NULL,
	[DESC_SUCURSAL] [varchar](500) NULL	
);


-- Creación INT de Vendedor

CREATE TABLE [dbo].[INT_DIM_VENDEDOR](
	[COD_VENDEDOR] [varchar](500) NULL,
	[NOMBRE] [varchar](500) NULL,
	[APELLIDO] [varchar](500) NULL
);


-- Creación INT de Ventas

CREATE TABLE [dbo].[INT_FACT_VENTAS](
	[COD_PRODUCTO] [varchar](100) NULL,
	[COD_CATEGORIA] [varchar](100) NULL,
	[COD_CLIENTE] [varchar](100) NULL,
	[COD_PAIS] [varchar](100) NULL,
	[COD_VENDEDOR] [varchar](100) NULL,
	[COD_SUCURSAL] [varchar](100) NULL,
	[FECHA] [smalldatetime] NULL,
	[CANTIDAD_VENDIDA] decimal(18,2) NULL,
	[MONTO_VENDIDO] decimal(18,2) NULL,
	[PRECIO] decimal(18,2) NULL,
	[COMISION_COMERCIAL] decimal(18,2) NULL
);


--- Creación tablas DIM y FACT ---

-- Creación DIM Categoría

CREATE TABLE [dbo].[DIM_CATEGORIA](
	[CATEGORIA_KEY] [int] IDENTITY(1,1) NOT NULL,
	[COD_CATEGORIA] [varchar](500) NOT NULL,
	[DESC_CATEGORIA] [varchar](500) NOT NULL,
	[FECHA_ALTA] [datetime],
	[USUARIO_ALTA] [varchar](500),
	[FECHA_UPDATE] [Datetime],
	[USUARIO_UPDATE] [varchar](500),
	PRIMARY KEY(CATEGORIA_KEY)
);


-- Creación DIM Cliente

CREATE TABLE [dbo].[DIM_CLIENTE](
	[CLIENTE_KEY] [int] IDENTITY(1,1) NOT NULL,
	[COD_CLIENTE] [varchar](500) NOT NULL,
	[NOMBRE] [varchar](500) NOT NULL,
	[APELLIDO] [varchar](500) NOT NULL,
	[FECHA_ALTA] [datetime] NULL,
	[USUARIO_ALTA] [varchar](500),
	[FECHA_UPDATE] [Datetime],
	[USUARIO_UPDATE] [varchar](500),
	PRIMARY KEY (CLIENTE_KEY)
);


-- Creación DIM Pais

CREATE TABLE [dbo].[DIM_PAIS](
	[PAIS_KEY] [int] IDENTITY(1,1) NOT NULL,
	[COD_PAIS] [varchar](3) NOT NULL,
	[DESC_PAIS] [varchar](500) NOT NULL,
	[FECHA_ALTA] [datetime] NULL,
	[USUARIO_ALTA] [varchar](500),
	[FECHA_UPDATE] [Datetime],
	[USUARIO_UPDATE] [varchar](500),
	PRIMARY KEY(PAIS_KEY)
);


-- Creación DIM Producto

CREATE TABLE [dbo].[DIM_PRODUCTO](
	[PRODUCTO_KEY] [int] IDENTITY(1,1) NOT NULL,
	[COD_PRODUCTO] [varchar](500) NOT NULL,
	[DESC_PRODUCTO] [varchar](500) NOT NULL,
	[FECHA_ALTA] [datetime] NULL,
	[USUARIO_ALTA] [varchar](500),
	[FECHA_UPDATE] [Datetime],
	[USUARIO_UPDATE] [varchar](500),
	PRIMARY KEY(PRODUCTO_KEY)
);


-- Creación DIM Sucursal

CREATE TABLE [dbo].[DIM_SUCURSAL](
	[SUCURSAL_KEY] [int] IDENTITY(1,1) NOT NULL,
	[COD_SUCURSAL] [varchar](500) NOT NULL,
	[DESC_SUCURSAL] [varchar](500) NOT NULL,
	[FECHA_ALTA] [datetime] NULL,
	[USUARIO_ALTA] [varchar](500),
	[FECHA_UPDATE] [Datetime],
	[USUARIO_UPDATE] [varchar](500),
	PRIMARY KEY(SUCURSAL_KEY)
);


-- Creación DIM Vendedor

CREATE TABLE [dbo].[DIM_VENDEDOR](
	[VENDEDOR_KEY] [int] IDENTITY(1,1) NOT NULL,
	[COD_VENDEDOR] [varchar](500) NOT NULL,
	[NOMBRE] [varchar](500) NOT NULL,
	[APELLIDO] [varchar](500) NOT NULL,
	[FECHA_ALTA] [datetime] NULL,
	[USUARIO_ALTA] [varchar](500),
	[FECHA_UPDATE] [Datetime],
	[USUARIO_UPDATE] [varchar](500),
	PRIMARY KEY(VENDEDOR_KEY)
);


-- Creación DIM Tiempo

CREATE TABLE [dbo].[DIM_TIEMPO](
	[TIEMPO_KEY] [smalldatetime],
	[ANIO] [int],
	[MES_NRO] [int],
	[MES_NOMBRE] [varchar](15),
	[SEMESTRE] [int],
	[TRIMESTRE] [int],
	[SEMANA_ANIO] [int],
	[SEMANA_NRO_MES] [int],
	[DIA] [int],
	[DIA_NOMBRE] [varchar](20),
	[DIA_SEMANA_NRO] [int],
	[FECHA_ALTA] [Datetime],
	[USUARIO_ALTA] [varchar](500),
	[FECHA_UPDATE] [Datetime],
	[USUARIO_UPDATE] [varchar](500),
	PRIMARY KEY(TIEMPO_KEY)
);



-- Creación FACT Ventas

CREATE TABLE [DW_COMERCIAL].[dbo].[FACT_VENTAS](
	[PRODUCTO_KEY] [int] NOT NULL,
	[CATEGORIA_KEY] [int] NOT NULL,
	[CLIENTE_KEY] [int] NOT NULL,
	[PAIS_KEY] [int] NOT NULL,
	[VENDEDOR_KEY] [int] NOT NULL,
	[SUCURSAL_KEY] [int] NOT NULL,
	[TIEMPO_KEY] [smalldatetime] NOT NULL,
	[CANTIDAD_VENDIDA] decimal(18,2),
	[MONTO_VENDIDO] decimal(18,2),
	[PRECIO] decimal(18,2),
	[COMISION_COMERCIAL] decimal(18,2),
	[FECHA_ALTA] [Datetime],
	[USUARIO_ALTA] [varchar](500),
	PRIMARY KEY([PRODUCTO_KEY],[CLIENTE_KEY],[VENDEDOR_KEY],[TIEMPO_KEY],[SUCURSAL_KEY])
);
