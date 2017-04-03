FROM elixir:1.4.2

WORKDIR /app

COPY . /app

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN mix compile

CMD ["mix", "phoenix.server"]
