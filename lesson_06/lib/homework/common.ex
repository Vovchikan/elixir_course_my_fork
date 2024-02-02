defmodule Common do
  defmacro __using__(_) do
    quote do
      alias MonEx.Option
      alias MonEx.Result
      require Result
      require Option
      require Logger
      import Result, only: [ok: 1, error: 1]
      import Option, only: [some: 1, none: 0]
    end
  end
end
