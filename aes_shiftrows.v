`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/22/2024 03:33:51 PM
// Design Name: 
// Module Name: aes_shiftrows
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


module aes_shiftrows (
    input  wire [127:0] state_in_row,  // 128-bit input
    output wire [127:0] state_out_row  // 128-bit output after shifting rows
);

    // Break down the 128-bit input into 16 bytes (8 bits each)
    wire [7:0] state [0:15];  // 16 bytes in the 4x4 matrix

     assign {state[0], state[1], state[2], state[3],
            state[4], state[5], state[6], state[7],
            state[8], state[9], state[10], state[11],
            state[12], state[13], state[14], state[15]} = state_in_row;


    // Perform row shifting according to AES specifications
    assign state_out_row = {
        // Row 0: No shift
        
        state[0],  state[5],  state[10],  state[15],  
       
        // Row 1: Shift left by 1 byte (state[5], state[6], state[7], state[4])
        state[4],  state[9],  state[14],  state[3],
       
        // Row 2: Shift left by 2 bytes (state[10], state[11], state[8], state[9])
        state[8], state[13], state[2],  state[7],
       
        // Row 3: Shift left by 3 bytes (state[15], state[12], state[13], state[14])
        state[12], state[1], state[6], state[11]
    };

endmodule
