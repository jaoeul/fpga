`include "src/cmd_handler.v"

module top
(
    input wire CLK,
    input wire BR3,
    input wire RX,
    output wire TX,
    output reg LED1,
    output reg LED2,
    output reg LED3,
    output reg LED4,
    output reg LED5
);

assign LED5 = 1;

cmd_handler cmd
(
    .clk(CLK),
    .reset(BR3),
    .rx(RX),
    .tx(TX),
    .led1(LED1),
    .led2(LED2),
    .led3(LED3),
    .led4(LED4)
);

endmodule
