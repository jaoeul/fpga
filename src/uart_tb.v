module uart_tb();

reg tb_clk = 1'b1;

reg tx_reset = 1'b0;
reg tx_enable = 1'b0;
reg[7:0] tx_buf = 8'b0;
wire tx_pin;
wire tx_done;

reg rx_reset = 1'b0;
reg rx_enable = 1'b0;
wire[7:0] rx_buf = 8'b0;
wire rx_pin;
wire rx_valid;

assign rx_pin = tx_pin;

uart_tx tx_i(
    .clk(tb_clk),
    .reset(tx_reset),
    .enable(tx_enable),
    .tx_buf(tx_buf),
    .serial_out(tx_pin),
    .done(tx_done)
);

uart_rx rx_i(
    .clk(tb_clk),
    .reset(rx_reset),
    .enable(rx_enable),
    .serial_in(rx_pin),
    .rx_buf(rx_buf),
    .valid(rx_valid)
);

always begin
    #5 tb_clk <= ~tb_clk;
end

initial begin
    $dumpfile("uart_tb.vcd");
    $dumpvars(0, uart_tb);

    #100
    tx_reset <= 1'b1;
    rx_reset <= 1'b1;

    #100
    tx_reset <= 1'b0;
    rx_reset <= 1'b0;

    #100
    tx_enable <= 1'b1;
    rx_enable <= 1'b1;

    tx_buf <= 8'hFE;
    @(posedge tx_done);

    tx_buf <= 8'h13;
    @(posedge tx_done);

    #5050

    // Pause transmission
    tx_enable <= 1'b0;

    // Delay for robustness test
    #500000

    tx_enable <= 1'b1;

    tx_buf <= 8'h37;
    @(posedge tx_done);
    tx_buf <= 8'h38;
    @(posedge tx_done);

    // Send `h'39` two times
    tx_buf <= 8'h39;
    @(posedge tx_done);
    tx_buf <= 8'h40;
    @(posedge tx_done);

    #1000000
    $finish;
end

endmodule
