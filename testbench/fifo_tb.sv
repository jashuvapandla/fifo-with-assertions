`timescale 1ns/1ps

module fifo_tb;

    // FIFO parameters
    parameter DATA_WIDTH = 8;       // Each data item is 8 bits
    parameter FIFO_DEPTH = 8;       // FIFO can store 8 items

    // Clock and reset
    logic clk;                      // Clock signal
    logic rst;                      // Reset signal

    // FIFO control signals
    logic wr_en;                    // Write enable
    logic rd_en;                    // Read enable

    // FIFO data signals
    logic [DATA_WIDTH-1:0] wr_data; // Data going into FIFO
    logic [DATA_WIDTH-1:0] rd_data; // Data coming out of FIFO

    // FIFO status signals
    logic full;                     // 1 when FIFO is full
    logic empty;                    // 1 when FIFO is empty


    // Create FIFO
    fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    ) DUT (

        .clk(clk),
        .rst(rst),

        .wr_en(wr_en),
        .rd_en(rd_en),

        .wr_data(wr_data),
        .rd_data(rd_data),

        .full(full),
        .empty(empty)
    );


    // Generate clock
    // Clock period = 10 ns
    always #5 clk = ~clk;


    // Test sequence
    initial begin

        // Initial values
        clk    = 0;
        rst    = 1;
        wr_en  = 0;
        rd_en  = 0;
        wr_data = 0;

        // Reset FIFO
        #20;
        rst = 0;


        // --------------------------------
        // WRITE DATA INTO FIFO
        // --------------------------------

        // Write 10
        #10;
        wr_en   = 1;
        wr_data = 8'd10;

        #10;

        // Write 20
        wr_data = 8'd20;

        #10;

        // Write 30
        wr_data = 8'd30;

        #10;

        // Stop writing
        wr_en = 0;


        // --------------------------------
        // READ DATA FROM FIFO
        // --------------------------------

        #20;

        // Read first value
        rd_en = 1;

        #10;

        // Read second value
        #10;

        // Read third value
        #10;

        // Stop reading
        rd_en = 0;


        // Finish simulation
        #20;

        $finish;

    end


    // Display FIFO activity
    always @(posedge clk) begin

        $display(
            "Time=%0t | WR=%b | RD=%b | WR_DATA=%d | RD_DATA=%d | FULL=%b | EMPTY=%b",
            $time,
            wr_en,
            rd_en,
            wr_data,
            rd_data,
            full,
            empty
        );

    end

endmodule
