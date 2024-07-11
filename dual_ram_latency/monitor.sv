////////////////////////////////////////////////////////////////////
// 
//      Monitor Class for Dual Port RAM
//
//      File Name       : 	monitor.sv
//
//      Design version  : 	0.2
//
//      -------- Parameters and Mailboxes declared in the Class -------------
//
//       mem_vif        = 	Virtual interface for memory signals
//       mbx_mon2scb    = 	Mailbox for communication from monitor to scoreboard
//       mbx_mon2ref    = 	Mailbox for communication from monitor to reference model
//       i              = 	Integer parameter for instance identification
//       data2ref_rd    = 	Transaction object for reference model read data
//       data2ref_wr    = 	Transaction object for reference model write data
//       data2scb       = 	Transaction object for scoreboard data
//       cg             = 	Transaction object for covergroup sampling
//       ref_mem        = 	Reference model object
//       mem_coverage   = 	Covergroup for memory coverage analysis
//
//      -------- Coverpoints declared in the Class -------------
//
//      WR_ADD          = 	Coverpoint for address coverage during write operations
//      DATA            = 	Coverpoint for data input coverage
//      DATAxADD        = 	Cross coverage of address and data input
//
//      -------- Tasks declared in the Class -------------
//
//      run             = 	Task to monitor and sample transactions
//
//
//      Description: 
//
//      This class defines a monitor used for observing and sampling transactions
//      in a SystemVerilog environment. It includes mailboxes for communication
//      between the monitor, scoreboard, and reference model. The class includes
//      a covergroup for memory coverage analysis, tracking address and data input
//      coverage. It also contains a task to monitor transactions, sample them,
//      and send them to the scoreboard and reference model.
// 
////////////////////////////////////////////////////////////////////

`ifndef MONITOR_SV
`define MONITOR_SV
import pkg::*;

class monitor;
  virtual                 mem_intf mem_vif;

  mailbox                 mbx_mon2scb;
  mailbox                 mbx_mon2ref;
      
  int                     i;

  local transaction       data2ref_rd;
  local transaction       data2ref_wr;
  local transaction       data2scb;
  local transaction       cg;
  local reference_model   ref_mem;

  covergroup mem_coverage;
    option.per_instance      = 1;
    ADD : coverpoint cg.addr {
      bins zero = {[0:1]};
      bins mid = {[2:5]};
      bins max = {[6:7]};
    }
    WR_DATA : coverpoint cg.din {
      bins zero = {0};
      bins mid1 = {[1:127]};
      bins mid2 = {[128:254]};
      bins max = {255};
    }
  endgroup: mem_coverage

  function new();
    mem_coverage     = new();
  endfunction

  extern local task monitor();

  extern task run();

  extern local task latency_rd(input [7:0] ref_dout);

endclass:monitor

task monitor::monitor();
  @(mem_vif.monitor_cb);
   
  if(mem_vif.monitor_cb.i_en && !mem_vif.monitor_cb.i_we) begin
    latency_rd(ref_mem.mem[mem_vif.monitor_cb.i_addr]);
  end 

  if(mem_vif.en && mem_vif.we) begin
    data2ref_wr.din  = mem_vif.din;
    data2ref_wr.addr = mem_vif.addr;
    data2ref_wr.op   = WRITE;
    mbx_mon2ref.put(data2ref_wr);
  end
  cg.din  = mem_vif.monitor_cb.i_din;
  cg.addr = mem_vif.monitor_cb.i_addr;
  mem_coverage.sample(); 
endtask:monitor

task monitor::run();
  fork begin    
    forever begin
      this.data2ref_rd = new();
      this.data2ref_wr = new();
      this.data2scb    = new();
      this.cg          = new();
      monitor();
    end
  end
  join_none
endtask:run 

task monitor::latency_rd(input [7:0] ref_dout);
  fork
    begin
      repeat(READ_LATENCY[i]) @(mem_vif.monitor_cb);
      data2scb.dout    = mem_vif.monitor_cb.o_dout;
      mbx_mon2scb.put(data2scb); 
      data2ref_rd.dout = ref_dout;
      data2ref_rd.op   = READ;
      mbx_mon2ref.put(data2ref_rd);
    end
  join_none
endtask:latency_rd
`endif //MONITOR_SV
