import pkg::*;
class environment;
  
  
  generator      gen;
  driver         driv;
  monitor        mon;
  scoreboard     scb;
  refernce_model rm; 
  
  mailbox        mbx_gen2driv;
  mailbox        mbx_mon2scb; 
  mailbox        mbx_mon2ref; 
  mailbox        mbx_ref2scb;
  
  
  virtual mem_intf mem_vif;
  

  function new(virtual mem_intf mem_vif);
    this.mem_vif = mem_vif; 
   

    mbx_gen2driv = new();
    mbx_mon2scb  = new(); 
    mbx_mon2ref  = new(); 
    mbx_ref2scb  = new();
 
    gen = new(mbx_gen2driv);

    driv = new(mem_vif,mbx_gen2driv);

    mon  = new(mem_vif,mbx_mon2scb,mbx_mon2ref);

    scb   = new(mbx_mon2scb,mbx_ref2scb);

    rm   = new(mbx_mon2ref,mbx_ref2scb);
  endfunction

  
  task run();
    //fork
	gen.run();
	driv.run();
	mon.run();
	rm.run();
 	scb.run();  
   // join_any    
  endtask  
endclass
