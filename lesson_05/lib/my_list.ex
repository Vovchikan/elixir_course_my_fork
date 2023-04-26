defmodule MyList do

  @doc """
  Function takes a list that may contain any number of sublists,
  which themselves may contain sublists, to any depth.
  It returns the elements of these lists as a flat list.

  ## Examples
  iex> MyList.flatten([1, [2, 3], 4, [5, [6, 7, [8, 9, 10]]]])
  [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  """
  def flatten([]), do: []

  def flatten([head | tail]), do: flatten(head) ++ flatten(tail)

  def flatten(item), do: [item]


  # ++ operator is not very effective.
  # It would be better to provide a more effective implementation,
  # which is possible, but a little bit tricky.
  def flatten_e(list) do
    flatten_e(list, [])
  end

  def flatten_e([h | t], acc) when is_list(h) do
    new_acc =
      flatten_e(h, [])
      |> List.foldl(acc, fn elem, acc ->
        [elem | acc]
      end)
    flatten_e(t, new_acc)
  end
  def flatten_e([h | t], acc) do
    flatten_e(t, [h | acc])
  end
  def flatten_e([], acc) do
    Enum.reverse(acc)
  end

end
