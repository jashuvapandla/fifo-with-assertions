module fifo #(
    parameter DATA_WIDTH = 8,       // Number of bits in each data item
    parameter FIFO_DEPTH = 8        // Number of items FIFO can store
)(
    input  logic                  clk,       // Clock signal
    input  logic                  rst,       // Reset signal

    input  logic                  wr_en,     // Write enable: 1 = write data
    input  logic                  rd_en,     // Read enable: 1 = read data

    input  logic [DATA_WIDTH-1:0] wr_data,   // Data to be written into FIFO
    output logic [DATA_WIDTH-1:0] rd_data,   // Data read from FIFO

    output logic                  full,      // 1 = FIFO is full
    output logic                  empty      // 1 = FIFO is empty
);

    // Memory used to store FIFO data
    logic [DATA_WIDTH-1:0] memory [0:FIFO_DEPTH-1];

    // Points to the location where the next data will be written
    logic [2:0] wr_ptr;

    // Points to the location from where the next data will be read
    logic [2:0] rd_ptr;

    // Number of data items currently stored in FIFO
    logic [3:0] count;


    // Main FIFO operation
    always_ff @(posedge clk or posedge rst) begin

        // Reset FIFO
        if (rst) begin
            wr_ptr  <= 0;       // Reset write pointer
            rd_ptr  <= 0;       // Reset read pointer
            count   <= 0;        // FIFO contains 0 items
            rd_data <= 0;        // Clear output data
        end

        else begin

            // Write data when write is enabled and FIFO is not full
            if (wr_en && !full) begin
                memory[wr_ptr] <= wr_data;
                wr_ptr <= wr_ptr + 1;
            end

            // Read data when read is enabled and FIFO is not empty
            if (rd_en && !empty) begin
                rd_data <= memory[rd_ptr];
                rd_ptr <= rd_ptr + 1;
            end

            // Update number of items in FIFO
            case ({wr_en && !full, rd_en && !empty})

                2'b10: count <= count + 1;  // Write only → increase count

                2'b01: count <= count - 1;  // Read only → decrease count

                2'b11: count <= count;      // Read + Write → count unchanged

                default: count <= count;    // Nothing happens

            endcase

        end
    end


    // FIFO status signals

    assign empty = (count == 0);          // FIFO empty when count is 0

    assign full = (count == FIFO_DEPTH);  // FIFO full when count reaches depth

        // =========================================================
    // SYSTEMVERILOG ASSERTIONS
    // =========================================================

    // 1. Do not write when FIFO is full
    property no_write_when_full;
        @(posedge clk)
        full |-> !(wr_en);
    endproperty

    assert property (no_write_when_full)
        else $error("ERROR: Write attempted when FIFO is FULL");


    // 2. Do not read when FIFO is empty
    property no_read_when_empty;
        @(posedge clk)
        empty |-> !(rd_en);
    endproperty

    assert property (no_read_when_empty)
        else $error("ERROR: Read attempted when FIFO is EMPTY");


    // 3. FIFO should be empty after reset
    property fifo_empty_after_reset;
        @(posedge clk)
        rst |-> empty;
    endproperty

    assert property (fifo_empty_after_reset)
        else $error("ERROR: FIFO is not EMPTY during reset");


    // 4. FIFO count should never exceed its depth
    property count_within_limit;
        @(posedge clk)
        count <= FIFO_DEPTH;
    endproperty

    assert property (count_within_limit)
        else $error("ERROR: FIFO count exceeded maximum depth");

endmodule
