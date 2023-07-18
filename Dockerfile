FROM hexpm/elixir:1.14.5-erlang-25.3.2.4-debian-buster-20230612-slim as builder

RUN apt-get update -y \
  && apt-get install -y --no-install-recommends build-essential curl inotify-tools \
  && curl -fsSL https://deb.nodesource.com/setup_17.x | bash - \
  && apt-get install -y --no-install-recommends nodejs \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN mix local.hex --force && \
  mix local.rebar --force

ARG MIX_ENV=prod

COPY mix.exs mix.lock ./

# copy all mix.exs from umbrella apps
# to corresponding folder
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

# compile assets
COPY apps/plataforma_digital/assets ./apps/plataforma_digital/assets/
RUN npm i --prefix ./apps/plataforma_digital/assets && mix assets.deploy

# copy source code and static files
COPY apps/cotacoes/lib ./apps/cotacoes/lib
COPY apps/cotacoes_etl/lib ./apps/cotacoes_etl/lib
COPY apps/database/lib ./apps/database/lib
COPY apps/identidades/lib ./apps/identidades/lib
COPY apps/modulo_pesquisa/lib ./apps/modulo_pesquisa/lib
COPY apps/plataforma_digital/lib ./apps/plataforma_digital/lib
COPY apps/plataforma_digital_api/lib ./apps/plataforma_digital_api/lib
COPY apps/proxy_web/lib ./apps/proxy_web/lib
COPY apps/seeder/lib ./apps/seeder/lib

COPY apps/cotacoes/priv ./apps/cotacoes/priv
COPY apps/identidades/priv ./apps/identidades/priv
COPY apps/modulo_pesquisa/priv ./apps/modulo_pesquisa/priv
COPY apps/plataforma_digital/priv ./apps/plataforma_digital/priv

# Compile the release
RUN mix compile

# Changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/

COPY rel rel
RUN mix release

FROM builder as runner

RUN apt-get update -y
RUN apt-get install -y iputils-ping libstdc++6 inotify-tools \
    openssl libncurses5 locales postgresql-client \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen \
    && locale-gen

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
