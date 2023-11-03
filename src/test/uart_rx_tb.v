`timescale 1ns / 1ps

`include "src/uart_defs.v"

module uart_rx_tb();

reg tb_clk = 1'b1;
reg tb_reset = 1'b0;
reg tb_enable = 1'b0;
reg tb_serial_in = 1'b0;
wire[7:0] tb_rx_buf;
wire tb_valid;

reg[9:0] tb_etu_count = 10'd0;

wire tb_etu_full;
assign tb_etu_full = (tb_etu_count == `UART_BIT_DURATION);

uart_rx rxi (
    .clk(tb_clk),
    .reset(tb_reset),
    .enable(tb_enable),
    .serial_in(tb_serial_in),
    .rx_buf(tb_rx_buf),
    .valid(tb_valid)
);

always begin
    #5 tb_clk <= ~tb_clk;
end

always @(posedge tb_clk) begin
    tb_etu_count <= tb_etu_count + 1;
end

initial begin
    $dumpfile("uart_rx_tb.vcd");
    $dumpvars(0, uart_rx_tb);

    tb_serial_in <= 1'b1;
    tb_reset <= 1'b0;
    tb_enable <= 1'b1;
    tb_etu_count <= 1'b0;

    // ===========
    // First byte
    // ===========

    // Start bit
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b0;

    // 'h55
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b0;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b0;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b0;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b0;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;

    // Stop bit
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;

    // Idle cycle
    @(posedge tb_etu_full);

    // ===========
    // Second byte
    // ===========

    // Start bit
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b0;

    // 'h13
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b0;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b0;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b0;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b0;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b0;

    // Stop bit
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;

    // Ilde 10 cycles for a lazy robustness test
    @(posedge tb_etu_full);
    @(posedge tb_etu_full);
    @(posedge tb_etu_full);
    @(posedge tb_etu_full);
    @(posedge tb_etu_full);
    @(posedge tb_etu_full);
    @(posedge tb_etu_full);
    @(posedge tb_etu_full);
    @(posedge tb_etu_full);
    @(posedge tb_etu_full);

    // ==========
    // Third byte
    // ==========

    // Start bit
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b0;

    // 'h37
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b0;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b0;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b0;

    // Stop bit
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;

    // Skip idling time

    // ==========
    // Fourth byte
    // ==========

    // Start bit
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b0;

    // 'h37
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b0;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b0;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b0;

    // Stop bit
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;

    // Idle bit
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;

    // ==========
    // Fifth byte
    // ==========

    // Start bit
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b0;

    // 'h37
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b0;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b0;
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b0;

    // Stop bit
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;

    // Idle bit
    @(posedge tb_etu_full);
    tb_serial_in <= 1'b1;

    #100000

    $finish;
end

endmodule
