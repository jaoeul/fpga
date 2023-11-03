`include "src/uart_rx.v"
`include "src/uart_tx.v"

module cmd_handler
(
    input wire clk,
    input wire reset,
    input wire rx,
    output wire tx,
    output reg led1,
    output reg led2,
    output reg led3,
    output reg led4
);

localparam LISTENING = 2'd0;
localparam SENDING = 2'd1;

reg tx_enable;
wire[7:0] rx_buf;
wire rx_valid;
reg[7:0] tx_buf;
wire tx_done;
reg[1:0] cmd_state = LISTENING;

// UART command receiver
(* keep *)
uart_rx rxi(
    .clk(clk),
    .reset(reset),
    .serial_in(rx),
    .rx_buf(rx_buf),
    .valid(rx_valid),
    .status(rx_state)
);

// UART ack transmitter
(* keep *)
uart_tx txi(
    .clk(clk),
    .reset(reset),
    .enable(tx_enable),
    .tx_buf(tx_buf),
    .serial_out(tx),
    .done(tx_done),
    .status(tx_state)
);

always @(posedge clk) begin
    if (reset) begin
        led1 <= 0;
        led2 <= 0;
        led3 <= 0;
        led4 <= 0;
    end
    else begin
        cmd_state <= cmd_state;

        case (cmd_state)
            LISTENING: begin
                if (rx_valid) begin

                    if (rx_buf == 8'h31) begin
                        led1 <= 1;
                    end
                    else if (rx_buf == 8'h32) begin
                        led2 <= 1;
                    end
                    else if (rx_buf == 8'h33) begin
                        led3 <= 1;
                    end
                    else if (rx_buf == 8'h34) begin
                        led4 <= 1;
                    end
                    else if (rx_buf == 8'h35) begin
                        led1 <= 0;
                        led2 <= 0;
                        led3 <= 0;
                        led4 <= 0;
                    end
                    cmd_state <= SENDING;
                end
            end
            SENDING: begin
                tx_enable <= 1;
                tx_buf <= 8'h55;

                if (tx_done) begin
                    tx_enable <= 0;
                    cmd_state <= LISTENING;
                end
            end
            default: begin
                cmd_state <= LISTENING;
                tx_buf <= 0;
                tx_enable <= 0;
            end

        endcase
    end
end

endmodule
