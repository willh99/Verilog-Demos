`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:49:46 03/06/2017
// Design Name:   mp_counter
// Module Name:   C:/Users/student/Desktop/Xilinx Programs/mp_counter/mp_counter_tb.v
// Project Name:  mp_counter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mp_counter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mp_counter_tb;

	// Inputs
	reg CLK;
	reg EN;
	reg RST;
	reg STYLE;

	// Outputs
	wire [6:0] DISP;
	wire [3:0] AN;
	wire [3:0] ONES;
	wire [3:0] TENS;

	// Instantiate the Unit Under Test (UUT)
	mp_counter uut (
		.CLK(CLK), 
		.EN(EN), 
		.RST(RST), 
		.STYLE(STYLE), 
		.DISP(DISP), 
		.AN(AN), 
		.ONES(ONES), 
		.TENS(TENS)
	);

	initial begin
		// Initialize Inputs
		CLK = 0;
		EN = 0;
		RST = 0;
		STYLE = 0;

		// Wait 20 ns for global reset to finish
		#20;
        
		// Add stimulus here
		#1 RST = 1;
		#2 RST = 0;
		
		#1 STYLE = 1;
		#1 EN = 1;
		
		#30 RST = 1;
		#2  EN = 0;
		#2 RST = 0;
		
		#1 STYLE = 0;
		#1 EN = 1;
		#30 $finish;

	end
      
	always begin
			#1 CLK=~CLK;
	end
		
endmodule

