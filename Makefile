################################################################################
## This is Makefile is used for documentation generation and automated test		##
## runnin.																																		##
################################################################################

.PHONY: all
all:

ref: nova doc
	luadoc --no-files -d doc nova

doc:
	mkdir doc

