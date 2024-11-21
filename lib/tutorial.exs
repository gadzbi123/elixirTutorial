_ = ~S"""
defmodule Tutorial do
  def hello do
    :world
  end

  def nil?(x \\ nil) when x == nil, do: true
  def nil?(x) when x == %{:name => ""}, do: true
  def nil?(x), do: false
end
IO.puts(Tutorial.nil?())
IO.puts(Tutorial.nil?(nil))
IO.puts(Tutorial.nil?(%{:name => ""}))
IO.puts(Tutorial.nil?(%{:namee => "abc"}))

defmodule Recursion do
  @type chardata :: String.t() | maybe_improper_list(char | chardata, String.t() | [])

  @spec print_multiple(chardata() | Strings.Chars.t(), non_neg_integer()) :: keyword()
  def print_multiple(msg, n) when n > 0 do
    IO.puts(msg)
    print_multiple(msg, n - 1)
  end

  def print_multiple(_msg, n) when n == 0, do: :end
  def print_multiple(_msg, n) when n < 0, do: raise("Should not pass negative to recursion")

  def double_dup([head | tail], length) when length > 0 do
    vals = tail ++ [head * 2, head * 2]
    double_dup(vals, length - 1)
  end

  def double_dup(list, _length) do
    list
  end
end

# Recursion.print_multiple("abc", 3)
list = [1, 2, 3]
new_list = [0, 0, 0]

# This shit sucks, i can make it imperative but it is
# a learning experience so i need to think about it more
brand_new =
Enum.zip_reduce(list, new_list, [], fn x, _, acc -> [x * 2 | acc] end)
IO.puts(brand_new)

parent = self()
spawn(fn -> send(parent, {:msg, "f u", :dest, self()}) end)
spawn(fn -> send(parent, {:msg, "f u", :dest, self()}) end)

receive do
  {:msg, msg, :dest, pid} ->
end


defmodule Recursion2 do
  def list_len([]), do: 0
  def list_len([_ | tail]), do: 1 + list_len(tail)

  def make_list(h, t) when h + 1 == t, do: [h]
  def make_list(h, t), do: [h | make_list(h + 1, t)]
end

IO.puts(Recursion2.list_len([1, 2, 3, 4]))
# IO.puts(Recursion2.make_list(1, 10))

defmodule FileCalcs do
  def lines_length() do
    File.read!("./files/1.input")
    |> String.split()
    |> Enum.map(&String.length(&1))

    # |> inspect(charlists: :as_lists)

    #   |> Enum.map(fn x -> String.length(x) end)
    #   |> Enum.reduce(fn x, acc -> max(x, acc) end)
  end

  def longest_line() do
    lines_length()
    |> Enum.reduce(&max(&1, &2))
  end

  defp words_in_line(line) do
    String.split(line)
    |> length()
  end

  def words_per_line() do
    File.stream!("./files/1.input")
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.map(&words_in_line/1)
  end
end

Stream.drop([1, 2, 3, 4, 5], 2) |> Stream.take(2) |> Enum.to_list() |> IO.inspect()
# IO.puts(FileCalcs.longest_line())
IO.inspect(FileCalcs.words_per_line())

defmodule Player do
  defstruct name: "", age: 0
  def new(name, age), do: %Player{name: name, age: age}

  # Here
  #   defimpl String.Chars do
  #     def to_string(v) do
  #       "Name: \"{v.name}\", Age: {v.age}"
  #     end
  #   end
end

# or Here
defimpl String.Chars, for: Player do
  def to_string(v) do
    "Name: {v.name}, Age: {v.age}"
  end
end

IO.puts(Player.new("sonic", 5))

defmodule Concurrent do
  def task(i) do
    parent = self()

    spawn(fn ->
      Process.sleep(1000)
      send(parent, {:ok, i})
    end)
  end

  def receive(_) do
    receive do
      {:ok, i} ->
        IO.puts("Task #{i} finished")
    end
  end
end

range = 1..5

range
|> Enum.map(&Concurrent.task/1)

range
|> Enum.map(&Concurrent.receive/1)

defmodule MyError do
  defexception message: "My msg"
end

defimpl String.Chars, for: MyError do
  def to_string(%MyError{message: msg}) do
    msg
  end
end

try do
  #   raise MyError
rescue
  e in RuntimeError ->
    e

  e in MyError ->
    # %MyError{message: msg} = e
    IO.puts(e)
end

:io.format("xd: ~5.4f\n", [:math.pi()])
:io.format("password: ~1s\n", ["my pass 123 xddd"])

[1, 2, 3]
|> IO.inspect(label: "before")
|> Enum.map(fn x -> x * x end)
|> IO.inspect(label: "after")
|> dbg()

# :socket.


# This fails due to atom limit of 1_048_576
# 1..1_048_577 |> Enum.map(fn _ -> String.to_atom("ok") end) |> IO.inspect()
# This works because we are reusing :ok atom
1..1_048_577 |> Enum.map(fn _ -> String.to_existing_atom("ok") end) |> IO.inspect()


# CHAPTER 6
defmodule ServerProcess do
  def start(callback_mod) do
    spawn(fn ->
      init = callback_mod.init()
      loop(callback_mod, init)
    end)
  end

  defp loop(callback_mod, curr_state) do
    receive do
      {:call, request, caller} ->
        {response, new_state} = callback_mod.handle_call(request, curr_state)
        send(caller, {:response, response})
        loop(callback_mod, new_state)

      {:cast, request} ->
        new_state = callback_mod.handle_cast(request, curr_state)
        loop(callback_mod, new_state)
    end
  end

  def call(server_pid, request) do
    send(server_pid, {:call, request, self()})

    receive do
      {:response, response} ->
        response
    end
  end

  def cast(server_pid, request) do
    send(server_pid, {:cast, request})
  end
end

defmodule KeyValueStore do
  def init() do
    %{}
  end

  def handle_call({:put, key, value}, curr_state) do
    {:ok, Map.put(curr_state, key, value)}
  end

  def handle_call({:get, key}, curr_state) do
    {Map.get(curr_state, key), curr_state}
  end

  def handle_call({:delete, key}, curr_state) do
    {Map.get(curr_state, key), Map.delete(curr_state, key)}
  end

  def handle_cast({:delete, key}, curr_state) do
    Map.delete(curr_state, key)
  end

  def handle_cast({:put, key, value}, curr_state) do
    Map.put(curr_state, key, value)
  end
end

pid = ServerProcess.start(KeyValueStore)
ServerProcess.call(pid, {:put, :some_key, :some_value}) |> IO.inspect()
ServerProcess.call(pid, {:get, :some_key}) |> IO.inspect()
ServerProcess.cast(pid, {:put, :k1, :v1})
# You can't make a cast on get request because cast don't wait for the response
# from the server. You can do put and other modifications.
# ServerProcess.cast(pid, {:get, :k1})
ServerProcess.call(pid, {:get, :k1}) |> IO.inspect()
ServerProcess.cast(pid, {:delete, :k1})
ServerProcess.call(pid, {:delete, :some_key}) |> IO.inspect()
ServerProcess.call(pid, {:get, :some_key}) |> IO.inspect()


defmodule FlyingBehaviour do
  @callback fly(obj :: String.t()) :: nil
end

defmodule EatingBehaviour do
  @callback eat(obj :: String.t()) :: nil
end

defmodule Dog do
  @behaviour EatingBehaviour
  def eat(dog) do
    IO.puts(dog <> " eats!")
  end
end

defmodule Bird do
  @behaviour FlyingBehaviour
  def fly(bird) do
    IO.puts(bird <> " flies!")
  end
end

Dog.eat("Dogo")
Bird.fly("Birdo")


defmodule KeyValueStore do
  use GenServer

  def start do
    GenServer.start(KeyValueStore, nil, name: :state)
  end

  def put(pid, key, value) do
    GenServer.cast(pid, {:put, key, value})
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  @impl true
  def init(init_state \\ nil) do
    # :timer.send_interval(5000, :cleanup)
    {:ok, init_state || %{}}
  end

  @impl true
  def handle_info(:cleanup, a_state) do
    IO.puts("removing :a...")
    {:noreply, Map.delete(a_state, :a)}
  end

  @impl true
  def handle_cast({:put, key, value}, curr_state) do
    {:noreply, Map.put(curr_state, key, value)}
  end

  @impl GenServer
  def handle_call({:get, key}, _, curr_state) do
    {:reply, Map.get(curr_state, key), curr_state}
  end
end

{:ok, pid} = KeyValueStore.start()
KeyValueStore.put(pid, :a, :b)
KeyValueStore.get(pid, :a) |> IO.inspect()

GenServer.call(:state, {:get, :a}) |> IO.inspect()
"""

