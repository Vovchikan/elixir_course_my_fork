# Решение 6. do-нотация.

В языке Haskell есть абстракция, которая называется **do-нотация**. Выглядит это так:

```
do 
  var1 <- func1(params)
  var2 = func2(params)
  var3 <- func3(params)
  do_something(var1, var2, var3)
```

В рамках блока `do` может вызываться много функций. `var2 = func2(params)` -- это обычный вызов функции. А вот вызов `var1 <- func1(params)` необычный. Здесь функция возращает монаду Result (на самом деле любую монаду), а оператор `<-` извлекает из нее значение и присваивает в переменную var1. 

Если `func1` возвращает error, то вычисление всего блока `do` прекращается, и результат функции становится результатом всего блока. Таким образом оператор `<-` похож на `bind`, только не связывает функции, а извлекает значение. 

В Эликсир нет do-нотации как таковой, но есть макрос `with` который работает похожим образом:

```
with {:ok, var1} <- func1(params),
     var2 = func2(params),
     {:ok, var3} <- func3(params) do
  do_something(var1, var2, var3)
end
```

Здесь оператор `<-` выполняет сопоставление с образцом. Если оно успешно, то `var1` получает свое значение, и блок `with` выполняется дальше. Если не успешно, то выполнение прекращается, и результат вызова `func1` становится результатом блока `with`.

На самом деле здесь нет ничего, связанного с монадами, а работает обычное сопоставление с образцом. 

Без синтаксического сахара макрос выглядит так:
```
with(line1, line2, line2) do 
  do_something 
end
```

Cинтаксический сахар не позволяет написать что-то вроде настоящей do-нотации:

```
with
  line1
  line2
  line3
  do_something
```

Писать нужно так:

```
with line1,
     line2,
     line3 do
  do_something
end
```

Либо так:

```
with(
  line1,
  line2,
  line3
) do
  do_something
end
```

Решение с макросом `with` выглядит так: lib/solution_6.ex

Этот вариант похож на 4-й вариант с использованием исключений. Он такой же простой и короткий, с описанием только happy path. Но в нем нет исключений :)


## В чем разница между pipeline и do-notation?

pipeline лучше всего подходит там, где нет промежуточного состояния, которое нужно было бы хранить между вызовами функций. Наш пример плохо подходит, так как у нас такое состояние есть. И нам пришлось делать обертки над функциями, чтобы пробрасывать состояние через них.

Обычно АПИ функций специально готовят для использования в pipeline. Библиотека Plug -- как раз такой случай. Все функции принимают и возвращают структуру данных, описывающую HTTP запрос, и все нужные данные хранятся в этой структуре.

do-нотация позволяет иметь промежуточное состояние и использовать какие угодно функции. Для нашего BookShop это самый подходящий вариант.

