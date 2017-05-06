defmodule Ingestory.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Ingestory.Worker.start_link(arg1, arg2, arg3)
      # worker(Ingestory.Worker, [arg1, arg2, arg3]),
      #worker(Ingestory.Worker, [{:poloniex, "asdf"}]),
      supervisor(Ingestory.Worker.Supervisor, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [
      strategy: :one_for_one,
      restart: :permanent,
      name: Ingestory.Supervisor
    ]
    Supervisor.start_link(children, opts)
  end
end
