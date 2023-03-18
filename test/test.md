% test

# bashdoc

Documentation generator for bash applications.

## Documentation syntax

Bashdoc will evaluate some special comments into the source code. The
comments are prefixed with the following doc strings:

`# mod: modname`
: The module name itself.

`# fun: funsignature`
: The function signature, usually include parameters here, but not describe
  them.

`# txt: `
: Textual description of the previous declarated section (module or
  function).

`# opt: param: ...`
: Describe an option or parameter to a function.

`# env: VAR: ...`
: Describe a environment variable called `$VAR`.

`# use: ...`
: Provides an example of use of the function or module.

`# api: ...`
: Set the API name for this element. The API name could be used to filter
  what functions or modules will be documented in final output.

## Examples

Let's suppose the following content of the file `script.bash`

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.bash}
# mod: example
# txt: this module is an example for documentation.
#      The txt sections as also opt and env ones can
#      be multiline if lines are kept vertical aligned.

# fun: sum num1 num2
# txt: sum two numbers and output the result
# opt: num1: the first number to sum
# opt: num2: the second number to sum
# use: sum 1 3
# api: sum
sum ()
{
  echo "$(($1 + $2))"
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Now you can generate the HTML with the command:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.bash}
bashdoc -o doc.html script.bash
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Using API name

Le'ts suppose the previous example code, and we need to add more functions
there:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.bash}
# fun: internal_sum num1
# txt: return zero (yes, it's not very usefull function)
# api: internal
internal_sum ()
{
  echo 0
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If we generate the HTML in the same way that we do previously, the result
HTML will contain two documented functions: `sum` and `internal_sum`, but
we don't want the second one in the documentation. Of course we can remove
the doc strings from there, but then we loose the documentation in the code
too. To avoid this problem we can use the API name. If you look carefully,
you can see that the api name in the first function is `sum`, and in the
second one is `internal`. If we run bashdoc as following:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.bash}
bashdoc -A sum -o doc.html script.bash
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We will create documentation only for functions tagged as API *sum*. Please
note that if you force a specific API tag, then functions or modules without
declared API will be not documented.

## Using custom stylesheet

By default bashdoc using its own CSS stylesheet and HTML template, which is
pretty nice, by the way, but if you want to use your own style and/or HTML
template, you can use it passing paramenters `-s` (for style) and `-t`
(for template) to the bashdoc command.

Accepted styleshet is any file which contains valid CSS code. Accepted
template is any template accepted by pandoc.

For example:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.bash}
bashdoc -s mystyle.css -t mytemplate.html -o doc.html script.bash
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



---

# API Reference

## arg {.module}

The `arg` module provides a number of functions to parse arguments
from command line.
To use the `arg` module you need to create handler functions which will
be called during the parser process. The handler functions should return
the number of parameters comsumed from the parameter list. See
example below for more information.

#### Usage example

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.bash}
opt_quiet () {
    QUIET=true; return 1; # we consum only the -q param
}
create () { echo "$arguments" }
arg::opt MAIN -q --quiet   opt_quiet   'do not output messages'
arg::action create create 'create new things'
arg::param create "arguments+"  'argument to create subcommand'
arg::parse "$@"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### arg::opt `<action>` `<short>` `<long>` `<handler>` `[help]` {.function}

set an option for a specific action argument.

#### Parameters

`action`
: the action for which the option will be added

`short`
: the short form of the option (usually prefixed by ``-``)

`long`
: the long form of the option (usually prefixed by ``--``)

`handler`
: function to handler when option is present.


### arg::parse::opt::fail `<cmdline>` {.function}

exit program with error 2 (cmdline error) interpreting cmdline passed
as argument.

#### Parameters

`cmdline`
: the cmdline which fails.


### arg::parse::opt::long `<action>` `<option>` `[option` `argument]` {.function}

set the specific long option for the action passed as argument. The
option can be suffixed with a colon (:) to specify a mandatory
argument.


### arg::parse::opt::short `<action>` `<option>` `[option` `argument]` {.function}

