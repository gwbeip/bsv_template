# ------------ specific project --------------------

# directory of source files
src=$(pwd)/src # source file
# top module name
top_module=mkTb
# top file name in the directory of source files
top_file=Hello.bsv
# simulation cycle count; 0 means don't care
cycle_count=0
# dump VCD file (1) or not (0)
gen_vcd_file=0


# ------------ common settings --------------------

# complier
compiler_name="bsc"

# temporary directory:
#   bdir/       --> -bdir   (*.bo  *.ba)
#   simdir/     --> -simdir (intermediate files for simulation)
#   verilog/    --> -vdir   (generated verilog files)
current_dir=$(pwd)
bdir=$current_dir/bdir
simdir=$current_dir/simdir
vdir=$current_dir/verilog

# colors for outputs
error_color="\033[1;31m"  # color for errors (bold red)
note_color="\033[4;36m"   # color for notations (under-line cyan) 
runsim_color="\033[0;32m" # color for the outputs of simulation (yellow) 
default_color="\033[m"    # default color (e.g., white)
