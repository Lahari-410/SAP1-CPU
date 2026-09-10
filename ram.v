module ram (
    input wire [3:0] addr,
    input wire ce_n,
    input wire we_n,
    input wire [7:0] switch_data,
    output wire [7:0] ram_bus
);
    reg [7:0] memory [0:15];

    always @(*) begin
        if (!we_n)
            memory[addr] = switch_data;
    end

    assign ram_bus = (!ce_n) ? memory[addr] : 8'hZZ;
endmodule