`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:48:41 04/20/2017 
// Design Name: 
// Module Name:    VGA_Control 
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
module VGA_Control(
	input clk50, 
	output [2:0] rout,
	output [2:0] gout,
	output [1:0] bout,
	output hsync,
	output vsync
	);
	
	
	reg clk25_int = 0;
	always@(posedge clk50)
	begin
		clk25_int <= ~clk25_int;
	end
	wire clk25;
	BUFG bufg_inst(clk25, clk25_int);
	//http://www.xilinx.com/support/documentation/sw_manuals/xilinx11/sse_p_instantiating_clock_buffer.htm

	wire [9:0] xpos;
	wire [9:0] ypos;
	wire [2:0] red;
	wire [2:0] green;
	wire [1:0] blue;

	videosyncs videosyncs_inst(clk25, red, green, blue, rout, gout, bout, hsync, vsync, xpos, ypos);
	game game_inst(xpos, ypos, red, green, blue, clk50);

endmodule

///////////////////////////////////////////////////////////////////////////////
module videosyncs (
   input wire clk,

   input wire [2:0] rin,
   input wire [2:0] gin,
   input wire [1:0] bin,

   output reg [2:0] rout,
   output reg [2:0] gout,
   output reg [1:0] bout,

   output reg hs,
   output reg vs,

   output wire [10:0] hc,
   output wire [10:0] vc
   );

	// VGA 640x480@60Hz,25MHz
	parameter htotal = 800;			// total counts on x direction
   parameter vtotal = 521;			// total counts on y direction
   parameter hactive = 640;		// active area on x direction
   parameter vactive = 480;		// active area on y direction
   parameter hfrontporch = 16;	// front porch on x direction
   parameter hsyncpulse = 96;		// sync pulse on x direction
   parameter vfrontporch = 10;	// front porch on y direction
   parameter vsyncpulse = 2;		// sync pulse on y direction
   parameter hsyncpolarity = 0;	// polarity of pulse on x direction
   parameter vsyncpolarity = 0;	// polarity of pulse on y direction
   reg [9:0] hcont = 0;
   reg [9:0] vcont = 0;
   reg active_area;

	assign hc = hcont;
   assign vc = vcont;

   always @(posedge clk) 
	begin
      if (hcont == htotal-1) 
		begin
         // Add codes here
			hcont=0;
         if (vcont == vtotal-1) 
			begin
            // Add codes here
				vcont=0;
         end
         else 
			begin
            // Add codes here
				vcont=vcont+1;
         end
      end
      else 
		begin
         // Add codes here
			hcont=hcont+1;
      end
   end

   always @* 
	begin
      if (hcont<=hactive && vcont<=vactive)
         active_area = 1'b1;
      else
         active_area = 1'b0;
      if (hcont>=(hactive+hfrontporch) && hcont<=(hactive+hfrontporch+hsyncpulse))
         hs = hsyncpolarity;
      else
         hs = ~hsyncpolarity;
      if (vcont>=(vactive+vfrontporch) && vcont<=(vactive+vfrontporch+vsyncpulse))
         vs = vsyncpolarity;
      else
         vs = ~vsyncpolarity;
    end

   always @* 
	begin
      if (active_area) 
		begin
         gout = gin;
         rout = rin;
         bout = bin;
      end
      else 
		begin
         gout = 3'b0;
         rout = 3'b0;
         bout = 2'b0;
      end
   end
endmodule   


/////////////////////////////////////////////////////////////////////////////
module game(xpos, ypos, red, green, blue, clk);
	input [9:0] xpos;
	input [9:0] ypos;
	input clk;

	output reg [2:0] red;
	output reg [2:0] green;
	output reg [1:0] blue;
	reg [4:0] temp;

	reg [26:0] CNTR;
	reg [7:0] color;

	always @(posedge clk)
	begin

		CNTR = CNTR+1;
		
		if(CNTR == 50000000)
		begin
			CNTR=0;
			color = (color+1)%128;
		end
		
		if(CNTR < 50000000)
		begin
		
			if(color < 256)
				green[0] = 1;
			else
				green[0] = 0;

			temp[0] = ((ypos>203+color && ypos <=206+color) && (xpos>=105+color&&xpos<=145+color ||
							xpos>=150+color && xpos<=190+color || xpos>=195+color && xpos<=235+color));
			
			temp[1] = ((ypos>207+color && ypos <=221+color) && (xpos>=105+color&&xpos<=108+color || 
							xpos>=150+color && xpos<=153+color || xpos>=195+color && xpos<=198+color));
			
			temp[2] = ((ypos>222+color && ypos <=225+color) && (xpos>=105+color && xpos<=142+color || 
							xpos>=150+color && xpos<=153+color || xpos>=195+color && xpos<=235+color));
			
			temp[3] = ((ypos>226+color && ypos <=241+color) && (xpos>=105+color && xpos<=108+color || 
							xpos>=150+color && xpos<=153+color || xpos>=195+color && xpos<=198+color));
			
			temp[4] = ((ypos>242+color && ypos <=245+color) && (xpos>=105+color && xpos<=145+color || 
							xpos>=150+color && xpos<=190+color || xpos>=195+color && xpos<=235+color));
		
			red[1] = temp[0]|temp[1]|temp[2]|temp[3]|temp[4];
			blue[0] = (red[1]|color)?0:1;
		end

	end
endmodule
