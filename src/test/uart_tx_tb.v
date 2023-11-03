`timescale 1ns / 1ps

module uart_tx_tb();

reg tb_clk = 1'b1;
reg tb_reset = 1'b0;
reg tb_enable = 1'b0;
reg[7:0] tb_tx_buf;
wire tb_serial_out;
wire tb_tx_done;

uart_tx txi (
    .clk(tb_clk),
    .reset(tb_reset),
    .enable(tb_enable),
    .tx_buf(tb_tx_buf),
    .serial_out(tb_serial_out),
    .done(tb_tx_done)
);

always begin
    #5 tb_clk <= ~tb_clk;
end

initial begin
    $dumpfile("uart_tx_tb.vcd");
    $dumpvars(0, uart_tx_tb);

    #10
    tb_reset <= 1'b1;

    #10
    tb_reset <= 1'b0;

    #10
    tb_enable <= 1'b1;

    #1000
    @(posedge tb_tx_done);

    tb_tx_buf <= 8'h13;
    @(posedge tb_tx_done);

    tb_tx_buf <= 8'h37;
    @(posedge tb_tx_done);

    tb_tx_buf <= 8'h00;
    @(posedge tb_tx_done);

    #1000000

    $finish;
end

endmodule
