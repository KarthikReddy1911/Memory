import pkg::*;
class scoreboard;
   
  mailbox mbx_mon2scb,mbx_ref2scb;
  
  transaction trans;
  transaction ref_trans;


  function new(mailbox mbx_mon2scb,mailbox mbx_ref2scb); 
    this.mbx_mon2scb = mbx_mon2scb;  
    this.mbx_ref2scb = mbx_ref2scb;
  endfunction
  

  task run(); 
   fork 
    forever begin
      ref_trans=new();
      trans=new();

      mbx_mon2scb.get(trans);
      trans.display("[MON-SCB] MBX GET",trans); 

      mbx_ref2scb.get(ref_trans);
      ref_trans.display("[REF-SCB] MBX GET",ref_trans); 

      if(ref_trans.dout === trans.dout)
         $display("Data Matched dout = %h,ref_dout =%h",trans.dout,ref_trans.dout);
      else 
         $display("Data not Matched dout = %h,ref_dout =%h",trans.dout,ref_trans.dout);
    end 
  join_none
 endtask  
endclass
