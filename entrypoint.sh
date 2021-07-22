#!/bin/sh
# Docker entrypoint script.

# Wait until Postgres is ready
while ! pg_isready -q -d $DB_URL
do
  echo "$(date) - esperando conexão com o banco de dados..."
  sleep 2
done

echo "Conectada ao banco de dados!"

echo "Executando migrações..."

./prod/rel/conts/bin/conts eval Fuschia.Release.migrate

echo "Inicializando API Fuschia!"

./prod/rel/conts/bin/conts start
