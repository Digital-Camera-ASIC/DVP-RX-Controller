// This state machine is a gate for data collection and error detection
module drc_ctrl_state #(
    parameter DVP_DATA_W        = 8,
    parameter PXL_INFO_W        = DVP_DATA_W + 1 + 1,   // FIFO_W =  VSYNC + HSYNC + PIXEL_W
    parameter RGB_PXL_W         = 16,
    // Image configure
    parameter IMG_DIM_MAX       = 640,
    parameter IMG_DIM_W         = $clog2(IMG_DIM_MAX)
) (
    // -- Global
    input                       clk,
    input                       rst_n,
    // Backward
    input   [PXL_INFO_W-1:0]    bwd_pxl_info_dat,
    input                       bwd_pxl_info_vld,
    output                      bwd_pxl_info_rdy,
    // Forward
    output  [RGB_PXL_W-1:0]     fwd_pxl_dat,
    output                      fwd_pxl_last,
    output                      fwd_pxl_vld,
    input                       fwd_pxl_rdy,
    // -- DRC CSRs  
    output                      cam_rx_en,      // Enable camera RX
    output  [1:0]               cam_rx_mode,    // Camera RX mode
    output                      cam_rx_start,   // Start camera RX
    input                       cam_rx_start_qed,// Start signal is queued
    input   [2:0]               cam_rx_state,   // Camera RX state
    input   [IMG_DIM_W*2-1:0]   cam_rx_len,     // Camera RX pixel length
    output                      irq_msk_frm_comp, // IRQ mask Frame completion
    output                      irq_msk_frm_err,  // IRQ mask Frame error
    output  [IMG_DIM_W-1:0]     img_width,      // Image width
    output  [IMG_DIM_W-1:0]     img_height,     // Image height
    // Interrupt
    output                      irq, // Caused by frame completion
    output                      trap // Caused by pixel misalignment
);

    // Module instantiation
    sync_fifo 
    #(
        .FIFO_TYPE      (3),        // Concat FIFO
        .DATA_WIDTH     (RGB_PXL_W),
        .IN_DATA_WIDTH  (DVP_DATA_W),
        .CONCAT_ORDER   ("MSB")
    ) concat_fifo (
        .clk            (clk),
        .data_i         (dvp_pxl_data),
        .data_o         (rgb_pxl_o),
        .wr_valid_i     (pxl_info_vld),
        .wr_ready_o     (pxl_info_rdy),
        .rd_valid_i     (rgb_pxl_rdy_i),
        .rd_ready_o     (rgb_pxl_vld_o),
        .empty_o        (),
        .full_o         (),
        .almost_empty_o (),
        .almost_full_o  (),
        .counter        (),
        .rst_n          (rst_n)
    );
endmodule
