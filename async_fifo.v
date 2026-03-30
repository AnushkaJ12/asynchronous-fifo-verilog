module async_fifo #(
    parameter DATASIZE = 8,
    parameter ADDRSIZE = 3
)(
    input                     wclk, wrst_n,
    input                     rclk, rrst_n,
    input                     wen, ren,
    input      [DATASIZE-1:0] wdata,
    output     [DATASIZE-1:0] rdata,
    output                    wfull,
    output                    rempty
);

    wire [ADDRSIZE-1:0] waddr, raddr;
    wire [ADDRSIZE:0]   wptr, rptr;
    wire [ADDRSIZE:0]   wq2_rptr, rq2_wptr;

    fifo_mem #(DATASIZE, ADDRSIZE) u_fifo_mem (
        .wclk  (wclk),
        .wen   (wen),
        .wfull (wfull),
        .waddr (waddr),
        .raddr (raddr),
        .wdata (wdata),
        .rdata (rdata)
    );

    sync_w2r #(ADDRSIZE) u_sync_w2r (
        .rclk     (rclk),
        .rrst_n   (rrst_n),
        .wptr     (wptr),
        .rq2_wptr (rq2_wptr)
    );

    sync_r2w #(ADDRSIZE) u_sync_r2w (
        .wclk     (wclk),
        .wrst_n   (wrst_n),
        .rptr     (rptr),
        .wq2_rptr (wq2_rptr)
    );

    write_ctrl #(ADDRSIZE) u_write_ctrl (
        .wclk     (wclk),
        .wrst_n   (wrst_n),
        .wen      (wen),
        .wq2_rptr (wq2_rptr),
        .wptr     (wptr),
        .wfull    (wfull),
        .waddr    (waddr)
    );

    read_ctrl #(ADDRSIZE) u_read_ctrl (
        .rclk     (rclk),
        .rrst_n   (rrst_n),
        .ren      (ren),
        .rq2_wptr (rq2_wptr),
        .rptr     (rptr),
        .rempty   (rempty),
        .raddr    (raddr)
    );

endmodule