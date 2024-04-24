ExUnit.start()
Faker.start()
Ecto.Adapters.SQL.Sandbox.mode(Pescarte.Database.Repo, :manual)

Mox.defmock(Supabase.GoTrueMock, for: Supabase.GoTrueBehaviour)
Mox.defmock(Supabase.GoTrue.AdminMock, for: Supabase.GoTrue.AdminBehaviour)
