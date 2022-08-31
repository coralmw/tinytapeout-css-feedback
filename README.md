![](../../workflows/wokwi/badge.svg)

Go to https://tinytapeout.com for instructions!

# 5 qubit CSS feedback decoder - in sillicon!

The [5 qubit code](https://en.wikipedia.org/wiki/Five-qubit_error_correcting_code) is the smallest possible code that protects a single logical qubit from all errors on the coding physical qubits. It uses a small number of ancilla - those are not protected, so this is not in itself a practical code.

It's probable that the decoding rate for full-strength codes will be a significant limitation; a content addressable memory with kilobit addressing is a challenging structure to build, even with 10's MHz cycle times. Practical decoders will be approximate, but as latency is a critical factor it's probable that dedicated semiprogrammable processing ASIC's will be needed.

# What files get made?

When the action is complete, you can [click here](https://github.com/mattvenn/wokwi-verilog-gds-test/actions) to see the latest build of your design. You need to download the zip file and take a look at the contents:

* gds_render.svg - picture of your ASIC design
* gds.html - zoomable picture of your ASIC design
* runs/wokwi/reports/final_summary_report.csv  - CSV file with lots of details about the design
* runs/wokwi/reports/synthesis/1-synthesis.stat.rpt.strategy4 - list of the [standard cells](https://www.zerotoasiccourse.com/terminology/standardcell/) used by your design
* runs/wokwi/results/final/gds/user_module.gds - the final [GDS](https://www.zerotoasiccourse.com/terminology/gds2/) file needed to make your design

# What next?

* Share your GDS on twitter, tag it #tinytapeout and [link me](https://twitter.com/matthewvenn)!
* [Submit it to be made](https://docs.google.com/forms/d/e/1FAIpQLSc3ZF0AHKD3LoZRSmKX5byl-0AzrSK8ADeh0DtkZQX0bbr16w/viewform?usp=sf_link)
* [Join the community](https://discord.gg/rPK2nSjxy8)
