;;;; tests/main.lisp

(in-package :myclproject-test)

(def-suite all-tests
    :description "The master suite of all quasiRPG tests.")

(in-suite all-tests)

(defun test-myclproject ()
  (run! 'all-tests))
