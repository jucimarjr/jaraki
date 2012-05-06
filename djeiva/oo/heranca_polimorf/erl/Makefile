ERLC=erlc -W0 -o ebin/

call:
	@echo Hiding All Warnings!
	@ mkdir -p ebin/
	@echo Compiling main...
	@$(ERLC) *.erl
	@echo Compiling source...
	@$(ERLC) */*.erl
	@echo
	@echo "Finished!"