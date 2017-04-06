module vending_machine(nickel,dime,EN,quarter,RST,dispense,collect,amount,clk,inserted,next_inserted);
input RST,EN;	//reset, enable
input clk;
input nickel,dime,quarter;
output dispense,collect;	//sell the drink, change
reg dispense,collect;
output [3:0] amount;	//	(inserted/5)
output [6:0] inserted;	// the value inserted
output [6:0] next_inserted;	// the possible nest inserted value
reg [3:0] amount;
reg [6:0] inserted;
reg [6:0] next_inserted;

/////////////////////////////////////////////////////////////////
// state (inserted) register logic
always @ (posedge clk or posedge RST)
	begin
		if (RST)
		begin
			inserted<=7'd0;
		end
		else
			inserted <= next_inserted;	// update the state(inserted) for every clock cycle
	end

////////////////////////////////////////////////////////////////
// next state (next_inserted) logic
always @ (nickel or dime or quarter or EN or RST) // next state control
	begin	
		if(RST)
			next_inserted=0;
		else if(EN) 
			begin
			next_inserted=inserted;	// keep staying at the self-loop
				case(inserted)
					7'd0: begin
							//amount=0;
							if(nickel) // make a decision for the next state depends on different input
							  next_inserted=7'd5;
							if(dime) 
							  next_inserted=7'd10;
							if(quarter)
							  next_inserted=7'd25;
						end

					7'd5: begin
							//amount=1;
							if(nickel)
							  next_inserted=7'd10;
							if(dime) 
							  next_inserted=7'd15;		
							if(quarter) 
							  next_inserted=7'd30;				
						end
						
					7'd10: begin
							//amount=2;
							if(nickel) 
							  next_inserted=7'd15;			
							if(dime)
							  next_inserted=7'd20;			
							if(quarter)
							  next_inserted=7'd35;			
						end

					7'd15: begin
							//amount=3;
							if(nickel) 
							  next_inserted=7'd20;			
							if(dime) 
							  next_inserted=7'd25;			
							if(quarter) 
							  next_inserted=7'd40;			
						end
						
					7'd20: begin
							//amount=4;
							if(nickel) 
							  next_inserted=7'd25;		
							if(dime) 
							  next_inserted=7'd30;	
							if(quarter) 
							  next_inserted=7'd45;
						end

					7'd25: begin
							if(nickel) 
							  next_inserted=7'd30;		
							if(dime) 
							  next_inserted=7'd35;
							if(quarter) 
							  next_inserted=7'd50;
						end
						
					7'd30: begin
							//amount=6;
							if(nickel) 
							  next_inserted=7'd35;			
							if(dime) 
							  next_inserted=7'd40;		
							if(quarter) 
							  next_inserted=7'd55;
						end

					7'd35: begin
						//	amount=7;
							if(nickel) 
							  next_inserted=7'd40;	
							if(dime) 
							  next_inserted=7'd45;
							if(quarter) 
							  next_inserted=7'd60;
						end

					7'd40: begin
						//	amount=8;
							if(nickel) 
							  next_inserted=7'd45;		
							if(dime) 
							  next_inserted=7'd50;	
							if(quarter) 
							  next_inserted=7'd65;
						end

					7'd45: begin
							//amount=9;
							if(nickel) 
							  next_inserted=7'd50;			
							if(dime) 
							  next_inserted=7'd55;			
							if(quarter) 
							  next_inserted=7'd70;
						end
						
					7'd50: begin
							next_inserted=7'd50;
						end

					7'd55: begin
							next_inserted=7'd55;
						end
						
					7'd60: begin
							next_inserted=7'd60;
						end
						
					7'd65: begin
							next_inserted=7'd65;
						end
						
					7'd70: begin
							next_inserted=7'd70;
						end
						
					default:
						next_inserted=inserted;
				endcase
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
endmodule


