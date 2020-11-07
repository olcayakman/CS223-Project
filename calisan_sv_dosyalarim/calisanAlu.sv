`timescale 1ns / 1ps


module alu(input logic signed [7:0] a, b,
           input logic [2:0] signal,
           output int res,
           output logic displayU);
           
    //logic c;           
    //eightBitAdder myAdder(a, b, c);  
    
    int ain, bin;
    initial displayU = 0;
     
    
    always_comb
        begin
        if (a[7] == 1)
            ain = a[6:0] - 128;
        else 
            ain = a;
        if (b[7] == 1)
            bin = b[6:0] - 128;
        else
            bin = b;
        case(signal)
            3'b000: //reset
                begin
                    res = 16'b0;
                    displayU = 0; 
                end
            3'b001: //toplama
                begin
                    res = ain + bin;
                    displayU = 0;
                end 
            3'b010: //mult
                begin 
                    res = ain * bin;
                    displayU = 0; 
                end
            3'b011: //division
                begin
                    if (bin == 0)
                        displayU = 1;
                    else
                        displayU = 0;
                    res = ain / bin;
                end 
            3'b100: //div rem
                begin
                    res = ain % bin;
                    displayU = 0; 
                end
            default: 
                begin
                    res = 16'b0;
                    displayU = 0;
                end
        endcase
        end
               
endmodule
