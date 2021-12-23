module uart_controller#(
    ADDRESS_WIDTH = 11
    )
    (
        input logic clock_in,
        input logic [31:0] readdata_in,
        input logic waitrequest_in,
        input logic irq_in,
        output logic chipselect_out,
        output logic address_out,
        output logic read_n_out,
        output logic write_n_out,
        output logic memory_wr_out,
        output logic [ADDRESS_WIDTH - 1:0] memory_address_out,
        output logic [15:0] instruction_out
    );

    logic ready;
    logic [15:0] instruction;

    avalon_master avm0(
        .clock_n_in(clock_in),
        .readdata_in(readdata_in),
        .waitrequest_in(waitrequest_in),
        .irq_in(irq_in),
        .chipselect_out(chipselect_out),
        .address_out(address_out),
        .read_n_out(read_n_out),
        .write_n_out(write_n_out),
        .ready_out(ready),
        .instruction_out(instruction)
    );

    memory_manager mmg0(
        .clock_in(clock_in),
        .ready_in(ready),
        .instruction_in(instruction),
        .memory_wr_out(memory_wr_out),
        .memory_address_out(memory_address_out),
        .instruction_out(instruction_out)
    );

endmodule