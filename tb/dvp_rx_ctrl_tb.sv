`timescale 1ns / 1ps

`define DUT_CLK_PERIOD  2
`define DVP_CLK_PERIOD  12
`define RST_DLY_START   3
`define RST_DUR         9

// DVP Physical characteristic
// -- t_PDV = 5 ns = (5/INTERNAL_CLK_PERIOD)*DUT_CLK_PERIOD = (5/8)*2
`define DVP_PCLK_DLY    1.25

module dvp_rx_ctrl_tb;
    // AXI configuration
    localparam DATA_W            = 32;
    localparam ADDR_W            = 32;
    localparam MST_ID_W          = 5;
    localparam TRANS_DATA_LEN_W  = 8;
    localparam TRANS_DATA_SIZE_W = 3;
    localparam TRANS_RESP_W      = 2;
    // DVP configuration
    localparam DVP_DATA_W        = 8;
    localparam PXL_INFO_W        = DVP_DATA_W + 1 + 1;   // FIFO_W =  VSYNC + HSYNC + PIXEL_W
    localparam RGB_PXL_W         = 16;
    localparam GS_PXL_W          = 8;
    
    
    // Input declaration
    logic                           clk;
    logic                           rst_n;
    // -- DVP RX interface
    logic   [DVP_DATA_W-1:0]        dvp_d_i;
    logic                           dvp_href_i;
    logic                           dvp_vsync_i;
    logic                           dvp_hsync_i;
    logic                           dvp_pclk_i;
    // -- AXI4 interface (pixel transfer)
    // -- -- AW channel
    logic                           s_awready_i;
    // -- -- W channel
    logic                           s_wready_i;
    // -- -- B channel
    logic   [MST_ID_W-1:0]          s_bid_i;
    logic   [TRANS_RESP_W-1:0]      s_bresp_i;
    logic                           s_bvalid_i;
    // -- AXI4 interface (configuration)
    // -- -- AW channel
    logic   [MST_ID_W-1:0]          m_awid_i;
    logic   [ADDR_W-1:0]            m_awaddr_i;
    logic                           m_awvalid_i;
    // -- -- W channel
    logic   [DATA_W-1:0]            m_wdata_i;
    logic                           m_wvalid_i;
    // -- -- B channel
    logic                           m_bready_i;
    // -- -- AR channel
    logic   [MST_ID_W-1:0]          m_arid_i;
    logic   [ADDR_W-1:0]            m_araddr_i;
    logic                           m_arvalid_i;
    // -- -- R channel
    logic                           m_rready_i;
    // Output declaration
    // -- DVP RX interface
    logic                          dvp_xclk_o;
    logic                          dvp_pwdn_o;
    // -- AXI4 interface (pixels transfer)
    // -- -- AW channel
    logic  [MST_ID_W-1:0]          s_awid_o;
    logic  [ADDR_W-1:0]            s_awaddr_o;
    logic                          s_awvalid_o;
    // -- -- W channel
    logic  [DATA_W-1:0]            s_wdata_o;
    logic                          s_wlast_o;
    logic                          s_wvalid_o;
    // -- -- B channel
    logic                          s_bready_o;
    // -- AXI4 interface (configuration)
    // -- -- AW channel
    logic                          m_awready_o;
    // -- -- W channel
    logic                          m_wready_o;
    // -- -- B channel
    logic  [TRANS_RESP_W-1:0]      m_bresp_o;
    logic                          m_bvalid_o;
    // -- -- AR channel
    logic                          m_arready_o;
    // -- -- R channel
    logic  [DATA_W-1:0]            m_rdata_o;
    logic  [TRANS_RESP_W-1:0]      m_rresp_o;
    logic                          m_rvalid_o;
    
    
    dvp_rx_controller #(
    
    ) dut (
        .*
    );
    
    initial begin
        clk     <= 0;
        rst_n   <= 1;
        
        // DVP interface
        dvp_d_i     <= 0;    
        dvp_href_i  <= 0;
        dvp_vsync_i <= 0;
        dvp_hsync_i <= 0;
        dvp_pclk_i  <= 0;
        // AXI4 Pixel TX ìnterface
        s_awready_i <= 1;
        s_wready_i  <= 1;
        s_bid_i     <= 0;
        s_bresp_i   <= 0;
        s_bvalid_i  <= 0;
        // AXI4 Configuration ìnterface
        m_awid_i    <= 0;
        m_awaddr_i  <= 0;
        m_awvalid_i <= 0;
        m_wdata_i   <= 0;
        m_wvalid_i  <= 0;
        m_bready_i  <= 1;
        m_arid_i    <= 0;
        m_araddr_i  <= 0;
        m_arvalid_i <= 0; 
        
        #(`RST_DLY_START)   rst_n <= 0;
        #(`RST_DUR)         rst_n <= 1;
    end
    
    initial begin
        #(`RST_DLY_START + `RST_DUR + 1);
        forever #(`DUT_CLK_PERIOD/2) clk <= ~clk;
    end
    
    initial begin
        #(`RST_DLY_START + `RST_DUR + 1);
        wait(dvp_pwdn_o == 1'b0); #0.1;
        forever #(`DVP_CLK_PERIOD/2) dvp_pclk_i <= ~dvp_pclk_i;
    end
    
    initial begin
        dvp_driver();
    end 
    
    task automatic dvp_driver();
        // Important note: 
        //      - Data and Control signal in DVP are changed in FALLING edge of PCLK
        //          + T_clk_delay   = 5ns
        //          + T_setup       = 15ns
        //          + T_hold        = 8ns
        //      -> Data will be stable befor RISING edge 
        //      -> (Delay time to sample data at RISING edge) < 8ns
        localparam IDLE_ST              = 0;
        localparam SOF_ST               = 1;
        localparam PRE_TXN_ST           = 2;
        localparam PRE_HSYNC_FALL_ST    = 3;
        localparam HSYNC_FALL_ST        = 4;
        localparam PRE_TX_ST            = 5;
        localparam TX_ST                = 6;
        localparam POST_TXN             = 7;
        localparam EOF_ST               = 8;
        int dvp_st                      = IDLE_ST;
        int pclk_cnt                    = 0;
        int tx_cnt                      = 0;
        int stall_cnt                   = 0;
        while(1'b1) begin
            stall_cnt = $urandom_range(10, 20);
            repeat(stall_cnt) begin
                pclk_cl;  
            end
            while (1'b1) begin
                case(dvp_st)
                    IDLE_ST: begin
                        // Update state
                        dvp_st      = SOF_ST;
                        // Set up pclk stall
                        // -- Next stall = 3*t_line = 17*(784*t_p) = 3*(784*(2*t_pclk))
                        pclk_cnt    = 3*784*2;
                        // Control signal
                        dvp_vsync_i <= 1'b1;
                    end
                    SOF_ST: begin
                        if(pclk_cnt == 0) begin
                            // Update state
                            dvp_st      = PRE_TXN_ST;
                            // Set up pclk stall
                            // -- Next stall = 17*t_line - 80*t_p - 40*t_p - 19*t_p = 17*(784*t_p) - 80*t_p - 40*t_p - 19*t_p = 17*(784*(2*t_pclk)) - 80*(2*t_pclk) - 40*(2*t_pclk) - 19*(2*t_pclk)
                            pclk_cnt    = 17*784*2 - 80*2 - 40*2 - 19*2;
                            // Control signal
                            dvp_vsync_i <= 1'b0;
                        end
                    end
                    PRE_TXN_ST: begin
                        if(pclk_cnt == 0) begin
                            // Update state
                            dvp_st      = PRE_HSYNC_FALL_ST;
                            // Set up pclk stall
                            // -- Next stall = 19*t_p = 19*t_p = 19*(2*t_pclk)
                            pclk_cnt    = 19*2;
                            // Control signal
                            dvp_hsync_i <= 1'b1;
                        end
                    end
                    PRE_HSYNC_FALL_ST: begin
                        if(pclk_cnt == 0) begin
                            // Update state
                            dvp_st      = HSYNC_FALL_ST;
                            // Set up pclk stall
                            // -- Next stall = 19*t_p = 19*t_p = 19*(2*t_pclk)
                            pclk_cnt    = 80*2;
                            // Control signal
                            dvp_hsync_i <= 1'b0;
                        end
                    end
                    HSYNC_FALL_ST: begin
                        if(pclk_cnt == 0) begin
                            // Update state
                            dvp_st      = PRE_TX_ST;
                            // Set up pclk stall
                            // -- Next stall = 19*t_p = 19*t_p = 19*(2*t_pclk)
                            pclk_cnt    = 40*2;
                            // Control signal
                            dvp_hsync_i <= 1'b1;
                        end
                    end
                    PRE_TX_ST: begin
                        if(pclk_cnt == 0) begin
                            if(tx_cnt == (640*480)) begin // Frame receiving is completed
                                // Update state
                                dvp_st      = POST_TXN;
                                // Set up pclk stall
                                // -- Next stall = 10*t_line - 80*t_p - 40*t_p - 19*t_p = 10*(784*t_p) - 80*t_p - 40*t_p - 19*t_p = 10*(784*(2*t_pclk)) - 80*(2*t_pclk) - 40*(2*t_pclk) - 19*(2*t_pclk)
                                pclk_cnt    = 10*784*2 - 80*2 - 40*2 - 19*2;
                                tx_cnt      = 0;
                                // Control signal
//                                dvp_hsync_i <= 1'b1;
                            end
                            else begin
                                // Update state
                                dvp_st      = TX_ST;
                                // Set up pclk stall
                                // -- Next stall = 10*t_line - 80*t_p - 40*t_p - 19*t_p = 10*(784*t_p) - 80*t_p - 40*t_p - 19*t_p = 10*(784*(2*t_pclk)) - 80*(2*t_pclk) - 40*(2*t_pclk) - 19*(2*t_pclk)
                                tx_cnt      = 0;
                                // Control signal
                                dvp_href_i  <= 1'b1;
                                // Data signal
                                dvp_d_i     <= tx_cnt;
                            end
                        end
                        // TODO: Transfer pixel
                    end
                    TX_ST: begin
                        // TODO: Transfer pixel
                        tx_cnt = tx_cnt + 1;
                        if(tx_cnt%640 == 0) begin
                            // Update state
                            dvp_st      = PRE_HSYNC_FALL_ST;
                            // Set up pclk stall
                            // -- Next stall = 19*t_p = 19*t_p = 19*(2*t_pclk)
                            pclk_cnt    = 19*2;
                            // Control signal
                            dvp_hsync_i <= 1'b1;
                            dvp_href_i  <= 1'b0;
                        end
                    end
                    POST_TXN: begin
                        if(pclk_cnt == 0) begin
                            // Update state
                            dvp_st      = EOF_ST;
                            // Set up pclk stall
                            // -- Next stall = 3*t_line = 17*(784*t_p) = 3*(784*(2*t_pclk))
                            pclk_cnt    = 3*784*2;
                            // Control signal
                            dvp_vsync_i <= 1'b1;
                        end
                    end
                    EOF_ST: begin
                        if(pclk_cnt == 0) begin
                            // Update state
                            dvp_st      = EOF_ST;
                            // Set up pclk stall
                            // -- Next stall = 3*t_line = 17*(784*t_p) = 3*(784*(2*t_pclk))
                            pclk_cnt    = 3*784*2;
                            // Control signal
                            dvp_vsync_i <= 1'b0;
                        end
                    end
                endcase
                // Synchronize FSM 
                pclk_cl;
                pclk_cnt = pclk_cnt - 1;
            end
        end
    endtask
    task automatic pclk_cl;
        @(negedge dvp_pclk_i);
        #(`DVP_PCLK_DLY); 
    endtask
endmodule
