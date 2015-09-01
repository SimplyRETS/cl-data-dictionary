#|
  This file is a part of data-dictionary project.
|#

(in-package :cl-user)
(defpackage data-dictionary-asd
  (:use :cl :asdf))
(in-package :data-dictionary-asd)

(defsystem data-dictionary
  :version "0.1"
  :author "Cody Reichert <cody@simplyrets.com>"
  :license "MIT"
  :depends-on (:cl-csv)
  :components ((:module "src"
                :components
                ((:file "data-dictionary"))))
  :description "Generate a markdown representation of RESO's Data Dictionary"
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.org"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq))))
