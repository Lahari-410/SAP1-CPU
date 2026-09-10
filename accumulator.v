module accumulator (
    input wire clk,
    input wire la_n,
    input wire ea,
    input wire [7:0] bus_in,
    output reg [7:0] acc_out,
    output wire [7:0] acc_bus
);
    always @(posedge clk) begin
        if (!la_n)
            acc_out <= bus_in;
    end

    assign acc_bus = ea ? acc_out : 8'hZZ;
endmodule