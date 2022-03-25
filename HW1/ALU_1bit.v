module ALU_1bit(result, c_out, set, overflow, a, b, less, Ainvert, Binvert, c_in, op);
input        a;
input        b;
input        less;
input        Ainvert;
input        Binvert;
input        c_in;
input  [1:0] op;
output       result;
output       c_out;
output       set;                 
output       overflow;      
wire [1:0] result_tmp; //0 for add
wire [1:0] c_out_tmp; //0 for add
reg result,c_out,set,overflow;

FA Add(.s(result_tmp[0]),.carry_out(c_out_tmp[0]),.x(a),.y(b),.carry_in(c_in));
FA Sub(.s(result_tmp[1]),.carry_out(c_out_tmp[1]),.x(a),.y(~b),.carry_in(c_in));
/*
	Write Your Design Here ~
*/
always @(*) begin
	case ({Ainvert,Binvert,op})
		4'b0000://AND
			  result = a & b;
		4'b0001://OR
			  result = a | b;
		4'b0010://ADD
			begin
			  result = result_tmp[0];
			  c_out = c_out_tmp[0];
			  overflow = c_out ^ c_in;
			end
		4'b0110://SUB
			begin
			  result = result_tmp[1];
			  c_out = c_out_tmp[1];
			  overflow = c_out ^ c_in;
			end
		4'b0111://SLT
			begin
			  result =less;
			  overflow = c_out_tmp[1] ^ c_in;
			  c_out = c_out_tmp[1];
			  set = result_tmp[1];
			end
		4'b1100://NOR
			  result = !(a | b);
		4'b1101://NAND
			  result = !(a & b);
	endcase	
end


endmodule
