":";if test "$LISP" = clisp; then exec clisp -q $0
":";elif test "$LISP" = clozure; then exec ccl -b -Q -l $0
":";elif test "$LISP" = ecl; then exec ecl -shell $0
":";else exec sbcl --script $0
":";fi

;Dorai Sitaram

;just the syntax-highlighting code out of tex2page

;first change 2013-03-15
;last change 2015-05-29

(defvar *lisphi-token-delims*
  (list #\( #\) #\[ #\] #\{ #\} #\' #\` #\" #\; #\, #\|))

(defvar *it*)

(defun lisphi-string-to-number (s)
  (if (position #\: s :test #'char=) nil
    (let ((n (read-from-string s nil)))
      (if (numberp n) n nil))))

(defun lisphi-char-whitespace-p (c)
  (or (char= c #\space)
      (char= c #\tab)
      (not (graphic-char-p c))))

(defvar *lisphi-keywords*
  (list

    "=>"
    "..."
    "and"
    "assert"
    "begin"
    "begin0"
    "block"
    "case"
    "cond"
    "decf"
    "define"
    "define-macro"
    "define-syntax"
    "defmacro"
    "defpackage"
    "defparameter"
    "defstruct"
    "defun"
    "defvar"
    "delay"
    "destructuring-bind"
    "do"
    "do-all-symbols"
    "do-external-symbols"
    "do-symbols"
    "dolist"
    "dotimes"
    "ecase"
    "else"
    "etypecase"
    "eval-when"
    "flet"
    "fluid-let"
    "handler-bind"
    "handler-case"
    "if"
    "incf"
    "labels"
    "lambda"
    "let"
    "let*"
    "let-syntax"
    "let-values"
    "letrec"
    "letrec-syntax"
    "loop" ;NB! common variable in Scheme
    "macrolet"
    "multiple-value-bind"
    "multiple-value-setq"
    "or"
    "pop"
    "prog1"
    "progn"
    "push"
    "quasiquote"
    "quote"
    "set!"
    "setf"
    "setq"
    "syntax-case"
    "syntax-rules"
    "typecase"
    "unless"
    "unquote"
    "unquote-splicing"
    "unwind-protect"
    "when"
    "with"
    "with-handlers"
    "with-input-from-string"
    "with-open-file"
    "with-open-socket"
    "with-open-stream"
    "with-output-to-string"
    "with-slots"

    ))

(defun lisphi-read-lispwords ()
  (let ((f ".lispwords"))
    (when (probe-file f)
      (with-open-file (i f :direction :input)
        (loop
          (let ((c (peek-char nil i nil)))
            (cond ((not c) (return))
                  ((or (lisphi-char-whitespace-p c)
                       (member c *lisphi-token-delims* :test #'char=))
                   (read-char i))
                  (t (push
                       (concatenate
                         'string
                         (nreverse
                           (let ((s '()) (esc-p nil))
                             (loop
                               (let ((c (peek-char nil i nil)))
                                 (cond ((not c) (return s))
                                       (esc-p (read-char i)
                                              (push c s)
                                              (setq esc-p nil))
                                       ((char= c #\\ )
                                        (read-char i)
                                        (push c s)
                                        (setq esc-p t))
                                       ((or (lisphi-char-whitespace-p c)
                                            (member c *lisphi-token-delims* :test #'char=))
                                        (return s))
                                       (t (read-char i)
                                          (push c s))))))))
                       *lisphi-keywords*)))))))))

(defun lisphi-get-type (s)
  (let (it)
    (cond ((member s *lisphi-keywords* :test 'string=) :keyword)
          ((setq it (position #\: s :test #'char=))
           (if (= it 0) :selfeval :variable))
          ((char= (char s 0) #\#) :selfeval)
          ((lisphi-string-to-number s) :selfeval)
          (t :variable))))

(defun lisphi-princ-char (c)
  (when c
    (cond ((char= c #\newline) (terpri))
          (t (princ (case c
                      ((#\<) "&lt;")
                      ((#\>) "&gt;")
                      ((#\") "&quot;")
                      ((#\&) "&amp;")
                      (t c)))))))

(defun lisphi-output-string ()
  (read-char)
  (princ "<span class=selfeval>")
  (lisphi-princ-char #\")
  (let ((esc-p nil))
    (loop
      (let ((c (read-char nil nil)))
        (case c
          (#\" (unless esc-p (return))
           (lisphi-princ-char c)
           (setq esc-p nil))
          (#\\ (princ c)
           (setq esc-p (not esc-p)))
          (t (lisphi-princ-char c)
             (setq esc-p nil))))))
  (lisphi-princ-char #\")
  (princ "</span>"))

(defun lisphi-output-comment ()
  (princ "<span class=comment>")
  (loop
    (let ((c (read-char nil nil)))
      (cond ((or (not c) (char= c #\newline)
                 (and (lisphi-char-whitespace-p c)
                      (let ((c2 (peek-char nil nil nil)))
                        (or (not c2) (char= c2 #\newline)))))
             (princ "</span>")
             (terpri)
             (return))
            (t (lisphi-princ-char c))))))

(defun lisphi-get-token ()
  (concatenate
    'string
    (nreverse
      (let ((s '()) (esc-p nil))
        (loop
          (let ((c (peek-char nil nil nil)))
            (when (not c) (return s))
            (cond (esc-p (read-char)
                         (push c s)
                         (setq esc-p nil))
                  ((char= c #\\ )
                   (read-char)
                   (push c s)
                   (setq esc-p t))
                  ((or (lisphi-char-whitespace-p c)
                       (member c *lisphi-token-delims* :test #'char=))
                   (return s))
                  (t (read-char)
                     (push c s)))))))))

(defun lisphi-princ (s)
  (let ((n (length s)) (k 0))
    (loop
      (unless (< k n) (return))
      (lisphi-princ-char (char s k))
      (incf k))))

(defun lisphi-output-token (s)
  (case (lisphi-get-type s)
    (:keyword
      (princ "<span class=keyword>")
      (lisphi-princ s)
      (princ "</span>"))
    (:selfeval
      (princ "<span class=selfeval>")
      (lisphi-princ s)
      (princ "</span>"))
    (t (princ "<span class=variable>")
       (lisphi-princ s)
       (princ "</span>"))))

(defun lisphi-output-next-chunk ()
  (let ((c (peek-char nil nil nil)))
    (cond ((char= c #\;)
           (lisphi-output-comment))
          ((char= c #\")
           (lisphi-output-string))
          ((or (char= c #\') (char= c #\`) (char= c #\,))
           (read-char)
           (princ "<span class=keyword>")
           (princ c)
           (when (char= c #\,)
             (let ((c (peek-char nil nil nil)))
               (when (char= c #\@)
                 (read-char)
                 (princ c))))
           (princ "</span>"))
          ((or (lisphi-char-whitespace-p c)
               (member c *lisphi-token-delims* :test #'char=))
           (read-char)
           (lisphi-princ-char c))
          (t (lisphi-output-token
               (lisphi-get-token))))))

(defun lisphi ()
  (loop
    (let ((c (peek-char nil nil nil)))
      (unless c (return)))
    (lisphi-output-next-chunk)))

(lisphi-read-lispwords)

(defun lisphi-test (f)
  (with-open-file (*standard-input* f :direction :input)
    (lisphi)))

(lisphi)
