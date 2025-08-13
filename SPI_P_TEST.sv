module tb_SPI;

parameter CLK_DIV=8;
parameter DATA_BITS=8;

logic clk;
logic sclk;
logic reset;
logic start;
logic [DATA_BITS-1:0] master_out;
logic [DATA_BITS-1:0] slave_out;
logic busy;
logic done;
logic [DATA_BITS-1:0] master_in;
logic [DATA_BITS-1:0] slave_in;

SPI_P_TOP #(
.CLK_DIV(CLK_DIV),
.DATA_BITS(DATA_BITS)
)uut(
.clk(clk),
.sclk(sclk),
.reset(reset),
.start(start),
.master_out(master_out),
.busy(busy),
.done(done),
.master_in(master_in),
.slave_out(slave_out),
.slave_in(slave_in));

task send_byte(input logic [DATA_BITS-1:0]master_data,slave_data);
begin
start=1;
master_out=master_data;
slave_out=slave_data;
#20
start=0;
@(negedge busy);
end
endtask

initial
begin
clk=0;
forever #5 clk=~clk;
end

initial
begin
reset=1;
start=0;
#10
reset=0;
start=1;
master_out=8'ha5;
slave_out=8'h77;
#10
start=0;
@(negedge busy);
send_byte(8'ha1,8'h76);
send_byte(8'ha3,8'h46);
$stop;
end

endmodule

