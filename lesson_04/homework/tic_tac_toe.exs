defmodule TicTacToe do

  @type cell :: :x | :o | :f
  defguard is_cell(val) when val in [:x, :o, :f]
  @type row :: {cell, cell, cell}
  @type game_state :: {row, row, row}
  @type game_result :: {:win, :x} | {:win, :o} | :no_win

  @spec valid_game?(game_state) :: boolean
  def valid_game?(state) do
    with {_, _, _} <- state do
      Tuple.to_list(state)
      |> Enum.all?(fn row -> valid_row?(row) end)
    else
      _ -> false
    end
  end

  defp valid_row?(row) do
    with {_, _, _} <- row do
      Tuple.to_list(row)
      |> Enum.all?(fn cell ->
        IO.inspect(cell, label: "CELL")
        IO.inspect(is_cell(cell), label: "is_cell()")
        is_cell(cell)
      end)
    else
      _ -> false
    end
  end

  @spec check_who_win(game_state) :: game_result
  def check_who_win(state) do
    with true <- valid_game?(state) do
      case state do
        {
          {val, _, _},
          {_, val, _},
          {_, _, val}
        } when val in [:x, :o] -> {:win, val}
        {
          {_, _, val},
          {_, val, _},
          {val, _, _}
        } when val in [:x, :o] -> {:win, val}
        {
          {val, _, _},
          {val, _, _},
          {val, _, _}
        } when val in [:x, :o] -> {:win, val}
        {
          {_, val, _},
          {_, val, _},
          {_, val, _}
        } when val in [:x, :o] -> {:win, val}
        {
          {_, _, val},
          {_, _, val},
          {_, _, val}
        } when val in [:x, :o] -> {:win, val}
        {
          {val, val, val},
          {_, _, _},
          {_, _, _}
        } when val in [:x, :o] -> {:win, val}
        {
          {_, _, _},
          {val, val, val},
          {_, _, _}
        } when val in [:x, :o] -> {:win, val}
        {
          {_, _, _},
          {_, _, _},
          {val, val, val}
        } when val in [:x, :o] -> {:win, val}
        _ -> :no_win
      end
    else
      v ->
        IO.inspect(v, label: "I'm here")
        :no_win
    end
  end

end
