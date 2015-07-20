`timescale 1ns/1ps

module Control(PCSrc,RegDst,RegWr,ALUSrc1,ALUSrc2,ALUFun,Sign,
	MemWr,MemRd,MemToReg,EXTOp,LUOp,Instrcution,IRQ);
	output reg	[2:0]PCSrc;
	output reg	[1:0]RegDst;
	output reg	RegWr;
	output reg	ALUSrc1;
	output reg	ALUSrc2;
	output reg	[5:0]ALUFun;
	output reg	Sign;
	output reg	MemWr;
	output reg	MemRd;
	output reg	[1:0]MemToReg;
	output reg	EXTOp;
	output reg	LUOp;
	input	[31:0]Instrcution;
	input	IRQ;

	// branch unfinished

	always@(*)
	begin
		if(IRQ)	//stall
		begin
			PCSrc <= 3'b100;	
			RegDst <= 2'b11;
			RegWr <= 1;
			MemWr <= 0;
			MemRd <= 0;
			MemToReg <= 2'b11;
		end
		else
		begin
			case(Instrcution[31:26])
				6'h23: 	//lw
					begin
						PCSrc <= 3'b000;
						RegDst <= 2'b00;
						RegWr <= 1;
						ALUSrc1 <= 0;
						ALUSrc2 <= 1;
						ALUFun <= 000000;
						Sign <= 1;
						MemWr <= 0;
						MemRd <= 1;
						MemToReg <= 2'b01;
						EXTOp <= 1;
						LUOp <= 0;
					end
				6'h2b:	//sw
					begin
						PCSrc <= 3'b000;
						RegWr <= 0;
						ALUSrc1 <= 0;
						ALUSrc2 <= 1;
						ALUFun <= 000000;
						Sign <= 1;
						MemWr <= 1;
						MemRd <= 0;
						EXTOp <= 1;
						LUOp <= 0;
					end
				6'h0f:
					begin
						case(Instrcution[25:21])
							5'h00:	//lui
								begin
									PCSrc <= 3'b000;
									RegDst <= 2'b00;
									RegWr <= 1;
									ALUSrc1 <= 0;
									ALUSrc2 <= 1;
									ALUFun <= 000000;
									Sign <= 1;
									MemWr <= 0;
									MemRd <= 0;
									MemToReg <= 2'b00;
									LUOp <= 1;
								end
							default:	//XADR
								begin
									PCSrc <= 3'b101;	
									RegDst <= 2'b11;
									RegWr <= 1;
									MemWr <= 0;
									MemRd <= 0;
									MemToReg <= 2'b10;
								end
						endcase
					end
				6'h08:	//addi
					begin
						PCSrc <= 3'b000;
						RegDst <= 2'b00;
						RegWr <= 1;
						ALUSrc1 <= 0;
						ALUSrc2 <= 1;
						ALUFun <= 000000;
						Sign <= 1;
						MemWr <= 0;
						MemRd <= 0;
						MemToReg <= 2'b00;
						EXTOp <= 1;
						LUOp <= 0;
					end
				6'h09:	//addiu
					begin
						PCSrc <= 3'b000;
						RegDst <= 2'b00;
						RegWr <= 1;
						ALUSrc1 <= 0;
						ALUSrc2 <= 1;
						ALUFun <= 000000;
						Sign <= 1;
						MemWr <= 0;
						MemRd <= 0;
						MemToReg <= 2'b00;
						EXTOp <= 1;
						LUOp <= 0;
					end
				6'h0c:	//andi
					begin
						PCSrc <= 3'b000;
						RegDst <= 2'b00;
						RegWr <= 1;
						ALUSrc1 <= 0;
						ALUSrc2 <= 1;
						ALUFun <= 011000;
						Sign <= 0;
						MemWr <= 0;
						MemRd <= 0;
						MemToReg <= 2'b00;
						EXTOp <= 1;
						LUOp <= 0;
					end
				6'h0a: PCSrc <= 3'b000; //slti
					begin
						PCSrc <= 3'b000;
						RegDst <= 2'b00;
						RegWr <= 1;
						ALUSrc1 <= 0;
						ALUSrc2 <= 1;
						ALUFun <= 110101;
						Sign <= 1;
						MemWr <= 0;
						MemRd <= 0;
						MemToReg <= 2'b00;
						EXTOp <= 1;
						LUOp <= 0;
					end
				6'h0b: PCSrc <= 3'b000;	//sltiu
					begin
						PCSrc <= 3'b000;
						RegDst <= 2'b00;
						RegWr <= 1;
						ALUSrc1 <= 0;
						ALUSrc2 <= 1;
						ALUFun <= 110101;
						Sign <= 0;
						MemWr <= 0;
						MemRd <= 0;
						MemToReg <= 2'b00;
						EXTOp <= 0;
						LUOp <= 0;
					end
				6'h02:	//j
					begin
						PCSrc <= 3'b010;
						RegWr <= 0;
						MemWr <= 0;
						MemRd <= 0;
					end
				6'h03:	//jal
					begin
						PCSrc <= 3'b010;
						RegDst <= 2'b10;
						RegWr <= 1;
						MemWr <= 0;
						MemRd <= 0;
						MemToReg <= 2'b10;
					end
				6'h04:	//beq
					begin
						PCSrc <= 3'b001;
						RegWr <= 0;
						ALUFun <= 110011;
						MemWr <= 0;
						MemRd <= 0;
					end
				6'h05: PCSrc <= 3'b001;	//bne
					begin
						PCSrc <= 3'b001;
						RegWr <= 0;
						ALUFun <= 110001;
						MemWr <= 0;
						MemRd <= 0;
					end
				6'h06: 
					begin
						case(Instrcution[20:16])
							5'h00:	//blez
								begin
									PCSrc <= 3'b001;
									RegWr <= 0;
									ALUFun <= 111101;
									MemWr <= 0;
									MemRd <= 0;
								end
							default:	//XADR
								begin
									PCSrc <= 3'b101;	
									RegDst <= 2'b11;
									RegWr <= 1;
									MemWr <= 0;
									MemRd <= 0;
									MemToReg <= 2'b10;
								end
						endcase
					end
				6'h07: 
					begin
						case(Instrcution[20:16])
							5'h00:	//bgtz
								begin
									PCSrc <= 3'b001;
									RegWr <= 0;
									ALUFun <= 111111;
									MemWr <= 0;
									MemRd <= 0;
								end
							default:	//XADR
								begin
									PCSrc <= 3'b101;	
									RegDst <= 2'b11;
									RegWr <= 1;
									MemWr <= 0;
									MemRd <= 0;
									MemToReg <= 2'b10;
								end
						endcase
					end
				6'h01: 
					begin
						case(Instrcution[20:16])
							5'h01:	//bgez
								begin
									PCSrc <= 3'b001;
									RegWr <= 0;
									ALUFun <= 111001;
									MemWr <= 0;
									MemRd <= 0;
								end
							default:	//XADR
								begin
									PCSrc <= 3'b101;	
									RegDst <= 2'b11;
									RegWr <= 1;
									MemWr <= 0;
									MemRd <= 0;
									MemToReg <= 2'b10;
								end
						endcase
					end
				6'h00:
					begin
						case(Instrcution[5:0])
							6'h20:
								begin
									case(Instrcution[10:6])
										5'h00:	//add
											begin
												PCSrc <= 3'b000;
												RegDst <= 2'b01;
												RegWr <= 1;
												ALUSrc1 <= 0;
												ALUSrc2 <= 0;
												ALUFun <= 000000;
												Sign <= 1;
												MemWr <= 0;
												MemRd <= 0;
												MemToReg <= 2'b00;
											end
										default:	//XADR
											begin
												PCSrc <= 3'b101;	
												RegDst <= 2'b11;
												RegWr <= 1;
												MemWr <= 0;
												MemRd <= 0;
												MemToReg <= 2'b10;
											end
									endcase
								end
							6'h21:
								begin
									case(Instrcution[10:6])
										5'h00:	//addu
											begin
												PCSrc <= 3'b000;
												RegDst <= 2'b01;
												RegWr <= 1;
												ALUSrc1 <= 0;
												ALUSrc2 <= 0;
												ALUFun <= 000000;
												Sign <= 1;
												MemWr <= 0;
												MemRd <= 0;
												MemToReg <= 2'b00;
											end
										default:	//XADR
											begin
												PCSrc <= 3'b101;	
												RegDst <= 2'b11;
												RegWr <= 1;
												MemWr <= 0;
												MemRd <= 0;
												MemToReg <= 2'b10;
											end
									endcase
								end
							6'h22:
								begin
									case(Instrcution[10:6])
										5'h00:	//sub
											begin
												PCSrc <= 3'b000;
												RegDst <= 2'b01;
												RegWr <= 1;
												ALUSrc1 <= 0;
												ALUSrc2 <= 0;
												ALUFun <= 000001;
												Sign <= 1;
												MemWr <= 0;
												MemRd <= 0;
												MemToReg <= 2'b00;
											end
										default:	//XADR
											begin
												PCSrc <= 3'b101;	
												RegDst <= 2'b11;
												RegWr <= 1;
												MemWr <= 0;
												MemRd <= 0;
												MemToReg <= 2'b10;
											end
									endcase
								end
							6'h23:
								begin
									case(Instrcution[10:6])
										5'h00:	//subu
											begin
												PCSrc <= 3'b000;
												RegDst <= 2'b01;
												RegWr <= 1;
												ALUSrc1 <= 0;
												ALUSrc2 <= 0;
												ALUFun <= 000001;
												Sign <= 0;
												MemWr <= 0;
												MemRd <= 0;
												MemToReg <= 2'b00;
											end
										default:	//XADR
											begin
												PCSrc <= 3'b101;	
												RegDst <= 2'b11;
												RegWr <= 1;
												MemWr <= 0;
												MemRd <= 0;
												MemToReg <= 2'b10;
											end
									endcase
								end
							6'h24:
								begin
									case(Instrcution[10:6])
										5'h00:	//and
											begin
												PCSrc <= 3'b000;
												RegDst <= 2'b01;
												RegWr <= 1;
												ALUSrc1 <= 0;
												ALUSrc2 <= 0;
												ALUFun <= 011000;
												Sign <= 0;
												MemWr <= 0;
												MemRd <= 0;
												MemToReg <= 2'b00;
											end
										default:	//XADR
											begin
												PCSrc <= 3'b101;	
												RegDst <= 2'b11;
												RegWr <= 1;
												MemWr <= 0;
												MemRd <= 0;
												MemToReg <= 2'b10;
											end
									endcase
								end
							6'h25:
								begin
									case(Instrcution[10:6])
										5'h00:	//or
											begin
												PCSrc <= 3'b000;
												RegDst <= 2'b01;
												RegWr <= 1;
												ALUSrc1 <= 0;
												ALUSrc2 <= 0;
												ALUFun <= 011110;
												Sign <= 0;
												MemWr <= 0;
												MemRd <= 0;
												MemToReg <= 2'b00;
											end
										default:	//XADR
											begin
												PCSrc <= 3'b101;	
												RegDst <= 2'b11;
												RegWr <= 1;
												MemWr <= 0;
												MemRd <= 0;
												MemToReg <= 2'b10;
											end
									endcase
								end
							6'h26:
								begin
									case(Instrcution[10:6])
										5'h00:	//xor
											begin
												PCSrc <= 3'b000;
												RegDst <= 2'b01;
												RegWr <= 1;
												ALUSrc1 <= 0;
												ALUSrc2 <= 0;
												ALUFun <= 010110;
												Sign <= 0;
												MemWr <= 0;
												MemRd <= 0;
												MemToReg <= 2'b00;
											end
										default:	//XADR
											begin
												PCSrc <= 3'b101;	
												RegDst <= 2'b11;
												RegWr <= 1;
												MemWr <= 0;
												MemRd <= 0;
												MemToReg <= 2'b10;
											end
									endcase
								end
							6'h27:
								begin
									case(Instrcution[10:6])
										5'h00:	//nor
											begin
												PCSrc <= 3'b000;
												RegDst <= 2'b01;
												RegWr <= 1;
												ALUSrc1 <= 0;
												ALUSrc2 <= 0;
												ALUFun <= 010001;
												Sign <= 0;
												MemWr <= 0;
												MemRd <= 0;
												MemToReg <= 2'b00;
											end
										default:	//XADR
											begin
												PCSrc <= 3'b101;	
												RegDst <= 2'b11;
												RegWr <= 1;
												MemWr <= 0;
												MemRd <= 0;
												MemToReg <= 2'b10;
											end
									endcase
								end
							6'h00:	//sll
								begin
									PCSrc <= 3'b000;
									RegDst <= 2'b01;
									RegWr <= 1;
									ALUSrc1 <= 1;
									ALUSrc2 <= 0;
									ALUFun <= 100000;
									Sign <= 0;
									MemWr <= 0;
									MemRd <= 0;
									MemToReg <= 2'b00;
								end
							6'h02:	//srl
								begin
									PCSrc <= 3'b000;
									RegDst <= 2'b01;
									RegWr <= 1;
									ALUSrc1 <= 1;
									ALUSrc2 <= 0;
									ALUFun <= 100001
									Sign <= 0;
									MemWr <= 0;
									MemRd <= 0;
									MemToReg <= 2'b00;
								end
							6'h03:	//sra
								begin
									PCSrc <= 3'b000;
									RegDst <= 2'b01;
									RegWr <= 1;
									ALUSrc1 <= 1;
									ALUSrc2 <= 0;
									ALUFun <= 100011;
									Sign <= 0;
									MemWr <= 0;
									MemRd <= 0;
									MemToReg <= 2'b00;
								end
							6'h2a:
								begin
									case(Instrcution[10:6])
										5'h00:	//slt
											begin
												PCSrc <= 3'b000;
												RegDst <= 2'b01;
												RegWr <= 1;
												ALUSrc1 <= 0;
												ALUSrc2 <= 0;
												ALUFun <= 110101;
												Sign <= 0;
												MemWr <= 0;
												MemRd <= 0;
												MemToReg <= 2'b00;
											end
										default:	//XADR
											begin
												PCSrc <= 3'b101;	
												RegDst <= 2'b11;
												RegWr <= 1;
												MemWr <= 0;
												MemRd <= 0;
												MemToReg <= 2'b10;
											end
									endcase
								end
							6'h2b: 
								begin
									case(Instrcution[10:6])
										5'h00:	//sltu
											begin
												PCSrc <= 3'b000;
												RegDst <= 2'b01;
												RegWr <= 1;
												ALUSrc1 <= 0;
												ALUSrc2 <= 0;
												ALUFun <= 110101;
												Sign <= 0;
												MemWr <= 0;
												MemRd <= 0;
												MemToReg <= 2'b00;
											end
										default:	//XADR
											begin
												PCSrc <= 3'b101;	
												RegDst <= 2'b11;
												RegWr <= 1;
												MemWr <= 0;
												MemRd <= 0;
												MemToReg <= 2'b10;
											end
									endcase
								end
							6'h08: 
								begin
									case(Instrcution[20:6])
										15'h0:	//jr
											begin
												PCSrc <= 3'b011;
												RegWr <= 0;
												MemWr <= 0;
												MemRd <= 0;
											end
										default:	//XADR
											begin
												PCSrc <= 3'b101;	
												RegDst <= 2'b11;
												RegWr <= 1;
												MemWr <= 0;
												MemRd <= 0;
												MemToReg <= 2'b10;
											end
									endcase
								end
							6'h09:
							begin
								if((Instrcution[10:6] == 0) && (Instrcution[15:11] == 0))
										//jalr
								begin
									PCSrc <= 3'b011;
									RegDst <= 2'b00;
									RegWr <= 1;
									MemWr <= 0;
									MemRd <= 0;
									MemToReg <= 2'b10;
								end
								else	//XADR
								begin
									PCSrc <= 3'b101;	
									RegDst <= 2'b11;
									RegWr <= 1;
									MemWr <= 0;
									MemRd <= 0;
									MemToReg <= 2'b10;
								end
							default:	//XADR
								begin
									PCSrc <= 3'b101;	
									RegDst <= 2'b11;
									RegWr <= 1;
									MemWr <= 0;
									MemRd <= 0;
									MemToReg <= 2'b10;
								end
						endcase
					end
				default:	//XADR
					begin
						PCSrc <= 3'b101;	
						RegDst <= 2'b11;
						RegWr <= 1;
						MemWr <= 0;
						MemRd <= 0;
						MemToReg <= 2'b10;
					end
			endcase
		end
	end
endmodule








