#
# Makefile
# ajdiaz, 2016-02-07 09:19
#

SRCDIR=src
OUTBIN=./bashdoc
REQUIREMENTS=./requirements.txt


all:
	cat $(SRCDIR)/blib > $(OUTBIN)
	find $(SRCDIR) ! -name "blib" -type f -exec cat {} \; >> $(OUTBIN)
	@while read line; do \
		echo "std::installed '$$line' || " \
			   "err::trace '$$line is required but not found'" >> $(OUTBIN); \
	done <$(REQUIREMENTS)
	@echo 'main "$$@"' >> $(OUTBIN)
	@chmod 755 $(OUTBIN)
	@ls -l $(OUTBIN)

test: test_html test_md test_man

test_html:
	 @$(OUTBIN) -T test -f README.md -o test.html bashdoc && \
	 	diff -Naurr test.html test/test.html || { echo "Test KO"; exit 1; } && \
	 	rm -f test.html

test_md:
	 @$(OUTBIN) -T test -f README.md -o test.md -F md bashdoc && \
	 	diff -Naurr test.md test/test.md || { echo "Test KO"; exit 1; } && \
	 	rm -f test.md

test_man:
	 @$(OUTBIN) -T test -f README.md -o test.1 -F man bashdoc && \
	 	diff -Naurr test.1 test/test.1 || { echo "Test KO"; exit 1; } && \
	 	rm -f test.1

doc: all
	$(OUTBIN) -T bashdoc -A bashdoc -f README.md -o doc/bashdoc.html bashdoc

clean:
	rm -f $(OUTBIN) test.html
# vim:ft=make
#
