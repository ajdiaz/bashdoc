=======
bashdoc
=======

-----------------------------------------------
a tool to documentate bash scripts in easy form
-----------------------------------------------

:Author: Andrés J. Díaz <ajdiaz@connectical.net>
:Date:   2008-01-28
:Copyright: MIT license
:Version: R0A0
:Manual section: 1

SYNOPSIS
========

  bashdoc [-h] [-o outfile] [-r rawcommand]
    [-H rsthandler] [format] <file>

DESCRIPTION
===========

This script is a frontend for various awk(1) scripts which parse a bash
script (file) and create a documentation in specified format. This script
works similar to javadoc for java projects.

OPTIONS
=======

-h
    Print a short help screen

-o outfile
    Write output into outfile instead of print in stdout.

-r rawcommand
    Pass the rawcommand rst to rst parser.

-H rsthandler
    Use the rsthandler as awk backend to convert the script into RST
    parseable file. By default use the basic parser provided with bashdoc.

FORMATS
=======

Formats available depends on docutils installation. bashdoc looking for
rst2X scripts in PATH. Usually you want html or latex.

REQUIREMENTS
============

ssh-keysend is written in bash, and require almost bash >= 3.0,
gawk >= 3.1.5, docutils >= 0.4 and GNU coreutils.

SEE ALSO
========

bash(1), awk(1)

