defmodule Trim do
  use Common

  # We only trim space character
  def is_space(char), do: char == 32

  @doc """
  Function trim spaces in the beginning and in the end of the string.
  It accepts both single-quoted and double-quoted strings.

  ## Examples
  iex> Trim.trim('   hello there   ')
  'hello there'
  iex> Trim.trim("  Привет   мир  ")
  "Привет   мир"
  """
  def trim(str) when is_list(str) do
    # We iterate string 4 times here
    str
    |> trim_left
    |> Enum.reverse
    |> trim_left
    |> Enum.reverse
  end

  def trim(str) when is_binary(str) do
    # And yet 2 more iterations here
    str
    |> to_charlist
    |> trim
    |> to_string
  end


  defp trim_left([]), do: []
  defp trim_left([head | tail] = str) do
    if is_space(head) do
      trim_left(tail)
    else
      str
    end
  end


  @type str() :: String.t() | charlist()

  @spec effective_trim(str) :: str
  def effective_trim(str) when is_bitstring(str) do
    String.to_charlist(str)
    |> effective_trim()
    |> List.to_string()
  end
  def effective_trim(str) do
    effective_trim_left(str)
    |> effective_trim_right()
  end

  @spec effective_trim_left(charlist) :: charlist
  def effective_trim_left([]), do: []
  def effective_trim_left(str) do
    next = true
    effective_trim_left(str, next)
  end

  @spec effective_trim_left(charlist, boolean) :: charlist
  defp effective_trim_left([], _), do: []
  defp effective_trim_left([32 | rest], true) do
    Logger.debug("Delete space",
      rest: rest)
    effective_trim_left(rest, true)
  end
  defp effective_trim_left([h | t], true) do
    Logger.debug("No more spaces left",
      result: [h | t])
    effective_trim_left([h | t], false)
  end
  defp effective_trim_left(trimed_str, false) do
    trimed_str
  end

  def effective_trim_right([]), do: []
  def effective_trim_right([32]), do: []
  def effective_trim_right(str) do
    [h | t] = str
    case effective_trim_right(t) do
      [] ->
        case h do
          32 -> []
          _ -> [h]
        end
      t ->
        [h | t]
    end
  end

end
