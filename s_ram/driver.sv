import pkg::*;
class driver;
  

    virtual mem_intf mem_vif;

    mailbox mbx_gen2driv;
   
    transaction trans;

    function new(virtual mem_intf mem_vif,mailbox mbx_gen2driv);
      this.mem_vif      = mem_vif; 
      this.mbx_gen2driv = mbx_gen2driv;
    endfunction

  
  //drivers the transaction items to interface signals
  task run();
    fork
       forever @(mem_vif.driver_cb) begin
         trans = new();
         mbx_gen2driv.get(trans);
         trans.display("[GEN - DRIV] MBX GET ",trans); 
         mem_vif.addr  <= trans.addr;
         mem_vif.we    <= trans.we;
         mem_vif.din   <= trans.din;
         mem_vif.en    <= trans.en; 
       end
    join_none
  endtask
endclass
