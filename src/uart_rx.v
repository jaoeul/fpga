`include "src/uart_defs.v"

module uart_rx
(
    input wire clk,
    input wire reset,
    input wire serial_in,
    output wire[7:0] rx_buf,
    output reg valid,
    output wire status
);

localparam[1:0] UART_START = 2'd0;
localparam[1:0] UART_DATA = 2'd1;
localparam[1:0] UART_STOP = 2'd2;

reg[1:0] state = UART_START;
reg[2:0] bit_count = 3'b0;
reg[9:0] etu_count = 10'b0;
reg[7:0] data;
assign rx_buf = data;
wire etu_full;

assign etu_full = (etu_count == `UART_BIT_DURATION);

always @(posedge clk) begin
    if (reset) begin
        state <= UART_START;
        data <= 0;
        etu_count <= 0;
        valid <= 0;
    end
    else begin
        state <= state;
        valid <= 1'b0;

        case (state)
            UART_START: begin
                if (serial_in == 1'b0) begin
                    etu_count <= 1'b0;
                    bit_count <= 3'd0;
                    state <= UART_DATA;
                end
            end
            UART_DATA: begin
                etu_count <= etu_count + 1'b1;
                if (etu_full) begin
                    data <= {serial_in, data[7:1]};
                    bit_count <= bit_count + 1'b1;
                    etu_count <= 0;

                    if (bit_count == 3'd7) begin
                        state <= UART_STOP;
                    end
                end
            end
            UART_STOP: begin
                etu_count <= etu_count + 1'b1;
                if (etu_full) begin
                    valid <= serial_in;
                    state <= UART_START;
                    etu_count <= 0;
                end
            end
        endcase
    end
end

endmodule
