module read_ctrl #(
    parameter ADDRSIZE = 3
)(
    input                     rclk, rrst_n,
    input                     ren,
    input      [ADDRSIZE:0]   rq2_wptr,
    output reg [ADDRSIZE:0]   rptr,
    output reg                rempty,
    output     [ADDRSIZE-1:0] raddr
);

    reg  [ADDRSIZE:0] rbin;
    wire [ADDRSIZE:0] rbin_next;
    wire [ADDRSIZE:0] rgray_next;

    assign rbin_next  = rbin + (ren & ~rempty);
    assign rgray_next = rbin_next ^ (rbin_next >> 1);
    assign raddr      = rbin[ADDRSIZE-1:0];

    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n)
            {rbin, rptr} <= 0;
        else
            {rbin, rptr} <= {rbin_next, rgray_next};
    end

    always @(posedge rclk or negedge rrst_n) begin
        if (!rrst_n)
            rempty <= 1;
        else
            rempty <= (rgray_next == rq2_wptr);
    end

endmodule
