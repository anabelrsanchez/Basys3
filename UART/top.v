module top(
	input clk,
	input rst,
	input rx, 	 
	output tx 	 
);
	wire [7:0] received_data;  
	wire clk_9600;        	 
	wire data_ready;      	 
	wire data_transmitted;    

	// UART Receiver
	UART_receive uart_rx (
    	.clk(clk),
    	.rst(rst),
    	.data_in(rx),
    	.data_transmitted(data_transmitted),
    	.data_out(received_data),
    	.data_ready(data_ready),
    	.clk_9600(clk_9600)
	);

	// UART Transmitter
	UART_transmit uart_tx (
    	.clk(clk),
    	.rst(rst),
    	.data_in(received_data),
    	.data_ready(data_ready),
    	.data_out(tx),
    	.data_transmitted(data_transmitted)
	);
endmodule
