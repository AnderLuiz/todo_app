defmodule Todo.ServerTest do
  use ExUnit.Case


  alias Todo.{Server, Cache}


  setup do
    on_exit fn ->
      Enum.each Server.lists, fn(list) ->
        Server.delete_list(list)
      end
      Cache.clear()
     end
  end

  test ".add_list adds a new supervised todo list" do
    Server.add_list("List 1")
    Server.add_list("List 2")

    counts = Supervisor.count_children(Server)
    assert counts.active == 2
  end


  test ".find_list  gets a list by its name" do
    name = "find-by-name"
    Server.add_list(name)
    list = Server.find_list(name)

    assert is_pid(list)
  end


  test ".delete_list delets a list by its name" do
    name = "delete-me"
    Server.add_list(name)

    list = Server.find_list(name)
    Server.delete_list(list)

    counts = Supervisor.count_children(Server)

    assert counts.active == 0
  end


  test "keep state when server restart" do
    Server.add_list("List 1")
    Server.add_list("List 2")

    Server
    |> Process.whereis
    |> Process.exit(:kill)

    :timer.sleep(500)

    counts = Supervisor.count_children(Server)

    assert counts.active == 2
  end

end