set the specific short option for the action passed as argument. The
option can be suffixed with a colon (:) to specify a mandatory
argument.


### arg::action `<action>` `<handler>` `[help_message]` {.function}

set a new action in argument parser.

#### Parameters

`action`
: the action name to add to the parser

`handler`
: the function name to use as handler for this action.

`help_message`
: a message to print on usage.


### arg::usage::action `<action>` {.function}

print usage information for the action passed as argument.


### arg:::main::help `<text>` {.function}

Set the main help for the program

#### Parameters

`text`
: the main help string for the program


### arg:::main::action `<fun>` {.function}

Set the function handler for main action, used when no action
defined.

#### Parameters

`fun`
: the handler for the MAIN action.


### arg::usage {.function}

print main usage information

#### Environment variables

`E`
: the error code to return to OS on exit.


### arg::parse::action `<action>` `[arguments]` {.function}

parse arguments starting with action passed as argument.


### arg::parse::arg `<action>` `[arguments]` {.function}

parse arguments (not options) for specific action passed as argument.


### arg::parse `[arguments]` {.function}

parse arguments according with previous configured parser.


### arg::param `<action>` `<parameter_name>` `[help_str]` {.function}

add position parameter to parser.

#### Parameters

`action`
: action where add the parameter

`parameter_name`
: the name of the paramenter

`help_str`
: a help string for the parameter to show in usage

## cache {.module}

The `cache` module provides a simple in-memory cache.

#### Usage example

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.bash}
cache::put "key" "val"
cache::get "key"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### cache::get `<key>` {.function}

get the value of the key from the potion in-memory cache.


### cache::put `<key>` `<value>` {.function}

save the content of the specified key to the in-memory cache.

## config {.module}

The `config` module allows you to read configuration file in
properties format

#### Usage example

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.bash}
config::load configname ./config.properties
echo $(config::get configname key)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### config::load `<table>` `<file>` {.function}

read a configuration file passed as argument and save in the memory
with specific table name.

#### Parameters

`table`
: a name to identify the config table where file will be load.

`file`
: path to a properties file to load.


### config::get `<table>` `<key>` `[default]` {.function}

outputs the specified configuration key in the table passed as
argument. If key does not exists raise an error, unless default
is passed as argument, in that case return default values.

#### Parameters

`table`
: the table name where to search key.

`key`
: the key to search in config table

`default`
: default value to output if value is not found. By default
  an error is raised.


### config::iter `<table>` `<pattern>` {.function}

iterate over a specific configuration using pattern passed as
argument and outputs keys with match.

#### Parameters

`table`
: the table name to iterate

`pattern`
: a glob pattern to match in config keys.

## curl {.module}

The curl module offers a way to access to HTTP resources easily.


### curl::get `<url>` {.function}

get an object from url and output it to stdout

#### Parameters

`url`
: any URL valid for curl.

#### Usage example

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.bash}
curl::get http://example.com
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### curl::source `<url>` {.function}

sources a file from url

#### Usage example

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.bash}
curl::source http://mydomain.com/file.bash
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## doc {.module}

The `doc` module provides functions to convert bash source code to
HTML, using markdown and specific CSS themes.


### doc::read_blocks `[api]` {.function}

read and print blocks readed from stdin which match with specific api
definition. If api is not provided all elements will be documentated,
if api is provided, only elements with declared api matched with
provided one will be documented. If api is provided, but is not
declared in documentation, then item will be documentated too.

#### Parameters

`api`
: a string which identify the API to be documented.

#### Environment variables

`DOCSTRING`
: The docstring comment which identify a special comment
  used for documentation. By default 'sha-space' (# ).

#### Usage example

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.bash}
doc::read_blocks v1 < script
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### doc::output `<file>+` {.function}

Create intermediate markdown code required to produce final HTML.

#### Environment variables

`TITLE`
: The document title.

`AUTHOR`
: The document author.

`DATE`
: The date of the produced document.

#### Usage example

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.bash}
doc::output file
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### doc::generate `<file>+` {.function}

generate HTML for the specified files passed as arguments.

