SRC_DIR=src
EBIN_DIR=ebin
INCLUDE_DIR=include
TEST_EBIN_DIR=test/ebin
JAVA_SRC_DIR = java_src
JAVA_CLASS_DIR = $(JAVA_SRC_DIR)/class
ERLC=erlc -I $(INCLUDE_DIR)# -W0
ERL=erl -noshell -pa $(EBIN_DIR) -pa $(TEST_EBIN_DIR)
JAVAC=javac -verbose
JAVA=java

.PHONY: clean debug

# This is the default task
compile: ebin/jaraki.beam src/jaraki_lexer.erl src/jaraki_parser.erl test/ebin/test.beam 

test:   compile
	@ clear
	@ echo EUnit testing...
	@ rm -rf $(TEST_EBIN_DIR)/
	@ mkdir -p $(TEST_EBIN_DIR)
	@ $(ERLC) -o $(TEST_EBIN_DIR) test/test.erl
	@ $(ERL) -eval 'eunit:test("test/ebin", [verbose]), halt().'
	@ mv *.erl $(TEST_EBIN_DIR)
	@ mv *.beam $(TEST_EBIN_DIR)

# This is the task when you intend to debug
debug: ERLC += +debug_info
debug: compile

ebin/jaraki.beam: $(INCLUDE_DIR)/*.hrl src/*.erl
	@ echo Compiling Erlang source...
	@ mkdir -p $(EBIN_DIR)
	@ $(ERLC) -o $(EBIN_DIR) src/*.erl
	@ echo

$(TEST_EBIN_DIR)/test.beam : test/*.erl
	@ echo Compiling Eunits tests...
	@ rm -rf $(TEST_EBIN_DIR)/
	@ mkdir -p $(TEST_EBIN_DIR)
	@ $(ERLC) -o $(TEST_EBIN_DIR) test/test.erl
	@ echo  

src/jaraki_lexer.erl: src/jaraki_lexer.xrl
	@ echo Compiling Lexer ...
	@ $(ERL) -eval 'leex:file("$<"), halt().'
	@ mkdir -p $(EBIN_DIR)
	@ $(ERLC) -o $(EBIN_DIR) $@
	@ echo

src/jaraki_parser.erl: src/jaraki_parser.yrl
	@ echo Compiling Parser ...
	@ $(ERL) -eval 'yecc:file("$<", [{verbose, true}]), halt().'
	@ mkdir -p $(EBIN_DIR)
	@ $(ERLC) -o $(EBIN_DIR) $@
	@ echo

java: java_src/*.java
	@ echo Compiling java source ...
	@ rm -rf $(JAVA_CLASS_DIR)/
	@ mkdir -p $(JAVA_CLASS_DIR)
	@ $(JAVAC) -d $(JAVA_CLASS_DIR) $(JAVA_SRC_DIR)/*.java
	@ echo

clean:
	@ clear
	@ echo Cleaning...
	rm -f erl_crash.dump
	rm -f *.erl
	rm -f *.java
	rm -f $(SRC_DIR)/jaraki_lexer.erl
	rm -f $(SRC_DIR)/jaraki_parser.erl
	rm -rf $(EBIN_DIR)/
	rm -rf $(TEST_EBIN_DIR)/
	rm -rf $(JAVA_CLASS_DIR)/
	find . -name  *.*~ -print0 | xargs -0 rm
	find . -name  *~ -print0 | xargs -0 rm
	find . -name  *.beam -print0 | xargs -0 rm
	find . -name  *.class -print0 | xargs -0 rm
	@ echo
