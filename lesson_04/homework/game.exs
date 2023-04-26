defmodule Game do
  @type role()  :: :admin | :moderator | atom()
  @type age()   :: integer()
  @type name()  :: String.t()

  @spec join_game({:user, name, age, role}) ::
          :ok | :error
  def join_game(user) do
    with {:user, _name, age, role} <- user do
      case {role, age} do
        {r, _} when r == :admin or r == :moderator -> :ok
        {_, a} when a >= 18                      -> :ok
        _                                          -> :error
      end
    else
      _ -> :error
    end
  end

  @type type() :: :pawn | :rock | :bishop | :knight | :queen | :king
  @type color() :: :white | :black
  @type figure() :: {type, color}

  @spec move_allowed?(color, figure) :: boolean
  def move_allowed?(current_color, {type, color}) do
    (type == :pawn || type == :rock) && color == current_color
  end

  @spec single_win?(boolean, boolean) :: boolean
  def single_win?(a_win, b_win) do
    (a_win != b_win) && (a_win || b_win)
  end

  @spec double_win?(boolean, boolean, boolean) ::
          :ab | :ac | :bc | false
  def double_win?(a_win, b_win, c_win) do
    case {a_win, b_win, c_win} do
      {true, true, true} -> false
      {true, true, _} -> :ab
      {true, _, true} -> :ac
      {_, true, true} -> :bc
      _               -> false
    end
  end

end
