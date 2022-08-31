# WOKWI_PROJECT_ID=coralmw_manual_verilog

WOKWI_PROJECT_ID=334335179919196756

# logic puzzle and muxes
# 4 inverters 334348818476696146
# the clock divider 334335179919196756
fetch:
	curl https://wokwi.com/api/projects/$(WOKWI_PROJECT_ID)/verilog > src/user_module_$(WOKWI_PROJECT_ID).v
	sed -e 's/USER_MODULE_ID/$(WOKWI_PROJECT_ID)/g' template/scan_wrapper.v > src/scan_wrapper_$(WOKWI_PROJECT_ID).v
	sed -e 's/USER_MODULE_ID/$(WOKWI_PROJECT_ID)/g' template/config.tcl > src/config.tcl
	echo $(WOKWI_PROJECT_ID) > src/ID

# needs PDK_ROOT and OPENLANE_ROOT, OPENLANE_IMAGE_NAME set from your environment
harden:
	docker run --rm \
	-v $(OPENLANE_ROOT):/openlane \
	-v $(PDK_ROOT):$(PDK_ROOT) \
	-v $(CURDIR):/work \
	-e PDK_ROOT=$(PDK_ROOT) \
	-u $(shell id -u $(USER)):$(shell id -g $(USER)) \
	$(OPENLANE_IMAGE_NAME) \
	/bin/bash -c "./flow.tcl -overwrite -design /work/src -run_path /work/runs -tag wokwi"

solve:
	cd src && python3 genexe.py
	cd build && parallel --results {.}.log "/Applications/Racket\ v8.6/bin/racket" {} ::: *.rkt