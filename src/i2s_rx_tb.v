`timescale 1ns / 1ps

module i2s_tb;

reg tb_clk = 1'b1;
reg tb_reset = 1'b1;
reg tb_enable = 1'b0;
reg tb_ws = 1'b1;
reg tb_serial_in = 1'b0;

wire[23:0] tb_rx_buf;

integer serial_in_fd = 0;
integer ws_fd = 0;

i2s_rx rxi (
    .clock(tb_clk),
    .reset(tb_reset),
    .enable(tb_enable),
    .ws(tb_ws),
    .serial_in(tb_serial_in),
    .rx_buf(tb_rx_buf)
);

// test bench clock
always begin
    #1 tb_clk = ~tb_clk;
end

// set up simulation data
initial begin

    $dumpfile("i2s_rx_tb.vcd");
    $dumpvars(0, i2s_tb);

    tb_reset <= 1'b0;
    tb_enable <= 1'b1;

    // test run time
    # 1000;

    $finish;

end

// toggle word select bit every 24 full clock cycles to simulate the 24-bit word
// transmission of the mic
always @(negedge tb_clk) begin
    # 48
    tb_ws = ~tb_ws;
end

// test bench data generation
always @(posedge tb_ws or negedge tb_ws) begin

    // ==========================
    // 24-bit word (LSB) 0x000055
    // ==========================

    // wait for word select to go low
    $display("time: %d, transmitting word", $time);

    @(negedge tb_clk)
    tb_serial_in <= 1'b1; // high
    @(negedge tb_clk)
    tb_serial_in <= 1'b0;
    @(negedge tb_clk)
    tb_serial_in <= 1'b1; // high
    @(negedge tb_clk)
    tb_serial_in <= 1'b0;
    @(negedge tb_clk)
    tb_serial_in <= 1'b1; // high
    @(negedge tb_clk)
    tb_serial_in <= 1'b0;
    @(negedge tb_clk)
    tb_serial_in <= 1'b1; // high
    @(negedge tb_clk)
    tb_serial_in <= 1'b0;
    @(negedge tb_clk)
    tb_serial_in <= 1'b0;
    @(negedge tb_clk)
    tb_serial_in <= 1'b0;
    @(negedge tb_clk)
    tb_serial_in <= 1'b0;
    @(negedge tb_clk)
    tb_serial_in <= 1'b0;
    @(negedge tb_clk)
    tb_serial_in <= 1'b0;
    @(negedge tb_clk)
    tb_serial_in <= 1'b0;
    @(negedge tb_clk)
    tb_serial_in <= 1'b0;
    @(negedge tb_clk)
    tb_serial_in <= 1'b0;
    @(negedge tb_clk)
    tb_serial_in <= 1'b0;
    @(negedge tb_clk)
    tb_serial_in <= 1'b0;
    @(negedge tb_clk)
    tb_serial_in <= 1'b0;
    @(negedge tb_clk)
    tb_serial_in <= 1'b0;
    @(negedge tb_clk)
    tb_serial_in <= 1'b0;
    @(negedge tb_clk)
    tb_serial_in <= 1'b0;
    @(negedge tb_clk)
    tb_serial_in <= 1'b0;
end

// display info every cycle
always @(posedge tb_clk) begin
    $display("time: %d, serial: %d, ws: %d", $time, tb_serial_in, tb_ws);
end

endmodule
