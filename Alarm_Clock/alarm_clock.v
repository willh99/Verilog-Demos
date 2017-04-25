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
    output [6:0] sseg,
    output [3:0] dgt,
    output pm,
    input [3:0] bcd,
    input [3:0] load,
    input sel24,
    input clock
    );

	wire [6:0] sseg1;
	wire [3:0] disp;
 	reg [17:0] prescaler;
	reg [1:0] state;
	reg [3:0] time24 [3:0];
	reg [3:0] alarm1 [3:0];
	reg [3:0] alarm2 [3:0];
	reg [7:0] scan;
	reg [7:0] tick;
	reg [5:0] sec;
	reg [5:0] min;

	bcd2sseg M1 (sseg1,disp);			
	dgt_decode M2 (dgt,state);
	mux3 M3 (disp, time24[state], alarm1[state], alarm2[state], bcd[3:2]);
//	format24 M4 (tout, pm, time24[3], time24[2], time24[1], time24[0], state, sel24);
// scanning frequency = 500 Hz
// prescaler = 100000	

				
	always @(posedge clock)
	   begin
		prescaler = prescaler + 1;
			if (prescaler>100000) 
				update_scan;
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
				if (bcd[1:0]==0) update_clock;
				if (min>60)
				   min = 0;
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

task inc_min1 (inout reg [3:0] min1);	   
   begin
	min1 = min1 + 1;
	if (min1>9) min1 = 0;
    end
endtask

task inc_min10 (inout reg [3:0] min10);	   
   begin
	min10 = min10 + 1;
	if (min10>5) min10 = 0;				
    end
endtask

task inc_hour1 (inout reg [3:0] hour1);	   
   begin
	hour1 = hour1 + 1;
	if (hour1>9)  hour1 = 0;
   end
endtask

task inc_hour10 (inout reg [3:0] hour10);	   
   begin
	hour10 = hour10 + 1;
	if (hour10>2) hour10 = 0;
   end
endtask

task adj_process;
	if (bcd[3:2]==0)
	begin
		if (load[3]) inc_hour10(time24[3]);
		if (load[2]) inc_hour1(time24[2]);
		if (load[1]) inc_min10(time24[1]);
		if (load[0]) inc_min1(time24[0]);
	end
	else if (bcd[3:2]==1)
	begin
		if (load[3]) inc_hour10(alarm1[3]);
		if (load[2]) inc_hour1(alarm1[2]);
		if (load[1]) inc_min10(alarm1[1]);
		if (load[0]) inc_min1(alarm1[0]);
	end		
	else if (bcd[3:2]==2)
	begin
		if (load[3]) inc_hour10(alarm2[3]);
		if (load[2]) inc_hour1(alarm2[2]);
		if (load[1]) inc_min10(alarm2[1]);
		if (load[0]) inc_min1(alarm2[0]);
	end				
endtask

endmodule
