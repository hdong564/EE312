`timescale 1ns / 100ps

module ALU(A,B,OP,C,Cout);

	input [15:0]A;
	input [15:0]B;
	input [3:0]OP;
	output [15:0]C;
	output Cout;

	//TODO
	reg reg_Cout;
	reg [15:0]reg_C;
	wire msbA;
	wire msbB;
	assign C = reg_C;
	assign Cout = reg_Cout;
	assign msbA = A[15];
	assign msbB = B[15];
	always @ (*) begin
		case (OP)
			4'b0000: //A+B
				begin
					reg_C = A+B;
					if((msbA == 1'b0)&(msbB == 1'b0)&(reg_C[15] == 1'b1)) begin
						reg_Cout = 1'b1;
					end
					if((msbA == 1'b1)&(msbB == 1'b1)&(reg_C[15] == 1'b0))begin
						reg_Cout = 1'b1;
					end
					else begin
						reg_Cout = 1'b0;
					end
				end
			4'b0001: //A-B
				begin
					reg_C = A-B;
					if((msbA == 1'b0)&(msbB == 1'b1)&(reg_C[15] == 1'b1)) begin
						reg_Cout = 1'b1;
					end
					if((msbA == 1'b1)&(msbB == 1'b0)&(reg_C[15] == 1'b0))begin
						reg_Cout = 1'b1;
					end
					else begin
						reg_Cout = 1'b0;
					end
				end
			4'b0010: // A and B
				begin
					reg_C= A&B;
					reg_Cout = 1'b0;
				end
			4'b0011: // A or B
				begin
					reg_C= A|B;
					reg_Cout = 1'b0;
				end
			4'b0100: // A nand B
				begin
					reg_C= ~(A&B);
					reg_Cout = 1'b0;
				end
			4'b0101: // A nor B
				begin
					reg_C= ~(A|B);
					reg_Cout = 1'b0;
				end
 			4'b0110: // A xor B
			 	begin
					reg_C = A^B;
					reg_Cout = 1'b0;
				end
			4'b0111: // A xnor B
				begin
					reg_C = ~(A^B);
					reg_Cout = 1'b0;
				end
			4'b1000: // identity
				begin
					reg_C = A;
					reg_Cout = 1'b0;
				end
			4'b1001: // ~A not
				begin
					reg_C = ~A;
					reg_Cout = 1'b0;
				end
			4'b1010: // A >> 1 logical
				begin
					reg_C = {1'b0, A[15:1]};
					reg_Cout = 1'b0;
				end
			4'b1011: // A >>> 1 arithmetic
				begin
					reg_C = {A[15], A[15:1]};
					reg_Cout = 1'b0;
				end
			4'b1100: // rotate right
				begin
					reg_C = {A[0], A[15:1]};
					reg_Cout = 1'b0;
				end
			4'b1101: // A << 1 
				begin
					reg_C = {A[14:0], 1'b0};
					reg_Cout = 1'b0;
				end
			4'b1110: // A <<< 1
				begin
					reg_C = {A[14:0], A[0]};
					reg_Cout = 1'b0;
				end
			4'b1111: // rotate left
				begin
					reg_C = {A[14:0], A[15]};
					reg_Cout = 1'b0;
				end
		endcase
	end

endmodule
