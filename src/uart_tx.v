`include "src/uart_defs.v"

module uart_tx
(
    input wire clk,
    input wire reset,
    input wire enable,
    input wire[7:0] tx_buf,
    output reg serial_out,
    output reg done,
    output wire status
);

localparam UART_START = 2'd0;
localparam UART_DATA = 2'd1;
localparam UART_STOP = 2'd2;
localparam UART_IDLE = 2'd3;

reg[1:0] state = UART_START;
reg[7:0] data = 8'd0;
reg[3:0] bit_count = 4'd0;
reg[9:0] etu_count = 10'd0;
wire etu_full;

assign etu_full = (etu_count == `UART_BIT_DURATION);
assign status = etu_full;

always @(posedge clk) begin
    if (reset) begin
        etu_count <= 1'b0;
        state <= UART_START;
        serial_out <= 1'b1;
        done <= 1'b0;
        data <= 0;
    end
    else if (enable) begin
        state <= state;

        case (state)
            UART_START: begin
                serial_out <= 1'b0;
                etu_count <= 1'b0;
                data <= tx_buf;
                bit_count <= 3'd0;
                done <= 1'b0;
                state <= UART_DATA;
            end
            UART_DATA: begin
            etu_count <= etu_count + 1'b1;
                if (etu_full) begin
                    etu_count <= 0;
                    bit_count <= bit_count + 1'b1;

                    serial_out <= data[0];
                    data <= {serial_out, data[7:1]};

                    if (bit_count == 4'd8) begin
                        serial_out <= 1'b1;
                        bit_count <= 0;
                        state <= UART_STOP;
                    end
                end
            end
            UART_STOP: begin
            etu_count <= etu_count + 1'b1;
                serial_out <= 1'b1;
                if (etu_full) begin
                    state <= UART_IDLE;
                    etu_count <= 0;
                end
            end
            UART_IDLE: begin
                serial_out <= 1'b1;
                done <= 1'b1;
                etu_count <= 1'b0;
                state <= UART_START;
            end
        endcase
    end
end

endmodule
