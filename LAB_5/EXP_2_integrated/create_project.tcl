# create_project.tcl
set proj_dir [file normalize [file dirname [info script]]]
create_project EXP_1_exp2 $proj_dir/project_1 -part xc7a100tcsg324-1 -force
add_files -norecurse [list "$proj_dir/clock_divider_core.sv" "$proj_dir/seg7_scan.sv" "$proj_dir/traffic_fsm_integrated.sv" "$proj_dir/top_module.sv"]
set_property top top_module [current_fileset]
add_files -fileset constrs_1 -norecurse "$proj_dir/Nexys-A7-100T-Master.xdc"
set_property target_language Verilog [current_project]
puts "Project created."
