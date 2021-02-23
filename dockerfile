FROM elixir:1.11.3-alpine as builder
WORKDIR /usr/src/app
COPY . .
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix release

FROM alpine:3.13
RUN apk add --no-cache ncurses-libs
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app/_build/dev/rel/bluec .
CMD [ "/usr/src/app/bin/bluec", "start" ]
EXPOSE 8080