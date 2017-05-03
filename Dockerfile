FROM elixir:1.4.2

WORKDIR /app

ENV MIX_ENV=prod

COPY docker-entrypoint.sh /entrypoint

RUN mix local.hex --force && \
    mix local.rebar --force

COPY config ./config
COPY mix.* ./
RUN mix do deps.get, deps.compile

RUN cd deps/comeonin && make clean && make

COPY . ./

RUN mix compile

ENTRYPOINT ["/entrypoint"]
CMD ["mix", "phoenix.server"]
