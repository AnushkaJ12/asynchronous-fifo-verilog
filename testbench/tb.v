module tb_async_fifo;

  reg        wclk, wrst_n;
  reg        rclk, rrst_n;
  reg        wen, ren;
  reg  [7:0] wdata;
  
  wire [7:0] rdata;
  wire wfull;
  wire rempty;
  
 async_fifo #(
        .DATASIZE(8),
        .ADDRSIZE(3)
) dut (
        .wclk   (wclk),
        .wrst_n (wrst_n),
        .rclk   (rclk),
        .rrst_n (rrst_n),
        .wen    (wen),
        .ren    (ren),
        .wdata  (wdata),
        .rdata  (rdata),
        .wfull  (wfull),
        .rempty (rempty)
);

 initial wclk = 0;
    always #5 wclk = ~wclk;
  
 initial rclk=0;
    always #8 rclk= ~rclk;
  
  
initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_async_fifo);
end
  
  
integer i;

    initial begin
       
        // RESET
       
        wrst_n = 0; rrst_n = 0;
        wen    = 0; ren    = 0;
        wdata  = 0;
        #20;
        wrst_n = 1; rrst_n = 1;
        #10;

        
        // TEST 1 - write 8 items (fill completely)
        
        $display("TEST 1: Writing 8 items");
        for (i = 0; i < 8; i = i + 1) begin
            @(posedge wclk);
            wen   = 1;
            wdata = i + 1;    // data = 1,2,3,4,5,6,7,8
        end
        @(posedge wclk);
        wen = 0;
        #20;
        $display("wfull = %b (should be 1)", wfull);

        
        // TEST 2 - read all 8 items (empty completely)
        
        $display("TEST 2: Reading 8 items");
        for (i = 0; i < 8; i = i + 1) begin
            @(posedge rclk);
            ren = 1;
        end
        @(posedge rclk);
        ren = 0;
        #40;
        $display("rempty = %b (should be 1)", rempty);

        
        // TEST 3 - simultaneous read and write
        
        $display("TEST 3: Simultaneous read and write");
        @(posedge wclk);
        wen   = 1;
        wdata = 8'hAA;
        @(posedge rclk);
        ren   = 1;
        #40;
        wen = 0;
        ren = 0;

      
        // TEST 4 - write when full (should be ignored)
        
        $display("TEST 4: Write when full");
        for (i = 0; i < 8; i = i + 1) begin
            @(posedge wclk);
            wen   = 1;
            wdata = i + 10;
        end
        @(posedge wclk);      // extra write when full
        wdata = 8'hFF;        // this should be ignored
        #20;
        wen = 0;
        $display("wfull = %b (should be 1)", wfull);

        
        // END
                #100;
        $display("Simulation Complete!");
        $finish;
    end

endmodule
