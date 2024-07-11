////////////////////////////////////////////////////////////////////
// 
//      Environment Class for Dual Port RAM
//
//      File Name         : 	envirnoment.sv
//
//      Design version    : 	0.2
//
//      -------- Parameters nad Mailboxes declared in the Class -------------
//
//       mem_vif_a        = 	Virtual interface for memory signals for port A
//       mem_vif_b        = 	Virtual interface for memory signals for port B
//       mbx_mon2scb_a    = 	Mailbox for communication from monitor A to scoreboard A
//       mbx_mon2ref_a    = 	Mailbox for communication from monitor A to reference model A
//       mbx_mon2scb_b    = 	Mailbox for communication from monitor B to scoreboard B
//       mbx_mon2ref_b    = 	Mailbox for communication from monitor B to reference model B
//       mbx_ref2scb_a    = 	Mailbox for communication from reference model A to scoreboard A
//       mbx_ref2scb_b    = 	Mailbox for communication from reference model B to scoreboard B
//       gen              = 	Generator object
//       driv_a           = 	Driver object for port A
//       driv_b           = 	Driver object for port B
//       mon_a            = 	Monitor object for port A
//       mon_b            = 	Monitor object for port B
//       scb_a            = 	Scoreboard object for port A
//       scb_b            = 	Scoreboard object for port B
//       ref_a            = 	Reference model object for port A
//       ref_b            = 	Reference model object for port B
//
//      -------- Tasks declared in the Class -------------
//
//      run               = 	Task to run the environment components
//
//      Description: 
//
//      This class defines the environment for a dual-port RAM testbench. It includes
//      generators, drivers, monitors, scoreboards, and reference models for both ports
//      of the RAM. The class sets up communication mailboxes between the components
//      and provides a task to run all the components.
// 
////////////////////////////////////////////////////////////////////

`ifndef ENVIRONMENT
`define ENVIRONMENT
import pkg::*;
`include "scoreboard.sv"


class environment;
  local generator         gen;
  local driver            driv_a, driv_b;
  local monitor           mon_a, mon_b;
  local scoreboard        scb_a, scb_b;
  local reference_model   ref_a, ref_b; 

  mailbox                 mbx_mon2scb_a, mbx_mon2ref_a; 
  mailbox                 mbx_mon2scb_b, mbx_mon2ref_b; 
  mailbox                 mbx_ref2scb_a, mbx_ref2scb_b;

  virtual                 mem_intf mem_vif_a, mem_vif_b;

  function new(virtual mem_intf mem_vif_a, virtual mem_intf mem_vif_b);
    this.mem_vif_a = mem_vif_a; 
    this.mem_vif_b = mem_vif_b; 
  endfunction


  extern task build();

  extern task connect();
  
  extern task run();

endclass:environment
`endif //ENVIRONMENT

task environment::build();
  mbx_mon2scb_a  = new(); 
  mbx_mon2scb_b  = new();
  mbx_mon2ref_a  = new(); 
  mbx_mon2ref_b  = new();
  mbx_ref2scb_a  = new();
  mbx_ref2scb_b  = new();

  gen            = new();

  driv_a         = new();
  driv_b         = new();

  mon_a          = new();
  mon_b          = new();

  scb_a          = new();
  scb_b          = new();

  ref_a          = new();
  ref_b          = new();

endtask:build

task environment::connect();

  driv_a.mem_vif    = mem_vif_a;
  driv_a.gen        = gen;
    
  driv_b.mem_vif    = mem_vif_b;
  driv_b.gen        = gen;

  mon_a.i           = 0;
  mon_b.i           = 1;

  mon_a.mem_vif     = mem_vif_a;
  mon_a.mbx_mon2scb = mbx_mon2scb_a;
  mon_a.mbx_mon2ref = mbx_mon2ref_a;

  mon_b.mem_vif     = mem_vif_b;
  mon_b.mbx_mon2scb = mbx_mon2scb_b;
  mon_b.mbx_mon2ref = mbx_mon2ref_b;
     
  scb_a.mbx_mon2scb = mbx_mon2scb_a;
  scb_a.mbx_ref2scb = mbx_ref2scb_a;

  scb_b.mbx_mon2scb = mbx_mon2scb_b;
  scb_b.mbx_ref2scb = mbx_ref2scb_b;

  ref_a.mbx_mon2ref = mbx_mon2ref_a;
  ref_a.mbx_ref2scb = mbx_ref2scb_a;

  ref_b.mbx_mon2ref = mbx_mon2ref_b;
  ref_b.mbx_ref2scb = mbx_ref2scb_b;

endtask:connect

task environment::run();
  driv_a.run();
  driv_b.run();
  mon_a.run();
  mon_b.run();
  ref_a.run();
  ref_b.run();  
  scb_a.run();  
  scb_b.run(); 
endtask:run

