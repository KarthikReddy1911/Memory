`include "interface.sv"
import pkg::*;

module tb_top;

  //creatinng instance of interface, inorder to connect DUT and testcase
  test       t1;
  bit        clk_a,clk_b;
  mem_intf   intf_a(clk_a);
  mem_intf   intf_b(clk_b);

  always #5  clk_a = ~clk_a;
  always #5  clk_b = ~clk_b;

   
  
    
 
  
  //DUT instance, interface signals are connected to the DUT ports
 DualPortRam #(8,3) DUT (
	    .clk_a(intf_a.clk),
	    .en_a(intf_a.en),
	    .we_a(intf_a.we),
	    .addr_a(intf_a.addr),
	    .din_a(intf_a.din),
	    .dout_a(intf_a.dout),
	    .clk_b(intf_b.clk),
	    .en_b(intf_b.en),
	    .we_b(intf_b.we),
	    .addr_b(intf_b.addr),
	    .din_b(intf_b.din),
	    .dout_b(intf_b.dout)
   );
  
  initial begin 
  //Testcase instance, interface handle is passed to test as an argument
    t1=new(intf_a,intf_b); 
    t1.run;
    #200 $finish; 
  end

endmodule
