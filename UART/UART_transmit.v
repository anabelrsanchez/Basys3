module UART_transmit(
	input clk,
	input rst,
	input [7:0] data_in,
	input data_ready,
	output reg data_out,
	output reg data_transmitted
);
localparam IDLE  = 2'b00;
localparam START = 2'b01;
localparam DATA  = 2'b10;
localparam STOP  = 2'b11;

reg [1:0] state = IDLE;
reg [13:0] counter = 0;
reg [3:0] bit_counter = 0;
reg [9:0] shift_reg = 10'b1111111111;
reg clk_9600 = 0;

always @(posedge clk or posedge rst) begin
	if (rst) begin
    	counter <= 0;
    	clk_9600 <= 0;
	end else begin
    	if (counter == 10_416 - 1) begin
        	counter <= 0;
        	clk_9600 <= 1;
    	end else begin
        	counter <= counter + 1;
        	clk_9600 <= 0;
    	end
	end
end

always @(posedge clk or posedge rst) begin
	if (rst) begin
    	state <= IDLE;
    	data_out <= 1'b1;
    	data_transmitted <= 0;
	end else if (clk_9600) begin
    	data_transmitted <= 0;
   	 
    	case (state)
        	IDLE: begin
            	data_out <= 1'b1; // Keep TX line HIGH when idle
            	if (data_ready) begin
                	shift_reg <= {1'b1, data_in, 1'b0}; // Stop bit (1), data, Start bit (0)
                	state <= START;
                	bit_counter <= 0;
                	data_transmitted <= 0; // Reset transmission flag
            	end
        	end
       	 
        	START: begin
            	data_out <= shift_reg[0];
            	state <= DATA;
        	end
       	 
        	DATA: begin
            	data_out <= shift_reg[bit_counter + 1];
            	if (bit_counter == 7) begin
                	state <= STOP;
            	end else begin
                	bit_counter <= bit_counter + 1;
            	end
        	end
       	 
        	STOP: begin
            	data_out <= 1;
            	state <= IDLE;
            	data_transmitted <= 1; // Signal that transmission is complete
        	end
    	endcase
	end
end
endmodule
