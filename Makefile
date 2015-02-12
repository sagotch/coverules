OCAMLBUILD=ocamlbuild -classic-display -I src
MENHIR=$(OCAMLBUILD) -use-menhir -yaccflag --trace -yaccflag --dump
OCAMLYACC=$(OCAMLBUILD) -yaccflag -v
COVERULES=coverules

.INTERMEDIATE: menhir.trace ocamlyacc.trace

menhir.byte:
	$(MENHIR) lexer.byte
	mv lexer.byte menhir.byte

ocamlyacc.byte:
	$(OCAMLYACC) lexer.byte
	mv lexer.byte ocamlyacc.byte

menhir.trace: menhir.byte
	echo "1 + 1" | ./menhir.byte 2> menhir.trace

ocamlyacc.trace: ocamlyacc.byte
	echo "1 + 1" | OCAMLRUNPARAM=p ./ocamlyacc.byte 2> ocamlyacc.trace

coverules: menhir.trace ocamlyacc.trace
	$(COVERULES) menhir.trace < _build/src/parser.automaton

clean:
	$(OCAMLBUILD) -clean
