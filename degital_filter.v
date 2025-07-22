
`timescale 1ns / 1ps

module fir_filter (
    input clk,
    input reset,
    input [15:0] sample_in,
    output reg [31:0] filter_out
);
    parameter TAP_NUM = 8;

    // Input samples shift register
    reg signed [15:0] samples [0:TAP_NUM-1];

    // FIR coefficients (scaled by 256 for fixed-point)
    reg signed [15:0] coeffs [0:TAP_NUM-1];

    integer i;

    // Coefficient initialization (simulation only)
    initial begin
        coeffs[0] = 16;
        coeffs[1] = 32;
        coeffs[2] = 64;
        coeffs[3] = 128;
        coeffs[4] = 64;
        coeffs[5] = 32;
        coeffs[6] = 16;
        coeffs[7] = 8;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < TAP_NUM; i = i + 1) begin
                samples[i] <= 0;
            end
            filter_out <= 0;
        end else begin
            // Shift samples and add new input
            for (i = TAP_NUM-1; i > 0; i = i - 1) begin
                samples[i] <= samples[i-1];
            end
            samples[0] <= sample_in;

            // Multiply-Accumulate logic
            filter_out <= 0;
            for (i = 0; i < TAP_NUM; i = i + 1) begin
                filter_out <= filter_out + samples[i] * coeffs[i];
            end
        end
    end
endmodule