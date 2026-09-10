module instruction_register (
    input wire clk,
    input wire clr,
    input wire li_n,
    input wire ei_n,
    input wire [7:0] bus_in,
    output wire [3:0] opcode,
    output wire [7:0] ir_bus
);
    reg [7:0] ir;

    always @(posedge clk or posedge clr) begin
        if (clr)
            ir <= 8'h00;
        else if (!li_n)
            ir <= bus_in;
    end

    assign opcode = ir[7:4];
    assign ir_bus = (!ei_n) ? {4'b0000, ir[3:0]} : 8'hZZ;
endmodule