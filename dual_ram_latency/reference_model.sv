////////////////////////////////////////////////////////////////////
// 
//      Reference Model Class for Dual Port RAM
//      
//      File Name          : 	reference_model.sv
//
//      Design version     : 	0.2
//
//      -------- Parameters and Mailboxes declared in the Class -------------
//
//       mbx_mon2ref       = 	Mailbox for process communication from monitor to reference model
//       mbx_ref2scb       = 	Mailbox for process communication from reference model to scoreboard
//       mem               = 	Static memory array
//       mon_data          = 	Transaction object
//
//      -------- Tasks declared in the Class -------------
//
//      run               = 	Task to run the reference model and handle transactions
//
//      Description: 
//
//      This class defines a reference model used for verifying transactions
//      in a SystemVerilog environment. It includes mailboxes for communication
//      between the monitor, reference model, and scoreboard, and a static memory
//      array to store the data. The class has a task to run the reference model
//      and handle transactions based on their type (read or write).
//
////////////////////////////////////////////////////////////////////

`ifndef REFERENCE_MODEL_SV
`define REFERENCE_MODEL_SV
import pkg::*;

class reference_model;
   
  mailbox            mbx_mon2ref;
  mailbox            mbx_ref2scb;
  local transaction  mon_data;

  static logic [DATA_WIDTH-1:0] mem [0:2**ADDRESS_WIDTH-1];

  extern task run(); 

endclass:reference_model
	  
task reference_model::run(); 
  fork   
    forever begin
      mon_data = new();  
      mbx_mon2ref.get(mon_data);
	  
      if(mon_data.op == READ) begin
         mbx_ref2scb.put(mon_data);
      end
      else if(mon_data.op == WRITE) begin
        mem[mon_data.addr] = mon_data.din;
      end
    end  
  join_none
endtask:run
`endif //REFERENCE_MODEL_SV


