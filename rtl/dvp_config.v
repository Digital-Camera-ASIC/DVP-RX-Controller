module dvp_config
#(
    // AXI4 Interface
    parameter BASE_ADDR         = 32'h4000_0000,    // Memory mapping - BASE
    parameter CONF_OFFSET       = 8'd4,             // Memory mapping - OFFSET
    parameter DATA_W            = 32,
    parameter ADDR_W            = 32,
    parameter MST_ID_W          = 5,
    parameter TRANS_DATA_LEN_W  = 8,
    parameter TRANS_DATA_SIZE_W = 3,
    parameter TRANS_RESP_W      = 2,
    // DVP Configuration
    parameter CONF_ADDR_W       = 1,
    parameter CONF_DATA_W       = 32
)
(   
    // Input declaration
    // -- Global 
    input                       clk,
    input                       rst_n,
    
    // -- to AXI4 Master
    // -- -- AW channel
    input   [MST_ID_W-1:0]      m_awid_i,
    input   [ADDR_W-1:0]        m_awaddr_i,
    input                       m_awvalid_i,
    // -- -- W channel
    input   [DATA_W-1:0]        m_wdata_i,
    input                       m_wvalid_i,
    // -- -- B channel
    input                       m_bready_i,
    // -- -- AR channel
    input   [MST_ID_W-1:0]      m_arid_i,
    input   [ADDR_W-1:0]        m_araddr_i,
    input                       m_arvalid_i,
    // -- -- R channel
    input                       m_rready_i,
    // Output declaration
    // -- -- AW channel
    output                      m_awready_o,
    // -- -- W channel
    output                      m_wready_o,
    // -- -- B channel
    output  [TRANS_RESP_W-1:0]  m_bresp_o,
    output                      m_bvalid_o,
    // -- -- AR channel
    output                      m_arready_o,
    // -- -- R channel 
    output  [DATA_W-1:0]        m_rdata_o,
    output                      m_rvalid_o
);
    // Local parameters 
    localparam CONF_ADDR_NUM    = CONF_ADDR_W<<1;
    localparam AW_INFO_W        = MST_ID_W + ADDR_W;
    localparam W_INFO_W         = DATA_W;
    localparam B_INFO_W         = TRANS_RESP_W;
    localparam AR_INFO_W        = MST_ID_W + ADDR_W;
    localparam R_INFO_W         = DATA_W;
    
    // Internal variables 
    genvar conf_idx;
    // Internal signal
    // -- wire
    // -- -- AXI4 interface
    wire [AW_INFO_W-1:0]        bwd_aw_info;
    
    wire [W_INFO_W-1:0]         bwd_rdata;
    wire                        bwd_r_rdy;
    
    wire [B_INFO_W-1:0]         bwd_b_info;
    wire                        bwd_b_vld;
    wire                        bwd_b_rdy;
    
    wire [AW_INFO_W-1:0]        bwd_ar_info;
    wire [AW_INFO_W-1:0]        fwd_ar_info;
    wire [MST_ID_W-1:0]         fwd_arid;
    wire [ADDR_W-1:0]           fwd_araddr;
    wire                        fwd_ar_vld;
    
    wire [AW_INFO_W-1:0]        fwd_aw_info;
    wire [MST_ID_W-1:0]         fwd_awid;
    wire [ADDR_W-1:0]           fwd_awaddr;
    wire                        fwd_aw_vld;
    wire                        fwd_aw_rdy;
    
    wire [W_INFO_W-1:0]         fwd_wdata;
    wire                        fwd_w_vld;
    wire                        fwd_w_rdy;
    // -- -- Config function
    wire [DATA_W-1:0]           dvp_config_reg;
    wire [DATA_W-1:0]           scaler_config_reg;
    wire [CONF_ADDR_NUM-1:0]    awaddr_map_vld;
    wire                        config_wr_en;
    // -- reg
    reg  [DATA_W-1:0]           ip_config_reg       [0:CONF_ADDR_NUM-1];
    
    // Internal module
    // -- AW channel buffer 
    skid_buffer #(
        .SBUF_TYPE(2),          // Light-weight
        .DATA_WIDTH(AW_INFO_W)
    ) aw_chn_buf (
        .clk        (clk),
        .rst_n      (rst_n),
        .bwd_data_i (bwd_aw_info),
        .bwd_valid_i(m_awvalid_i), 
        .fwd_ready_i(fwd_aw_rdy), 
        .fwd_data_o (fwd_aw_info),
        .bwd_ready_o(m_awready_o), 
        .fwd_valid_o(fwd_aw_vld)
    );
    // -- W channel buffer 
    skid_buffer #(
        .SBUF_TYPE(2),          // Light-weight
        .DATA_WIDTH(W_INFO_W)
    ) w_chn_buf (
        .clk        (clk),
        .rst_n      (rst_n),
        .bwd_data_i (m_wdata_i),
        .bwd_valid_i(m_wvalid_i), 
        .fwd_ready_i(fwd_w_rdy), 
        .fwd_data_o (fwd_wdata),
        .bwd_ready_o(m_wready_o), 
        .fwd_valid_o(fwd_w_vld)
    );
    // -- B channel buffer 
    skid_buffer #(
        .SBUF_TYPE(2),          // Light-weight
        .DATA_WIDTH(B_INFO_W)
    ) b_chn_buf (
        .clk        (clk),
        .rst_n      (rst_n),
        .bwd_data_i (bwd_b_info),
        .bwd_valid_i(bwd_b_vld), 
        .fwd_ready_i(m_bready_i), 
        .fwd_data_o (m_bresp_o),
        .bwd_ready_o(bwd_b_rdy), 
        .fwd_valid_o(m_bvalid_o)
    );
    // -- AR channel buffer 
    skid_buffer #(
        .SBUF_TYPE(2),          // Light-weight
        .DATA_WIDTH(AR_INFO_W)
    ) ar_chn_buf (
        .clk        (clk),
        .rst_n      (rst_n),
        .bwd_data_i (bwd_ar_info),
        .bwd_valid_i(m_arvalid_i), 
        .fwd_ready_i(bwd_r_rdy), 
        .fwd_data_o (fwd_ar_info),
        .bwd_ready_o(m_awready_o), 
        .fwd_valid_o(fwd_ar_vld)
    );
    // -- R channel buffer 
    skid_buffer #(
        .SBUF_TYPE(2),          // Light-weight
        .DATA_WIDTH(R_INFO_W)
    ) r_chn_buf (
        .clk        (clk),
        .rst_n      (rst_n),
        .bwd_data_i (bwd_rdata),
        .bwd_valid_i(fwd_ar_vld), 
        .fwd_ready_i(m_rready_i), 
        .fwd_data_o (m_rdata_o),
        .bwd_ready_o(bwd_r_rdy), 
        .fwd_valid_o(m_rvalid_o)
    );
    
    // Combination logic
    generate 
    for(conf_idx = 0; conf_idx < CONF_ADDR_NUM; conf_idx = conf_idx + 1) begin
        assign awaddr_map_vld[conf_idx] = ~|(fwd_awaddr ^ (BASE_ADDR+conf_idx*CONF_OFFSET));
    end
    endgenerate
    assign config_wr_en = fwd_w_vld & fwd_aw_vld;
    assign bwd_b_vld    = config_wr_en;
    assign fwd_aw_rdy   = config_wr_en & bwd_b_rdy;
    assign fwd_w_rdy    = config_wr_en & bwd_b_rdy;
    assign bwd_aw_info  = {m_awid_i, m_awaddr_i};
    assign bwd_b_info   = (|awaddr_map_vld) ? 2'b00 : 2'b11;    // 2'b00: SUCCESS || 2'b11: Wrong mapping
    assign bwd_rdata    = ip_config_reg[fwd_araddr[CONF_ADDR_W+CONF_OFFSET-1-:CONF_ADDR_W]];
    assign {fwd_arid, fwd_araddr} = fwd_ar_info;
    assign {fwd_awid, fwd_awaddr} = fwd_aw_info;
    // Flip-flop
    generate 
    for(conf_idx = 0; conf_idx < CONF_ADDR_NUM; conf_idx = conf_idx + 1) begin
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            ip_config_reg[conf_idx] <= {DATA_W{1'b0}};
        end
        else if(awaddr_map_vld[conf_idx] & config_wr_en) begin
            ip_config_reg[conf_idx] <= fwd_wdata;
        end
    end
    end
    endgenerate
    
endmodule