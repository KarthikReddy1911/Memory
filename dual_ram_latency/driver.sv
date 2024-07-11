////////////////////////////////////////////////////////////////////
// 
//      Driver Class for Driving Transactions to Interface
//
//      File Name          : 	driver.sv
//
//      Design version     : 	0.2
//
//      -------- Parameters declared in the Class -------------
//
//       mem_vif           = 	Virtual interface for memory
//       gen               = 	Generator instance
//       data2dut          = 	Transaction object
//
//      -------- Tasks declared in the Class -------------
//
//      run               = 	Task to run the driver and generate transactions
//      drive             = 	Task to drive transaction items to interface signals
//
//      Description: 
//
//      This class defines a driver used to drive transactions to
//      interface signals in a SystemVerilog environment. It includes
//      a virtual memory interface, a generator instance, and a transaction
//      object. The driver class has tasks to run the driver and to drive
//      transaction items to the interface signals.
// 
////////////////////////////////////////////////////////////////////

`ifndef DRIVER_SV
`define DRIVER_SV
import pkg::*;

class driver;
  virtual              mem_intf mem_vif;
  generator            gen;
  local transaction    data2dut;
  
  extern  task run();

  extern local task drive(input transaction data2dut);

endclass:driver

task driver::run();
  fork
    begin
      for(int i = 0; i < no_of_transaction; i++) begin
        gen.gen_pkt(data2dut);
        drive(data2dut);
      end
    end
  join_none
endtask:run


task driver::drive(input transaction data2dut);
  mem_vif.driver_cb.i_addr <= data2dut.addr;
  mem_vif.driver_cb.i_din  <= data2dut.din;

  if(data2dut.op == WRITE) begin
    mem_vif.driver_cb.i_we <= 1;
    mem_vif.driver_cb.i_en <= 1;
    write_operations++; 
  end 

  else if (data2dut.op == READ) begin
    mem_vif.driver_cb.i_we <= 0;
    mem_vif.driver_cb.i_en <= 1;
    read_operations++;
  end

  else if (data2dut.op == IDLE) begin
    mem_vif.driver_cb.i_we <= 0;
    mem_vif.driver_cb.i_en <= 0; 
    idle_operations++;
  end
  @(mem_vif.driver_cb);
endtask:drive
`endif //DRIVER_SV

