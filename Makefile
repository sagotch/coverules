OCAMLBUILD=ocamlbuild -classic-display -I src
MENHIR=$(OCAMLBUILD) -use-menhir -yaccflag --trace -yaccflag --dump
COVERULES=coverules

.INTERMEDIATE: trace

build:
	$(MENHIR) lexer.byte

trace: build
	echo "1 + 1" | ./lexer.byte 2> trace

coverules: build trace
	$(COVERULES) trace < _build/src/parser.automaton

clean:
	$(OCAMLBUILD) -clean
