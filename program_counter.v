module program_counter (
    input wire clk,
    input wire clr,
    input wire cp,
    input wire ep,
    output wire [3:0] pc_bus
);
    reg [3:0] pc;

    always @(negedge clk or posedge clr) begin
        if (clr)
            pc <= 4'b0000;
        else if (cp)
            pc <= pc + 1'b1;
    end

    assign pc_bus = ep ? pc : 4'bzzzz;
endmodule