defmodule Ingestory.Worker do
  use GenServer
  require Logger

  ## Client API

  def start_link({exchange_name, uri}) do
    GenServer.start_link(__MODULE__, {exchange_name, uri}, name: exchange_name)
  end

  ## Server callbacks

  @doc """
  This handles the messages from the subscriptions
  """
  def handle_info(message, state) do
    IO.inspect message
    case message do
      {spell_peer, pid, spell_message} ->
        IO.inspect Map.keys(spell_message)
        # This will cause the GenServer to crash, and spawn multiple spell pids.
        Logger.debug "__struct__: #{spell_message.__struct}"
    end
    {:noreply, state}
  end

  def init({exchange_name, uri}) do
    connect({exchange_name, uri})
  end

  def connect({exchange_name, uri}) do
    Logger.debug fn -> "CONNECTING TO: #{exchange_name} via #{uri}" end
    publisher = Spell.connect(
      "wss://api.poloniex.com",
      realm: "realm1",
      roles: [Spell.Role.Subscriber],
      timeout: 1,
    )
    case publisher do
      {:ok, peer_pid} ->
        case subscribe(peer_pid, "ticker", []) do
          {:ok, subscription_pid} -> {:ok, subscription_pid}
          {:error, reason} -> {:error, reason}
        end
        case subscribe(peer_pid, "BTC_XRP", []) do
          {:ok, subscription_pid} -> {:ok, subscription_pid}
          {:error, reason} -> {:error, reason}
        end
      {:error, timeout} ->
        Logger.debug fn ->
          "timeout problem lol: #{timeout}"
        end
        {:stop, timeout}
    end
  end

  def subscribe(pid, channel, options \\ []) do
    case Spell.cast_subscribe(pid, channel, options) do
      {:ok, subscriber} -> {:ok, subscriber}
      {:error, reason} ->
        {:stop, reason}
    end
  end
end
