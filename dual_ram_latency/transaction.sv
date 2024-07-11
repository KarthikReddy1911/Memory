////////////////////////////////////////////////////////////////////
// 
//      Transaction Class for Data Handling
//
//      File Name         : 	transaction.sv
//
//      Design version    : 	0.1
//
//      -------- Parameters declared in the Class -------------
//
//       ADDRESS_WIDTH    =     Width of address input
//       DATA_WIDTH       =     Width of data input/output
//
//      -------- Input and Output Ports declared in the Class -------------
//
//      addr              =     Transaction address
//      din               =     Input data for transaction
//      op                =     Operation type (read/write/idle)
//      dout              =     Output data from transaction
//      out               =     Formatted output string for display
//
//      -------- Functions declared in the Class -------------
//
//      compare           =     Function to compare two transactions
//      display           =     Function to display transaction details
//
//
//      Description: 
//
//      This class defines a transaction used for data handling
//      in a SystemVerilog environment. It includes parameters for
//      address and data width, and declares inputs and outputs for
//      transaction data. The class provides functions for comparing
//      transactions and displaying transaction details.
//
////////////////////////////////////////////////////////////////////


`ifndef TRANSACTION_SV
`define TRANSACTION_SV
import pkg::*;

class transaction;
  rand  logic [ADDRESS_WIDTH-1:0] addr;
  rand  logic [DATA_WIDTH-1:0]    din;
  rand  state_t                   op;
        logic [DATA_WIDTH-1:0]    dout;
  string                          out;
  
  extern function int compare(input transaction ref_data);
  extern function void display(input string name);

endclass:transaction

function void transaction::display(input string name);
  out = $sformatf($time, "-----%s-----Addr = %0h, DataIn = %0h, DataOut = %0h, Operation = %s--------\n",name,addr,din, dout, op);
  $display("================================================================================================");
  $display($time,"  %s",out);
  $display("================================================================================================");
endfunction:display


function int transaction::compare(input transaction ref_data);
  if(this.dout === ref_data.dout) begin
    $display($time, "  Data Matched dout = %h , ref_dout = %h", this.dout, ref_data.dout);
    return 1;
  end else begin
    $info($time, "  Data not Matched dout = %h , ref_dout = %h", this.dout, ref_data.dout);
    return 0;
  end
endfunction:compare
`endif //TRANSACTION_SV
