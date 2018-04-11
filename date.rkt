#lang racket/base
(require racket/contract)
(provide/contract [register-srfi/19! (-> any)]
                  [date->string (-> date? string?)])
(require srfi/29)

(define (register-srfi/19!)
  (define id (list 'srfi-19 'ru))
  (declare-bundle! id '( ;; weekday abbreviations
                        (sun . "вс")
                        (mon . "пн") (tue . "вт") (wed . "ср")
                        (thu . "чт") (fri . "пт") (sat . "сб")
                                     
                        ;; long weekdays
                        (sunday . "воскресенье") (monday . "понедельник") (tuesday . "вторник")
                        (wednesday . "среда") (thursday . "четверг") (friday . "пятница")
                        (saturday . "суббота")
                       
                        ;; month abbrevs
                        (jan . "янв") (feb . "фев") (mar . "мар") (apr . "апр")
                        (may . "май") (jun . "июн") (jul . "июл") (aug . "авг")
                        (sep . "сен") (oct . "окт") (nov . "ноя") (dec . "дек")

                        ;; long month
                        (january . "Январь") (february . "Февраль") (march . "Март") (april . "Апрель")
                        (may . "Май") (june . "Июнь") (july . "Июль") (august . "Август")
                        (septembre . "Сентябрь") (octuber . "Октябрь") (november . "Ноябрь") (december . "Декабрь")
                       
                        (pm . "PM") (am . "AM")
                        (date-time . "~a ~b ~d ~H:~M:~S~z ~Y")
                        (date . "~d/~m/~y")
                        (time . "~H:~M:~S")
                        (iso8601 . "~Y-~m-~dT~H:~M:~S~z")
                        (separator . ".")))
  (store-bundle! id))

(define (date->string d)
  (define weekdays '#("воскресенье" "понедельник" "вторник" "среда" "четверг" "пятница" "суббота"))
  (define months '#("января" "февраля" "марта" "апреля" "мая" "июня" "июля" "августа" "сентября" "октября" "ноября" "декабря"))
  (parameterize ([current-language 'ru])
    (format "~a, ~a ~a, ~a"
            (vector-ref weekdays (date-week-day d))
            (date-day d)
            (vector-ref months (sub1 (date-month d)))
            (date-year d))))