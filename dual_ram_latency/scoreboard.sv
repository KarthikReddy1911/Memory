////////////////////////////////////////////////////////////////////
// 
//      Scoreboard Class for Dual Port RAM
//      File Name         : 	scoreboard.sv
//
//      Design version    : 	0.2
//
//      -------- Parameters and  Mailboxes declared in the Class -------------
//
//       mbx_mon2scb      = 	Mailbox for process communication from monitor to scoreboard
//       mbx_ref2scb      = 	Mailbox for process communication from reference model to scoreboard
//       ref_data         = 	Transaction object for reference model data
//       mon_data         = 	Transaction object for monitor data
//       pass_or_fail     = 	Integer to track pass or fail status of comparisons
//
//       mem_coverage     = 	Covergroup for memory coverage analysis
//
//      -------- Coverpoints declared in the Class -------------
//
//      RD_ADD            = 	Coverpoint for address coverage
//      DATA              = 	Coverpoint for data output coverage
//      DATAxADD          = 	Cross coverage of address and data output
//
//      -------- Tasks declared in the Class -------------
//
//      run               = 	Task to run the scoreboard and handle transactions
//
//      Description: 
//
//      This class defines a scoreboard used for verifying the correctness of
//      transactions in a SystemVerilog environment. It includes mailboxes for
//      communication between the monitor, reference model, and scoreboard. The
//      class includes a covergroup for memory coverage analysis, tracking address
//      and data output coverage. It also contains a task to run the scoreboard,
//      comparing transactions and updating pass/fail counts.
// 
////////////////////////////////////////////////////////////////////

`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV
import pkg::*;

class scoreboard;
  mailbox            mbx_mon2scb;
  mailbox            mbx_ref2scb;
  local transaction  ref_data;
  local  transaction  mon_data;

  int                pass_or_fail = 0;

  covergroup mem_coverage;
    option.per_instance  = 1;
    RD_DATA : coverpoint ref_data.dout {
      bins zero = {0};
      bins mid1 = {[1:127]};
      bins mid2 = {[128:254]};
      bins max  = {255};
    }
  endgroup: mem_coverage
  
  function new();
    mem_coverage = new();
  endfunction

  extern task run();

endclass:scoreboard

task scoreboard::run();
  fork
    forever begin
      ref_data = new();
      mon_data = new();

      mbx_mon2scb.get(mon_data);
      mbx_ref2scb.get(ref_data);

       pass_or_fail = mon_data.compare(ref_data);
    //  pass_or_fail = mon_data::compare(ref_data);


      if(pass_or_fail == 1) begin
        test_cases_passed++;
        mem_coverage.sample();
      end else if (pass_or_fail == 0) begin
        test_cases_failed++;
      end
    end
  join_none
endtask:run
`endif //SCOREBOARD_SV

