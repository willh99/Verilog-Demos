module vending_machine(nickel, dime, EN, quarter, RST, dispense, collect, amount, clk, inserted, next_inserted, DISP, AN);
	input RST,EN;	//reset, enable
	input clk;
	input nickel,dime,quarter;
	output dispense,collect;	//sell the drink, change
	reg dispense,collect;
	output [3:0] amount;	//(inserted / 5)
	output [6:0] inserted;	// the value inserted
	output [6:0] next_inserted;	// the possible nest inserted value
	reg [3:0] amount;
	reg [6:0] inserted;
	reg [6:0] next_inserted;
	reg 	previous_quarter,previous_dime,previous_nickle;
	output reg [6:0] DISP;
	output reg [3:0] AN = 4'b1010;
	reg [15:0] CLKCNTR;

/////////////////////////////////////////////////////////////////
// state (inserted) register logic
	always @ (posedge clk or posedge RST)
		begin
			if (RST)
			begin
				previous_dime<=0;
				previous_nickle<=0;
				previous_quarter<=0;		
				inserted<=7'd0;
			end
			else
				begin
					inserted <= next_inserted;	// update the state(inserted) for every clock cycle
					previous_dime<=dime;
					previous_nickle<=nickel;
					previous_quarter<=quarter;
				end
		end

	////////////////////////////////////////////////////////////////
	// next state (next_inserted) logic
	always @ (nickel or dime or quarter or EN or RST or inserted or previous_dime or previous_nickle or previous_quarter) // next state control
		begin	
			if(RST)
				begin
					next_inserted=0;
				end
			else if(EN )		
						begin
						
							next_inserted=inserted;	// keep staying at the self-loop
							if(previous_dime==0 && dime==1)
								next_inserted=inserted+7'd10;
							if(previous_nickle==0&& nickel==1)
								next_inserted=inserted+7'd5;
							if(previous_quarter==0&& quarter==1)
								next_inserted=inserted+7'd25;
								
						end
				
			else
				next_inserted=inserted;
	end

	////////////////////////////////////////////////////////////////
	// output logic
	always @ (inserted or RST)
	begin
		if (RST)
			begin
	//			if (amount!=0)
	//				begin
	//					collect = 1;
	//					#5000000 collect = 0; 
	//				end
				collect=0;
				amount=4'd0;
				dispense=0;
				
			end
		else
		begin
			case(inserted)
				7'd0: begin
							  amount = 4'd0;
							  dispense = 0;
							  collect = 0;
						end

					7'd5: begin
							  amount = 4'd1;
							  dispense = 0;
							  collect = 0;
						end
						
					7'd10: begin
							  amount = 4'd2;
							  dispense = 0;
							  collect = 0;
						end

					7'd15: begin
							  amount = 4'd3;
							  dispense = 0;
							  collect = 0;
						end
						
					7'd20: begin
							  amount = 4'd4;
							  dispense = 0;
							  collect = 0;
						end

					7'd25: begin
							  amount = 4'd5;
							  dispense = 0;
							  collect = 0;
						end
						
					7'd30: begin
							  amount = 4'd6;
							  dispense = 0;
							  collect = 0;
						end

					7'd35: begin
							  amount = 4'd7;
							  dispense = 0;
							  collect = 0;
						end

					7'd40: begin
							  amount = 4'd8;
							  dispense = 0;
							  collect = 0;
						end

					7'd45: begin
							  amount = 4'd9;
							  dispense = 0;
							  collect = 0;
						end
						
					7'd50: begin
							dispense=1;
							collect=0;	
							amount = 4'd0;					
						end

					7'd55: begin
							dispense=1;
							collect=1;
							amount = 4'd1;
						end
						
					7'd60: begin
							dispense=1;
							collect=1;
							amount = 4'd2;
						end
					
					7'd65: begin
							dispense=1;
							collect=1;
							amount = 4'd3;
						end
						
					7'd70: begin
							dispense=1;
							collect=1;
							amount = 4'd4;
						end
					default:
					begin
							dispense=0;
							collect=0;
							amount = 0;
					end
			endcase
		end
	end

always @ (posedge clk)
	begin
		CLKCNTR=CLKCNTR+1;
		if (CLKCNTR>=16'b1100001101010000)
		begin
			CLKCNTR=0;
		
			AN[0]=~AN[0];
			AN[1]=~AN[1];
			AN[2]=1;
			AN[3]=1;
		
			if(AN[1])
			begin	
				case(amount)
					0,1: DISP = 7'b1000000;
					2,3: DISP = 7'b1111001;
					4,5: DISP = 7'b0100100;
					6,7: DISP = 7'b0110000;
					8,9: DISP = 7'b0011001;
					default: AN=4'b1111;
				endcase
			end

			else if (AN[0])
			begin
				if(amount%2==0)
					DISP=7'b1000000;
				else
					DISP=7'b0010010;
			end
			else
				DISP = 7'b1000000;
		
		end
	end
endmodule
	