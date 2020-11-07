`timescale 1ns / 1ps


module calculator(input clk,
                  input r, a, m, d, dr,
                  input signed [7:0] firstNumber, secondNumber,
                  output logic [7:0] ledsFirst, ledsSecond,
                  output logic [6:0] seg, logic dp,
                  output logic [3:0] an);
    
    logic [2:0] alu_signal;
    logic displayU;
    logic [15:0] result;
    int resInt;
    logic yak, sondur;
    logic flag;
    initial flag = 0;
    initial yak = 1;
    initial sondur = 0;
    logic [6:0] preSeg;
    int res0, res1, res2, res3;
    logic clkSlow;
    logic sttIsReset;
    
    always_comb
        begin
            ledsFirst = firstNumber;
            ledsSecond = secondNumber;
            result = resInt;
            if (resInt < 0)
                result = ~result + 1;
        end
    
    always @ (posedge clkSlow)
        begin
            //flag = ~flag;
            if (flag == 1)
                yak = ~yak;
        end
    
    always @ (negedge clkSlow)
        begin
            flag = ~flag;
            if (flag == 1) 
                sondur = ~sondur;
        end
        
    //sevseg display helper
    always_ff @ (posedge clk)
        begin
            if (yak)
                begin
                    seg <= preSeg;
                    if (displayU == 1)
                        begin
                            res3 = 5'd17;
                            res2 = 5'd17;
                            res1 = 5'd17;
                            res0 = 5'd18;
                        end
                    else 
                        begin
                            if (resInt < 0)
                                begin
                                    if (resInt < -4095)
                                        begin
                                            res3 = 5'd16;
                                            res2 = result[15:12];
                                            res1 = result[11:8];
                                            res0 = result[7:4];
                                        end
                                    else
                                        begin
                                            res3 = 5'd16;
                                            res2 = result[11:8];
                                            res1 = result[7:4];
                                            res0 = result[3:0];
                                        end
                                end
                            else //result is positive
                                begin
                                    res3 = result[15:12];
                                    res2 = result[11:8];
                                    res1 = result[7:4];
                                    res0 = result[3:0];
                                end
                        end
                    if (sondur && ~sttIsReset)
                        seg <= 7'b1111111;
                end
        end
        
        controller myController(clk, r, a, m, d, dr, alu_signal, sttIsReset);
            
        alu myAlu(firstNumber, secondNumber, alu_signal, resInt, displayU);
         
        SevSeg_4digit mySevSeg(clk, res0, res1, res2, res3, preSeg, dp, an);
        
        clockDivider div(clk, clkSlow);
                  
endmodule
