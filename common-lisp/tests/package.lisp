;;;; tests/package.lisp

(defpackage #:myclproject-test
  (:use #:cl #:fiveam)
  (:export #:run!
	   #:all-tests
       #:test-myclproject))
