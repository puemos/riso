# Stage 1 - the build process
FROM registry.gitlab.com/matthieusegret/riso-phoenix-graphql/elixir:1.6.5 as build

WORKDIR /app
ENV MIX_ENV=prod

COPY mix.exs mix.lock ./
COPY rel ./rel
COPY config ./config
COPY lib ./lib
COPY priv ./priv

RUN mix do deps.get --only $MIX_ENV, deps.compile && \
  mix phx.digest && \
  mix release --env=$MIX_ENV --verbose
RUN mv $(ls -d _build/prod/rel/riso/releases/*/riso.tar.gz) ./

# Stage 2 - the production environment
FROM alpine:3.6

WORKDIR /opt/app/

# we need bash and openssl for Phoenix
RUN apk add --no-cache bash openssl imagemagick

ENV MIX_ENV=prod \
  REPLACE_OS_VARS=true \
  PORT=80 \
  SHELL=/bin/bash

COPY --from=build /app/riso.tar.gz ./
RUN tar -xzf riso.tar.gz

EXPOSE $PORT

ENTRYPOINT ["/opt/app/bin/riso"]
CMD ["foreground"]