/* SAGRISA legacy Movil - constraints. Generado desde movil.sql. Conectarse a la base destino antes de ejecutar. */

ALTER TABLE [dbo].[Cargos] ADD  CONSTRAINT [DF_Cargos_Tipo]  DEFAULT ((1)) FOR [Tipo]
GO
ALTER TABLE [dbo].[CorreosPendientes] ADD  DEFAULT (getdate()) FOR [FechaRegistro]
GO
ALTER TABLE [dbo].[CorreosPendientes] ADD  DEFAULT ((0)) FOR [Procesado]
GO
ALTER TABLE [dbo].[PedidoDetalle] ADD  CONSTRAINT [DF_PedidoDetalle_Origen]  DEFAULT ('MOV') FOR [Origen]
GO
ALTER TABLE [dbo].[PedidoEncabezado] ADD  CONSTRAINT [DF_PedidoEncabezado_Origen]  DEFAULT (N'MOV') FOR [Origen]
GO
ALTER TABLE [dbo].[Cobro]  WITH CHECK ADD FOREIGN KEY([banco_fk_cobro])
REFERENCES [dbo].[Banco] ([id_banco])
GO
ALTER TABLE [dbo].[Cobro]  WITH CHECK ADD FOREIGN KEY([marca_tarjeta_fk_cobro])
REFERENCES [dbo].[MarcaTarjeta] ([id_marca_tarjeta])
GO
ALTER TABLE [dbo].[Cobro]  WITH CHECK ADD FOREIGN KEY([metodo_pago_fk_cobro])
REFERENCES [dbo].[MetodoPago] ([id_metodo_pago])
GO
ALTER TABLE [dbo].[SAGPagosDetalle]  WITH CHECK ADD  CONSTRAINT [FK_SAGPagosDetalle_SAGPagosEncabezado] FOREIGN KEY([NumPago])
REFERENCES [dbo].[SAGPagosEncabezado] ([NumPago])
GO
ALTER TABLE [dbo].[SAGPagosDetalle] CHECK CONSTRAINT [FK_SAGPagosDetalle_SAGPagosEncabezado]
GO
