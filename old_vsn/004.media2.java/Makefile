EBIN_DIR=ebin
INCLUDE_DIR=include

SRC_DIR=src/
DEBUG_MODS=\"$(SRC_DIR)jaraki.erl\", \"$(SRC_DIR)jaraki_utils.erl\"

ERLC=erlc -I $(INCLUDE_DIR) -W0
ERL=erl -noshell -pa $(EBIN_DIR)

.PHONY: clean debug

# This is the default task
compile: ebin/jaraki.beam ebin | src/jaraki_lexer.erl src/jaraki_parser.erl

# This is the task when you intend to debug
debug: ERLC += +debug_info
debug: compile

ebin/jaraki.beam: $(INCLUDE_DIR)/*.hrl
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
	rm -f $(SRC_DIR)/jaraki_lexer.erl
	rm -f $(SRC_DIR)/jaraki_parser.erl
	rm -rf $(EBIN_DIR)/*.beam
	@ echo
