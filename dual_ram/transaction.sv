import pkg::*;
class transaction;

  randc logic [2:0]   addr;
  rand  logic         we;
  rand  logic         en;
  randc logic [7:0]   din;
        logic [7:0]   dout;
      

   function void display(input string name,input transaction trans);
     $display("----------------------%s-----------------------",name);
     $display($time,"-------------Addr=%0h,we=%0h,en=%0h,din=%0h,dout=%0h--------------\n",addr,we,en,din,dout);
   endfunction
 
endclass
