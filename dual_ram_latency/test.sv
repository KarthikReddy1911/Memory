////////////////////////////////////////////////////////////////////
// 
//      Test Class Definition
//
//      File Name         : 	test.sv
//
//      Design version    : 	0.2
//      
//      Description: 
//
//      This class defines the test environment for the dual-port RAM.
//      It includes the environment instantiation and a run task to 
//      execute the test environment and wait for completion.
// 
////////////////////////////////////////////////////////////////////

`ifndef TEST_SV
`define TEST_SV
`include "environment.sv"

class test;
  local environment     env;
  virtual mem_intf      mem_vif_a, mem_vif_b;

  function new(virtual mem_intf mem_vif_a, virtual mem_intf mem_vif_b);
    this.mem_vif_a = mem_vif_a;
    this.mem_vif_b = mem_vif_b;
    env = new(mem_vif_a, mem_vif_b);
  endfunction

 extern task run();

endclass:test

task test::run();
  env.build();
  env.connect();
  env.run();
  wait(2*no_of_transaction == total_transaction);
  #50 ;
  $finish;            
endtask:run
`endif //TEST_SV
