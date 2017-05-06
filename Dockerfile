FROM elixir:latest

RUN apt-get update && apt-get install -y inotify-tools

RUN yes | mix local.hex && yes | mix local.rebar
