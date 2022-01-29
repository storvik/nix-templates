;;;; tests/addition.lisp

(in-package #:myclproject-test)

(def-suite addition-tests
    :description "Tests for src/addition."
    :in all-tests)

(in-suite addition-tests)

(test make-addition-tests
  :description "Test addition function."
  (is (eq 2 (myclproject::addition (1 1)))
      "ERROR, test didnt work"))
