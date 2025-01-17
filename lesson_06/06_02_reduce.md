# Reduce (Fold)

В разных языках эта функция называется по-разному. Где-то она называется **fold** (свертка), а где-то **reduce** (сокращение). Лично мне больше привычно называть fold, как в Эрланг. Но в Эликсир функцию называют reduce.

Свертка -- важный прием в функциональном программировании. Её понять немного сложнее, чем map и filter. Ну давайте разберемся.

Map и filter принимают на вход список и возвращают список. Reduce принимает список, а возвращает одно значение, то есть, сокращает (сворачивает) список.

Простые книжные примеры -- суммирование и произведение элементов списка:

```
> lst = [1,2,3,4,5]
[1, 2, 3, 4, 5]
> Enum.reduce(lst, 0, fn(item, acc) -> item + acc end)
15
> Enum.reduce(lst, 0, &+/2)
15
> Enum.reduce(lst, 1, fn(item, acc) -> item * acc end)
120
> Enum.reduce(lst, 1, &*/2)
120
```

**Enum.reduce** принимает 3 аргумента:
- коллекция (в данном случае список)
- начальное значение аккумулятора
- функцию сворачивания

Функция сворачивания принимает 2 аргумента: текущий элемент списка и текущее значение аккумулятора. И должна вернуть новое значение аккумулятора.

Для суммирования начальное значение аккумулятора 0, и потом к нему прибавляется каждый элемент списка.  Для произведения начальное значение аккумулятора 1, и потом на него умножается каждый элемент списка.

Но это учебные примеры, они не такие интересные :) Давайте сделаем что-нибудь интересное с нашим списком пользователей.


## Пример 1

Вычислим средний возраст всех пользователей в списке.

```
$ iex lib/hof.exs
> users = HOF.test_data
[
  {:user, 1, "Bob", 23},
  {:user, 2, "Helen", 20},
  {:user, 3, "Bill", 15},
  {:user, 4, "Kate", 14}
]
> HOF.get_average_age(users)
{4, 72}
> HOF.get_average_age(users)
18.0
```

Аккумулятор представляет собой кортеж из двух чисел, где мы суммируем пользователей и их возраст. Сворачивающая функция принимает текущего пользователя из списка и текущее значение аккумулятора. Она обновляет оба числа в аккумуляторе -- добавяет очередного пользователя и его возраст. На выходе из свертки мы получаем количество всех пользователей и их суммарный возраст, что позволяет вычислить средний возраст.


## Пример 2

Давайте вернемся к задаче, упомянутой выше -- разделить пользователей на два списка: несовершеннолетние и взрослые.

```
> HOF.split_by_age(users)
{[{:user, 2, "Helen", 20}, {:user, 1, "Bob", 23}],
 [{:user, 4, "Kate", 14}, {:user, 3, "Bill", 15}]}
```

Аккумулятор представляет собой кортеж из двух списков. Сворачивающая функция смотрит возраст каждого пользователя, и в зависимости от этого добавляет его либо в первый, либо во второй список.

Можно немного улучшить наше решение. Возраст в 16 лет можно не зашивать в коде, а передать аргументом в функцию. Давайте сделаем это:
```
> HOF.split_by_age(users, 20)
{[{:user, 1, "Bob", 23}],
 [{:user, 4, "Kate", 14}, {:user, 3, "Bill", 15}, {:user, 2, "Helen", 20}]}
> HOF.split_by_age(users, 10)
{[
   {:user, 4, "Kate", 14},
   {:user, 3, "Bill", 15},
   {:user, 2, "Helen", 20},
   {:user, 1, "Bob", 23}
 ], []}
```


## Пример 3

Найдем двух пользователей -- с самым длинным именем, и самого старшего.

В качестве начального значения аккумулятора можно взять любого пользователя, кто уже есть в списке. Удобно взять первого.

```
> HOF.get_longest_name_user(users)
{:user, 2, "Helen", 20}
> HOF.get_oldest_user(users)
{:user, 1, "Bob", 23}
```

Впрочем, в модуле Enum есть функция reduce от двух аргументов, которая так и работает -- в качестве начального значения аккумулятора берет первый элемент списка. Исправим код, и поведение не изменится:

```
iex(13)> r HOF
iex(14)> HOF.get_oldest_user(users)
{:user, 1, "Bob", 23}
```
