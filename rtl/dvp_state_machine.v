module dvp_state_machine
#(
    parameter DVP_DATA_W        = 8,
    parameter PXL_INFO_W        = DVP_DATA_W + 1 + 1,   // FIFO_W =  VSYNC + HSYNC + PIXEL_W
    parameter RGB_PXL_W         = 16,
    parameter GS_PXL_W          = 8
)
(
    // Input declaration
    // -- Global
    input                       clk,
    input                       rst_n,
    // -- Pixel FIFO
    input   [PXL_INFO_W-1:0]    pxl_info_i,
    input                       pxl_info_vld_i,
    // -- DVP configuration register
    input                       dcr_cam_start_i,
    // -- Gray-scale
    input                       rgb_pxl_rdy_i,
    // Output declaration
    // -- Pixel FIFO
    output                      pxl_info_rdy_o,
    // -- Gray-scale 
    output  [GS_PXL_W-1:0]      rgb_pxl_o,
    output                      rgb_pxl_vld_o
);
    // Local parameter 
    localparam IDLE_ST  = 1'd0;
    localparam WORK_ST  = 1'd1;
    // Internal signal 
    // -- wire
    wire    [DVP_DATA_W-1:0]    dvp_pxl_data;
    reg                         dvp_st_d;
    wire                        pf_hsk;
    wire    [RGB_PXL_W-1:0]     rgb_pxl_d;
    // -- reg
    reg                         dvp_st_q;
    reg                         rgb_pxl_comp_q;
    reg     [RGB_PXL_W-1:0]     rgb_pxl_q;
    
    // Combination logic
    assign rgb_pxl_o = rgb_pxl_q;
    assign rgb_pxl_vld_o = rgb_pxl_comp_q;
    assign pxl_info_rdy_o = (dvp_st_q == WORK_ST) & ((~rgb_pxl_comp_q) | (rgb_pxl_comp_q & rgb_pxl_rdy_i));
    assign dvp_pxl_data =  pxl_info_i[DVP_DATA_W-1:0];
    assign pf_hsk = pxl_info_vld_i & pxl_info_rdy_o;
    assign rgb_pxl_d[DVP_DATA_W-1:0] = (~rgb_pxl_comp_q) ? dvp_pxl_data : rgb_pxl_q[DVP_DATA_W-1:0];
    assign rgb_pxl_d[RGB_PXL_W-1-:DVP_DATA_W] = (rgb_pxl_comp_q) ? dvp_pxl_data : rgb_pxl_q[RGB_PXL_W-1-:DVP_DATA_W];
    always @* begin
        dvp_st_d = dvp_st_q;
        case(dvp_st_q) 
            IDLE_ST: begin
                if(dcr_cam_start_i) begin
                    dvp_st_d = WORK_ST;
                end
            end
            WORK_ST: begin
                // TODO: Updated in next versions
                // - Check VSYNC & HSYNC -> Error Interrupt
                // - Stall mode
                // - etc
            end
        endcase
    end
    
    // Flip-flop 
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            dvp_st_q <= 1'd0;
        end
        else begin
            dvp_st_q <= dvp_st_d;
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            rgb_pxl_comp_q <= 1'b0;
        end
        else if(pf_hsk) begin
            rgb_pxl_comp_q <= ~rgb_pxl_comp_q;
        end
    end
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            rgb_pxl_q <= {RGB_PXL_W{1'b0}};
        end
        else if(pf_hsk) begin
            rgb_pxl_q <= rgb_pxl_d;
        end
    end
endmodule
