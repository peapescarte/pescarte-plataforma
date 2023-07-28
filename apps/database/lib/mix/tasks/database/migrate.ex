defmodule Mix.Tasks.Database.Migrate do
  use Mix.Task

  @impl true
  def run(args) do
    Application.load(:database)
    migrations_paths_args = String.split(migrations_paths(), " ", trim: true)
    Mix.Task.run("ecto.migrate", args ++ migrations_paths_args)
  end

  defp migrations_paths do
    paths = Database.migrations_paths(:dev)

    for path <- paths, reduce: "" do
      acc -> "--migrations-path #{path}" <> " " <> acc
    end
  end
end
