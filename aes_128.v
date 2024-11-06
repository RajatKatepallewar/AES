module aes_128(
    input clk,
    input rst,
    input start,
    input [2:0] seed,
    input [127:0] data_in,
    input [127:0] key,
    output reg [127:0] data_out,
    output reg done
);

    // Internal signals
    wire [127:0] subbyte_out;
    wire [127:0] row_out;
    wire [127:0] col_out;
    wire [1407:0] expanded_key;
    reg [127:0] state;
    reg [3:0] round; // To count the rounds

    // Instantiate the submodules
    aes_subbytes subbytes(
        .state_in(state),
        .state_out(subbyte_out)
    );

    aes_shiftrows shiftrows(
        .state_in_row(subbyte_out),
        .state_out_row(row_out)
    );

    mixcolumns aes_mixcolumns(
        .state_in(row_out),
        .state_out(col_out)
    );

    key_exp aes_key_exp(
        .cipher_key(key),
        .seed(seed),
        .expanded_key(expanded_key)
    );

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            state <= 128'b0;
            data_out <= 128'b0;
            done <= 1'b0;
            round <= 0;
        end else if (start && !done) begin
            if (round == 0) begin
                state <= data_in ^ expanded_key[127:0]; // Initial AddRoundKey
                round <= round + 1;
            end else if (round < 10) begin
                state <= col_out ^ expanded_key[(128 * round) +: 128]; // Main rounds
                round <= round + 1;
            end else if (round == 10) begin
                state <= row_out ^ expanded_key[(128 * 10) +: 128]; // Final round
                data_out <= state;
                done <= 1'b1;
            end
        end else begin
            done <= 1'b0;
        end
    end
endmodule
