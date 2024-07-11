// ** Module declaration with parameters **
module DualPortRam #(
  parameter integer DATA_WIDTH = 8,  // Width of data output (default 8 bits)
  parameter integer ADDRESS_WIDTH = 3  // Width of address input (default 3 bits)
) (
  // ** Port A signals **
  input  clk_a,  // Clock signal for Port A
  input  en_a,    // Enable signal for Port A
  input  we_a,    // Write enable signal for Port A
  input  [ADDRESS_WIDTH-1:0] addr_a,  // Address input for Port A
  input  [DATA_WIDTH-1:0] din_a,   // Data input for Port A
  output logic [DATA_WIDTH-1:0] dout_a, // Data output for Port A

  // ** Port B signals **
  input  clk_b,  // Clock signal for Port B
  input  en_b,    // Enable signal for Port B
  input  we_b,    // Write enable signal for Port B
  input  [ADDRESS_WIDTH-1:0] addr_b,  // Address input for Port B
  input  [DATA_WIDTH-1:0] din_b,   // Data input for Port B
  output logic [DATA_WIDTH-1:0] dout_b  // Data output for Port B
);

  // ** Internal memory array declaration **
  logic [DATA_WIDTH-1:0] mem [0:2**ADDRESS_WIDTH-1];  // Memory array with size based on address width

  // ** Concurrent port operations **
  always_ff @(posedge clk_a) begin
    if (en_a && we_a) begin  // Write operation for Port A
      mem[addr_a] <= din_a;  // Write data to memory at address addr_a
    end else if (en_a) begin   // Read operation for Port A
      dout_a <= mem[addr_a];  // Read data from memory at address addr_a
    end
  end

  always_ff @(posedge clk_b) begin
    if (en_b && we_b) begin  // Write operation for Port B
      mem[addr_b] <= din_b;  // Write data to memory at address addr_b
    end else if (en_b) begin   // Read operation for Port B
      dout_b <= mem[addr_b];  // Read data from memory at address addr_b
    end
  end
endmodule
