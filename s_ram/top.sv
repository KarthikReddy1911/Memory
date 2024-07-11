`include "interface.sv"
import pkg::*;

module tb_top;

  //creatinng instance of interface, inorder to connect DUT and testcase
  test       t1;
  bit        clk;
  mem_intf   intf(clk);

  always #5  clk = ~clk;

   
  
    
 
  
  //DUT instance, interface signals are connected to the DUT ports
 SinglePortRAM #(8,3) DUT (
	    .clk(intf.clk),
	    .en(intf.en),
	    .we(intf.we),
	    .addr(intf.addr),
	    .din(intf.din),
	    .dout(intf.dout)
   );
  
  initial begin 
  //Testcase instance, interface handle is passed to test as an argument
    t1=new(intf); 
    t1.run;
    #500 $finish; 
  end
endmodule
