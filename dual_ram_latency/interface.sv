//////////////////////////////////////////////////////////////////////////////////////////////////////////
// 
//      Memory Interface Definition
//
//      File Name         : 	interface.sv
//
//      Design version    : 	0.1
//
//      -------- Parameters declared in the Interface -------------
//
//       i_clk            = 	Clock signal input for DUT
//       i_addr           = 	Address input for DUT
//       i_en             = 	Enable input for DUT
//       i_we             = 	Write enable input for DUT
//       i_din            = 	Data input for DUT
//       o_dout           = 	Data output for DUT
//
//       addr             = 	Address output with latency
//       en               = 	Enable output with latency
//       we               = 	Write enable output  with latency
//       din              = 	Data output with latency
//       i                = 	Integer input to distinguish write latency array for Port A & Port B
//
//      Description: 
//
//      This interface defines the memory interface for a dual-port RAM. 
//      It includes clocking blocks for the driver and monitor, as well as 
//      signal declarations for address, enable, write enable, data input, 
//      and data output signals. The interface also includes a process to 
//      synchronize signals based on write latency.
// 
//////////////////////////////////////////////////////////////////////////////////////////////////////////

`ifndef INTERFACE_SV
`define INTERFACE_SV
import pkg::*;
interface mem_intf(input  i_clk,input int i);
  
  //declaring the signals
  logic [ADDRESS_WIDTH-1:0]   i_addr;
  logic                       i_en;
  logic                       i_we;
  logic [DATA_WIDTH-1:0]      i_din;
  logic [DATA_WIDTH-1:0]      o_dout;
  
  

  logic [ADDRESS_WIDTH-1:0]   addr;
  logic                       en;
  logic                       we;
  logic [DATA_WIDTH-1:0]      din;
 
  //driver clocking block
  clocking driver_cb @(negedge i_clk); 
    default input #1 output #1;  
    output       i_addr;
    output       i_en;
    output       i_we;
    output       i_din;
  endclocking:driver_cb
  
  //monitor clocking block
  clocking monitor_cb @(posedge i_clk);  
    default input #1 output #1;   
    input        i_addr;
    input        i_we;
    input        i_en;
    input        i_din;
    input        o_dout;  
  endclocking:monitor_cb
  
  always@(posedge i_clk) begin 
    {addr,din,en,we} <= repeat(WRITE_LATENCY[i]-1)@(posedge i_clk) {i_addr,i_din,i_en,i_we};
  end
endinterface:mem_intf
`endif //INTERFACE_SV

