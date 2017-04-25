`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:57:12 04/16/2016 
// Design Name: 
// Module Name:    mux3 
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
module mux3(
   output reg [3:0] outp,
	input [3:0] inp0, inp1, inp2,
	input [1:0] sel);
	
	always @ (*)
	   if (sel==0)
	      assign outp = inp0;
		else if (sel==1)
	      assign outp = inp1;		
		else if (sel==2)	      
		   assign outp = inp2;

endmodule
