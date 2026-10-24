# create_project.tcl
set proj_dir [file normalize [file dirname [info script]]]
create_project EXP_1_exp3 $proj_dir/project_1 -part xc7a100tcsg324-1 -force
add_files -norecurse [list "$proj_dir/func_f1.sv" "$proj_dir/func_f2.sv" "$proj_dir/top_module.sv"]
set_property top top_module [current_fileset]
add_files -fileset constrs_1 -norecurse "$proj_dir/Nexys-A7-100T-Master.xdc"
set_property target_language Verilog [current_project]
puts "Project created."
