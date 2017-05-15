FROM elixir:1.4.2

WORKDIR /app

RUN echo deb http://ftp.nl.debian.org/debian jessie-backports main >> /etc/apt/sources.list && \
    apt-get update -y && \
    apt-get install -yqq ffmpeg

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
