module memory_manager#(
    ADDRESS_WIDTH = 11
    )
    (
        input logic clock_in,
        input logic ready_in,
        input logic [15:0] instruction_in,
        output logic memory_wr_out = 1'b0,
        output logic [ADDRESS_WIDTH - 1:0] memory_address_out,
        output logic [15:0] instruction_out
    );

logic write_rq = 1'b0, write_finished = 1'b1;
logic [ADDRESS_WIDTH - 1:0] memory_address = {ADDRESS_WIDTH{1'b0}};
int counter = 0;

always_ff @(posedge ready_in or posedge write_finished) 
begin
    if(write_finished)
        write_rq <= !write_rq;

    else
        write_rq <= 1'b1;
end

always_ff @(posedge clock_in) 
begin
    if(write_rq)
    begin
        instruction_out <= instruction_in;

        if(counter<1)
        begin
            memory_wr_out <= 1'b1;
            counter += 1;
            write_finished <= 1'b0;
        end

        else
        begin
            memory_wr_out <= 1'b0;
            counter = 0;
            write_finished <= 1'b1;

            if(instruction_in == 16'h0000)
            memory_address <= {ADDRESS_WIDTH{1'b0}};

            else
            memory_address <= memory_address + 1'b1;
        end
    end
end

assign memory_address_out = memory_address;

endmodule