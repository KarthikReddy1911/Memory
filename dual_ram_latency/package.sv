////////////////////////////////////////////////////////////////////
// 
//      Package Definition for SystemVerilog Environment
//
//       File Name           :    pkg.sv
//
//       Design version      :    0.2
//
//      -------- Parameters and Constants -------------
//
//       DATA_WIDTH          =     Width of data input/output
//       ADDRESS_WIDTH       =     Width of address input
//       READ_LATENCY        =     Array of read latencies for ports A and B
//       WRITE_LATENCY       =     Array of write latencies for ports A and B
//       no_of_transaction   =     Number of transactions for testing
//
//      -------- Enumerated Type -------------
//
//      state_t              =     Enumeration to perform WRITE, READ and IDLE operations
//
//      -------- Static Variables -------------
//
//      read_operations      =     Number of read operations performed
//      write_operations     =     Number of write operations performed
//      idle_operations      =     Number of idle operations
//      test_cases_passed    =     Number of test cases passed
//      test_cases_failed    =     Number of test cases failed
//      total_transaction    =     Total number of transactions executed
//
//      -------- Included Files -------------
//
//      transaction.sv       =     Transaction class definition
//      generator.sv         =     Generator class definition
//      driver.sv            =     Driver class definition
//      reference_model.sv   =     Reference model class definition
//      monitor.sv           =     Monitor class definition
//      scoreboard.sv        =     Scoreboard class definition
//      environment.sv       =     Environment class definition
//
//
//      Description: 
//
//      This package defines parameters, constants, an enumerated type,
//      and static variables for a SystemVerilog environment. It also
//      includes definitions for various classes used in the environment.
//
////////////////////////////////////////////////////////////////////

`ifndef PACKAGE_SV
`define PACKAGE_SV
package pkg;

  parameter int DATA_WIDTH         = 8;       // Specifies the width of data    in bits
  parameter int ADDRESS_WIDTH      = 3;       // Specifies the width of address in bits
  parameter int READ_LATENCY[0:1]  = {2,3};   // Read  latency in clock cycles for port A & B
  parameter int WRITE_LATENCY[0:1] = {3,4};   // Write latency in clock cycles for port A & B
  parameter int TP_A               = 5;
  parameter int TP_B               = 7;

  int           no_of_transaction  = 200;

  static int read_operations       = 0;
  static int write_operations      = 0;
  static int idle_operations       = 0;

  static int test_cases_passed 	   = 0;
  static int test_cases_failed     = 0;
  static int total_transaction     = 0;



  typedef enum  {WRITE, READ, IDLE} state_t;

  // Static variables for reporting 
  `include "transaction.sv"
  `include "generator.sv"
  `include "driver.sv"
  `include "reference_model.sv"
  `include "monitor.sv"

endpackage:pkg
`endif //PACKAGE_SV
