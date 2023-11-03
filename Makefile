PROJ = cmd_handler
TOP = top

OUT_DIR = out
FILELIST_DIR = file-lists

PIN_DEF = icestick.pcf
DEVICE = hx1k
PACKAGE = tq144

SRC = src/top.v

ice: $(PIN_DEF)
	#yosys -p 'synth_ice40 -top $(TOP) -json $(OUT_DIR)/$(PROJ).json' $(SRC)
	yosys -p 'synth_ice40 -noflatten -top $(TOP) -json $(OUT_DIR)/$(PROJ).json' $(SRC)
	nextpnr-ice40 --$(DEVICE) --package $(PACKAGE) --asc $(OUT_DIR)/$(PROJ).asc --pcf $< --json $(OUT_DIR)/$(PROJ).json
	icetime -d $(DEVICE) -mtr $(OUT_DIR)/$(PROJ).rpt $(OUT_DIR)/$(PROJ).asc
	icepack $(OUT_DIR)/$(PROJ).asc $(OUT_DIR)/$(PROJ).bin

prog: $(OUT_DIR)/$(PROJ).bin
	iceprog $(OUT_DIR)/$(PROJ).bin

show: $(OUT_DIR)/$(PROJ).json
	yosys -p 'read_json $<; show top'

tb:
	iverilog -o $(OUT_DIR)/$(PROJ)_tb.out -s \
	cmd_handler_tb src/test/cmd_handler_tb.v && $(OUT_DIR)/$(PROJ)_tb.out

.PHONY: clean prog
clean:
	rm -f $(OUT_DIR)/$(PROJ).asc  $(OUT_DIR)/$(PROJ).json  \
		$(OUT_DIR)/$(PROJ).rpt \ $(OUT_DIR)/$(PROJ).bin	$(OUT_DIR)/$(PROJ).out \
		$(OUT_DIR)/$(PROJ)_tb.out $(OUT_DIR)/$(PROJ)_tb.vcd
