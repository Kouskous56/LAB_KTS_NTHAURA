# create_project.tcl - run: vivado -mode batch -source create_project.tcl
set proj_dir [file normalize [file dirname [info script]]]
set proj_name "EXP_2_alu"
create_project $proj_name "$proj_dir/project_1" -part xc7a100tcsg324-1 -force
add_files -norecurse [list "alu_4bit.sv" "top_module.sv"]
set_property top top_module [current_fileset]
add_files -fileset constrs_1 -norecurse "$proj_dir/Nexys-A7-100T-Master.xdc"
set_property target_language SystemVerilog [current_project]
puts "Project $proj_name created."
