module fifo_mem #(
    parameter DATASIZE = 8,
    parameter ADDRSIZE = 3
)(
    input                     wclk, wen, wfull,
    input      [ADDRSIZE-1:0] waddr,
    input      [ADDRSIZE-1:0] raddr,
    input      [DATASIZE-1:0] wdata,
    output     [DATASIZE-1:0] rdata
);

    reg [DATASIZE-1:0] mem [0:(1<<ADDRSIZE)-1];

    assign rdata = mem[raddr];

    always @(posedge wclk) begin
        if (wen && !wfull)
            mem[waddr] <= wdata;
    end

endmodule