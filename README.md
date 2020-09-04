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


