

`timescale 1ns / 1ps

module fir_tb;
    // Signal declarations
    reg clk;
    reg reset;
    reg [15:0] sample_in;
    wire [31:0] filter_out;

    // FIR filter module instantiation
    fir_filter uut (
        .clk(clk),
        .reset(reset),
        .sample_in(sample_in),
        .filter_out(filter_out)
    );

    // Integer for loop control
    integer i;

    // Clock generation: 100 MHz
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus and waveform dumping
    initial begin
        $dumpfile("fir_wave.vcd");      // For GTKWave
        $dumpvars(0, fir_tb);

        // Reset sequence
        reset = 1;
        sample_in = 0;
        #20;
        reset = 0;

        // ?? Impulse input: single high sample
        sample_in = 16'h0100;  // 256 decimal
        #10 sample_in = 0;

        // ?? Hold zeros for filter response
        for (i = 0; i < 20; i = i + 1) begin
            #10 sample_in = 0;
        end

        // ?? Optional: sine wave input (basic simulation)
        for (i = 0; i < 40; i = i + 1) begin
            sample_in = $rtoi(128 * $sin(2 * 3.1416 * i / 20));
            #10;
        end

        #50;
        $finish;
    end
endmodule