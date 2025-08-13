module SPI_P_MASTER #(
parameter CLK_DIV,
parameter DATA_BITS
)(
input logic clk,
input logic reset,

input logic start,
input logic miso,
input logic [DATA_BITS-1:0]data_out,

output logic busy,
output logic done,
output logic mosi,
output logic [DATA_BITS-1:0]data_in,

output logic sclk,
output logic cs,
output logic [3:0]div_counter);

logic state;
parameter IDLE=0,TRANS=1;

logic [3:0]data_counter;

//????

localparam DIV=CLK_DIV/2;

always_ff @(posedge clk or posedge reset)
begin

if(reset)
begin
div_counter<=0;
sclk<=0;
end

else if(busy)
begin

if(div_counter==DIV-1)
begin
sclk<=~sclk;
div_counter<=0;
end

else
begin
div_counter<=div_counter+1;
end

end

end

always_ff @(posedge clk or posedge reset)
begin

if(reset)
begin
busy<=0;
done<=0;
cs<=0;
data_counter<=0;
state<=IDLE;
end

else
begin

if(state==IDLE)
begin

done<=0;
data_counter<=0;

if(start)
begin
state<=TRANS;
busy<=1;
cs<=1;
mosi<=data_out[data_counter];
end

else
begin
state<=IDLE;
busy<=0;
cs<=0;
mosi<=0;
end

end

end

end

always_ff @(negedge sclk or posedge reset)
begin

if(reset)
begin
mosi<=0;
end

else if(state==TRANS)
begin
mosi<=data_out[data_counter];
end

end

always_ff @(posedge sclk or posedge reset)
begin

if(reset)
begin
data_in<=0;
end

else if(state==TRANS)
begin

data_in[data_counter]<=miso;

if(data_counter==DATA_BITS-1)
begin
state<=IDLE;
busy<=0;
done<=1;
data_counter<=0;
cs<=0;
sclk<=0;
end

else
begin
data_counter<=data_counter+1;
end

end

end

endmodule

