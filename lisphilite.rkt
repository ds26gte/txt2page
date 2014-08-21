#! /usr/bin/env racket

#lang racket

;dorai.sitaram@gmail.com
;
;first change 2013-03-15
;last change 2013-03-17

;just the syntax-highlighting code out of tex2page

(define *hilite-token-delims*
  (list #\( #\) #\[ #\] #\{ #\} #\' #\` #\" #\; #\, #\|))

(define *hilite-keywords*
  (list

    "=>"
    "and"
    "begin" "begin0" "block"
    "case" "cond"
    "define" "define-syntax" "delay" "do"
    "else"
    "if"
    "lambda" "let" "let*" "let-syntax" "let-values" "letrec" "letrec-syntax"
    "or"
    "quasiquote" "quote"
    "set!" "syntax-case" "syntax-rules"
    "unless" "unquote" "unquote-splicing" "unwind-protect"
    "when" "with-handlers" 

    ))

(define (hilite-read-lispwords)
  (let ((f ".lispwords"))
    (when (file-exists? f)
      (call-with-input-file
        f (lambda (i)
            (let loop ()
              (let ((c (peek-char i)))
                (unless (eof-object? c)
                  (cond ((char=? c #\;) (read-line i))
                        ((or (char-whitespace? c)
                             (ormap (lambda (x) (char=? x c))
                                    *hilite-token-delims*))
                         (read-char i))
                        (else (set! *hilite-keywords*
                                (cons (list->string
                                        (reverse
                                          (let loop ((s '()) (esc-p #f))
                                            (let ((c (peek-char i)))
                                              (cond ((eof-object? c) s)
                                                    (esc-p (loop (cons (read-char i) s) #f))
                                                    ((char=? c #\\ ) (loop (cons (read-char i) s) #t))
                                                    ((or (char-whitespace? c)
                                                         (ormap
                                                           (lambda (x)
                                                             (char=? c x))
                                                           *hilite-token-delims*))
                                                     s)
                                                    (else (loop (cons (read-char i) s)
                                                                #f)))))))
                                      *hilite-keywords*))))
                  (loop)))))))))

(define (hilite-output-token s)
  (printf "<span class=~a>~a</span>"
          (hilite-get-type s) s))

(define (hilite-get-type s)
  (cond ((ormap (lambda (x) (string=? s x)) *hilite-keywords*)
         'keyword)
        ((char=? (string-ref s 0) #\#) 'selfeval)
        ((string->number s) 'selfeval)
        (else 'variable)))

(define (hilite-write-char c)
  (display (case c
             ((#\<) "&lt;")
             ((#\>) "&gt;")
             ((#\") "&quot;")
             ((#\&) "&amp;")
             (else c))))

(define (hilite-output-string)
  (read-char)
  (display "<span class=selfeval>")
  (hilite-write-char #\")
  (let loop ((esc-p #f))
    (let ((c (read-char)))
      (case c
        ((#\") (when esc-p
                 (hilite-write-char c)
                 (loop #f)))
        ((#\\ ) (write-char c)
                (loop #t))
        (else (hilite-write-char c)
              (loop #f)))))
  (hilite-write-char #\")
  (display "</span>"))

(define (hilite-output-comment)
  (display "<span class=comment>")
  (let loop ()
    (let ((c (read-char)))
      (cond ((or (eof-object? c)
                 (char=? c #\newline)
                 (and (char=? c #\return)
                      (let ((c (peek-char)))
                        (or (eof-object? c)
                            (char=? c #\newline)
                            (begin (read-char) #t)))))
             #t)
            (else (hilite-write-char c)
                  (loop)))))
  (printf "</span>~%"))

(define (hilite-output-next-chunk)
  (let ((c (peek-char)))
    (unless (eof-object? c)
      (cond ((char=? c #\;) (hilite-output-comment))
            ((char=? c #\") (hilite-output-string))
            ((or (char=? c #\') (char=? c #\`) (char=? c #\,))
             (read-char)
             (printf "<span class=keyword>~c" c)
             (when (and (char=? c #\,) (char=? (peek-char) #\@))
               (write-char (read-char)))
             (printf "</span>"))
            ((or (char-whitespace? c)
                 (ormap (lambda (x) (char=? x c)) *hilite-token-delims*))
             (hilite-write-char (read-char)))
            (else
              (hilite-output-token (hilite-get-token)))))))

(define (hilite)
  (let loop ()
    (let ((c (peek-char)))
      (unless (eof-object? c)
        (hilite-output-next-chunk)
        (loop)))))

(define (hilite-get-token)
  (list->string
    (reverse
      (let loop ((s '()) (esc-p #f))
        (let ((c (peek-char)))
          (cond ((eof-object? c) s)
                (esc-p (loop (cons (read-char) s) #f))
                ((char=? c #\\ ) (loop (cons (read-char) s) #t))
                ((or (char-whitespace? c)
                     (ormap (lambda (x) (char=? c x)) *hilite-token-delims*))
                 s)
                (else (loop (cons (read-char) s) #f))))))))

(hilite-read-lispwords)

(define hilite-test
  (lambda (f)
    (with-input-from-file f hilite)))

(hilite)
