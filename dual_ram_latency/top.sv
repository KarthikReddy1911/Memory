////////////////////////////////////////////////////////////////////
// 
//      Top Testbench Module for Dual-Port RAM Latency Testing
//
//      File Name         : 	tb_top.sv
//
//      Design version    : 	0.2
//
//      -------- Parameters and Ports -------------
//
//       DATA_WIDTH       =     Width of data input/output
//       ADDRESS_WIDTH    =     Width of address input
//       READ_LATENCY     =     Array of read latencies for ports A and B
//       WRITE_LATENCY    =     Array of write latencies for ports A and B
//
//      -------- Description -------------
//
//      This module serves as the top-level testbench for testing
//      the DualPortRamLatency module. It instantiates the DUT and
//      the test class, connects interface signals to the DUT ports,
//      and runs the testbench.
//
////////////////////////////////////////////////////////////////////

`include "test.sv"

module tb_top;

  //creatinng instance of interface, inorder to connect DUT and testcase
  test          t1;
  bit           clk_a,clk_b;
  mem_intf      intf_a(clk_a,0);
  mem_intf      intf_b(clk_b,1);

  always #TP_A  clk_a = ~clk_a;
  always #TP_B  clk_b = ~clk_b;
  
  //DUT instance, interface signals are connected to the DUT ports
  DualPortRamLatency #(
                       .DATA_WIDTH(DATA_WIDTH),
                       .ADDRESS_WIDTH(ADDRESS_WIDTH),
                       .READ_LATENCY_A(READ_LATENCY[0]),
                       .WRITE_LATENCY_A(WRITE_LATENCY[0]),
                       .READ_LATENCY_B(READ_LATENCY[1]),
                       .WRITE_LATENCY_B(WRITE_LATENCY[1])
                      )
                  DUT (
	               .clk_a(intf_a.i_clk),
	               .en_a(intf_a.i_en),
	               .we_a(intf_a.i_we),
	               .addr_a(intf_a.i_addr),
	               .din_a(intf_a.i_din),
	               .dout_a(intf_a.o_dout),
	               .clk_b(intf_b.i_clk),
	               .en_b(intf_b.i_en),
	               .we_b(intf_b.i_we),
	               .addr_b(intf_b.i_addr),
	               .din_b(intf_b.i_din),
	               .dout_b(intf_b.o_dout)
                      );
  
  initial begin 
  //Testcase instance, interface handle is passed to test as an argument
    t1=new(intf_a,intf_b); 
    t1.run();
    //#2000 $finish; 
  end
 
  final begin
    $display("Report:");
    $display("Total Transactions : %0d",total_transaction);
    $display("Read Operations    : %0d",read_operations);
    $display("Write Operations   : %0d",write_operations);
    $display("Idle Operations    : %0d",idle_operations);
    $display("Test Cases Passed  : %0d",test_cases_passed);
    $display("Test Cases Failed  : %0d",test_cases_failed);
  end

endmodule:tb_top
