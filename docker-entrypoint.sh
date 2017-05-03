#! /bin/sh

mix ecto.migrate

exec "$@"
