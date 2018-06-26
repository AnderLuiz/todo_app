defmodule Todo.Item do
  defstruct id: nil,
            description: nil,
            completed: false

            @type t :: %Todo.Item{
                      id: integer | nil,
                      description: String.t | nil,
                      completed: boolean
            }

            
  @spec new(String.t, boolean) :: t
  def new(description, completed \\ false) do
    %__MODULE__{
      id: :rand.uniform(1_000_000_000),
      description: description,
      completed: completed
    }
  end

end
