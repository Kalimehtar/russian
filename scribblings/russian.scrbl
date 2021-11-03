#lang scribble/manual
@require[@for-label[russian/date
                    russian/plural
                    racket/base]]

@title{russian}
@author+email["Roman Klochkov" "kalimehtar@mail.ru"]

This package provides localization for russian language.

Этот пакет предоставляет функции для русской локализации.

@defmodule[russian/date]

This module localizes date function.

Этот модуль предоставляет русские версии функций для работы с датами.

@defproc[(date->string [date date?]) string?]{
It is the same function as in @racket[racket/date], but returning russian
date presentation.

Это та же функция, что в @racket[racket/date], но возвращает русское представление даты.}

@defproc[(register-srfi/19!) any]{
Registers russian localization for @racket[srfi/19].

Регистрирует русскую локализацию для модуля @racket[srfi/19].}

@defmodule[russian/plural]

This module provides text representation for numbers and utilities for plurals.

Этот модуль предоставляет функции для формирования текстового представления чисел и выбора формы множественного числа.

@defproc[(plural [n exact-integer?]) (or/c 0 1 2)]{
Returns version of plural form for given number. Used in @racket[plural-text].

Возвращает вариант множественного числа для переданного количества. 0 - вариант, используемый после чисед 1, 11, ...; 1 - вариант, используемыя после 2, 3, 22, ...; 2 - вариант,
используемый в остальных случаях.}

@defproc[(plural-text [n exact-integer?] [words (vector/c string? string? string?)]) string?]{
Returns version of plural form, taken from @racket[words] for given number. @racket[words] is an array with versions of plural like in @racket[plural].

Возвращает вариант множественного числа для переданного количества из параметра @racket[words]. @racket[words] - массив из трёх элементов с формами множестенного числа как в
@racket[plural]. Например @racket[#("штука" "штуки" "штук")].}

@defproc[(number-in-words [n exact-integer?] [units (or/c #f (vector/c string? string? string?))]) string?]{
Returns words presentation of @racket[n] with added correct form from @racket[units].

Возвращает число прописью @racket[n] и добавялет к нему единицу измерения @racket[units]. Единица измерения можеть быть #f, тонда возвращается просто число.
Единица измерения представлена в виде массива из трёх строк как в @racket[plural-text].}