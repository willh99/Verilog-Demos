`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:16:45 03/09/2017 
// Design Name: 
// Module Name:    twoway_code 
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
module twoway_code(EN, STYLE, CODEin, CODEout, FLAG);

	input EN;
	input STYLE;
	input [3:0] CODEin;
	output reg [3:0] CODEout;
	output FLAG;
	
	wire [3:0] ENCout;
	wire [3:0] DECout;
	
	enc4to2 encode(ENCout, FLAG, CODEin, EN);
	dec2to4 decode(DECout, CODEin, EN);
	
	always @ (EN)
		if(STYLE)
			CODEout = DECout;
		else
			CODEout = ENCout;

endmodule

module enc4to2 (ENCout, FLAG, ENCin, EN);

	// Declaration of the input-output
	input [3:0] ENCin;
	input EN;

	output reg [1:0] ENCout;
	output FLAG;
	
	assign FLAG = ENCin >= 1 ? 1 : 0;

	always @ (ENCin)
	begin
		if(EN==0)
			casex(ENCin)
				4'b1xxx: ENCout=3;
				4'b01xx: ENCout=2;
				4'b001x: ENCout=1;
				4'b0001: ENCout=0;
				default: begin
					ENCout=2'bxx;
				end
			endcase
		else
			ENCout = 0;
	end

endmodule

module dec2to4 (DECout, DECin, EN);

	// declarations of inputs, outputs, & registers;
	input [1:0] DECin;
	input EN;
	integer i=0;

	output reg [3:0] DECout;

  always @ (DECin or EN)
	  begin
		 for(i=0; i<=3; i=i+1)
			if((DECin==i) && (EN))
			  DECout[i]=1;
			else
			  DECout[i]=0;
		end

endmodule

