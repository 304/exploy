FROM elixir:1.4

RUN mix local.hex --force
RUN mkdir /app && cd app

WORKDIR app
CMD ["mix", "release"]
