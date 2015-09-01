(in-package :cl-user)
(defpackage data-dictionary
  (:use :cl))
(in-package :data-dictionary)

;; code:

(defparameter *md* nil)
(defparameter *out* #p"./data-dictionary.markdown")

(defstruct definition
  "Representation of Data Dictionary definition."
  standard-name
  field-definition
  data-type
  group
  notes)

(defmethod parse-dd (rows)
  "Parse a CSV's rows to a list of `definition's."
  (let ((vals (rest rows)))
    (map 'list #'parse-definition vals)))

(defmethod parse-definition ((row list))
  "Returns a `definition'."
  (make-definition
   :standard-name (first row)
   :field-definition (second row)
   :data-type (third row)
   :group (nth 11 row)
   :notes (nth 22 row)))

(defmethod empty-row ((x definition))
  "Is the current row empty?"
  (= (length (definition-standard-name x)) 0))

(defun set-md (str)
  "Simple helper to concatenate markdown stream."
  (setf *md* (concatenate 'string *md* str)))

(defmethod make-markdown ((d definition))
  "Given a `definition', <d>, return a string markdown representation."
  (with-output-to-string (s)
    (let ((link (format nil "<a href='#~A'>~A</a>"
                        (string-downcase (definition-standard-name d))
                        (definition-standard-name d))))
      (format s "~%## ~A~%" link)
      (format s "~%*Type: ~A*~%" (definition-data-type d))
      (format s "~%~A~%" (definition-field-definition d)))))

(defun -main (csv)
  "Takes a pathname to `csv', renders markdown to `*out*'."
  (when *md* (setf *md* nil))
  (let ((dds (remove-if #'empty-row (parse-dd (cl-csv:read-csv csv)))))
    (loop for d in dds do
         (set-md (make-markdown d)))
    (with-open-file (stream *out* :direction :output :if-exists :supersede)
      (format stream *md*))))
