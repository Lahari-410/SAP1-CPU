module output_register (
    input wire clk,
    input wire lo_n,
    input wire [7:0] bus_in,
    output reg [7:0] display_out
);
    always @(posedge clk) begin
        if (!lo_n)
            display_out <= bus_in;
    end
endmodule