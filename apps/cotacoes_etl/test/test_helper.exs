alias CotacoesETL.Integrations.IManagePesagroIntegration
Mox.defmock(IManagePesagroIntegrationMock, for: IManagePesagroIntegration)
Application.put_env(:cotacoes_etl, :pesagro_api, IManagePesagroIntegrationMock)

alias CotacoesETL.Integrations.IManageZamzarIntegration
Mox.defmock(IManageZamzarIntegrationMock, for: IManageZamzarIntegration)
Application.put_env(:cotacoes_etl, :zamzar_api, IManageZamzarIntegrationMock)

alias CotacoesETL.Handlers.IManagePesagroHandler
Mox.defmock(IManagePesagroHandlerMock, for: IManagePesagroHandler)
Application.put_env(:cotacoes_etl, :pesagro_handler, IManagePesagroHandlerMock)

alias CotacoesETL.Handlers.IManageZamzarHandler
Mox.defmock(IManageZamzarHandlerMock, for: IManageZamzarHandler)
Application.put_env(:cotacoes_etl, :zamzar_handler, IManageZamzarHandlerMock)

ExUnit.start()