#### Environment variables

`OUTPUT`
: filename of the output file or stdout if not provided.

#### Usage example

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.bash}
doc::generate file
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## err {.module}

The `err` module offers a way to stop potion execution with
a traceback.


### err::trace {.function}

print to stderr a traceback of an error.

#### Usage example

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.bash}
false || err::trace "Error because of false"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## main {.module}

The ``main`` module contain the specified potion body.


### main::init {.function}

print nice potion logo and some custom messages at the beginning.

## mutex {.module}

The `mutex` module provides a way to ensure critical region access
across different processes. NOTE this module does not work fine on some
filesystems, like NFS, AFS and others.

#### Usage example

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.bash}
mutex::run mymutex sleep 10 # run a sleep in a critical region
mutex::adquire mymutex
# do some critical changes
mutex::release mymutex
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### mutex::adquire `<name>` {.function}

create a mutex or wait until mutex removed

#### Parameters

`name`
: the name to identify this mutex


### mutex::release `<name>` {.function}

release mutex by name

#### Parameters

`name`
: the name to identify this mutex


### mutex::run `<name>` `<command>` `[args]` {.function}

run a command protected by mutex named as argument name.

#### Parameters

`name`
: the name to identify this mutex

`command`
: the command to run

`args`
: optional arguments to the command.

## os {.module}

The `os` module provides specified functions to guess the operating
system related variables.


### os::family {.function}

print to stdout the operating system family


### os::provider {.function}

print the operating system provider (formerly distribution).


### os::release {.function}

print to stdout the properly release of operating system provider.


### os::path `<file>` {.function}

return the path of a file in PATH

#### Parameters

`file`
: the file name to find the full path.

#### Environment variables

`PATH`
: contains the path to search file

## os.ubuntu {.module}

The ``os.ubuntu`` module extends ``os`` module adding specific
functions for Ubuntu based systems.


### os::relase::ubuntu {.function}

return specific relese for ubuntu operating systems.

## out {.module}

The `out` module provides functions to output messages in stderr or
stdout.


### out::log `<message>` `[message_type]` {.function}

print to stdout a log line with specified message and prefixed by
date and message_type.

#### Environment variables

`DATE_FORMAT`
: defines the format for the datetime, in regular date(1)
  format.

`COLOR_DATE`
: defines the color to use (if available) to print the date.

`COLOR_MESSAGE`
: defines the color to use to print the message.

`COLOR_NONE`
: defines the sequence to reset defined color.

`QUIET`
: if true do not show any messages


### out::info `<message>` {.function}

print an informational message in stdout.

#### Environment variables

`COLOR_INFO`
: defines the color to be used in informational messages.


### out::fail `<message>` {.function}

print an informational message in stdout.

print an error message in stderr.

#### Environment variables

`COLOR_FAIL`
: defines the color to be used in this kind of messages.
  E: if set exit program with error code defined in the variable


### out::warn `<message>` {.function}

print an informational message in stdout.

print a warning message in stderr.

#### Environment variables

`COLOR_WARN`
: defines the color to be used in this kind of messages.


### out::user `<message>` {.function}

print an informational message in stdout.

print a user defined message in stdout

#### Environment variables

`COLOR_USER`
: defines the color to be used in this kind of messages.

## proc {.module}

The `proc` module provides a number of functions to manage parallel
processes


### proc::waitn `[number]` {.function}

wait for n procs to finished, or for everyone if no number specify

#### Parameters

`number`
: the number of proccess to wait for or none if wait for everyone.

## std {.module}

The `std` module contains a numer of standard functions usefull to
progamming in bash.


### std::quit {.function}

perform an exit clean of the running program.


### std::add_quit_handler `<func_name>` {.function}

Add func_name as handler to execute before quit the application.
When the application finished, then the functions registered as quit
handlers will be executed in the same order than they were
registered.

#### Parameters

`func_name`
: the name of the function to be registered.

#### Usage example

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.bash}
somefunc () { echo "exiting"; }
std::add_quit_handler somefunc
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### std::hmac `<text>` {.function}

