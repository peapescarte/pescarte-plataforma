VERSION 0.7

deps:
  ARG ELIXIR=1.16.0
  ARG OTP=26.1.2
  ARG ALPINE_VERSION=3.18.4
  FROM hexpm/elixir:${ELIXIR}-erlang-${OTP}-alpine-${ALPINE_VERSION}
  RUN apk update --no-cache
  RUN apk add --no-cache build-base gcc git curl
  WORKDIR /src
  COPY mix.exs mix.lock ./
  COPY --dir config lib . # check .earthlyignore
  RUN mix local.rebar --force
  RUN mix local.hex --force
  RUN mix deps.get
  SAVE ARTIFACT /src/deps AS LOCAL deps

ci:
  FROM +deps
  COPY .credo.exs .
  COPY .formatter.exs .
  RUN mix clean
  RUN mix compile --warning-as-errors
  RUN mix format --check-formatted
  RUN mix credo --strict

test:
  FROM +deps
  RUN apk add postgresql-client
  COPY --dir config ./
  RUN MIX_ENV=test mix deps.compile
  COPY docker-compose.ci.yml ./docker-compose.yml
  COPY mix.exs mix.lock ./
  COPY .env-sample ./
  COPY --dir lib priv test ./

  WITH DOCKER --compose docker-compose.yml
    RUN while ! pg_isready --host=localhost --port=5432 --quiet; do sleep 1; done; \
        SUPABASE_KEY="123" SUPABASE_URL="123" DATABASE_USER="peapescarte" DATABASE_PASS="peapescarte" mix test
  END

docker-prod:
  FROM DOCKERFILE .
  ARG GITHUB_REPO
  SAVE IMAGE --push ghcr.io/$GITHUB_REPO:prod

docker-dev:
  FROM +deps
  RUN apk update --no-cache
  RUN apk add --no-cache inotify-tools
  ENV MIX_ENV=dev
  COPY --dir config ./
  RUN mix deps.compile
  COPY --dir lib ./
  RUN mix compile
  CMD ["mix", "dev"]
  ARG GITHUB_REPO=peapescarte/pescarte-plataforma
  SAVE IMAGE --push ghcr.io/$GITHUB_REPO:dev

docker:
  BUILD +docker-dev
  BUILD +docker-prod
