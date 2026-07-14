PYTHON ?= python3
IMAGE := ./rescue_raiders.dsk
TOOL := tools/recover.py

.PHONY: all doctor emulator-doctor emulator-practice fingerprint extract analyze disassemble assets rebuild report verify fresh-verify smoke clean

all: verify

doctor:
	$(PYTHON) $(TOOL) doctor --image $(IMAGE) --output build/toolchain.json

emulator-doctor:
	@echo "approval-gated: authorize apple2ts before running the read-only consistency preflight"
	@exit 2

emulator-practice:
	@echo "approval-gated: authorize apple2ts before the three fresh-session qualification runs"
	@exit 2

fingerprint:
	$(PYTHON) $(TOOL) fingerprint --image $(IMAGE) --checksums original/checksums.txt --output build/fingerprint.json

extract: fingerprint
	$(PYTHON) $(TOOL) extract --image $(IMAGE) --output build/extract

analyze: extract
	$(PYTHON) $(TOOL) analyze --image $(IMAGE) --output build/reports

disassemble: extract
	$(PYTHON) $(TOOL) disassemble --image $(IMAGE) --output build/disassembly

assets: disassemble
	$(PYTHON) $(TOOL) assets --image $(IMAGE) --build build --output build/assets

rebuild: disassemble
	$(PYTHON) $(TOOL) rebuild --image $(IMAGE) --build build --output build/rebuild

report: doctor analyze disassemble assets rebuild
	$(PYTHON) $(TOOL) report --image $(IMAGE) --output build/reports/baseline.md

verify: doctor fingerprint extract analyze disassemble assets rebuild report
	$(PYTHON) -m unittest discover -s tests -v
	$(PYTHON) $(TOOL) verify --image $(IMAGE) --checksums original/checksums.txt --build build

fresh-verify: clean
	$(MAKE) verify

smoke:
	@echo "approval-gated: qualify apple2ts and authorize the bounded Rescue Raiders checkpoint run first"
	@exit 2

clean:
	rm -rf build
