import pkg::*;
class generator;
  
  transaction trans;

  int  repeat_count;
  mailbox mbx_gen2driv;
    
  //constructor
  function new(mailbox mbx_gen2driv);
    this.mbx_gen2driv = mbx_gen2driv;
  endfunction
  

  task run();  
    fork    
      repeat(50) begin
      trans = new();  
      trans.randomize() with {trans.en==1;};
      mbx_gen2driv.put(trans);
      trans.display("[GEN - DRIV] MBX PUT",trans);      
      end
    join_none
  endtask
endclass
