SRC_DIR=src
EBIN_DIR=ebin
INCLUDE_DIR=include
LIB_EBIN_DIR=lib/ebin

ERLC=erlc -I $(INCLUDE_DIR) -W0
ERL=erl -noshell -pa $(EBIN_DIR)

.PHONY: clean debug

# This is the default task
compile: ebin/jaraki.beam src/jaraki_lexer.erl src/jaraki_parser.erl 

# This is the task when you intend to debug
debug: ERLC += +debug_info
debug: compile

ebin/jaraki.beam: $(INCLUDE_DIR)/*.hrl src/*.erl
	@ echo Compiling Erlang source...
	@ mkdir -p $(EBIN_DIR)
	@ $(ERLC) -o $(EBIN_DIR) src/*.erl
	@ echo

#$(LIB_EBIN_DIR)/control.beam: lib/control.erl
#	@ echo Compiling libs source...
#	@ mkdir -p $(LIB_EBIN_DIR)
#	@ $(ERLC) -o $(LIB_EBIN_DIR) loop.erl
#	@ echo

src/jaraki_lexer.erl: src/jaraki_lexer.xrl
	@ echo Compiling lexer ...
	@ $(ERL) -eval 'leex:file("$<"), halt().'
	@ mkdir -p $(EBIN_DIR)
	@ $(ERLC) -o $(EBIN_DIR) $@
	@ echo

src/jaraki_parser.erl: src/jaraki_parser.yrl
	@ echo Compiling parser ...
	@ $(ERL) -eval 'yecc:file("$<", [{verbose, true}]), halt().'
	@ mkdir -p $(EBIN_DIR)
	@ $(ERLC) -o $(EBIN_DIR) $@
	@ echo

clean:
	@ echo Cleaning...
	rm -f erl_crash.dump
	rm -f $(SRC_DIR)/jaraki_lexer.erl
	rm -f $(SRC_DIR)/jaraki_parser.erl
	rm -rf $(EBIN_DIR)/*.beam
	rm -rf $(LIB_EBIN_DIR)/*.beam
	find . -name  *.*~ -print0 | xargs -0 git rm
	@ echo
