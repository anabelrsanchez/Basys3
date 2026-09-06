module UART_receive(
	input clk,
	input rst,
	input data_in,
	input data_transmitted,
	output reg [7:0] data_out,
	output reg data_ready,
	output reg clk_9600
);

localparam IDLE  = 2'b00;
localparam START = 2'b01;
localparam DATA  = 2'b10;
localparam STOP  = 2'b11;

reg [13:0] counter = 0;
reg [3:0] bit_counter = 0;
reg [7:0] shift_reg = 0;
reg [1:0] state = IDLE;
reg reset_counter = 0;

 
always @(posedge clk or posedge rst) begin
	if (rst || reset_counter) begin
    	counter <= 0;
    	clk_9600 <= 0;
	end else begin
    	if (counter == 10_416 - 1) begin
        	clk_9600 <= 1;
        	counter <= 0;
    	end else begin
        	counter <= counter + 1;
        	clk_9600 <= 0;
    	end
	end
end

always @(posedge clk or posedge rst) begin
	if (rst) begin
    	state <= IDLE;
    	bit_counter <= 0;
    	shift_reg <= 0;
    	data_out <= 0;
    	reset_counter <= 0;
    	data_ready <= 0;
	end else begin
    	if (data_transmitted) begin
        	data_ready <= 0;
    	end

    	case (state)
        	IDLE: begin
            	if (data_in == 0) begin
                	state <= START;
                	reset_counter <= 1;  
            	end else begin
                	reset_counter <= 0;
            	end
        	end
       	 
        	START: begin
            	reset_counter <= 0;
            	if (counter == (10_416 / 2)) begin
                	if (data_in == 0) begin
                    	reset_counter <= 1;  
                    	state <= DATA;
                    	bit_counter <= 0;
                	end else begin
                    	state <= IDLE;
                	end
            	end
        	end
       	 
        	DATA: begin
            	reset_counter <= 0;
            	if (counter == 10_415) begin
                	shift_reg[bit_counter] <= data_in;
                	if (bit_counter == 7) begin
                    	state <= STOP;
                	end else begin
                    	bit_counter <= bit_counter + 1;
                	end
            	end
        	end
       	 
       	STOP: begin
            	reset_counter <= 0;
            	if (counter == 10_415) begin
                	if (data_in == 1) begin
                    	data_out <= shift_reg;
                    	data_ready <= 1; // ready to be sent
                	end
                	state <= IDLE;
            	end
        	end

    	endcase
	end
end
endmodule
