FROM hexpm/elixir:1.14.5-erlang-25.3.2.4-debian-buster-20230612-slim as builder

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update -y \
  && apt-get install -y --no-install-recommends build-essential curl \
  && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get install -y --no-install-recommends nodejs \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /pescarte

RUN mix local.hex --force && \
  mix local.rebar --force

ARG MIX_ENV=prod

COPY mix.exs mix.lock ./

# copy all mix.exs from umbrella apps
# to corresponding folder
COPY apps/catalogo/mix.exs ./apps/catalogo/
COPY apps/cotacoes/mix.exs ./apps/cotacoes/
COPY apps/cotacoes_etl/mix.exs ./apps/cotacoes_etl/
COPY apps/database/mix.exs ./apps/database/
COPY apps/identidades/mix.exs ./apps/identidades/
COPY apps/modulo_pesquisa/mix.exs ./apps/modulo_pesquisa/
COPY apps/plataforma_digital/mix.exs ./apps/plataforma_digital/
COPY apps/plataforma_digital_api/mix.exs ./apps/plataforma_digital_api/
COPY apps/proxy_web/mix.exs ./apps/proxy_web/
COPY apps/seeder/mix.exs ./apps/seeder/


RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

# to be re-compiled.
COPY config/config.exs config/${MIX_ENV}.exs config/

# compile static and dynamic assets
COPY apps/plataforma_digital/priv ./apps/plataforma_digital/priv
COPY apps/plataforma_digital/assets ./apps/plataforma_digital/assets
RUN ["npm", "ci", "--prefix", "./apps/plataforma_digital/assets/"]

# copy source code and static files
COPY apps/catalogo/lib ./apps/catalogo/lib
COPY apps/cotacoes/lib ./apps/cotacoes/lib
COPY apps/cotacoes_etl/lib ./apps/cotacoes_etl/lib
COPY apps/database/lib ./apps/database/lib
COPY apps/seeder/lib ./apps/seeder/lib
COPY apps/proxy_web/lib ./apps/proxy_web/lib
COPY apps/identidades/lib ./apps/identidades/lib
COPY apps/modulo_pesquisa/lib ./apps/modulo_pesquisa/lib
COPY apps/plataforma_digital/lib ./apps/plataforma_digital/lib
COPY apps/plataforma_digital_api/lib ./apps/plataforma_digital_api/lib

COPY apps/cotacoes/priv ./apps/cotacoes/priv
COPY apps/identidades/priv ./apps/identidades/priv
COPY apps/modulo_pesquisa/priv ./apps/modulo_pesquisa/priv

# Compile the release
RUN mix compile

# Changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/

FROM builder as dev

ARG MIX_ENV="dev"

WORKDIR /pescarte

RUN apt-get update -y && apt-get install -y --no-install-recommends inotify-tools glibc-source

COPY config/test.exs ./config/
COPY /apps/cotacoes/test ./apps/cotacoes/test
COPY /apps/identidades/test ./apps/identidades/test
COPY /apps/modulo_pesquisa/test ./apps/modulo_pesquisa/test
COPY /apps/plataforma_digital/test ./apps/plataforma_digital/test
COPY /apps/plataforma_digital_api/test ./apps/plataforma_digital_api/test

RUN mix deps.get
RUN mix do deps.compile, compile

CMD ["mix", "phx.server"]

FROM builder as production

WORKDIR /pescarte
RUN chown nobody /pescarte

RUN apt-get update -y
RUN apt-get install -y iputils-ping libstdc++6 glibc-source \
    openssl libncurses5 locales postgresql-client \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen \
    && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# set runner ENV
ENV MIX_ENV="prod"

COPY rel rel
RUN mix assets.deploy
RUN mix release

USER nobody

CMD ["/pescarte/_build/prod/rel/pescarte/bin/server"]
