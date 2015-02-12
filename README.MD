# Coverules

Test the grammar coverage of your program(s) execution(s).

## How to use coverules?

### Compile with dump and trace option

    menhir --dump --trace parser.mly

`--trace` option will print debugging information on stderr
on program execution.

`--dump` option generate `parser.automaton` file, which is needed
by `coverules`.

### Generate traces

Record execution(s) traces in a file. You may record multiple traces
in different files or append them to one file.

    ./prog 2> prog.trace

### See rules coverage

Pass trace(s) file(s) to `coverules` as command line arguments,
and send `parser.automaton` file on stdin.

    $ coverules trace < parser.automaton
    9/83 automaton transitions visited.
