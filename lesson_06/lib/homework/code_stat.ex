defmodule Homework.CodeStat do
  use Common

  @type analyze_result :: map(
    String.t,
    map(tuple(), integer()))
  @types [
      {"Elixir", [".ex", ".exs"]},
      {"Erlang", [".erl"]},
      {"Python", [".py"]},
      {"JavaScript", [".js"]},
      {"SQL", [".sql"]},
      {"JSON", [".json"]},
      {"Web", [".html", ".htm", ".css"]},
      {"Scripts", [".sh", ".lua", ".j2"]},
      {"Configs", [".yaml", ".yml", ".conf", ".args", ".env"]},
      {"Docs", [".md"]}
    ]

  @ignore_names [".git", ".gitignore", ".idea", "_build", "deps", "log", "tmp", ".formatter.exs"]

  @ignore_extensions [".beam", ".lock", ".iml", ".log", ".pyc"]

  @max_depth 5

  @spec analyze(String.t) :: map()
  def analyze(path) do
    # TODO add your implementation
    analyze(path, 0, %{})
  end

  defp analyze(path, depth, acc) when depth >= 6, do: acc
  defp analyze(path, depth, acc) do
    # 1. Получить список элементов по заданному пути
    # 2. Для каждого элемента, если он:
    #    файл: отправить в фунцию подсчёта
    #    папка: отправить в рекурсию
    if File.dir?(path) do
      File.ls!(path)
      |> MonEx.flat_map(fn files ->
        Enum.reduce(files, fn file ->
          analyze_file(file)
        end)
      end)
    else
      acc
    end
  end

  @spec analyze_file(
          String.t,
          analyze_result()
        ) :: analyze_result()
  def analyze_file(file, acc) do
    if File.dir?(path) do
      acc
    else
      # тут надо увеличить(создать) счётчики (файл, строки, размер)
      acc
    end
  end

end
