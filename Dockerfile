ARG ELIXIR_VERSION=1.14.2
ARG OTP_VERSION=25.1.2.1
ARG DEBIAN_VERSION=buster-20230109-slim

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

FROM ${BUILDER_IMAGE} as builder

RUN apt-get update -y && apt-get install -y build-essential curl \
  && curl -fsSL https://deb.nodesource.com/setup_17.x | bash - \
  && apt-get install -y nodejs

WORKDIR /app

RUN mix local.hex --force && \
  mix local.rebar --force

ENV MIX_ENV="prod"

COPY mix.exs mix.lock ./
COPY apps/catalogo/mix.exs ./apps/catalogo/
COPY apps/database/mix.exs ./apps/database/
COPY apps/seeder/mix.exs ./apps/seeder/
COPY apps/proxy_web/mix.exs ./apps/proxy_web/
COPY apps/identidades/mix.exs ./apps/identidades/
COPY apps/modulo_pesquisa/mix.exs ./apps/modulo_pesquisa/
COPY apps/plataforma_digital/mix.exs ./apps/plataforma_digital/
COPY apps/plataforma_digital_api/mix.exs ./apps/plataforma_digital_api/
COPY apps/cotacoes/mix.exs ./apps/cotacoes/


RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# to be re-compiled.
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

COPY apps/identidades/priv ./apps/identidades/priv
COPY apps/catalogo/priv ./apps/catalogo/priv
COPY apps/modulo_pesquisa/priv ./apps/modulo_pesquisa/priv
COPY apps/plataforma_digital/priv ./apps/plataforma_digital/priv
COPY apps/cotacoes/priv ./apps/cotacoes/priv

COPY apps/database/lib ./apps/database/lib
COPY apps/catalogo/lib ./apps/catalogo/lib
COPY apps/seeder/lib ./apps/seeder/lib
COPY apps/proxy_web/lib ./apps/proxy_web/lib
COPY apps/identidades/lib ./apps/identidades/lib
COPY apps/modulo_pesquisa/lib ./apps/modulo_pesquisa/lib
COPY apps/plataforma_digital/lib ./apps/plataforma_digital/lib
COPY apps/plataforma_digital_api/lib ./apps/plataforma_digital_api/lib
COPY apps/cotacoes/lib ./apps/cotacoes/lib

COPY apps/plataforma_digital/assets ./apps/plataforma_digital/assets/

# compile assets
RUN npm i --prefix ./apps/plataforma_digital/assets
RUN mix assets.deploy

# Compile the release
RUN mix compile

# Changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/

COPY rel rel
RUN mix release

FROM ${RUNNER_IMAGE}

RUN apt-get update -y \
  && apt-get install -y iputils-ping libstdc++6 openssl libncurses5 locales postgresql-client

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /pescarte
RUN chown nobody /pescarte

# set runner ENV
ENV MIX_ENV="prod"

# Only copy the final release from the build stage
COPY --from=builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/pescarte ./

USER nobody

CMD ["bin/server"]
