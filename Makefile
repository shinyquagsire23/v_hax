all: save

clean:
	@rm -f build/* constants/* v_code/v_code.bin v_code/v_code.elf v_code/build/*

save: v_save/v_constants.s v_save/v_macros.s v_save/v_rop.s v_ropdb/$(REGION)_ropdb.txt
	@mkdir -p build constants
	@python scripts/makeHeaders.py constants/constants "FIRM_VERSION=$(FIRM_VERSION)" v_ropdb/$(REGION)_ropdb.txt
	@cd v_code && $(MAKE)
	armips v_save/v_rop.s
	@python scripts/bin2xml.py qsave build/rop.bin build/qsave.vvv
	@python scripts/bin2xml.py unlock data/v_unlock_stack.bin build/unlock.vvv
	
