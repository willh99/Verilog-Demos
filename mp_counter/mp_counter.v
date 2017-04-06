`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:03:26 03/06/2017 
// Design Name: 
// Module Name:    mp_counter 
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
module mp_counter (CLK, EN, RST, STYLE, DISP, AN, ONES, TENS);

	input CLK;
	input EN;
	input RST;
	input STYLE;
	
	output [3:0] ONES;
	output [3:0] TENS;
	
	output [6:0] DISP;
	output [3:0] AN;

	
	counter cnt(ONES, TENS, CLK,EN,RST,STYLE);
	display disp(DISP, AN, CLK, ONES, TENS);

endmodule


module counter(ONES, TENS, CLK,EN,RST,STYLE);
	
	input CLK;
	input EN;
	input RST;
	input STYLE;
	
	reg[25:0] CLKCNTR;
	
	output reg [3:0] ONES;
	output reg [3:0] TENS;

	always @ (posedge CLK)
	begin

		if (RST)
		begin
			ONES <=4'b0000;
	      TENS <=4'b0000;
			CLKCNTR <= 0;
			
		end

		else if (EN)
		begin
			CLKCNTR <= CLKCNTR+1;

			if (CLKCNTR==50000000)
			begin
			   CLKCNTR <= 0;
				if (STYLE)
				begin
					if (ONES==9)
					begin
						ONES <= 0;
						if(TENS == 5)
						   TENS <= 0;
						else
						   TENS <= TENS + 1;
					end
					else 
					 begin
					    ONES <= ONES + 1;
					 end
					
				end

				else if (!STYLE)
				begin
					if (ONES>0)
						ONES <= ONES-1;
					else
					begin
						ONES <= 9;
						if (TENS>0)
							TENS <= TENS-1;
						else
							TENS <= 5;
					end
				end
			end
		end
	end
endmodule


module display(DISP, AN, CLK, ONES, TENS);

	input [3:0] ONES;
	input [3:0] TENS;
	input CLK;
	
	output [3:0] AN;
	output [6:0] DISP;
	
	reg [6:0] DISP;
	reg [3:0] AN= 4'b1101;
	reg [17:0] DISPCNTR;

	always @ (posedge CLK)
	begin
		DISPCNTR<=DISPCNTR+1;

		if (DISPCNTR==250000)
		begin

			DISPCNTR<=0;
			AN[1]<=~AN[1];
			AN[0]<=~AN[0];
			AN[2]<=1;
			AN[3]<=1;			

			if (AN[1])
			begin

				case (TENS)
					0: DISP=7'b1000000;
					1: DISP=7'b1111001;
					2: DISP=7'b0100100;
					3: DISP=7'b0110000;
					4: DISP=7'b0011001;
					5: DISP=7'b0010010;
					6: DISP=7'b0000010;
					7: DISP=7'b1111000;
					8: DISP=7'b0000000;
					9: DISP=7'b0010000;
					default: DISP=7'b1111111;
				endcase
			end

			else if (AN[0])
			begin
				
				//Add codes here
				case (ONES)
					0: DISP=7'b1000000;
					1: DISP=7'b1111001;
					2: DISP=7'b0100100;
					3: DISP=7'b0110000;
					4: DISP=7'b0011001;
					5: DISP=7'b0010010;
					6: DISP=7'b0000010;
					7: DISP=7'b1111000;
					8: DISP=7'b0000000;
					9: DISP=7'b0010000;
					default: DISP=7'b1111111;
				endcase
			end
		end
	end
endmodule
