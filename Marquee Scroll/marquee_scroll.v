`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:10:06 04/06/2017 
// Design Name: 
// Module Name:    marquee_scroll 
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
module marquee_scroll (CLK,EN,RST,STYLE,Speed,DISP,AN,LEDs);
		input CLK;
		input Speed;
		input EN;
		input RST;
		input STYLE;
		output AN;
		wire[3:0] AN;
		reg [25:0] CLKCNTR;
		reg [25:0] SPEED_COUNTER;
		output [6:0] DISP;
		output LEDs;
		reg [7:0] LEDs;

		reg[55:0] Words;
		wire [27:0] selected_words;		
		assign selected_words = Words[55:28];

	  //every one or half second (speed) scroll the marquee
		always@(posedge CLK)
		begin
			if(RST)
			begin
				Words = {		 
					// set your words here
					// Word is "PIZZA___" where _ means space
					7'b0001100,
					7'b1111001,
					7'b0100100,
					7'b0100100,
					7'b0001000,
					7'b1111111,
					7'b1111111,
					7'b1111111
					};
					
				CLKCNTR = 0;
				LEDs = 8'b11111000; // set the LEDs here;
			end
			 
			else 
			begin
				CLKCNTR =  CLKCNTR + 1;
				if(CLKCNTR == SPEED_COUNTER)
				begin
					//Trigger whenever clkcntr value equals speed_counter value
					
					CLKCNTR = 0;
					if(EN)
					begin
						if(STYLE)
						begin
							//Move in the backward direction
							Words = {Words[49:0],Words[55:49]}; //Place first word at end of array
							LEDs  = {LEDs[6:0],LEDs[7]};			//Place first LED at end of array
						end
						else
						begin
							//Move in the forward direction
							Words = {Words[6:0],Words[55:7]};	//Place last word at the beginning to the Words array
							LEDs  = {LEDs[0],LEDs[7:1]};			//Place last LED at the beginning of the LED array
						end
					end
				end
			end
		end
		
		always@(Speed)
		begin
			if(Speed == 1'b0)
				SPEED_COUNTER = 50000000; //choose a right number here that scroll speed = 1HZ
			else
				SPEED_COUNTER = 25000000; //choose a right number here that scroll speed = 2HZ
		end
		
	scrolling_display scroll(RST, DISP,CLK, selected_words,AN);
	endmodule

///////////////////////////////////////////////////////////////////
	module scrolling_display (RST,DISP,CLK,selected_words,AN);

		input CLK;
		input RST;
		input [27:0] selected_words;
		output [6:0] DISP;
		output[3:0] AN;
		reg [6:0] DISP;
		reg[3:0] AN;
		reg[3:0] CNTR;
		reg [17:0] DISPCNTR;
		
		wire [6:0] display_separated [3:0];

		assign {display_separated[3],display_separated[2],display_separated[1],display_separated[0]} = selected_words;
		
		always @ (posedge CLK)
		begin
			if(RST)
			begin
				CNTR = 4'b0001;
				DISP= 7'b1111111;
			end
			  
			else 
			begin
				//Multiplex every 250000/50000000 = 5ms
				
				DISPCNTR = DISPCNTR+1;
				if(DISPCNTR == 250000)
				begin
					DISPCNTR=0;
					
					//Shift active display over by one
					//Reset in order to wrap around 
					if(CNTR==4'b0001) 
						CNTR=4'b1000;
					else
						CNTR = CNTR>>1;
						
					AN=~CNTR;
					
					case (CNTR)
						//2D array storing the values for the 4 7-seg displays depending of CNTR value
						4'b1000: DISP=display_separated [0];
						4'b0100: DISP=display_separated [1];
						4'b0010: DISP=display_separated [2];
						4'b0001: DISP=display_separated [3];			
						default: DISP=7'b1111111;
					endcase
				end
			end
		end
	endmodule

