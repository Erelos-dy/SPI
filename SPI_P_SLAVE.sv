module SPI_P_SLAVE #(
parameter DATA_BITS
)(
input logic clk,
input logic sclk,
input logic reset,
input logic [3:0]div_counter,

input logic cs,
input logic mosi,
input logic [DATA_BITS-1:0]data_out,

output logic miso,
output logic [DATA_BITS-1:0]data_in);

logic [3:0]data_counter;

always_ff @(posedge cs or posedge reset)
begin

if(reset)
begin
data_counter<=0;
end

else
begin
data_counter<=0;
miso<=data_out[data_counter];
end

end

always_ff @(negedge cs)
begin
data_counter<=0;
end

always_ff @(negedge sclk or posedge reset)
begin

if(reset)
begin
miso<=0;
end

else if(cs)
begin
miso<=data_out[data_counter];
end

end

always_ff @(posedge sclk or posedge reset)
begin

if(reset)
begin
data_in<=0;
end

else if(cs)
begin
data_in[data_counter]<=mosi;
data_counter<=data_counter+1;
end

end

endmodule

