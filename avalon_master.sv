module avalon_master(
    input logic clock_n_in,
    input logic [31:0] readdata_in,
    input logic waitrequest_in,
    input logic irq_in,
    output logic chipselect_out,
    output logic address_out,
    output logic read_n_out,
    output logic write_n_out,
    output logic ready_out = 1'b1,
    output logic [15:0] instruction_out = 16'h0000
);

 
logic read_rq = 1'b0, read_finished = 1'b1, half_word = 1'b1;
logic address = 1'b0, waitrequest_edge = 1'b0, interruption_enable = 1'b1;
logic [7:0] r_byte = 8'h00;
int counter = 0;

initial 
begin
    chipselect_out <= 1'b1;
    read_n_out <= 1'b1;
    write_n_out <= 1'b0;
    address = 1'b1;
end

always @(posedge irq_in or posedge read_finished) 
begin
    if(read_finished)
		read_rq <= !read_rq;
    else
        read_rq <= 1'b1;
end

always @(read_rq, interruption_enable) 
begin
    if(!interruption_enable)
    begin
        if(read_rq)
        begin
            chipselect_out <= 1'b1;
            read_n_out <= 1'b0;
        end
        
        else
        begin
            chipselect_out <= 1'b0;
            read_n_out <= 1'b1;
        end

        address = 1'b0;
        write_n_out <= 1'b1;
    end

    else
    begin
        chipselect_out <= 1'b1;
        read_n_out <= 1'b1;
        address = 1'b1;
        write_n_out <= 1'b0;
    end
    
end

always_ff @(negedge waitrequest_in) 
begin
    waitrequest_edge <= 1'b1;
end

always_ff @(negedge clock_n_in) 
begin
    if(chipselect_out && !read_n_out && !waitrequest_in)
    begin
        r_byte <= readdata_in[7:0];
        half_word <= !half_word;

        if(readdata_in[31:16] == 16'h0000)
            read_finished <= 1'b1;
        else
            read_finished <= 1'b0;
    end

    else if(waitrequest_edge)
        interruption_enable = 1'b0; 

end

always_latch
begin
    if(half_word)
    begin
        instruction_out[15:8] <= r_byte;
        ready_out <= 1'b1;
    end
    
    else
    begin
        instruction_out[7:0] <= r_byte;
        ready_out <= 1'b0;
    end 
end

assign address_out = address;

endmodule