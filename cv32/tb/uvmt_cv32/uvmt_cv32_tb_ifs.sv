
// Copyright 2020 OpenHW Group
// Copyright 2020 Datum Technologies
// 
// Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     https://solderpad.org/licenses/
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// 



// This file specifies all interfaces used by the CV32 test bench (uvmt_cv32_tb).
// Most interfaces support tasks to allow control by the ENV or test cases.

`ifndef __UVMT_CV32_TB_IFS_SV__
`define __UVMT_CV32_TB_IFS_SV__


/**
 * clocks and reset
 */
interface uvmt_cv32_clk_gen_if (output logic core_clock, output logic core_reset_n);

   import uvm_pkg::*;
   
   bit       start_clk               = 0;
   // TODO: get the uvme_cv32_* values from random ENV CFG members.
   realtime  core_clock_period       = 1500ps; // uvme_cv32_clk_period * 1ps;
   realtime  reset_deassert_duration = 7400ps; // uvme_cv32_reset_deassert_duarion * 1ps;
   realtime  reset_assert_duration   = 7400ps; // uvme_cv32_reset_assert_duarion * 1ps;
   
   
   /**
    * Generates clock and reset signals.
    * If reset_n comes up de-asserted (1'b1), wait a bit, then assert, then de-assert
    * Otherwise, leave reset asserted, wait a bit, then de-assert.
    */
   initial begin
      core_clock   = 0; // uvme_cv32_clk_initial_value;
      core_reset_n = 0; // uvme_cv32_reset_initial_value;
      wait (start_clk);
      fork
         forever begin
            #(core_clock_period/2) core_clock = ~core_clock;
         end
         begin
           if (core_reset_n == 1'b1) #(reset_deassert_duration);
           core_reset_n = 1'b0;
           #(reset_assert_duration);
           core_reset_n = 1'b1;
         end
      join_none
   end
   
   /**
    * Sets clock period in ps.
    */
   function void set_clk_period ( real clk_period );
      core_clock_period = clk_period * 1ps;
   endfunction : set_clk_period
   
   /** Triggers the generation of clk. */
   function void start();
      start_clk = 1;
      `uvm_info("CLK_GEN_IF", "uvmt_cv32_clk_gen_if.start() called", UVM_NONE)
   endfunction : start
   
endinterface : uvmt_cv32_clk_gen_if

/**
 * Status information generated by the Virtual Peripherals in the DUT WRAPPER memory.
 */
interface uvmt_cv32_vp_status_if (
                                  inout wire        tests_passed,
                                  inout wire        tests_failed,
                                  inout wire        exit_valid,
                                  inout wire [31:0] exit_value
                                 );

  import uvm_pkg::*;

  // TODO: X/Z checks
  initial begin
  end

endinterface : uvmt_cv32_vp_status_if


/**
 * Quasi-static core control signals.
 */
interface uvmt_cv32_core_cntrl_if (
                                    output logic        fetch_en,
                                    output logic        ext_perf_counters,
                                    // quasi static values
                                    output logic        clock_en,
                                    output logic        scan_cg_en,
                                    output logic [31:0] boot_addr,
                                    output logic [31:0] mtvec_addr,
                                    output logic [31:0] dm_halt_addr,
                                    output logic [31:0] dm_exception_addr,
                                    output logic [31:0] hart_id,
                                    // To be driven by future debug module (DM)
                                    output logic        debug_req,
                                    // Testcase asserts this to load memory (not really a core control signal)
                                    output logic        load_instr_mem
                                  );

  import uvm_pkg::*;

  string qsc_stat_str; //Quasi Static Control Status

  covergroup core_cntrl_cg;
    clock_enable: coverpoint clock_en {
      bins enabled  = {1'b1};
      bins disabled = {1'b0};
    }
    scan_enable: coverpoint scan_cg_en {
      bins enabled  = {1'b1};
      bins disabled = {1'b0};
    }
    boot_address: coverpoint boot_addr {
      bins low  = {[32'h0000_0000 : 32'h0000_FFFF]};
      bins med  = {[32'h0001_0000 : 32'hEFFF_FFFF]};
      bins high = {[32'hF000_0000 : 32'hFFFF_FFFF]};
    }
    mtvec_address: coverpoint mtvec_addr {
      bins low  = {[32'h0000_0000 : 32'h0000_FFFF]};
      bins med  = {[32'h0001_0000 : 32'hEFFF_FFFF]};
      bins high = {[32'hF000_0000 : 32'hFFFF_FFFF]};
    }
    debug_module_halt_address: coverpoint dm_halt_addr {
      bins low  = {[32'h0000_0000 : 32'h0000_FFFF]};
      bins med  = {[32'h0001_0000 : 32'hEFFF_FFFF]};
      bins high = {[32'hF000_0000 : 32'hFFFF_FFFF]};
    }
    debug_module_exception_address: coverpoint dm_exception_addr {
      bins low  = {[32'h0000_0000 : 32'h0000_FFFF]};
      bins med  = {[32'h0001_0000 : 32'hEFFF_FFFF]};
      bins high = {[32'hF000_0000 : 32'hFFFF_FFFF]};
    }
    hart_id: coverpoint hart_id {
      bins low  = {[32'h0000_0000 : 32'h0000_FFFF]};
      bins med  = {[32'h0001_0000 : 32'hEFFF_FFFF]};
      bins high = {[32'hF000_0000 : 32'hFFFF_FFFF]};
    }
  endgroup: core_cntrl_cg

  core_cntrl_cg core_cntrl_cg_inst;

  initial begin: static_controls
    fetch_en          = 1'b0; // Enabled by go_fetch(), below
    ext_perf_counters = 1'b0; // TODO: set proper width (currently 0 in the RTL)
  end

  // TODO: randomize hart_id (should have no affect?).
  //       randomize boot_addr and mtvec addr (need to sync with the start address of the test program.
  //       figure out what to do with test_en.
  initial begin: quasi_static_controls

    clock_en          = 1'b1;
    scan_cg_en        = 1'b0;
    boot_addr         = 32'h0000_0080;
    mtvec_addr        = 32'h0000_0000;
    dm_halt_addr      = 32'h1A11_0800;
    dm_exception_addr = 32'h1A11_1000;
    hart_id           = 32'h0000_0000;

    // If a override is provided via plusarg then set bootstrap pins and adjust ISS model
    if ($value$plusargs("mtvec_addr=0x%x", mtvec_addr)) begin
      string override;
      int fh;

`ifdef ISS
      override = $sformatf("--override root/cpu/mtvec=0x%08x", {mtvec_addr[31:8], 8'h01});
      fh = $fopen("ovpsim.ic", "a");      
      $fwrite(fh, " %s\n", override);
      $fclose(fh);
`endif
    end

    qsc_stat_str =                $sformatf("\tclock_en          = %0d\n", clock_en);
    qsc_stat_str = {qsc_stat_str, $sformatf("\tscan_cg_en        = %0d\n", scan_cg_en)};
    qsc_stat_str = {qsc_stat_str, $sformatf("\tboot_addr         = %8h\n", boot_addr)};
    qsc_stat_str = {qsc_stat_str, $sformatf("\tmtvec_addr        = %8h\n", mtvec_addr)};
    qsc_stat_str = {qsc_stat_str, $sformatf("\tdm_halt_addr      = %8h\n", dm_halt_addr)};
    qsc_stat_str = {qsc_stat_str, $sformatf("\tdm_exception_addr = %8h\n", dm_exception_addr)};
    qsc_stat_str = {qsc_stat_str, $sformatf("\thart_id           = %8h\n", hart_id)};

    `uvm_info("CORE_CNTRL_IF", $sformatf("Quasi-static CORE control inputs:\n%s", qsc_stat_str), UVM_NONE)
  end

  // TODO: waiting for the User Manual to provide some guidance here...
  initial begin: debug_control
    debug_req  = 1'b0;
  end

  /** Sets fetch_en to the core. */
  function void go_fetch();
    fetch_en = 1'b1;
    `uvm_info("CORE_CNTRL_IF", "uvmt_cv32_core_cntrl_if.go_fetch() called", UVM_DEBUG)
    core_cntrl_cg_inst = new();
    core_cntrl_cg_inst.sample();
  endfunction : go_fetch

endinterface : uvmt_cv32_core_cntrl_if

/**
 * Core status signals.
 */
interface uvmt_cv32_core_status_if (
                                    input  wire        core_busy,
                                    input  logic       sec_lvl
                                   );

  import uvm_pkg::*;

endinterface : uvmt_cv32_core_status_if

/**
 * ISA coverage interface
 * ISS wrapper will fill in ins (instruction) and fire ins_valid event
 */
interface uvmt_cv32_isa_covg_if;

  import uvm_pkg::*;
  import uvme_cv32_pkg::*;

  event ins_valid;
  ins_t ins;

endinterface : uvmt_cv32_isa_covg_if

/**
 * Step and compare interface
 * Xcelium does not support event types in the module port list
 */
interface uvmt_cv32_step_compare_if;

  import uvm_pkg::*;

  // From RTL riscv_tracer.sv
  typedef struct {
     logic [ 5:0] addr;
     logic [31:0] value;
   } reg_t;

   event        ovp_cpu_retire; // Was ovp.cpu.Retire
   event        riscv_retire;   // Was riscv_core.riscv_tracer_i.retire
   bit   [31:0] ovp_cpu_PCr;    // Was iss_wrap.cpu.PCr
   logic [31:0] insn_pc;
   bit         ovp_b1_Step;    // Was ovp.b1.Step = 0;
   bit         ovp_b1_Stepping; // Was ovp.b1.Stepping = 1;
   event       ovp_cpu_busWait;  // Was call to ovp.cpu.busWait();
   logic   [31:0] ovp_cpu_GPR[32];
   logic [31:0][31:0] riscy_GPR; // packed dimensions, register index by data width
   logic       deferint_prime; // Stages deferint for the ISS deferint signal

   int  num_pc_checks;
   int  num_gpr_checks;
   int  num_csr_checks;

   // Report on the checkers at the end of simulation
   function void report_step_compare();
      if (num_pc_checks > 0) begin
         `uvm_info("step_compare", $sformatf("Checked PC 0d%0d times", num_pc_checks), UVM_LOW);
      end
      else begin
         `uvm_error("step_compare", "PC was checked 0 times!");
      end
      if (num_gpr_checks > 0) begin
         `uvm_info("step_compare", $sformatf("Checked GPR 0d%0d times", num_gpr_checks), UVM_LOW);
      end
      else begin
         `uvm_error("step_compare", "GPR was checked 0 times!");
      end
      if (num_csr_checks > 0) begin
         `uvm_info("step_compare", $sformatf("Checked CSR 0d%0d times", num_csr_checks), UVM_LOW);
      end
      else begin
         `uvm_error("step_compare", "CSR was checked 0 times!");
      end
   endfunction // report_step_compare
   
endinterface: uvmt_cv32_step_compare_if

// Interface to debug assertions and covergroups
interface uvmt_cv32_debug_cov_assert_if
    import cv32e40p_pkg::*;
    (
    input logic clk_i,
    input logic rst_ni,

    // Core inputs
    input logic        fetch_enable_i, // external core fetch enable

    // External interrupt interface
    input logic [31:0] irq_i,
    input logic        irq_ack_o,
    input logic [4:0]  irq_id_o,
    input logic [31:0] mie_q,

    // Instruction fetch stage
    input logic        if_stage_instr_rvalid_i, // Instruction word is valid
    input logic [31:0] if_stage_instr_rdata_i, // Instruction word data

    // Instruction ID stage (determines executed instructions)  
    input logic        id_stage_instr_valid_i, // instruction word is valid
    input logic [31:0] id_stage_instr_rdata_i, // Instruction word data
    input logic        id_stage_is_compressed,
    input logic [31:0] id_stage_pc, // Program counter in decode
    input logic [31:0] if_stage_pc, // Program counter in fetch
    input logic        is_decoding,
    input logic        id_valid,
    input wire ctrl_state_e  ctrl_fsm_cs,            // Controller FSM states with debug_req
    input logic        illegal_insn_i,
    input logic        illegal_insn_q, // output from controller
    input logic        ecall_insn_i,

    input logic [31:0] boot_addr_i,

    // Debug signals
    input logic              debug_req_i, // From controller
    input logic              debug_mode_q, // From controller
    input logic [31:0] dcsr_q, // From controller
    input logic [31:0] depc_q, // From cs regs
    input logic [31:0] depc_n, // 
    input logic [31:0] dm_halt_addr_i,
    input logic [31:0] dm_exception_addr_i,

    input logic [31:0] mcause_q,
    input logic [31:0] mtvec,
    input logic [31:0] mepc_q,
    input logic [31:0] tdata1,
    input logic [31:0] tdata2,
    input logic trigger_match_i,

    // Counter related input from cs_registers
    input logic [31:0] mcountinhibit_q,
    input logic [63:0] mcycle,
    input logic [63:0] minstret,
    input logic inst_ret,
    // WFI Interface
    input logic core_sleep_o,

    input logic csr_access,
    input logic [1:0] csr_op,
    input logic [1:0] csr_op_dec,
    input logic [11:0] csr_addr,
    input logic csr_we_int,
    output logic is_wfi,
    output logic in_wfi,
    output logic dpc_will_hit,
    output logic addr_match,
    output logic is_ebreak,
    output logic is_cebreak,
    output logic is_dret,
    output logic [31:0] pending_enabled_irq,
    input logic pc_set
);

  clocking mon_cb @(posedge clk_i);    
    input #1step
    fetch_enable_i,

    irq_i,
    irq_ack_o,
    irq_id_o,
    mie_q,

    if_stage_instr_rvalid_i,
    if_stage_instr_rdata_i,

    id_stage_instr_valid_i,
    id_stage_instr_rdata_i,
    id_stage_is_compressed,
    id_stage_pc,
    if_stage_pc,
    ctrl_fsm_cs,
    illegal_insn_i,
    illegal_insn_q,
    ecall_insn_i,
    boot_addr_i, 
    debug_req_i,
    debug_mode_q,
    dcsr_q,
    depc_q,
    depc_n,
    dm_halt_addr_i,
    dm_exception_addr_i,
    mcause_q,
    mtvec,
    mepc_q,
    tdata1,
    tdata2,
    trigger_match_i,

    mcountinhibit_q,
    mcycle,
    minstret,
    inst_ret,
    
    core_sleep_o,
    csr_access,
    csr_op,
    csr_op_dec,
    csr_addr,
    is_wfi,
    in_wfi,
    dpc_will_hit,
    addr_match,
    is_ebreak,
    is_cebreak,
    is_dret,
    pending_enabled_irq,
    pc_set;
  endclocking : mon_cb

endinterface : uvmt_cv32_debug_cov_assert_if

`endif // __UVMT_CV32_TB_IFS_SV__
