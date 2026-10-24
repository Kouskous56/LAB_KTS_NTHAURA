# create_project.tcl
set proj_dir [file normalize [file dirname [info script]]]
create_project EXP_1_func $proj_dir/project_1 -part xc7a100tcsg324-1 -force
add_files -norecurse [list "$proj_dir/func_and_or.sv" "$proj_dir/func_nand.sv" "$proj_dir/top_module.sv"]
set_property top top_module [current_fileset]
add_files -fileset constrs_1 -norecurse "$proj_dir/Nexys-A7-100T-Master.xdc"
set_property target_language Verilog [current_project]
puts "Project created."
