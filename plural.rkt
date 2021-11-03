#lang racket/base
(require racket/string racket/contract)

(provide (contract-out
          [number-in-words (-> (or/c exact-integer? string?) (or/c #f (vector/c string? string? string?)) string?)]
          [plural-text (-> exact-integer? (vector/c string? string? string?) string?)]
          [plural (-> exact-integer? (or/c 0 1 2))]))

(define (plural-text n a)
  (vector-ref a (plural n)))

(define (plural n)
  (define n10 (remainder n 10))
  (define n100 (remainder n 100))
  (cond
    [(and (= n10 1) (not (= n100 11))) 0]
    [(and (<= 2 n10 4) (or (< n100 10) (>= n100 20))) 1]
    [else 2]))

(define (number-in-words n [units #f])
  (cond
    [(string? n)
     (define n1 (string->number n))
     (if (exact-integer? n1)
         (number-in-words n1 units)
         (raise-argument-error 'number-in-words "строка, которую можно прочитать как целое число" n))]
    [(= n 0)
     (if units (string-append "ноль " (vector-ref units 2)) "ноль")]
    [(< n 0) (raise-argument-error 'number-in-words "неотрицательное число" n)]
    [(> n 999999999999) (raise-argument-error 'number-in-words "число меньше триллиона" n)]
    [else
     ((λ (s) (if units (string-append s " " (plural-text n units)) s))
      (combine
       (reverse (for/list ([triple (in-list (number->triples n))]
                           [triple-num (in-naturals)])
                  (triple->string triple (vector-ref triple-names triple-num))))))]))

(define e0m-names (vector "" "один" "два" "три" "четыре" "пять" "шесть" "семь"  "восемь" "девять"))
(define e0f-names (vector "" "одна" "две"))
(define e01-names (vector "десять" "одиннадцать" "двенадцать" "тринадцать" "четырнадцать" 
                          "пятнадцать" "шестнадцать" "семнадцать" "восемнадцать" "девятнадцать"))
(define e1-names (vector "" "" "двадцать" "тридцать" "сорок" "пятьдесят" "шестьдесят" 
                         "семьдесят" "восемьдесят" "девяносто"))
(define e2-names (vector "" "сто" "двести" "триста" "четыреста" "пятьсот" "шестьсот" 
                         "семьсот" "восемьсот" "девятьсот"))
(define triple-names (vector                      
                      '("" "" "" #t)
                      '("тысяча" "тысячи" "тысяч" #f)
                      '("миллион" "миллиона" "миллионов" #t)
                      '("миллиард" "миллиарда" "миллиардов" #t)))

(define (number->triples n)
  (define-values (q r) (quotient/remainder n 1000))
  (if (= q 0) (list r) (cons r (number->triples q))))

(define (char->number char)
  (define char0 (char->integer #\0))
  (- (char->integer char) char0))

(define (filled-string? str)
  (not (string=? str "")))

(define (combine list)
  (string-join (filter filled-string? list) " "))

(define (triple->string triple triple-name)
  (define-values (one two many sex) (apply values triple-name))
  (define-values (t e0) (quotient/remainder triple 10))
  (define-values (e2 e1) (quotient/remainder t 10))
  (combine
   (list (vector-ref e2-names e2)
         (vector-ref e1-names e1)
         (vector-ref (cond 
                       [(= e1 1) e01-names]
                       [(or sex (> e0 2)) e0m-names]
                       [else e0f-names])
                     e0)
         (if (= triple 0) "" (plural-text triple (vector one two many))))))

(module+ test
  (require rackunit)
  (define rouble #("рубль" "рубля" "рублей"))
  (check-equal? (plural-text 3 rouble) "рубля")
  (check-equal? (plural-text 5 rouble) "рублей")
  (check-equal? (plural-text 21 rouble) "рубль")
  (check-equal? (plural-text 0 rouble) "рублей")
  (check-equal? (number-in-words 1000123) "один миллион сто двадцать три")
  (check-equal? (number-in-words 345123) "триста сорок пять тысяч сто двадцать три")
  (check-equal? (number-in-words 45311 rouble) "сорок пять тысяч триста одиннадцать рублей")
  (check-equal? (number-in-words 0 rouble) "ноль рублей"))
  