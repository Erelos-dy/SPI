module SPI_P_TOP #(
parameter CLK_DIV,
parameter DATA_BITS
)(
input logic clk,
input logic reset,
output logic sclk,

input logic start,
input logic [DATA_BITS-1:0]master_out,
output logic busy,
output logic done,
output logic [DATA_BITS-1:0]master_in,

input logic [DATA_BITS-1:0]slave_out,
output logic [DATA_BITS-1:0]slave_in);

logic cs;
logic mosi;
logic miso;
logic [3:0]div_counter;

SPI_P_MASTER #(
.CLK_DIV(CLK_DIV),
.DATA_BITS(DATA_BITS)
)instance0
(.clk(clk), .reset(reset), .start(start), .miso(miso), .data_out(master_out), .busy(busy), .done(done), .mosi(mosi), .data_in(master_in), .sclk(sclk), .cs(cs), .div_counter(div_counter));

SPI_P_SLAVE #(
.DATA_BITS(DATA_BITS)
)instance1
(.clk(clk), .sclk(sclk), .reset(reset), .div_counter(div_counter), .cs(cs), .mosi(mosi), .data_out(slave_out), .miso(miso), .data_in(slave_in));

endmodule
