#
# Makefile
# ajdiaz, 2016-02-07 09:19
#

SRCDIR=src
OUTBIN=./bashdoc
REQUIREMENTS=./requirements.txt


all:
	find $(SRCDIR) -type f -exec cat {} \; > $(OUTBIN)
	@while read line; do \
		echo "std::installed '$$line' || " \
			   "err::trace '$$line is required but not found'" >> $(OUTBIN); \
	done <$(REQUIREMENTS)
	@echo 'main "$$@"' >> $(OUTBIN)
	@chmod 755 $(OUTBIN)
	@ls -l $(OUTBIN)

test: all
	 $(OUTBIN) -a bashdoc -f README.md -o test.html bashdoc
	 @if diff -Naurr test.html test/test.html; then \
	    echo "Test OK"; \
	 else \
	    echo "Test KO"; \
	    exit 1; \
	 fi;
	 rm -f test.html

doc: all
	$(OUTBIN) -T bashdoc -a bashdoc -f README.md -o doc/bashdoc.html bashdoc

clean:
	rm -f $(OUTBIN) test.html
# vim:ft=make
#
