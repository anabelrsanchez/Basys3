module BCD (input LOAD, input clk, input CLEAR, input ENABLE, input UP, input [3:0] D,
        	output reg CO, output reg [3:0] counter);

always @(posedge clk or negedge CLEAR) begin
	if (LOAD & ENABLE) begin
    		counter <= D;
    		CO <= 0;
	end
		else if (ENABLE & UP) begin
    		CO <= counter == 4'b1001 ? 1'b1 : CO;
    		counter <= counter == 4'b1001 ? 4'b0000 : counter + 1;
	end
	else if (ENABLE & ~UP) begin
    		CO <= counter == 4'b1001 ? 1'b0 : CO;
    		counter <= counter == 4'b0000 ? 4'b1001 : counter - 1;
	end
	else if (CLEAR) begin
		Counter <= 4’b0000;
	end
	else begin
    		counter <= counter;
	end
end
endmodule
