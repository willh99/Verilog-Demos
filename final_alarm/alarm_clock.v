`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:43:29 04/09/2016 
// Design Name: 
// Module Name:    alarm_clock 
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
module alarm_clock(
    output [6:0] sseg,			//Seven seg display
    output [3:0] dgt,			//AN/dgt select
	 output reg pm,				//PM light LED0
	 output reg alarm,			//Alarm light on LED1
    input [3:0] bcd,				//
	 input [3:0] load,			//Load value from btns
	 input sel24,					
	 input [1:0] alarmsel,		//Select alarm
	 input clock
    );

	wire [6:0] sseg1;
	wire [3:0] disp;
 	reg [17:0] prescaler;
	reg [1:0] state;
	reg [3:0] time24 [3:0];
	reg [3:0] alarm1_24 [3:0];
	reg [3:0] alarm2_24 [3:0];
	reg [3:0] time12 [3:0];
	reg [3:0] alarm1_12 [3:0];
	reg [3:0] alarm2_12 [3:0];
	reg [7:0] scan;
	reg [7:0] tick;
	reg [5:0] sec;
	reg [5:0] min;

	bcd2sseg M1 (sseg1,disp);			
	dgt_decode M2 (dgt,state);
	mux3 M3 (disp, time24[state], time12[state], alarm1_24[state], alarm1_12[state], alarm2_24[state], alarm2_12[state], bcd[3:2], sel24);
//	format24 M4 (tout, pm, time24[3], time24[2], time24[1], time24[0], state, sel24);
// scanning frequency = 500 Hz
// prescaler = 100000	

				
	always @(posedge clock)
	   begin
		   prescaler = prescaler + 1;
			if (prescaler>100000) update_scan;
			
			if(alarmsel[0] && {time24[3], time24[2], time24[1], time24[0]}=={alarm1_24[3], alarm1_24[2], alarm1_24[1], alarm1_24[0]}) alarm = 1;
			else alarm = 0;
			
			if(alarmsel[1] && {time24[3], time24[2], time24[1], time24[0]}=={alarm2_24[3], alarm2_24[2], alarm2_24[1], alarm2_24[0]}) alarm = 1;
			else alarm = 0;
			
			//Convert 24 to 12 hour time
			time12[0]<=time24[0];
			time12[1]<=time24[1];
			{time12[3],time12[2]} <= convalarm(time24[3], time24[2]);
			alarm1_12[0]<=alarm1_24[0];
			alarm1_12[1]<=alarm1_24[1];
			{alarm1_12[3],alarm1_12[2]} <= convalarm(alarm1_24[3], alarm1_24[2]);
			alarm2_12[0]<=alarm2_24[0];
			alarm2_12[1]<=alarm2_24[1];
			{alarm2_12[3],alarm2_12[2]} <= convalarm(alarm2_24[3], alarm2_24[2]);
				
		end
	
	
	always @(bcd[3], bcd[2])
	begin
		case(bcd[3:2])
			0: pm =(time24[3]>=1 && time24[2]>=2) || (time24[3]==2) ? 1:0;
			1: pm =(alarm1_24[3]>=1 && alarm1_24[2]>=2) || (alarm1_24[3]==2) ? 1:0;
			2: pm =(alarm2_24[3]>=1 && alarm2_24[2]>=2) || (alarm2_24[3]==2) ? 1:0;
			default: pm = (time24[3]>=1 && time24[2]>=2) || (time24[3]==2) ? 1:0;
		endcase		
	end
	
	assign sseg = ~sseg1;		

task update_scan;
	begin
		prescaler = 0;
		state = state + 1;
		scan = scan + 1;
		if (scan>100) begin
         scan = 0;
			tick = tick + 1;
			adj_process;

			if (bcd[1:0]==2) update_clock;
		end
		if (tick>5) begin
			tick = 0;
			sec = sec + 1;
			if (bcd[1:0]==1) update_clock;
			if (sec>60) begin
			   sec = 0;
				min = min + 1;
				if (bcd[1:0]==0 || bcd[1:0]==3) update_clock;
				if (min>60) min = 0;
			end
		end
	end
endtask

task update_clock;
	   begin
		   time24[0] = time24[0] + 1;
			if (time24[0]>9) begin
				time24[0] = 0;
				time24[1] = time24[1] + 1;
				if (time24[1]>5) begin
					time24[1] = 0;
					time24[2] = time24[2] + 1;
					if ((time24[2]>9) && (time24[3]<2)) begin
						time24[2] = 0;
						time24[3] = time24[3] + 1;
					end
					else if ((time24[2]>3) && (time24[3]>1)) begin
						time24[2] = 0;
						time24[3] = 0;
					end
				end
		   end
      end
endtask

task inc_min1 (inout reg[3:0] min1, inout reg[3:0] min10, inout reg[3:0] hour1,inout reg[3:0] hour10);	   
   begin
		min1 = min1 + 1;
		if (min1>9) min1 = 0;
	end
endtask

task inc_min10 (inout reg[3:0] min1, inout reg[3:0] min10, inout reg[3:0] hour1,inout reg[3:0] hour10);	   
   begin
		min10 = min10 + 1;
		if (min10>5) min10 = 0;				
	end
endtask

task inc_hour1 (inout reg[3:0] min1, inout reg[3:0] min10, inout reg[3:0] hour1,inout reg[3:0] hour10);	   
   begin
		hour1 = hour1 + 1;
		if (hour1>9 || (hour10==2 && hour1>3))  hour1 = 0;
	end
endtask

task inc_hour10 (inout reg[3:0] min1, inout reg[3:0] min10, inout reg[3:0] hour1,inout reg[3:0] hour10);	   
   begin
		hour10 = hour10 + 1;
		//Prevent improper time from user
		if(hour10==2 && hour1>3) hour1=3;
		if(hour10>2) hour10 = 0;
	end
endtask

task adj_process;
	if (bcd[3:2]==0)
		begin
		   if (load[3]) inc_hour10(time24[0],time24[1],time24[1],time24[3]);
		   if (load[2]) inc_hour1(time24[0],time24[1],time24[1],time24[3]);
		   if (load[1]) inc_min10(time24[0],time24[1],time24[1],time24[3]);
		   if (load[0]) inc_min1(time24[0],time24[1],time24[1],time24[3]);
		end
	else if (bcd[3:2]==1)
		begin
		   if (load[3]) inc_hour10(alarm1_24[0],alarm1_24[1],alarm1_24[2],alarm1_24[3]);
		   if (load[2]) inc_hour1(alarm1_24[0],alarm1_24[1],alarm1_24[2],alarm1_24[3]);
		   if (load[1]) inc_min10(alarm1_24[0],alarm1_24[1],alarm1_24[2],alarm1_24[3]);
		   if (load[0]) inc_min1(alarm1_24[0],alarm1_24[1],alarm1_24[2],alarm1_24[3]);
		end		
	else if (bcd[3:2]==2)
		begin
		   if (load[3]) inc_hour10(alarm2_24[0],alarm2_24[1],alarm2_24[2],alarm2_24[3]);
		   if (load[2]) inc_hour1(alarm2_24[0],alarm2_24[1],alarm2_24[2],alarm2_24[3]);
		   if (load[1]) inc_min10(alarm2_24[0],alarm2_24[1],alarm2_24[2],alarm2_24[3]);
		   if (load[0]) inc_min1(alarm2_24[0],alarm2_24[1],alarm2_24[2],alarm2_24[3]);
		end
	else
		begin
			if (load[3]) inc_hour10(time24[0],time24[1],time24[1],time24[3]);
		   if (load[2]) inc_hour1(time24[0],time24[1],time24[1],time24[3]);
		   if (load[1]) inc_min10(time24[0],time24[1],time24[1],time24[3]);
		   if (load[0]) inc_min1(time24[0],time24[1],time24[1],time24[3]);
		end
endtask

function [7:0] convalarm(input [3:0] hr10, input [3:0] hr1);
	begin
		case({hr10, hr1})
		8'h00: convalarm = 8'h12;
		8'h01: convalarm = 8'h01;
		8'h02: convalarm = 8'h02;
		8'h03: convalarm = 8'h03;
		8'h04: convalarm = 8'h04;
		8'h05: convalarm = 8'h05;
		8'h06: convalarm = 8'h06;
		8'h07: convalarm = 8'h07;
		8'h08: convalarm = 8'h08;
		8'h09: convalarm = 8'h09;
		8'h10: convalarm = 8'h10;
		8'h11: convalarm = 8'h11;
		8'h12: convalarm = 8'h12;
		8'h13: convalarm = 8'h01;
		8'h14: convalarm = 8'h02;
		8'h15: convalarm = 8'h03;
		8'h16: convalarm = 8'h04;
		8'h17: convalarm = 8'h05;
		8'h18: convalarm = 8'h06;
		8'h19: convalarm = 8'h07;
		8'h20: convalarm = 8'h08;
		8'h21: convalarm = 8'h09;
		8'h22: convalarm = 8'h10;
		8'h23: convalarm = 8'h11;
		8'h24: convalarm = 8'h12;
		default: convalarm = {hr10, hr1};
		endcase
	end
endfunction

endmodule

