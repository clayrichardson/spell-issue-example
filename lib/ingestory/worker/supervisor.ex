defmodule Ingestory.Worker.Supervisor do
  use Supervisor

  @name Ingestory.Worker.Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
    #Supervisor.start_child(@name, [])
  end

  # def start_worker do
  #   Supervisor.start_child(@name, [])
  # end

  def init(:ok) do
    children = [
      worker(Ingestory.Worker, [{:poloniex, "asdf"}], [restart: :permanent]),
    ]

    supervise(children, strategy: :one_for_one, restart: :permanent)
  end
end
