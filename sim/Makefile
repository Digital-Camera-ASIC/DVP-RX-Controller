.PHONY: all pre_sim input_gen sim output_anal clean

all: clean pre_sim input_gen sim output_anal

pre_sim:
	if not exist env\dvp_mem_data.txt (type nul > env\dvp_mem_data.txt)
	if not exist env\axi_mem_format.txt (type nul > env\axi_mem_format.txt)
	if not exist env\axi_mem_data.txt (type nul > env\axi_mem_data.txt)

input_gen:
	python env/img2txt.py

sim:
	$(MAKE) -f tool_run

output_anal:
	python env/txt2img.py

clean:
	if exist env\dvp_mem_data.txt del /f env\dvp_mem_data.txt
	if exist env\axi_mem_format.txt del /f env\axi_mem_format.txt
	if exist env\axi_mem_data.txt del /f env\axi_mem_data.txt
	if exist output* del /f output*
