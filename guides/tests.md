# Testes

## Tags de módulo

Para criarmos uma separação das diferentes suítes de testes, priorizamos o uso
do atributo de módulo `@moduletag` em que se especifica o contexto dos testes
de um determinado módulo.

### Exemplo

#### Teste unitário
```elixir
defmodule Pescarte.UnitTests do
  @moduletag :unit

  describe "Test a function" do
    # ...
  end
end
```

#### Teste de integração
```elixir
defmodule Pescarte.IntegrationTests do
  @moduletag :integration

  describe "Test an external endpoint" do
   # ...
  end
end
```
