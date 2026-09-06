module tb_BCD;
reg [3:0] D;
reg LOAD;
reg ENABLE;
reg UP;
wire [3:0] counter;
wire CO;
reg CLEAR;
reg clk;

BCD DUT (.LOAD(LOAD), .CLEAR(CLEAR), .ENABLE(ENABLE), .UP(UP), .counter(counter),
     	.CO(CO), .D(D), .clk(clk));

always #5 clk = ~clk;
	 
initial begin
clk = 1;
CLEAR = 1;
D = 4'b0101;
LOAD = 1;
ENABLE = 1;
UP = 0;
@(posedge clk) UP=1; LOAD = 0;
@(posedge clk) UP=1;
@(posedge clk) UP=1;
@(posedge clk) UP=1;
@(posedge clk) UP=0;
@(posedge clk);
end
endmodule
