`include "vending_machine_def.v"

module vending_machine (

	clk,							// Clock signal
	reset_n,						// Reset signal (active-low)

	i_input_coin,				// coin is inserted.
	i_select_item,				// item is selected.
	i_trigger_return,			// change-return is triggered

	o_available_item,			// Sign of the item availability
	o_output_item,			// Sign of the item withdrawal
	o_return_coin,				// Sign of the coin return
	stopwatch,
	current_total,
	return_temp,
);

	// Ports Declaration
	// Do not modify the module interface
	input clk;
	input reset_n;

	input [`kNumCoins-1:0] i_input_coin;
	input [`kNumItems-1:0] i_select_item;
	input i_trigger_return;

	output reg [`kNumItems-1:0] o_available_item;
	output reg [`kNumItems-1:0] o_output_item;
	output reg [`kNumCoins-1:0] o_return_coin;

	output [3:0] stopwatch;
	output [`kTotalBits-1:0] current_total;
	output [`kTotalBits-1:0] return_temp;
	// Normally, every output is register,
	//   so that it can provide stable value to the outside.

//////////////////////////////////////////////////////////////////////	/

	//we have to return many coins
	reg [`kCoinBits-1:0] returning_coin_0; // 100원
	reg [`kCoinBits-1:0] returning_coin_1; // 500원
	reg [`kCoinBits-1:0] returning_coin_2; // 1000원
	reg block_item_0;
	reg block_item_1;
	//check timeout
	reg [3:0] stopwatch;
	//when return triggered
	reg have_to_return;
	reg  [`kTotalBits-1:0] return_temp;
	reg [`kTotalBits-1:0] temp;
////////////////////////////////////////////////////////////////////////

	// Net constant values (prefix kk & CamelCase)
	// Please refer the wikepedia webpate to know the CamelCase practive of writing.
	// http://en.wikipedia.org/wiki/CamelCase
	// Do not modify the values.
	wire [31:0] kkItemPrice [`kNumItems-1:0];	// Price of each item
	wire [31:0] kkCoinValue [`kNumCoins-1:0];	// Value of each coin
	assign kkItemPrice[0] = 400;
	assign kkItemPrice[1] = 500;
	assign kkItemPrice[2] = 1000;
	assign kkItemPrice[3] = 2000;
	assign kkCoinValue[0] = 100;
	assign kkCoinValue[1] = 500;
	assign kkCoinValue[2] = 1000;


	// NOTE: integer will never be used other than special usages.
	// Only used for loop iteration.
	// You may add more integer variables for loop iteration.
	integer i, j, k,l,m,n,p;

	// Internal states. You may add your own net & reg variables.
	reg [`kTotalBits-1:0] current_total;
	reg [`kItemBits-1:0] num_items [`kNumItems-1:0];
	reg [`kCoinBits-1:0] num_coins [`kNumCoins-1:0];

	// Next internal states. You may add your own net and reg variables.
	reg [`kTotalBits-1:0] current_total_nxt;
	reg [`kItemBits-1:0] num_items_nxt [`kNumItems-1:0];
	reg [`kCoinBits-1:0] num_coins_nxt [`kNumCoins-1:0];

	// Variables. You may add more your own registers.
	reg [`kTotalBits-1:0] input_total, output_total, return_total_0,return_total_1,return_total_2;
	//return_total_n would be next state of returning_coin_n
	/*
	`define kTotalBits 31
	`define kItemBits 8
	`define kNumItems 4
	`define kCoinBits 8
	`define kNumCoins 3
	`define kWaitTime 10
	*/

	// Combinational logic for the next states
	always @(*) begin
		// TODO: current_total_nxt
		// You don't have to worry about concurrent activations in each input vector (or array).
		//check weather there are input coins
		for(i = 0;i<`kNumCoins;i++) begin
			// if there is input coin, increase, total input, number of coins
		
			if(i_input_coin[i] == 1) begin
				input_total = input_total + kkCoinValue[i];
				current_total_nxt = current_total_nxt + input_total;
				num_coins_nxt[i] = num_coins[i] + 1;
			end
		end

		//check weather there are item selection
		for(j = 0;j <`kNumItems;j++) begin
			if(i_select_item[i] ==1) begin
				output_total = output_total + kkItemPrice[i];
				num_items_nxt[i] = num_items[i] -1;
				if(current_total > output_total) begin
					current_total_nxt = current_total_nxt - output_total;
				end
			end
		end

		//check weather we have to return charges(caculate changes)
		if(i_trigger_return == 1) begin
			// todo: calculate 
			have_to_return = 1;
			temp = current_total;
			return_total_0 = temp/`kkCoinValue[2];
			temp = temp - return_total_0*`kkCoinValue[2];
			return_total_1 = temp/`kkCoinValue[1];
			temp = temp - return_total_1*`kkCoinValue[1];
			return_total_2 = temp/`kkCoinValue[0];
			// let return_total_n is next state
		end
		if(returning_total_0 > 0) begin
			return_total_0 = returning_coin_0 -1;
			return_temp = return_temp + `kkCoinValue[0];
			current_total_nxt = current_total_nxt - return_temp;
			num_coins_nxt[0] = num_coins[0]-1;
			o_return_coin[0] = 1'b1;
		end
		else begin
			o_return_coin[0] = 1'b0;
		end
		if(return_total_1 >0) begin
			return_total_1 = returning_coin_1 -1;
			return_temp = return_temp + `kkCoinValue[1];
			num_coins_nxt[1] = num_coins[1]-1;
			current_total_nxt = current_total_nxt - return_temp;
			o_return_coin[1] = 1'b1;
		end
		else begin
			o_return_coin[1] = 1'b0;
		end
		if(return_total_2 >0) begin
			return_total_2 = returning_coin_2 -1;
			return_temp = return_temp + `kkCoinValue[2];
			num_coins_nxt[2] = num_coins[2]-1;
			current_total_nxt = current_total_nxt - return_temp;
			o_return_coin[2] = 1'b1;
		end
		else begin
			o_return_coin[2] = 1'b0;
		end
		// Calculate the next current_total state. current_total_nxt =


	end


	// Combinational logic for the outputs
	always @(*) begin
	// TODO: o_available_item
		for(n = 0; n<`kNumItems; n++) begin
			if(num_items[n]>0)	begin
				if(current_total >= kkItemPrice[n]) begin
					o_available_item[n] = 1'b1;
				end 
				else o_available_item[n]=1'b0;
			end
			else o_available_item[n]=1'b0;
		end
	// TODO: o_output_item
		for(p = 0; p<kNumItems;p++) begin
			if(i_select_item[p]) begin
				if (o_available_item[p]) begin
					o_output_items[p] = 1'b1;
				end
				else o_output_items[p] = 1'b0;
			end
			else o_output_items[p] = 1'b0;
		end

	end

	// Sequential circuit to reset or update the states
	always @(posedge clk) begin
		if (!reset_n) begin
			// TODO: reset all states.
			


		end
		else begin
			// TODO: update all states.
			returning_coin_0 = return_total_0;
			returning_coin_1 = return_total_1;
			returning_coin_2 = return_total_2;
/////////////////////////////////////////////////////////////////////////

			// decreas stopwatch
			stopwatch = stopwatch -1;



			//if you have to return some coins then you have to turn on the bit


/////////////////////////////////////////////////////////////////////////
		end		   //update all state end
	end	   //always end

endmodule