module TLS(clk, reset, Set, Stop, Jump, Gin, Yin, Rin, Gout, Yout, Rout);
input           clk;
input           reset;
input           Set;
input           Stop;
input           Jump;
input     [3:0] Gin;
input     [3:0] Yin;
input     [3:0] Rin;
output          Gout;
output          Yout;
output          Rout;
reg Gout;
reg Yout;
reg Rout;
reg [3:0] Gtime;
reg [3:0] Ytime;
reg [3:0] Rtime;
reg    [3:0] Count;
reg [1:0] current_state;
reg [1:0] next_state;
parameter [1:0] Idle = 2'b00;
parameter [1:0] S1 = 2'b01;
parameter [1:0] S2 = 2'b10;
parameter [1:0] S3 = 2'b11;


always @(posedge clk) begin
    if(reset)begin
      current_state = Idle;
      Count = 0;
    end
    
    case ({Set,Stop,Jump})
      3'b100:begin
        Gtime = Gin;
        Ytime = Yin;
        Rtime = Rin;
        current_state = S1;
      end

      3'b010:begin
        current_state = current_state;
      end

      3'b001:begin
        current_state = S3;
      end

      default:
        current_state = next_state;
      
    endcase  
end



always @(current_state or Count) begin
    case (current_state)
        Idle:begin
          if(Count==3'b000)
            next_state = S1;
          else
            next_state = Idle;
        end

        S1:begin
          if(Count==Gtime)begin
            Count = 0;
            next_state = S2;
            current_state = next_state;
          end
          else
            next_state = S1;
        end 

        S2:begin
          if(Count==Ytime)begin
            Count = 0;
            next_state = S3;
            current_state = next_state;
          end
          else
            next_state = S2;
        end

        S3:begin
          if(Count==Rtime)begin
            Count = 0;
            next_state = S1;
            current_state = next_state;
          end
          else
            next_state = S3;
        end

        default: 
            next_state = S3;

    endcase
end


always @(posedge clk) begin
    case ({Set,Stop,Jump})
      3'b100:begin
        Count = 0;
      end

      3'b010:begin
        Count = Count;
      end

      3'b001:begin
        Count = 0;
      end

      default:begin
        Count = Count + 1;
      end
    endcase

end

always @(current_state) begin
    case (current_state)
        S1:
            {Gout,Yout,Rout} = 3'b100;
        
        S2:
            {Gout,Yout,Rout} = 3'b010;

        S3:
            {Gout,Yout,Rout} = 3'b001;
    endcase
end


endmodule