module SevSeg(input clk, output reg [6:0] out, output [3:0] an);
               	 
reg [26:0] counter = 0;
reg [3:0] D = 4'hF; // start at displaying F
reg clk_1s = 0;	 
wire rst = 0;
assign an = 4'b1110; // right segment on

always@(posedge clk) begin
	if (rst) begin
    	counter <= 0;
	end
	else begin
    	if (counter == 99_999_999) begin
        	counter <= 0;
        	clk_1s <= ~clk_1s;
    	end
    	else begin
        	counter <= counter + 1;
    	end
	end
end

always @(posedge clk_1s) begin
	D <= (D == 4'h0) ? 4'hF : D - 1;
end

always @(*) begin
	if (~rst) begin
    	case (D)
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
        	4'b1010: out <= 7'b0001000;//1110111; // A
        	4'b1011: out <= 7'b1100000;//0011111; // b
        	4'b1100: out <= 7'b0110001;//1001110; // C
        	4'b1101: out <= 7'b1000010;//0111101; // d
        	4'b1110: out <= 7'b0110000;//1001111; // E
        	4'b1111: out <= 7'b0111000;//1000111; // F
        	default: out <= 7'b1111111; // default is off
    	endcase
	end
	else begin
    	out <= 7'b1111111; // off
	end
end
endmodule
