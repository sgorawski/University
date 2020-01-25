OC = ocamlc

all: streams.cmi streams.cmo

streams.cmi:
	$(OC) -c streams.mli

streams.cmo:
	$(OC) -c streams.ml

clean:
	rm -f *.cmi *.cmo
