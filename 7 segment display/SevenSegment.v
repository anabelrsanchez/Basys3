module SevenSegment(input [3:0] sw, output reg [6:0] out,
                	output [3:0] an);
              	 
assign an = 4'b1110; // right segment on
wire rst = 1'b0;

always @(*) begin
	if (~rst) begin
    	case (sw)
        	4'b0000: out <= 7'b0000001;//1111110; // 0
        	4'b0001: out <= 7'b1001111;//0110000; // 1
        	4'b0010: out <= 7'b0010010;//1101101; // 2
        	4'b0011: out <= 7'b0000110;//1111001; // 3
        	4'b0100: out <= 7'b1001100;//0110011; // 4
        	4'b0101: out <= 7'b0100100;//1011011; // 5
        	4'b0110: out <= 7'b0100000;//1011111; // 6
        	4'b0111: out <= 7'b0001111;//1110000; // 7
        	4'b1000: out <= 7'b0000000;//1111111; // 8
        	4'b1001: out <= 7'b0000100;//1111011; // 9
        	default: out <= 7'b1001111; // default is E (for error)
    	endcase
	end
	else begin
    	out <= 7'b1111111; // off
	end
end
endmodule
