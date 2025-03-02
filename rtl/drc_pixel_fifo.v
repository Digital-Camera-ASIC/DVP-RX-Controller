module drc_pixel_fifo #(
    parameter DVP_DATA_W    = 8,
    parameter PXL_FIFO_D    = 32,   /* Caution: Full FIFO can cause data loss */
    // Do not configure
    parameter PXL_INFO_W    = DVP_DATA_W + 1 + 1 // FIFO_W =  VSYNC + HSYNC + PIXEL_W
)
(
    // Input declaraion
    // -- Global
    input                       clk,
    input                       rst_n,
    // -- DVP Configuration register
    input                       cam_rx_en,
    // -- DVP Camera interface
    input   [DVP_DATA_W-1:0]    dvp_d_i,
    input                       dvp_href_i,
    input                       dvp_vsync_i,
    input                       dvp_hsync_i,
    // -- DVP PCLK synchronizer
    input                       pclk_sync,
    // -- Pixel Info 
    output  [PXL_INFO_W-1:0]    pxl_info_dat,
    output                      pxl_info_vld,
    input                       pxl_info_rdy
);
    // Internal signal
    // -- wire  
    wire                        vsync_rising;
    wire                        hsync_rising;
    reg                         vsync_flag_d;
    reg                         hsync_flag_d;
    wire                        dvp_d_vld;
    wire    [PXL_INFO_W-1:0]    ff_data_in;
    // -- reg
    reg                         vsync_flag_q;
    reg                         hsync_flag_q;
    // Internal module 
    // -- FIFO
    sync_fifo #(
        .FIFO_TYPE  (0),
        .DATA_WIDTH (PXL_INFO_W),    // PIXEL_W + VSYNC + HSYNC
        .FIFO_DEPTH (PXL_FIFO_D)
    ) fifo (
        .clk            (clk),
        .rst_n          (rst_n),
        .data_i         (ff_data_in),
        .data_o         (pxl_info_dat),
        .wr_valid_i     (dvp_d_vld),
        .rd_valid_i     (pxl_info_rdy),
        .empty_o        (),
        .full_o         (), /* Caution: FIFO full state can cause data missing */
        .wr_ready_o     (),
        .rd_ready_o     (pxl_info_vld),
        .almost_empty_o (),
        .almost_full_o  (),
        .counter        ()
    );
    // -- VSYNC detector
    edgedet #(
        .RISING_EDGE(1'b1) // Rising
    ) vsync_det (
        .clk    (clk),
        .rst_n  (rst_n),
        .en     (cam_rx_en),
        .i      (dvp_vsync_i),
        .o      (vsync_rising)
    );
    // -- HSYNC detector
    edgedet #(
        .RISING_EDGE(1'b1) // Rising
    ) hsync_det (
        .clk    (clk),
        .rst_n  (rst_n),
        .en     (cam_rx_en),
        .i      (dvp_hsync_i),
        .o      (hsync_rising)
    );
    // Combination logic
    assign ff_data_in   = {vsync_flag_q, hsync_flag_q, dvp_d_i};
    assign dvp_d_vld    = dvp_href_i & pclk_sync & cam_rx_en;
    always @* begin
        vsync_flag_d = vsync_flag_q;
        if(vsync_rising) begin
            vsync_flag_d = 1'b1;
        end
        else if(dvp_d_vld) begin
            vsync_flag_d = 1'b0;
        end
    end
    always @* begin
        hsync_flag_d = hsync_flag_q;
        if(hsync_rising) begin
            hsync_flag_d = 1'b1;
        end
        else if(dvp_d_vld) begin
            hsync_flag_d = 1'b0;
        end
    end
    // Flip-flop
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            hsync_flag_q <= 1'b0;
        end
        else begin
            hsync_flag_q <= hsync_flag_d;
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            vsync_flag_q <= 1'b0;
        end
        else begin
            vsync_flag_q <= vsync_flag_d;
        end
    end
endmodule
