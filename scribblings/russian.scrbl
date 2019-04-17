#lang scribble/manual
@require[@for-label[russian/date
                    racket/base]]

@title{russian}
@author+email["Roman Klochkov" "kalimehtar@mail.ru"]

@defmodule[russian/date]

This package provides localization for russian language.

Этот пакет предоставляет функции для русской локализации.

@defproc[(date->string [date date?] string?)]{
It is the same function as in @racket[racket/date], but returning russian
date presentation.

Это та же функция, что в @racket[racket/date], но возвращает русское представление даты.}

@defproc[(register-srfi/19! any)]{
Registers russian localization for @racket[srfi/19].

Регистрирует русскую локализацию для модуля @racket[srfi/19].}