outputs the calculated HMAC using SHA1 for the text passed as
argument.

#### Parameters

`text`
: a plain text to be hashed.

#### Environment variables

`ALGO`
: set the algorithm to use for calculate HMAC. Valid values are:
  sha1, md5, sha256, sha512. The proper helper tool must be installed
  on the system.

#### Usage example

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.bash}
std::hmac "hello world"
ALGO=md5 std::hmac "hello world"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### std::mute `<command>` {.function}

mute outputs, including `stderr` when running a command, alias or
function

#### Parameters

`command`
: the command to run muted.


### std::strin `<str1>` `<str2>` {.function}

return true if `str2` is into `str1`, or false otherwise.

#### Parameters

`str1`
: the string which could be contain `str2` and wants to evaluate

`str2`
: the string to find into `str1`

#### Usage example

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.bash}
std::strin "somelargestring" "some"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### std::func `<func_name>` {.function}

return true if function name passed as argument is defined, or false
otherwise.


### std::arch {.function}

outputs the hardware architecture of the current host.


### std::timestamp {.function}

outputs the UNIX timestamp

#### Environment variables

`TZ`
: the timezone to use to print the timestamp, by default get the
  timezone from the system.


### std::parse `<arg_string>` {.function}

parse an argument string in the form key=value and promote this
variables to environment. The key `name` is mandatory. If the
first parameter has no key, key `name` is using by default. The
`name` parameter must be the first one.

#### Usage example

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.bash}
std::parse "name=Jhon" "age=90"
echo "$name has $age years old"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### std::run `<command>` {.function}

Run command passed as argument if $PRETEND is not set to true

#### Environment variables

`PRETEND`
: if true do nothing.


### std::installed `<command>` {.function}

return true if command is installed in path


### std::is_dir_empty `<dir>` {.function}

return true if dir is empty


### std::sort `<array>` {.function}

sort an array using qsort in pure bash (not very efficient) and
return the output to an special variable called `sort_ret`.

#### Environment variables

`sort_ret`
: will contain the sorted array


### str2array `<string>` `[separator]` {.function}

create a new array with the contents of the string, using separator
passed as argument.

#### Parameters

`string`
: the string to covert to array

`separator`
: the character to use as separator, by default use comma.

#### Usage example

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.bash}
str2array "one,two,three"
echo "${str2array_ret[@]}"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## term {.module}

The `term` module provides functions related with terminal
configuration. This module also define some useful color variables to
be used in `out` module.


### term::attached {.function}

return true if output is a terminal, false otherwise


### term::tcap `<capability>` {.function}

check if some capabilty is enabled in terminal


### term::init {.function}

initialize terminal, in theory you never need to call this function,
unless you want to change your terminal online.

## tmp {.module}

The `tmp` module provides functions to create and destroy temporary
directories. Even if you don't remove the temporary file or directoy
explicitely, the directory or file will be deleted when program
exits.

#### Environment variables

`TMPDIR`
: a subdirectory into /tmp to use to create temporary files or
  directories.

`BLIB_TMPDIR`
: a full path to temporary directory to use to store files
  or other directories.

#### Usage example

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.bash}
tmp::create
# do some actions in current directory, which is temporary one
tmp::destroy
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.bash}
echo $(tmp::file)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


### tmp::create `<dirname>` {.function}

create temporary directory and move working directory into it


### tmp::exit {.function}

exit the temporary directory, but not remove it.


### tmp::destroy {.function}

move to root directoy and remove temporary directory


### tmp::exists `<name>` {.function}

return true if the specified file name or directory name is
a temporary file or directory.


### tmp::file {.function}

print to stdout the name of unique temporary file.


### tmp::touch `<name>` {.function}

create a temporary file with specified name in temporary directory.

## version {.module}

The `version` module provides a number of functions to handle version
numbers.


### version::cmp `<version1>` `<version2>` {.function}

compare two version numbers, return -1 (255) if version1 is greater
than version2, return 1 if version2 is greater than version1 and 0
if both are equal


---

