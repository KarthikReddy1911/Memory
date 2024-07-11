////////////////////////////////////////////////////////////////////
// 
//      Generator Class for Data Generation
//
//      File Name          : 	generator.sv
//      
//      Design version     : 	0.2
//
//      -------- Parameters declared in the Class -------------
//
//       total_transaction =	Counter for total number of transactions
//
//      -------- Input and Output Ports declared in the Class -------------
//
//      trans             = 	Transaction object
//
//      -------- Tasks declared in the Class -------------
//
//      gen               = 	Task to randomize and generate a transaction
//
//      Description: 
//
//      This class defines a generator used to create transactions
//      in a SystemVerilog environment. It includes a counter for
//      total transactions and declares a task to randomize and 
//      generate transactions.
// 
////////////////////////////////////////////////////////////////////

`ifndef GENERATOR_SV
`define GENERATOR_SV
import pkg::*;

class generator;
  local transaction trans;

  extern task gen_pkt(output transaction trans);

endclass:generator


task  generator::gen_pkt(output transaction trans);
  trans = new();
  total_transaction++; 
  trans.randomize();
endtask:gen_pkt
`endif //GENERATOR_SV
