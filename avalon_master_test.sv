`timescale 1 ns / 1 ps

module avalon_master_test;

    logic clock, chipselect, address, read_n, write_n, waitrequest, irq;
    logic [31:0] readdata;
    logic [15:0] instruction;

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
        .instruction_out(instruction)
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

        readdata = 32'h0003000A;
        waitrequest = 1'b0;
        #2;

        waitrequest = 1'b1;
        #2;

        readdata = 32'h00020009;
        waitrequest = 1'b0;
        #2;

        waitrequest = 1'b1;
        #2;

        readdata = 32'h00010008;
        waitrequest = 1'b0;
        #2;

        waitrequest = 1'b1;
        #2;

        readdata = 32'h00000007;
        waitrequest = 1'b0;
        #2;

        waitrequest = 1'b1;
        irq = 1'b0;
        #2;


    end

endmodule