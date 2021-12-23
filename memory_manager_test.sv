`timescale 1 ns / 1 ps

module memory_manager_test#(
    ADDRESS_WIDTH = 11
    );

    logic clock, chipselect, address, read_n, write_n, waitrequest, irq, memory_wr;
    logic [31:0] readdata;
    logic [15:0] instruction_in, instruction_out, data_0, data_1;;
    logic [ADDRESS_WIDTH - 1:0] memory_address, address_0, address_1;

    clock_generator GCLOCK(clock);

    avalon_master avm0(
        .clock_n_in(clock),
        .readdata_in(readdata),
        .waitrequest_in(waitrequest),
        .irq_in(irq),
        .chipselect_out(chipselect),
        .address_out(address),
        .read_n_out(read_n),
        .write_n_out(write_n),
        .ready_out(ready),
        .instruction_out(instruction_in)
    );

    tri_port_memory #(.ADDRESS_WIDTH(ADDRESS_WIDTH)) memory0(
      .data_in(instruction_out),
      .write_address_in(memory_address),
      .address_0_in(address_0),
      .address_1_in(address_1),
      .memory_wr_in(memory_wr),
      .read_clock_in(clock),
      .write_clock_in(!clock),
      .data_0_out(data_0),
      .data_1_out(data_1)
   );

    memory_manager mmg0(
        .clock_in(clock),
        .ready_in(ready),
        .instruction_in(instruction_in),
        .memory_wr_out(memory_wr),
        .memory_address_out(memory_address),
        .instruction_out(instruction_out)
    );

    initial 
    begin
        irq = 1'b0; waitrequest = 1'b1;
        readdata = 32'h00000000;
        #4;

        waitrequest = 1'b0;
        #2;

        irq = 1'b1; waitrequest = 1'b1;
        #2;

        readdata = 32'h00030004;
        waitrequest = 1'b0;
        #2;

        waitrequest = 1'b1;
        #2;

        readdata = 32'h00020003;
        waitrequest = 1'b0;
        #2;

        waitrequest = 1'b1;
        #2;

        readdata = 32'h00010000;
        waitrequest = 1'b0;
        #2;

        waitrequest = 1'b1;
        #2;

        readdata = 32'h00000000;
        waitrequest = 1'b0;
        #2;

        waitrequest = 1'b1;
        irq = 1'b0;
        #2;

        irq = 1'b1; 
        #2;

        readdata = 32'h0007000A;
        waitrequest = 1'b0;
        #2;

        waitrequest = 1'b1;
        #2;

        readdata = 32'h0006000B;
        waitrequest = 1'b0;
        #2;

        waitrequest = 1'b1;
        #2;

        readdata = 32'h0005000C;
        waitrequest = 1'b0;
        #2;

        waitrequest = 1'b1;
        #2;

        readdata = 32'h0004000D;
        waitrequest = 1'b0;
        #2;

        waitrequest = 1'b1;
        #2;

        readdata = 32'h0003000E;
        waitrequest = 1'b0;
        #2;

        waitrequest = 1'b1;
        #2;

        readdata = 32'h0002000F;
        waitrequest = 1'b0;
        #2;

        waitrequest = 1'b1;
        #2;

        readdata = 32'h00010000;
        waitrequest = 1'b0;
        #2;

        waitrequest = 1'b1;
        #2;

        readdata = 32'h00000000;
        waitrequest = 1'b0;
        #2;

        waitrequest = 1'b1;
        irq = 1'b0;
        #2;

    end


endmodule