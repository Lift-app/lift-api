FROM elixir:1.4.2

WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

COPY mix.* ./
RUN mix do deps.get, deps.compile

COPY . ./

CMD ["mix", "phoenix.server"]
