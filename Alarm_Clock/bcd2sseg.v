`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:45:40 02/21/2016 
// Design Name: 
// Module Name:    bcd2sseg 
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
// SW3-0: B4, K3, L3, P11
// a-g,dp: L14, H12, N14, N11, P12, L13, M12, N13
// dgt3-0: F12, J12, M13, K12
//////////////////////////////////////////////////////////////////////////////////
module bcd2sseg(
    output reg[6:0] sseg,
    input [3:0] bcd
    );

	always @(bcd)
	case (bcd)
	// x: a b c d e f g
	0: sseg = 7'b1111110;
	1: sseg = 7'b0110000;
	2: sseg = 7'b1101101;	
	3: sseg = 7'b1111001;
	4: sseg = 7'b0110011;
	5: sseg = 7'b1011011;
	6: sseg = 7'b1011111;
	7: sseg = 7'b1110000;
	8: sseg = 7'b1111111;
	9: sseg = 7'b1111011;
	10: sseg = 7'b1110111;  // a
	11: sseg = 7'b0011111;  // b
	12: sseg = 7'b0001101;  // c
	13: sseg = 7'b0111101;  // d
	14: sseg = 7'b1001111;  // e	
	15: sseg = 7'b1000111;  // f
	default: sseg = 7'b0000000;
	endcase

endmodule
