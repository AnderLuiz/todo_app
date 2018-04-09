defmodule Todo.ListTest do
  use ExUnit.Case

  alias Todo.{List, Item, Cache}

  setup do
    {:ok, list} = List.start_link("ListTest")
    on_exit fn ->
      Cache.clear()
    end
    {:ok, list: list}
  end

  test ".items returns the todos on the list", %{list: list} do
    assert List.items(list) == []
  end

  test ".add adds an item to the list" , %{list: list} do
    item = Item.new("Item 1")
    List.add(list,item)

    assert List.items(list) == [item]
  end

  test ".update can mark an item as completed",  %{list: list} do
    item = Item.new("Item to be updated")
    List.add(list,item)

    #Update the item
    item = %{item | description: "new", completed: true}
    List.update(list, item)

    assert List.items(list) == [item]
  end

end
