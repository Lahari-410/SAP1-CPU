module sap1_top (
    input wire clk,
    input wire clr,
    input wire run_prog_n,        // 1 = RUN mode, 0 = PROG mode
    input wire [3:0] switch_addr,  // Address switches S1
    input wire [7:0] switch_data,  // Data switches S3
    input wire we_n,               // Write Enable switch S4
    output wire [7:0] display_out, // Binary Display LEDs
    output wire hlt
);
    wire [7:0] w_bus;
    wire [11:0] con;
    wire [3:0] ram_addr;
    wire [3:0] opcode;
    wire [7:0] a_val;
    wire [7:0] b_val;

    // Decoding 12-bit CON word
    wire cp   = con[11];
    wire ep   = con[10];
    wire lm_n = con[9];
    wire ce_n = con[8];
    wire li_n = con[7];
    wire ei_n = con[6];
    wire la_n = con[5];
    wire ea   = con[4];
    wire su   = con[3];
    wire eu   = con[2];
    wire lb_n = con[1];
    wire lo_n = con[0];

    // Instantiations
    program_counter u_pc (
        .clk(clk), .clr(clr), .cp(cp), .ep(ep),
        .pc_bus(w_bus[3:0])
    );

    mar_mux u_mar (
        .clk(clk), .lm_n(lm_n), .bus_in(w_bus[3:0]),
        .switch_addr(switch_addr), .run_prog_n(run_prog_n),
        .ram_addr(ram_addr)
    );

    ram u_ram (
        .addr(ram_addr), .ce_n(ce_n), .we_n(we_n),
        .switch_data(switch_data), .ram_bus(w_bus)
    );

    instruction_register u_ir (
        .clk(clk), .clr(clr), .li_n(li_n), .ei_n(ei_n),
        .bus_in(w_bus), .opcode(opcode), .ir_bus(w_bus)
    );

    controller_sequencer u_control (
        .clk(clk), .clr(clr), .opcode(opcode),
        .hlt(hlt), .con(con)
    );

    accumulator u_acc (
        .clk(clk), .la_n(la_n), .ea(ea),
        .bus_in(w_bus), .acc_out(a_val), .acc_bus(w_bus)
    );

    adder_subtractor u_alu (
        .a_in(a_val), .b_in(b_val), .su(su), .eu(eu),
        .alu_bus(w_bus)
    );

    b_register u_breg (
        .clk(clk), .lb_n(lb_n), .bus_in(w_bus),
        .b_out(b_val)
    );

    output_register u_out (
        .clk(clk), .lo_n(lo_n), .bus_in(w_bus),
        .display_out(display_out)
    );

endmodule