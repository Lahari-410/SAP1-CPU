module adder_subtractor (
    input wire [7:0] a_in,
    input wire [7:0] b_in,
    input wire su,
    input wire eu,
    output wire [7:0] alu_bus
);
    wire [7:0] result;

    assign result = su ? (a_in - b_in) : (a_in + b_in);
    assign alu_bus = eu ? result : 8'hZZ;
endmodule