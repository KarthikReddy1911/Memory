//`include "environment.sv"
import pkg::*;
class test;
      environment env;
      virtual mem_intf mem_vif;

      function new(virtual mem_intf mem_vif);
	this.mem_vif = mem_vif;
      endfunction

      task run;
	env = new(mem_vif);
	env.run;
      endtask
endclass
