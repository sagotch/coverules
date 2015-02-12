all: build

build:
	ocamlbuild -I src cli.native

install: build
ifndef bindir
	$(error bindir is not set)
else
	cp cli.native $(bindir)/coverules
endif

clean:
	ocamlbuild -clean
