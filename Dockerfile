ARG ELIXIR_VERSION=1.18.0
ARG OTP_VERSION=27.1.2
ARG ALPINE_VERSION=3.19.4
ARG MIX_ENV=prod

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-alpine-${ALPINE_VERSION}"
ARG RUNNER_IMAGE="alpine:${ALPINE_VERSION}"

FROM ${BUILDER_IMAGE} AS builder

# prepare build dir
WORKDIR /app

RUN apk update --no-cache
RUN apk add --no-cache build-base gcc curl git wget nodejs npm

ARG MIX_ENV

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
# to be re-compiled.
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

COPY priv priv
COPY lib lib

# Compile the release
RUN mix compile

# compile assets
COPY assets assets

RUN mix assets.setup
RUN npm ci --prefix assets
RUN mix assets.deploy

# Changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/

# generate mappings for sentry stacktraces
RUN mix sentry.package_source_code

COPY rel rel
RUN mix release

# start a new build stage so that the final image will only contain
# the compiled release and other runtime necessities
FROM ${RUNNER_IMAGE} AS runner

RUN apk update --no-cache
RUN apk add --no-cache tzdata openssl ncurses wget
RUN apk add --no-cache chromium --repository=http://dl-cdn.alpinelinux.org/alpine/v3.18/community

ARG MIX_ENV

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

WORKDIR "/app"
RUN chown nobody /app

# set runner ENV
ENV MIX_ENV="prod"

# Only copy the final release from the build stage
COPY --from=builder --chown=nobody:root /app/_build/$MIX_ENV/rel/pescarte ./

USER nobody

CMD ["/app/bin/server"]
