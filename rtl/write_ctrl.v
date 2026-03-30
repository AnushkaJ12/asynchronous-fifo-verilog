module write_ctrl #(
    parameter ADDRSIZE = 3
)(
    input                     wclk, wrst_n,
    input                     wen,
    input      [ADDRSIZE:0]   wq2_rptr,
    output reg [ADDRSIZE:0]   wptr,
    output reg                wfull,
    output     [ADDRSIZE-1:0] waddr
);

    reg  [ADDRSIZE:0] wbin;
    wire [ADDRSIZE:0] wbin_next;
    wire [ADDRSIZE:0] wgray_next;

    assign wbin_next  = wbin + (wen & ~wfull);
    assign wgray_next = wbin_next ^ (wbin_next >> 1);
    assign waddr      = wbin[ADDRSIZE-1:0];

    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n)
            {wbin, wptr} <= 0;
        else
            {wbin, wptr} <= {wbin_next, wgray_next};
    end

    always @(posedge wclk or negedge wrst_n) begin
        if (!wrst_n)
            wfull <= 0;
        else
            wfull <= (wgray_next[ADDRSIZE]     != wq2_rptr[ADDRSIZE])   &&
                     (wgray_next[ADDRSIZE-1]   != wq2_rptr[ADDRSIZE-1]) &&
                     (wgray_next[ADDRSIZE-2:0] == wq2_rptr[ADDRSIZE-2:0]);
    end

endmodule
