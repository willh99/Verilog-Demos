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
	input [3:0] inp0, inp01, inp1, inp11, inp2, inp21,
	input [1:0] sel, input sel24);
	
	always @ (*)
	begin
	   if (sel==0 || sel==3)
	      outp = (sel24==1)? inp0:inp01;
		else if (sel==1)
	      outp = (sel24==1)? inp01:inp11;		
		else if (sel==2)	      
		   outp =(sel24==1)? inp2:inp21;
	end
endmodule