defmodule KeyValueStore.Database do
  @behaviour GenServer

  def start do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  @db_folder "./persistent"
  @impl GenServer
  def init(_) do
    File.mkdir_p!(@db_folder)
    {:ok, start_workers()}
  end

  defp start_workers() do
    for id <- 1..3, into: %{} do
      {:ok, pid} = KeyValueStore.DatabaseWorker.start(@db_folder)
      {id - 1, pid}
    end
  end

  def store(key, data) do
    key
    |> choose_worker()
    |> KeyValueStore.DatabaseWorker.store(key, data)
  end

  defp choose_worker(key) do
    GenServer.call(__MODULE__, {:choose_worker, key})
  end

  @impl GenServer
  def handle_call({:choose_worker, key}, _, state) do
    worker_key = :erlang.phash2(key, 3)
    IO.puts("Returning worker #{worker_key} from key #{key}")
    {:reply, Map.get(state, worker_key), state}
  end

  def get(key) do
    key |> choose_worker() |> KeyValueStore.DatabaseWorker.get(key)
  end
end

defmodule KeyValueStore.DatabaseWorker do
  @behaviour GenServer

  def start(db_folder) do
    GenServer.start(__MODULE__, db_folder)
  end

  @impl GenServer
  def init(db_folder) do
    {:ok, db_folder}
  end

  def store(worker_key, key, data) do
    GenServer.cast(worker_key, {:store, key, data})
  end

  @impl GenServer
  def handle_cast({:store, key, data}, state) do
    Path.join(state, key) |> File.write!(:erlang.term_to_binary(data))
    IO.puts("Storing key: #{key}, data: #{data}")
    {:noreply, state}
  end

  def get(worker_key, key) do
    GenServer.call(worker_key, {:get, key})
  end

  @impl GenServer
  def handle_call({:get, key}, caller, state) do
    spawn(fn ->
      data =
        Path.join(state, to_string(key)) |> File.read!() |> :erlang.binary_to_term()

      IO.puts("Sending key: #{inspect(key)}, data: #{data}, to caller: #{inspect(caller)}")
      GenServer.reply(caller, data)
    end)

    {:noreply, state}
  end
end

{:ok, pid} = KeyValueStore.Database.start()
KeyValueStore.Database.store("data", "my_data")
KeyValueStore.Database.get("data") |> IO.inspect()
KeyValueStore.Database.store("neandertal", "uga_ubga")
KeyValueStore.Database.get("neandertal") |> IO.inspect()
KeyValueStore.Database.store("andrzej", "lubie_placki")
KeyValueStore.Database.get("andrzej") |> IO.inspect()
