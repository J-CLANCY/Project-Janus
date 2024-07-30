
# NC-Sim Command File
# TOOL:	ncsim(64)	15.20-s030
#
#
# You can restore this configuration with:
#
#      irun -covoverwrite -coverage block -f rtl.f ram.v ../verify/tb_janus.v +access+r+w +gui -s -input /proj/ASP1800/workareas/zbf63z/repo1/design_data/ConceptStudy/Janus/rtl/fib_test.tcl
#

set tcl_prompt1 {puts -nonewline "ncsim> "}
set tcl_prompt2 {puts -nonewline "> "}
set vlog_format %h
set vhdl_format %v
set real_precision 6
set display_unit auto
set time_unit module
set heap_garbage_size -200
set heap_garbage_time 0
set assert_report_level note
set assert_stop_level error
set autoscope yes
set assert_1164_warnings yes
set pack_assert_off {}
set severity_pack_assert_off {note warning}
set assert_output_stop_level failed
set tcl_debug_level 0
set relax_path_name 1
set vhdl_vcdmap XX01ZX01X
set intovf_severity_level ERROR
set probe_screen_format 0
set rangecnst_severity_level ERROR
set textio_severity_level ERROR
set vital_timing_checks_on 1
set vlog_code_show_force 0
set assert_count_attempts 1
set tcl_all64 false
set tcl_runerror_exit false
set assert_report_incompletes 0
set show_force 1
set force_reset_by_reinvoke 0
set tcl_relaxed_literal 0
set probe_exclude_patterns {}
set probe_packed_limit 4k
set probe_unpacked_limit 16k
set assert_internal_msg no
set svseed 1
set assert_reporting_mode 0
alias . run
alias iprof profile
alias quit exit
database -open -shm -into waves.shm waves -default
probe -create -database waves tb_janus.janus.inst_decoder.id_fsm.cs tb_janus.janus.clk_janus tb_janus.janus.rst_janus_b tb_janus.janus.inst_decoder.id_fsm.instr tb_janus.janus.pc_incr tb_janus.janus.inst_decoder.ir_wr tb_janus.janus.inst_decoder.ir_wr_ack tb_janus.janus.dob_sel tb_janus.janus.dob tb_janus.janus.cb_out tb_janus.janus.cb_in tb_janus.janus.ab tb_janus.janus.addr_sel tb_janus.janus.rtr_sel tb_janus.janus.reg_wr_ack tb_janus.janus.reg_wr tb_janus.janus.reg_clr tb_janus.janus.rb_reg_clr_sel tb_janus.janus.rb_ip_reg_sel tb_janus.janus.rb_ip_sel tb_janus.janus.imme_out tb_janus.janus.hl_sel tb_janus.janus.alu_a tb_janus.janus.alu_a_sel tb_janus.janus.alu.alu_req tb_janus.janus.alu_ack tb_janus.janus.alu_b tb_janus.janus.alu_b_sel tb_janus.janus.alu_fnct_sel tb_janus.janus.alu_out tb_janus.janus.cf tb_janus.janus.zf tb_janus.janus.vf tb_janus.janus.nf tb_janus.janus.dib_ack tb_janus.janus.dib_id tb_janus.janus.dib_janus tb_janus.janus.dib_rb tb_janus.janus.dib_sel tb_janus.ram.address tb_janus.ram.mem tb_janus.ram.mar_wr tb_janus.ram.ram_wr tb_janus.ram.ram_oe tb_janus.ram.mar_wr_ack tb_janus.ram.ram_wr_ack tb_janus.ram.ram_oe_ack tb_janus.janus.reg_bank.pc.data_out tb_janus.janus.reg_bank.reg0.data_out tb_janus.janus.reg_bank.reg1.data_out tb_janus.janus.reg_bank.reg2.data_out tb_janus.janus.reg_bank.reg3.data_out tb_janus.janus.reg_bank.reg4.data_out tb_janus.janus.reg_bank.reg5.data_out tb_janus.janus.reg_bank.reg6.data_out tb_janus.janus.reg_bank.reg7.data_out tb_janus.janus.reg_bank.reg8.data_out tb_janus.janus.reg_bank.reg9.data_out tb_janus.janus.reg_bank.reg10.data_out tb_janus.janus.reg_bank.reg11.data_out tb_janus.janus.reg_bank.reg12.data_out tb_janus.janus.reg_bank.reg13.data_out tb_janus.janus.reg_bank.reg14.data_out tb_janus.janus.reg_bank.reg15.data_out
probe -create -database waves

simvision -input fib_test.tcl.svcf
