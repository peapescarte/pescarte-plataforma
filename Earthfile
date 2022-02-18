# Db args
ARG POSTGRES="13.5"
ARG PG_USER="pescarte"
ARG PG_PASS="pescarte"
ARG PG_DB="fuschia_test"

# App versions
ARG ELIXIR="1.13.2"
ARG OTP="24.0.2"

all:
  BUILD +format
  BUILD +credo
  BUILD +all-test

all-test:
  BUILD +unit-test
  BUILD +integration-test
  BUILD +rollback

format:
  FROM +test-setup

  RUN mix format --check-formatted

credo:
  FROM +test-setup

  RUN mix credo --strict

rollback:
  FROM +test-setup

  WITH DOCKER \
        --pull "postgres:$POSTGRES"
        RUN set -e; \
            timeout=$(expr $(date +%s) + 30); \
            docker run --name pg --network=host -d -e POSTGRES_USER=$PG_USER -e POSTGRES_PASSWORD=$PG_PASS -e POSTGRES_DB=$PG_DB "postgres:$POSTGRES"; \
            # wait for postgres to start
            while ! pg_isready --host=127.0.0.1 --port=5432 --quiet; do \
                test "$(date +%s)" -le "$timeout" || (echo "timed out waiting for postgres"; exit 1); \
                echo "waiting for postgres"; \
                sleep 1; \
            done; \
            # run tests
            mix do ecto.rollback --all, ecto.migrate;
  END

unit-test:
  FROM +test-setup

  WITH DOCKER \
        --pull "postgres:$POSTGRES"
        RUN set -e; \
            timeout=$(expr $(date +%s) + 30); \
            docker run --name pg --network=host -d -e POSTGRES_USER=$PG_USER -e POSTGRES_PASSWORD=$PG_PASS -e POSTGRES_DB=$PG_DB "postgres:$POSTGRES"; \
            # wait for postgres to start
            while ! pg_isready --host=127.0.0.1 --port=5432 --quiet; do \
                test "$(date +%s)" -le "$timeout" || (echo "timed out waiting for postgres"; exit 1); \
                echo "waiting for postgres"; \
                sleep 1; \
            done; \
            # run tests
            mix test --only unit;
  END

integration-test:
  FROM +test-setup

  WITH DOCKER \
        --pull "postgres:$POSTGRES"
        RUN set -e; \
            timeout=$(expr $(date +%s) + 30); \
            docker run --name pg --network=host -d -e POSTGRES_USER=$PG_USER -e POSTGRES_PASSWORD=$PG_PASS -e POSTGRES_DB=$PG_DB "postgres:$POSTGRES"; \
            # wait for postgres to start
            while ! pg_isready --host=127.0.0.1 --port=5432 --quiet; do \
                test "$(date +%s)" -le "$timeout" || (echo "timed out waiting for postgres"; exit 1); \
                echo "waiting for postgres"; \
                sleep 1; \
            done; \
            # run tests
            mix test --only integration;
  END

setup-base:
  FROM hexpm/elixir:$ELIXIR-erlang-$OTP-alpine-3.13.3

  RUN apk add --no-progress --update git build-base
  ENV ELIXIR_ASSERT_TIMEOUT=10000
  WORKDIR /src

test-setup:
  FROM +setup-base

  RUN apk add --no-progress --update docker docker-compose postgresql-client

  COPY mix.exs mix.lock .formatter.exs .
  COPY --dir config lib priv test .

  RUN mix local.rebar --force --if-missing
  RUN mix local.hex --force --if-missing

  ENV MIX_ENV="test"

  RUN mix deps.get
  RUN mix compile
