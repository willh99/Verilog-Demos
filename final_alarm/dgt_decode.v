`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:23:19 04/18/2017 
// Design Name: 
// Module Name:    dgt_decode 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module dgt_decode(
	output reg [3:0] dgt,
	input [1:0] state);

	always @(state)
		case (state)
			 0: dgt <= 4'b1110;	    
			 1: dgt <= 4'b1101;	    
			 2: dgt <= 4'b1011;	    
			 3: dgt <= 4'b0111;
		endcase

endmodule
