`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:07:59 02/09/2017
// Design Name:   Full_Adder
// Module Name:   C:/Users/student/Desktop/Xilinx Programs/Lab1/full_adder_b.v
// Project Name:  Lab1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Full_Adder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module full_adder_b;

	// Inputs
	reg A;
	reg B;
	reg C_in;

	// Outputs
	wire Sum;
	wire C_out;

	// Instantiate the Unit Under Test (UUT)
	Full_Adder uut (
		.A(A), 
		.B(B), 
		.C_in(C_in), 
		.Sum(Sum), 
		.C_out(C_out)
	);

	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;
		C_in = 0;
		// Wait 0 ns for global reset to finish
		#0;
		
		// Add stimulus here
		#2;A = 0; B = 0; C_in = 0;
		#2;A = 0; B = 0; C_in = 1;
		#2;A = 0; B = 1; C_in = 0;
		#2;A = 0; B = 1; C_in = 1;
		#2;A = 1; B = 0; C_in = 0;
		#2;A = 1; B = 0; C_in = 1;
		#2;A = 1; B = 1; C_in = 0;
		#2;A = 1; B = 1; C_in = 1;
		#2; $finish; 

	end
      
endmodule

