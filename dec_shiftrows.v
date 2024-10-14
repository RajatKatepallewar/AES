module aes_rightshiftrows(
    input [127:0] state_in_row,
    output [127:0] state_out_row
    );
    
    //row 0  no shift 
    assign state_out_row[127:120]=state_in_row[127:120];
    assign state_out_row[95:88]=state_in_row[95:88];
    assign state_out_row[63:56]=state_in_row[63:56];
    assign state_out_row[31:24]=state_in_row[31:24];
//row1    right shift 1 
    assign state_out_row[55:48] = state_in_row[23:16];  
    assign state_out_row[87:80] = state_in_row[55:48];   
    assign state_out_row[119:112] = state_in_row[87:80];   
    assign state_out_row[23:16] = state_in_row[119:112];   
//row 2     right shift 2
    assign state_out_row[111:104] = state_in_row[47:40];
    assign state_out_row[79:72] = state_in_row[15:8];
    assign state_out_row[47:40] = state_in_row[111:104];
    assign state_out_row[15:8] = state_in_row[79:72];
//row 3    right shift 3
    assign state_out_row[7:0] = state_in_row[39:32];  
    assign state_out_row[103:96] = state_in_row[7:0];  
    assign state_out_row[71:64] = state_in_row[103:96];  
    assign state_out_row[39:32] = state_in_row[71:64];  

    endmodule
