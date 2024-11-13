module dvp_rx_controller
#(
    // AXI configuration
    parameter DATA_W            = 32,
    parameter ADDR_W            = 32,
    parameter MST_ID_W          = 5,
    parameter TRANS_DATA_LEN_W  = 8,
    parameter TRANS_DATA_SIZE_W = 3,
    parameter TRANS_RESP_W      = 2,
    // DVP configuration
    parameter DVP_DAT_W = 7
)
(
    // Input declaration
    // -- DVP RX interface
    input   [DVP_DAT_W-1:0]         dvp_d_i,
    input                           dvp_href_i,
    input                           dvp_vsync_i,
    input                           dvp_hsync_i,
    input                           dvp_pclk_i,
    // -- AXI4 interface (pixel transfer)
    // -- -- AW channel
    input                           s_awready_i,
    // -- -- W channel
    input                           s_wready_i,
    // -- -- B channel
    input   [MST_ID_W-1:0]          s_bid_i,
    input   [TRANS_RESP_W-1:0]      s_bresp_i,
    input                           s_bvalid_i,
    // -- AXI4 interface (configuration)
    // -- -- AW channel
    input   [MST_ID_W-1:0]          m_awid_i,
    input   [ADDR_W-1:0]            m_awaddr_i,
    input                           m_awvalid_i,
    // -- -- W channel
    input   [DATA_W-1:0]            m_wdata_i,
    input                           m_wvalid_i,
    // -- -- B channel
    input                           m_bready_i,
    // -- -- AR channel
    input   [MST_ID_W-1:0]          m_arid_i,
    input   [ADDR_W-1:0]            m_araddr_i,
    input                           m_arvalid_i,
    // -- -- R channel
    input                           m_rready_i,
    // Output declaration
    // -- DVP RX interface
    output                          dvp_pwdn_o,
    output                          dvp_xclk_o,
    // -- AXI4 interface (pixels transfer)
    // -- -- AW channel
    output  [MST_ID_W-1:0]          s_awid_o,
    output  [ADDR_W-1:0]            s_awaddr_o,
    output  [TRANS_DATA_LEN_W-1:0]  s_awlen_o,
    output  [TRANS_DATA_SIZE_W-1:0] s_awsize_o,
    output                          s_awvalid_o,
    // -- -- W channel
    output  [DATA_W-1:0]            s_wdata_o,
    output                          s_wvalid_o,
    // -- -- B channel
    output                          s_bready_o,
    // -- AXI4 interface (configuration)
    // -- -- AW channel
    output                          m_awready_o,
    // -- -- W channel
    output                          m_wready_o,
    // -- -- B channel
    output  [TRANS_RESP_W-1:0]      m_bresp_o,
    output                          m_bvalid_o,
    // -- -- AR channel
    output                          m_arready_o,
    // -- -- R channel
    output  [DATA_W-1:0]            m_rdata_o,
    output  [TRANS_RESP_W-1:0]      m_rresp_o,
    output                          m_rvalid_o
);
    dvp_camera_controller #(
    
    ) dvp_camera_controller (
    
    );
    
    dvp_pclk_sync #(
    
    ) dvp_pclk_synchronizer (
    
    );
    
    dvp_state_machine #(
    
    ) dvp_rx_state_machine (
    
    );
    
    pixel_fifo #(
    
    ) pixel_fifo (
    
    );
    
    pixel_gray_scale #(
    
    ) pixel_gray_scale (
    
    );
    
    pixel_downscaler_fifo #(
    
    ) pixel_downscaler_fifo (
    
    );
endmodule
