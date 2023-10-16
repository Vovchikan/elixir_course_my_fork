defmodule Homework.WorldChamp do
  @moduledoc """
  В чемпионате участвуют несколько команд. Каждая команда представлена кортежем:
  {:team, name, players}

  Где players -- это список игроков. Игрок представлен кортежем:
  {player, name, age, rating, health}

  В целом структура данных, описывающая чемпионат, выглядит так:
  championship = [
      {:team, "Crazy Bulls",
          [{:player, "Big Bull", 22, 545, 100},
          {:player, "Small Bull", 18, 324, 95}]},
      {:team, "Cool Horses",
          [{:player, "Lazy Horse", 21, 423, 80},
          {:player, "Sleepy Horse", 23, 101, 55}]}
  ]
  """

  def sample_champ() do
    [
      {
        :team, "Crazy Bulls",
        [
          {:player, "Big Bull", 22, 545, 99},
          {:player, "Small Bull", 18, 324, 95},
          {:player, "Bull Bob", 19, 32, 45},
          {:player, "Bill The Bull", 23, 132, 85},
          {:player, "Tall Ball Bull", 38, 50, 50},
          {:player, "Bull Dog", 35, 201, 91},
          {:player, "Bull Tool", 29, 77, 96},
          {:player, "Mighty Bull", 22, 145, 98}
        ]
      },
      {
        :team, "Cool Horses",
        [
          {:player, "Lazy Horse", 21, 423, 80},
          {:player, "Sleepy Horse", 23, 101, 35},
          {:player, "Horse Doors", 19, 87, 23},
          {:player, "Rainbow", 21, 200, 17},
          {:player, "HoHoHorse", 20, 182, 44},
          {:player, "Pony", 25, 96, 76},
          {:player, "Hippo", 17, 111, 96},
          {:player, "Hop-Hop", 31, 124, 49}
        ]
      },
      {
        :team, "Fast Cows",
        [
          {:player, "Flash Cow", 18, 56, 34},
          {:player, "Cow Bow", 28, 89, 90},
          {:player, "Boom! Cow", 20, 131, 99},
          {:player, "Light Speed Cow", 21, 201, 98},
          {:player, "Big Horn", 23, 38, 93},
          {:player, "Milky", 25, 92, 95},
          {:player, "Jumping Cow", 19, 400, 98},
          {:player, "Cow Flow", 18, 328, 47}
        ]
      },
      {
        :team, "Fury Hens",
        [
          {:player, "Ben The Hen", 57, 403, 83},
          {:player, "Hen Hen", 20, 301, 56},
          {:player, "Son of Hen", 21, 499, 43},
          {:player, "Beak", 22, 35, 96},
          {:player, "Superhen", 27, 12, 26},
          {:player, "Henman", 20, 76, 38},
          {:player, "Farm Hen", 18, 131, 47},
          {:player, "Henwood", 40, 198, 77}
        ]
      },
      {
        :team, "Extinct Monsters",
        [
          {:player, "T-Rex", 21, 999, 99},
          {:player, "Velociraptor", 29, 656, 99},
          {:player, "Giant Mammoth", 30, 382, 99},
          {:player, "The Big Croc", 42, 632, 99},
          {:player, "Huge Pig", 18, 125, 98},
          {:player, "Saber-Tooth", 19, 767, 97},
          {:player, "Beer Bear", 24, 241, 99},
          {:player, "Pure Horror", 31, 90, 43}
        ]
      }
    ]
  end

  @doc """
  Функция на вход принимает структуру данных, описывающую
  чемпионат и на выходе отдает кортеж:

  {num_teams, num_players, avg_age, avg_rating}

  где

  num_teams -- число команд в чемпионате;
  num_players -- число игроков в чемпионате;
  avg_age -- средний возраст игрока;
  avg_rating -- средний рейтинг игрока.

  ## Examples
    iex> alias Homework.WorldChamp
    iex> [
    ...>{:team, "Crazy Bulls",
    ...>    [{:player, "Big Bull", 22, 545, 100},
    ...>    {:player, "Small Bull", 18, 324, 95}]},
    ...>{:team, "Cool Horses",
    ...>    [{:player, "Lazy Horse", 21, 423, 80},
    ...>    {:player, "Sleepy Horse", 23, 101, 55}]}
    ...> ] |> WorldChamp.get_stat()
    {2, 4, (22+18+21+23)/4, (545+324+423+101)/4}
  """
  def get_stat(champ) do
    {t, players, sum_age, sum_rating} =
      List.foldl(champ, {0, 0, 0, 0}, fn
        {:team, _, players}, acc ->
          {teams, p, a, r} =
            List.foldl(players, acc, fn
              {:player, _name, age, rating, _health}, acc ->
                {teams, players, sum_age, sum_rating} = acc
                {teams, players + 1, sum_age + age, sum_rating + rating}
              end)
          {teams + 1, p, a, r}
        end)
    {t, players, sum_age / players, sum_rating / players}
  end


  @doc """
  Удаляет из игры (чемпионата) игроков,
  чьё здоровье (health) стало меньше 50 единиц.

  Команды где меньше 5 игроков исключаются из турнира.
  """
  def examine_champ(champ) do
    Enum.map(champ, fn
      {:team, name, players} ->
        updated_players =
          Enum.filter(players, fn
            {:player, _name, _age, _rating, health} ->
              health >= 50
            end)
        {:team, name, updated_players}
      end)
    |> Enum.filter(fn
      {:team, _, players} -> length(players) >= 5 end)
  end

  @doc """
  Возвращает все возможные комбинации пар игроков, такие что:
  - сумма рейтингов пары игроков должна быть больше 600.
  """
  def make_pairs(team1, team2) do
    {:team, _, players1} = team1
    {:team, _, players2} = team2
    List.foldl(players1, [], fn
      {:player, name1, _age, rating1, _health}, acc ->
        Enum.filter(players2, fn
          {:player, _, _, rating2, _} ->
            rating2 + rating1 > 600
          end)
        |> Enum.map(fn {:player, name2, _, _, _} -> {name1, name2} end)
        |> then(&(acc ++ &1))
      end)
  end

end
