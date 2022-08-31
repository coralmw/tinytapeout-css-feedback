# empty wokwi project; used to ensure the project is unique
WOKWI_PROJECT_ID=339800239192932947


fetch:
	# curl https://wokwi.com/api/projects/$(WOKWI_PROJECT_ID)/verilog > src/user_module_$(WOKWI_PROJECT_ID).v
	sed -e 's/USER_MODULE_ID/$(strip $(WOKWI_PROJECT_ID))/g' template/scan_wrapper.v > src/scan_wrapper_$(WOKWI_PROJECT_ID).v
	sed -e 's/USER_MODULE_ID/$(strip $(WOKWI_PROJECT_ID))/g' template/config.tcl > src/config.tcl
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

lint:
	iverilog src/user_module_339800239192932947.v

test:
	make TOPLEVEL=CodeLUT_339800239192932947 MODULE=src.testCodeLUT -f cocotb.mk sim

solve:
	cd src && python3 genexe.py
	cd build && parallel -j 8 --results {.}.log racket {} ::: *.rkt
