module b_register (
    input wire clk,
    input wire lb_n,
    input wire [7:0] bus_in,
    output reg [7:0] b_out
);
    always @(posedge clk) begin
        if (!lb_n)
            b_out <= bus_in;
    end
endmodule