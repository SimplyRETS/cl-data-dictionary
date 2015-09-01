# data-dictionary.lisp - Makefile
# author: Cody Reichert <cody@simplyrets.com>
#
# Requirements:
# - SBCL
# - Quicklisp
#
# Usage:
# - Set the CSV variable in this Makefile to the path of your reso-data-dictionary.csv
# - Run `make` to generate a markdown version in the CWD

CSV=$(HOME)/docs/reso/reso-data-dictionary.1.4.csv

markdown:
	sbcl --noinform --non-interactive \
		--load data-dictionary.asd \
		--eval '(ql:quickload :data-dictionary)'  \
		--eval '(data-dictionary:-main #p"$(CSV)")'
