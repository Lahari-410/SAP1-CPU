module mar_mux (
    input wire clk,
    input wire lm_n,
    input wire [3:0] bus_in,
    input wire [3:0] switch_addr,
    input wire run_prog_n, // 1 for RUN mode (MAR), 0 for PROG mode (switches)
    output reg [3:0] ram_addr
);
    reg [3:0] mar;

    always @(posedge clk) begin
        if (!lm_n)
            mar <= bus_in;
    end

    always @(*) begin
        if (run_prog_n)
            ram_addr = mar;
        else
            ram_addr = switch_addr;
    end
endmodule