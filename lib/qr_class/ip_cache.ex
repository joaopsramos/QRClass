defmodule QRClass.IPCache do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ips_cache, name: __MODULE__)
  end

  def exists?(class_session_id, ip) do
    GenServer.call(__MODULE__, {:exists?, {class_session_id, ip}})
  end

  def put(class_session_id, ip) do
    GenServer.cast(__MODULE__, {:put, {class_session_id, ip}})
  end

  ## Server callbacks

  @impl true
  def init(table) do
    :ets.new(table, [:named_table, read_concurrency: true])

    {:ok, table}
  end

  @impl true
  def handle_call({:exists?, value}, _from, table) do
    exists =
      case :ets.lookup(table, value) do
        [{^value}] -> true
        [] -> false
      end

    {:reply, exists, table}
  end

  @impl true
  def handle_cast({:put, value}, table) do
    :ets.insert(table, {value})

    {:noreply, table}
  end

  @impl true
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
