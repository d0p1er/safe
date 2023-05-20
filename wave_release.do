onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /safe/CODE_LENGTH
add wave -noupdate /safe/TIMEOUT_VALUE
add wave -noupdate /safe/clk_i
add wave -noupdate /safe/arst_n_i
add wave -noupdate /safe/KEY_0
add wave -noupdate /safe/KEY_1
add wave -noupdate /safe/KEY_2
add wave -noupdate /safe/KEY_OK
add wave -noupdate /safe/KEY_CLEAR
add wave -noupdate /safe/DOOR_SEALED
add wave -noupdate /safe/current_pass
add wave -noupdate /safe/current_input
add wave -noupdate -expand /safe/current_input_cnt
add wave -noupdate /safe/state
add wave -noupdate /safe/is_digit_input
add wave -noupdate /safe/data_prev
add wave -noupdate /safe/is_submit
add wave -noupdate /safe/code_match
add wave -noupdate /safe/timeout
add wave -noupdate /safe/timeout_active
add wave -noupdate /safe/digit_input_allowed
add wave -noupdate -divider OUT
add wave -noupdate /safe/data_out_o
add wave -noupdate /safe/data_out_valid_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3691 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 180
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1825 ns}
view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue HiZ -period 100ns -dutycycle 50 -starttime 0ns -endtime 1000ns sim:/safe/clk_i 
wave modify -driver freeze -pattern clock -initialvalue HiZ -period 100ns -dutycycle 50 -starttime 0ns -endtime 10000ns Edit:/safe/clk_i 
wave create -driver freeze -pattern clock -initialvalue HiZ -period 10000ns -dutycycle 99 -starttime 0ns -endtime 10000ns sim:/safe/arst_n_i 
wave create -driver freeze -pattern clock -initialvalue {Not Logged} -period 10000ns -dutycycle 1 -starttime 0ns -endtime 10000ns sim:/safe/KEY_1 
wave edit change_value -start 0ns -end 110ns -value 0 Edit:/safe/KEY_1 
wave edit invert -start 271ns -end 431ns Edit:/safe/KEY_1 
wave create -pattern constant -value 1 -starttime 0ns -endtime 10000ns sim:/safe/code_is_set 
wave create -driver freeze -pattern clock -initialvalue HiZ -period 10000ns -dutycycle 1 -starttime 0ns -endtime 10000ns sim:/safe/KEY_2 
wave edit change_value -start 0ns -end 110ns -value 0 Edit:/safe/KEY_2 
wave edit invert -start 929ns -end 1117ns Edit:/safe/KEY_2 
wave create -driver freeze -pattern clock -initialvalue HiZ -period 10000ns -dutycycle 1 -starttime 0ns -endtime 10000ns sim:/safe/KEY_OK 
wave edit change_value -start 0ns -end 109ns -value 0 Edit:/safe/KEY_OK 
wave edit invert -start 1755ns -end 1952ns Edit:/safe/KEY_OK 
wave edit change_value -start 262ns -end 442ns -value 0 Edit:/safe/KEY_1 
wave edit invert -start 928ns -end 1123ns Edit:/safe/KEY_1 
wave edit invert -start 299ns -end 477ns Edit:/safe/KEY_2 
wave edit change_value -start 923ns -end 1126ns -value 0 Edit:/safe/KEY_2 
wave edit change_value -start 1948ns -end 2163ns -value 1 Edit:/safe/KEY_OK 
wave create -driver freeze -pattern clock -initialvalue HiZ -period 10000ns -dutycycle 1 -starttime 0ns -endtime 10000ns sim:/safe/KEY_CLEAR 
wave edit change_value -start 0ns -end 112ns -value 0 Edit:/safe/KEY_CLEAR 
wave edit invert -start 1326ns -end 1521ns Edit:/safe/KEY_CLEAR 
wave edit change_value -start 1311ns -end 1531ns -value 0 Edit:/safe/KEY_CLEAR 
wave create -driver freeze -pattern clock -initialvalue HiZ -period 10000ns -dutycycle 1 -starttime 0ns -endtime 10000ns sim:/safe/DOOR_SEALED 
wave edit change_value -start 0ns -end 105ns -value 0 Edit:/safe/DOOR_SEALED 
wave edit invert -start 2706ns -end 2906ns Edit:/safe/DOOR_SEALED 
wave edit invert -start 683ns -end 862ns Edit:/safe/KEY_2 
wave edit change_value -start 671ns -end 870ns -value 0 Edit:/safe/KEY_2 
wave create -driver freeze -pattern clock -initialvalue HiZ -period 10000ns -dutycycle 1 -starttime 0ns -endtime 10000ns sim:/safe/KEY_0 
wave edit change_value -start 0ns -end 109ns -value 0 Edit:/safe/KEY_0 
wave edit invert -start 693ns -end 816ns Edit:/safe/KEY_0 
wave edit invert -start 2607ns -end 2780ns Edit:/safe/KEY_2 
wave edit invert -start 3143ns -end 3368ns Edit:/safe/KEY_1 
wave edit invert -start 3691ns -end 3896ns Edit:/safe/KEY_OK 
{wave export -file /home/d0p1er/Desktop/p/verilog/safe/release.vcd -starttime 0 -endtime 10000 -format force -designunit safe} 
WaveCollapseAll -1
wave clipboard restore
