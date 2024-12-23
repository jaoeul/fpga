`timescale 1ns / 1ps

`define I2S_WORD_SIZE (24)

module i2s_rx
(
    input wire clock,
    input wire reset,
    input wire enable,
    input wire ws,
    input wire serial_in,
    output reg[23:0] rx_buf
);

localparam[2:0] I2S_IDLE = 3'd0;
localparam[2:0] I2S_DATA = 3'd1;
localparam[2:0] I2S_FINISH = 3'd2;

reg[1:0] state = I2S_IDLE;

// negative edge of ws means left channel will transmit a word
always @(negedge ws or posedge ws) begin
    rx_buf <= {serial_in, rx_buf[23:1]};
    state <= I2S_FINISH;
end

always @(posedge clock) begin
    if (reset) begin
        state <= I2S_IDLE;
    end
    else if (enable) begin

        case (state)

            I2S_DATA: begin
                rx_buf <= {serial_in, rx_buf[23:1]};
            end

            I2S_FINISH: begin
                // this the one clockcycle where we can store rx_buf, before it
                // gets overwritten by the next iteration

                state <= I2S_DATA;
            end

        endcase
    end
    else begin
        state <= I2S_IDLE;
    end
end

endmodule
