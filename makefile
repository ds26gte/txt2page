# makefile for use in directories that contain .txt files
# that need to be converted to HTML
# 
# last modified 2011-09-11

default: 
	@for f in *.txt ;\
	do \
		h=$${f%.txt}.html ;\
		if test ! -f $${h} -o $${f} -nt $${h} ;\
		then echo converting $${f} ;\
			txt2page $${f} ;\
		fi ;\
		: ;\
	done
