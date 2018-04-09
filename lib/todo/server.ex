defmodule Todo.Server do
  use Supervisor


  alias Todo.Cache

  def add_list(name) do
    Supervisor.start_child(__MODULE__, [name])
  end

  def find_list(name) do
    Enum.find lists, fn(list) ->
      Todo.List.name(list) == name
    end
  end

  def delete_list(list) do
    Supervisor.terminate_child(__MODULE__, list)
  end


  def lists do
    __MODULE__
    |> Supervisor.which_children
    |> Enum.map(fn({_,child,_,_}) -> child end)
  end


  ####
  # Supervisor API
  ####
  def start_link(_) do
    server = Supervisor.start_link(__MODULE__, [], name: __MODULE__)
    Enum.map(Cache.lists,
      fn({_, list}) ->
        add_list(to_string(list.name))
      end
    )
    server
  end


  def init(_) do
    children = [
      worker(Todo.List, [], restart: :transient)
    ]
    supervise(children, strategy: :simple_one_for_one)
  end
end
