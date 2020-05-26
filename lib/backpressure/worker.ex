defmodule Backpressure.Worker do
  use GenServer
  
  @long 400
  @short 200
    
  def start_link(initial_count) do
    GenServer.start_link(__MODULE__, initial_count, name: __MODULE__)
  end
    
  def toil_and_trouble(pid) do
    short_wait()
    work(pid)
    IO.puts(Process.info(pid, :message_queue_len) |> elem(1))
    toil_and_trouble(pid)
  end
  
  def work(pid) do
    GenServer.cast(pid, :work)
  end
  
  def init(initial_count) do
    {:ok, initial_count}
  end

  def handle_call(:work, _from, state) do
    long_job()
    {:reply, :ok, state + 1}
  end

  def handle_cast(:work, state) do
    long_job()
    {:noreply, state + 1}
  end
  
  def short_wait do
    Process.sleep(:random.uniform(@short))
  end
  
  def long_job do
    Process.sleep(:random.uniform(@long))
    :ok
  end  
end