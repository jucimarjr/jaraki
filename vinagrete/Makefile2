SOURCE=$(wildcard *.erl)
HEADERS=$(wildcard *.hrl)
BEAM=$(wildcard ebin/*.beam)
EBIN_DIR=ebin

all: compile test

compile: $(SOURCE) $(HEADERS) Makefile
	@ echo Compilando geral...
	@ mkdir -p $(EBIN_DIR)
	erlc -o $(EBIN_DIR) $(SOURCE)

test:
	erl -noshell -pa $(EBIN_DIR) -eval 'eunit:test("ebin",[verbose])' -s init stop

clean:
	rm -rf $(BEAM)
	rm -rf erl_crash.dump

