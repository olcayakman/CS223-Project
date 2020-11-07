`timescale 1ns / 1ps


module controller(input logic clk,
                  input r, a, m, d, dr,
                  output logic [2:0] alu_signal,
                  output logic sttIsReset);
             
    typedef enum logic [2:0] {s0, s1, s2, s3, s4} state;
    state [2:0] currentState, nextState;
    
    //next state logic
    always_ff @ (posedge clk, posedge r)
        begin
            if (r)
                nextState = s0;
            else
                case (currentState)
                    s0: //reset state
                        begin
                            if (a)
                                nextState = s1;
                            else if (m)
                                nextState = s2;
                            else if (d)
                                nextState = s3;
                            else if (dr)
                                nextState = s4;
                            else
                                nextState = s0;
                        end
                    s1: //addition state
                        begin
                            if (r)
                                nextState = s0;
                            else 
                                nextState = s1;
                        end
                    s2: //multiplication state
                        begin
                            if (r)
                                nextState = s0;
                            else 
                                nextState = s2;
                        end
                    s3: //division state
                        begin
                            if (r)
                                nextState = s0;
                            else
                                nextState = s3;
                        end
                    s4: //division remainder state
                        begin
                            if (r)
                                nextState = s0;
                            else
                                nextState = s4;
                        end
                    default: nextState = s0;
                endcase
        end
  
    //state register
    always_ff @ (posedge clk)
        begin
            if (r)
                currentState <= s0;
            else
                currentState <= nextState;
        end
    
    //output logic
    always_comb
        begin
            if (currentState == s0)
                begin
                    alu_signal = 3'b000; //reset - r
                end
            else if (currentState == s1)
                begin
                    alu_signal = 3'b001; //addition - a
                end
            else if (currentState == s2)
                begin
                    alu_signal = 3'b010; //multiplication - m
                end
            else if (currentState == s3)
                begin
                    alu_signal = 3'b011; //division - d
                end
            else if (currentState == s4)
                begin
                    alu_signal = 3'b100; //division remainder - dr
                end
        end
        assign sttIsReset = (currentState == s0);
        
    
endmodule
