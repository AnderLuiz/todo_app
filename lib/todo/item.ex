defmodule Todo.Item do
  defstruct id: nil,
            description: nil,
            completed: false



  def new(description, completed \\ false) do
    %__MODULE__{
      id: :rand.uniform(1_000_000_000),
      description: description,
      completed: completed
    }
  end

end
