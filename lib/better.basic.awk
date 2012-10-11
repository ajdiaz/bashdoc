# This is an attempted at a correction to the basic gawk backend for bashdoc(1)
# the author doesn't really understand liscenses & copyright; don't be a dick.

# initial state
BEGIN {
	debug	= 0
	bash_pound_comment_line	= 0
	styled_bash_pound_comment_line	= 0
	consecutive_noncomment_lines	= 0
	ignore_this_line	= 0
}

# Skip shebangs
(FNR == 1) && /^#!.*$/ {
	if (debug == 1)
		print	"*next*; shebang:"$0
	next
}

# I haven't played around with these yet; straight from the original basic.awk:
# The following rules create a RST notes for each codification label, such
# as TODO, FIXME and XXX.
# /^[#][ ]*TODO.*/ {
# 	print "\n.. note:: To-Do"
# 	sub("^[#][ ]*TODO[:]?","")
# 	if (debug == 0)
# 		print "  "$0
# 	else
# 		print "  <TODO>"$0
# }
# /^[#][ ]*FIXME.*/ {
# 	print "\n.. note:: Fix me"
# 	sub("^[#][ ]*FIXME[:]?","")
# 	if (debug == 0)
# 		print "  "$0
# 	else
# 		print "  <FIXME>"$0
# }
# /^[#][ ]*XXX.*/ {
# 	print "\n.. note:: Hack"
# 	sub("^[#][ ]*XXX[:]?","")
# 	if (debug == 0)
# 		print "  "$0
# 	else
# 		print "  <HACK>"$0
# }

# detection first, printing later
# -------------------------------

# detect anything that is not a 'bash-#-comment-only line'
/^[[:space:]]*[^#].*$/ {
	bash_pound_comment_line	= 0
	styled_bash_pound_comment_line	= 0
	ignore_this_line	= 0
	if (debug == 1)
		print	"not a 'bash-#-comment-only line':"$0
}
# detect anything that is a 'bash-#-comment-only line'
/^[[:space:]]*[#].*$/ {
	bash_pound_comment_line	= 1
	styled_bash_pound_comment_line	= 0
	ignore_this_line	= 0
	if (debug == 1)
		print	"is a 'bash-#-comment-only line':"$0
}
# detect anything that is a styled 'bash-#-comment-only line' and which we should not ignore
/^[[:space:]]*[#][![:space:]].*$/  {
	if ((debug == 1) && (bash_pound_comment_line != 1))
		print	"*error state*; 'bash-#-comment-only line' should have already registered."
	styled_bash_pound_comment_line	= 1
	ignore_this_line	= 0
	if (debug == 1)
		print	"is a styled 'bash-#-comment-only line':"$0
}
# detect anything that is a styled 'bash-#-comment-only line' and which we should ignore
/^[[:space:]]*[#][^![:space:]].*$/ {
	if ((debug == 1) && (bash_pound_comment_line != 1))
		print	"*error state*; 'bash-#-comment-only line' should have already registered."
	styled_bash_pound_comment_line	= 1
	ignore_this_line	= 1
	if (debug == 1)
		print	"*ignored*; is a styled 'bash-#-comment-only line':"$0
}
# detect blank lines because nothing else will
/^$/ {
	bash_pound_comment_line	= 0
	styled_bash_pound_comment_line	= 0
	ignore_this_line	= 1
	if (debug == 1)
		print	"*ignored*; is a blank line:"$0
}
# I can't think of a way to account for the following comments using a single regexp or just a few regexps (textbook regexs shouldn't be able to catch the patterns of these lines)
# These could be accounted for individually, but that would be bad for users (it would dash their unentitled expectations and make them rage, a lot) and would not scale to cover the more general problem.
#
#	^$((muffin--))	# I have less muffins now.$
#
#	^wigglytuff_used='#'	# It's not very effective.$
#
#	^wigglytuff_used='##'	# It's not very effective.$
#
#	^wigglytuff_used='#"'	# It's not very effective.$
#
#	^wigglytuff_used='"#"'	# It's not very effective.$
#
#	^wigglytuff_used="#'"	# It's not very effective.$
#
#	^wigglytuff_used="#	# It's not very effective.$
#
#	^}	# And *that* was the best function ever.$
#
#	^{ # don't you want some chocolate right now?$
#
#	^{ # } # tread carefully if you try to implement single curly-brace cases$
#

# printing now
# ------------

# If the ignore_this_line flag's state survived this far, then honor it.
ignore_this_line == 1	{
	if (debug == 1)
		print	"*next*; *ignored*:"$0
	next
}

# print a thing that is exactly a 'bash-#-comment-only line'
(bash_pound_comment_line == 1) && (styled_bash_pound_comment_line == 0) && (parentheses_then_bash_pound_comment_line == 0)	{
	sub("^[[:space:]]*#","")
	printf "\n%s",$0
	consecutive_noncomment_lines	= 0
}
# print a thing that is exactly a styled 'bash-#-comment-only line'
(bash_pound_comment_line == 1) && (styled_bash_pound_comment_line == 1) && (parentheses_then_bash_pound_comment_line == 0)	{
	sub("^[[:space:]]*#[![:space:]]","")
	printf "\n%s",$0
	consecutive_noncomment_lines	= 0
}
# anything that is not a comment, is code; For each code line, if it is consecutively the first such of its code block, then treat it specially.
(bash_pound_comment_line == 0) && (consecutive_noncomment_lines == 0) && (parentheses_then_bash_pound_comment_line == 0)	{
	printf "\n\n::\n\n"
}
# anything that is not a comment, is code; print it now.
bash_pound_comment_line == 0	{
	print "  "$0
	++consecutive_noncomment_lines
}

END { printf "\n" }
