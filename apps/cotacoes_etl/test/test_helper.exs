alias CotacoesETL.Integrations.IManagePesagroIntegration
Mox.defmock(IManagePesagroIntegrationMock, for: IManagePesagroIntegration)
Application.put_env(:cotacoes_etl, :pesagro_api, IManagePesagroIntegrationMock)

alias CotacoesETL.Integrations.IManageZamzarIntegration
Mox.defmock(IManageZamzarIntegrationMock, for: IManageZamzarIntegration)
Application.put_env(:cotacoes_etl, :zamzar_api, IManageZamzarIntegrationMock)

ExUnit.start()
