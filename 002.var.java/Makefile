EBIN_DIR=ebin
#EXBIN_DIR=exbin
#TEST_DIR=test
INCLUDE_DIR=include

#TEST_SOURCE_DIR=$(TEST_DIR)/erlang
#TEST_EBIN_DIR=$(TEST_DIR)/ebin

SRC_DIR=src/
DEBUG_MODS=\"$(SRC_DIR)jaraki_compile.erl\", \"$(SRC_DIR)jaraki_utils.erl\"

ERLC=erlc -I $(INCLUDE_DIR) -W0
ERL=erl -I $(INCLUDE_DIR) -noshell -pa $(EBIN_DIR)

.PHONY: clean debug

# This is the default task
compile: ebin/jaraki_compile.beam ebin | src/jaraki_lexer.erl src/jaraki_parser.erl

debug: ERLC += +debug_info
debug: compile

ebin/jaraki_compile.beam: $(INCLUDE_DIR)/*.hrl
	@ echo Compiling Erlang source ...
	@ mkdir -p $(EBIN_DIR)
	$(ERLC) -o $(EBIN_DIR) src/*.erl
	@ echo

src/jaraki_lexer.erl: src/jaraki_lexer.xrl
	@ echo Compiling lexer ...
	$(ERL) -eval 'leex:file("$<"), halt().'
	@ mkdir -p $(EBIN_DIR)
	$(ERLC) -o $(EBIN_DIR) $@
	@ echo

src/jaraki_parser.erl: src/jaraki_parser.yrl
	@ echo Compiling parser ...
	$(ERL) -eval 'yecc:file("$<"), halt().'
	@ mkdir -p $(EBIN_DIR)
	$(ERLC) -o $(EBIN_DIR) $@
	@ echo

ebin: src/*.erl
	@ echo Compiling Erlang source ...
	@ mkdir -p $(EBIN_DIR)
	$(ERLC) -o $(EBIN_DIR) $?
	@ echo

clean:
	rm -f src/jaraki_lexer.erl
	rm -f src/jaraki_parser.erl
	rm -rf $(EBIN_DIR)/*.beam
	@ echo
