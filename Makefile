################################################################################
## This is Makefile is used for documentation generation and automated test		##
## runnin.																																		##
################################################################################

.PHONY: all
all:

ref: lux doc
	luadoc --no-files -d doc lux

doc:
	mkdir doc

