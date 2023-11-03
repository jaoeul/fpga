`timescale 1ns / 1ps

`include "src/cmd_handler.v"

module cmd_handler_tb();

reg clk = 1;
reg reset = 1;
reg tx_enable = 0;
wire host_tx;
wire host_rx;
reg[7:0] host_tx_buf;
wire host_tx_done;

// Simulated FPGA-side command handler
cmd_handler device_cmd_handler
(
    .clk(clk),
    .reset(reset),
    .rx(host_tx),
    .tx(host_rx)
);

// Simulated PC-side UART-transmitter
uart_tx host_uart_tx
(
    .clk(clk),
    .reset(reset),
    .enable(tx_enable),
    .tx_buf(host_tx_buf),
    .serial_out(host_tx),
    .done(host_tx_done)
);

always begin
    #5 clk <= ~clk;
end

initial begin
    $dumpfile("out/cmd_handler_tb.vcd");
    $dumpvars(0, cmd_handler_tb);

    #10
    reset <= 1;

    #10000
    reset <= 0;
    tx_enable <= 1;
    host_tx_buf <= 8'hff;
    @(posedge host_tx_done);
    tx_enable <= 0;

    #100000
    tx_enable <= 1;
    host_tx_buf <= 8'h00;
    @(posedge host_tx_done);
    host_tx_buf <= 8'hf0;
    @(posedge host_tx_done);
    host_tx_buf <= 8'h0f;
    @(posedge host_tx_done);
    host_tx_buf <= 8'h13;
    @(posedge host_tx_done);
    host_tx_buf <= 8'h37;
    @(posedge host_tx_done);
    host_tx_buf <= 8'h01;
    @(posedge host_tx_done);
    host_tx_buf <= 8'h55;

    #1000000
    $finish;
end

endmodule
