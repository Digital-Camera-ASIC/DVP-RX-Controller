module drc_dvp_data_fifo #(
    parameter DVP_DATA_W    = 8,
    parameter PXL_FIFO_D    = 32,   /* Caution: Full FIFO can cause data loss */
    // Do not configure
    parameter PXL_INFO_W    = DVP_DATA_W + 1 + 1 // FIFO_W =  VSYNC + HSYNC + PIXEL_W
) (
    input                       clk,
    input                       rst_n,
    // -- DVP Configuration register
    input                       cam_rx_en,
    // -- DVP Camera interface
    input                       dvp_pclk_i,
    input   [DVP_DATA_W-1:0]    dvp_d_i,
    input                       dvp_href_i,
    input                       dvp_vsync_i,
    input                       dvp_hsync_i,
    // -- Pixel Info 
    output  [PXL_INFO_W-1:0]    pxl_info_dat,
    output                      pxl_info_vld,
    input                       pxl_info_rdy
);
    // Internal signal
    // -- wire  
    wire                        vsync_rising;   // PCLK domain
    wire                        href_rising;    // PCLK domain
    reg                         vsync_flag_d;   // PCLK domain
    wire                        dvp_d_vld;      // PCLK domain
    wire    [PXL_INFO_W-1:0]    ff_data_in;     // PCLK domain
    // -- reg
    reg                         vsync_flag_q;   // PCLK domain
    // Internal module 
    // -- Asynchronous FIFO
    asyn_fifo #(
        .ASFIFO_TYPE    (0),            // Normal type
        .DATA_WIDTH     (PXL_INFO_W),   // VSYNC + HSYNC + PIXEL_W 
        .FIFO_DEPTH     (PXL_FIFO_D)
    ) asf (
        // PCLK domain
        .clk_wr_domain  (dvp_pclk_i),
        .data_i         (ff_data_in),
        .wr_valid_i     (dvp_d_vld),
        .wr_ready_o     (),
        .full_o         (), /* Caution: FIFO full state can cause data missing */
        .almost_full_o  (),
        // System clock domain
        .clk_rd_domain  (clk),
        .data_o         (pxl_info_dat),
        .rd_valid_i     (pxl_info_rdy),
        .rd_ready_o     (pxl_info_vld),
        .empty_o        (),
        .almost_empty_o (),
        .rst_n          (rst_n) // PROVED: rst_n remains stable at HIGH, then dvp_pclk_i starts toggling
        );
    // -- VSYNC detector
    edgedet #(
        .RISING_EDGE(1'b1) // Rising
    ) vsync_det (
        .clk    (dvp_pclk_i),
        .rst_n  (rst_n),        // PROVED: rst_n remains stable at HIGH, then dvp_pclk_i starts toggling
        .en     (cam_rx_en),    // PROVED: cam_rx_en remains stable at HIGH, then dvp_pclk_i starts toggling 
        .i      (dvp_vsync_i),
        .o      (vsync_rising)
    );
    // -- HREF detector
    edgedet #(
        .RISING_EDGE(1'b1) // Rising
    ) href_det (
        .clk    (dvp_pclk_i),
        .rst_n  (rst_n),        // PROVED: rst_n remains stable at HIGH, then dvp_pclk_i starts toggling
        .en     (cam_rx_en),    // PROVED: cam_rx_en remains stable at HIGH, then dvp_pclk_i starts toggling
        .i      (dvp_href_i),
        .o      (href_rising)
    );
    // Combination logic
    assign ff_data_in   = {vsync_flag_q, href_rising, dvp_d_i};
    assign dvp_d_vld    = dvp_href_i & cam_rx_en; // PROVED: cam_rx_en remains stable at HIGH, then dvp_pclk_i starts toggling
    always @* begin
        vsync_flag_d = vsync_flag_q;
        if(vsync_rising) begin
            vsync_flag_d = 1'b1;
        end
        else if(dvp_d_vld) begin
            vsync_flag_d = 1'b0;
        end
    end
    // Flip-flop
    always @(posedge dvp_pclk_i or negedge rst_n) begin
        if(!rst_n) begin    // PROVED: rst_n remains stable at HIGH, then dvp_pclk_i starts toggling
            vsync_flag_q <= 1'b0;
        end
        else begin
            vsync_flag_q <= vsync_flag_d;
        end
    end
endmodule
