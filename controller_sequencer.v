module controller_sequencer (
    input wire clk,
    input wire clr,
    input wire [3:0] opcode,
    output reg hlt,
    output reg [11:0] con
);
    // Control signal bit indices corresponding to CON:
    // CON = [Cp, Ep, Lm_n, Ce_n, Li_n, Ei_n, La_n, Ea, Su, Eu, Lb_n, Lo_n]
    reg [5:0] ring_counter;

    // Ring Counter logic (T1 to T6 states)
    always @(negedge clk or posedge clr) begin
        if (clr)
            ring_counter <= 6'b000001;
        else if (!hlt)
            ring_counter <= {ring_counter[4:0], ring_counter[5]};
    end

    always @(*) begin
        hlt = 1'b0;
        con = 12'b011_1111_0001_1; // Inactive default state

        if (ring_counter[0])      // T1 State: Ep, Lm_n active
            con = 12'b010_1111_0001_1;
        else if (ring_counter[1]) // T2 State: Cp active
            con = 12'b101_1111_0001_1;
        else if (ring_counter[2]) // T3 State: Ce_n, Li_n active
            con = 12'b001_0011_0001_1;
        else if (ring_counter[3]) // T4 State
            case (opcode)
                4'b0000, 4'b0001, 4'b0010: con = 12'b000_1101_0001_1; // Lm_n, Ei_n
                4'b1110:                    con = 12'b001_1111_1101_1; // Ea, Lo_n
                4'b1111:                    hlt = 1'b1;               // HLT
            endcase
        else if (ring_counter[4]) // T5 State
            case (opcode)
                4'b0000: con = 12'b001_0110_1001_1; // Ce_n, La_n
                4'b0001, 4'b0010: con = 12'b001_0111_0000_1; // Ce_n, Lb_n
            endcase
        else if (ring_counter[5]) // T6 State
            case (opcode)
                4'b0001: con = 12'b001_1110_1010_1; // La_n, Eu
                4'b0010: con = 12'b001_1110_1011_1; // La_n, Su, Eu
            endcase
    end
endmodule