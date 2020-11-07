`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.05.2019 22:42:22
// Design Name: 
// Module Name: clockDivider
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clockDivider(input clk_in, 
                    output clk_out);

    logic [25:0] count = {26{1'b0}};
    logic clk_NoBuf;
    always@ (posedge clk_in) 
        begin
            count <= count + 1;
        end
        
    // you can modify 25 to have different clock rate
    assign clk_NoBuf = count[24]; //bu 24te guzel oldu
    //yanik yer burasi 4snden fazla
    
    BUFG BUFG_inst (.I(clk_NoBuf), // 1-bit input: Clock input
                     .O(clk_out)   // 1-bit output: Clock output
                     );        

endmodule
