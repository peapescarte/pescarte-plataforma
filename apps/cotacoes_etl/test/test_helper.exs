alias CotacoesETL.Integrations.IManagePesagroIntegration
Mox.defmock(IManagePesagroIntegrationMock, for: IManagePesagroIntegration)
Application.put_env(:cotacoes_etl, :pesagro_api, IManagePesagroIntegrationMock)

ExUnit.start()
