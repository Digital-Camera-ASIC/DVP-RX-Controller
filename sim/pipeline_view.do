onerror resume
wave tags  F0
wave update off
wave zoom range 627416945 628103457
wave group DVP -backgroundcolor #664400
wave add -group DVP dvp_rx_controller_tb.dvp_d_i -tag F0 -radix hexadecimal
wave add -group DVP dvp_rx_controller_tb.dvp_vsync_i -tag F0 -radix hexadecimal
wave add -group DVP dvp_rx_controller_tb.dvp_href_i -tag F0 -radix hexadecimal
wave add -group DVP dvp_rx_controller_tb.dvp_hsync_i -tag F0 -radix hexadecimal
wave add -group DVP dvp_rx_controller_tb.dvp_pclk_i -tag F0 -radix hexadecimal
wave add -group DVP dvp_rx_controller_tb.dvp_pwdn_o -tag F0 -radix hexadecimal
wave add -group DVP dvp_rx_controller_tb.dvp_xclk_o -tag F0 -radix hexadecimal
wave add -group DVP dvp_rx_controller_tb.dut.pf.dvp_d_vld -tag F0 -radix hexadecimal
wave insertion [expr [wave index insertpoint] + 1]
wave group DVP_CAPTURE -backgroundcolor #666600
wave add -group DVP_CAPTURE dvp_rx_controller_tb.dut.pf.vsync_flag_q -tag F0 -radix hexadecimal
wave add -group DVP_CAPTURE dvp_rx_controller_tb.dut.pf.hsync_flag_q -tag F0 -radix hexadecimal
wave add -group DVP_CAPTURE dvp_rx_controller_tb.dut.pf.dvp_d_i -tag F0 -radix hexadecimal
wave insertion [expr [wave index insertpoint] + 1]
wave group DRC_Slave -backgroundcolor #004466
wave group DRC_Slave:AW -backgroundcolor #006666
wave add -group DRC_Slave:AW dvp_rx_controller_tb.s_awid_i -tag F0 -radix hexadecimal
wave add -group DRC_Slave:AW dvp_rx_controller_tb.s_awaddr_i -tag F0 -radix hexadecimal
wave add -group DRC_Slave:AW dvp_rx_controller_tb.s_awburst_i -tag F0 -radix hexadecimal
wave add -group DRC_Slave:AW dvp_rx_controller_tb.s_awlen_i -tag F0 -radix hexadecimal
wave add -group DRC_Slave:AW dvp_rx_controller_tb.s_awvalid_i -tag F0 -radix hexadecimal
wave add -group DRC_Slave:AW dvp_rx_controller_tb.s_awready_o -tag F0 -radix hexadecimal
wave insertion [expr [wave index insertpoint] + 1]
wave group DRC_Slave:W -backgroundcolor #226600
wave add -group DRC_Slave:W dvp_rx_controller_tb.s_wdata_i -tag F0 -radix hexadecimal
wave add -group DRC_Slave:W dvp_rx_controller_tb.s_wlast_i -tag F0 -radix hexadecimal
wave add -group DRC_Slave:W dvp_rx_controller_tb.s_wvalid_i -tag F0 -radix hexadecimal
wave add -group DRC_Slave:W dvp_rx_controller_tb.s_wready_o -tag F0 -radix hexadecimal
wave insertion [expr [wave index insertpoint] + 1]
wave group DRC_Slave:B -backgroundcolor #666600
wave add -group DRC_Slave:B dvp_rx_controller_tb.s_bid_o -tag F0 -radix hexadecimal
wave add -group DRC_Slave:B dvp_rx_controller_tb.s_bresp_o -tag F0 -radix hexadecimal
wave add -group DRC_Slave:B dvp_rx_controller_tb.s_bvalid_o -tag F0 -radix hexadecimal
wave add -group DRC_Slave:B dvp_rx_controller_tb.s_bready_i -tag F0 -radix hexadecimal
wave insertion [expr [wave index insertpoint] + 1]
wave insertion [expr [wave index insertpoint] + 1]
wave group DRC_Master -backgroundcolor #004466
wave group DRC_Master:AW -backgroundcolor #006666
wave add -group DRC_Master:AW dvp_rx_controller_tb.m_awaddr_o -tag F0 -radix hexadecimal
wave add -group DRC_Master:AW dvp_rx_controller_tb.m_awburst_o -tag F0 -radix hexadecimal
wave add -group DRC_Master:AW dvp_rx_controller_tb.m_awid_o -tag F0 -radix hexadecimal
wave add -group DRC_Master:AW dvp_rx_controller_tb.m_awlen_o -tag F0 -radix hexadecimal
wave add -group DRC_Master:AW dvp_rx_controller_tb.m_awready_i -tag F0 -radix hexadecimal
wave add -group DRC_Master:AW dvp_rx_controller_tb.m_awvalid_o -tag F0 -radix hexadecimal
wave insertion [expr [wave index insertpoint] + 1]
wave group DRC_Master:W -backgroundcolor #226600
wave add -group DRC_Master:W dvp_rx_controller_tb.m_wdata_o -tag F0 -radix hexadecimal
wave add -group DRC_Master:W dvp_rx_controller_tb.m_wlast_o -tag F0 -radix hexadecimal
wave add -group DRC_Master:W dvp_rx_controller_tb.m_wvalid_o -tag F0 -radix hexadecimal
wave add -group DRC_Master:W dvp_rx_controller_tb.m_wready_i -tag F0 -radix hexadecimal
wave insertion [expr [wave index insertpoint] + 1]
wave insertion [expr [wave index insertpoint] + 1]
wave add dvp_rx_controller_tb.dut.cs.sm.drc_st_q -tag F0 -radix mnemonic
wave add dvp_rx_controller_tb.dut.cs.sm.bwd_pxl_hsk -tag F0 -radix hexadecimal
wave add dvp_rx_controller_tb.dut.cs.sm.bwd_pxl_data -tag F0 -radix hexadecimal
wave add dvp_rx_controller_tb.dut.cs.sm.bwd_pxl_hsync -tag F0 -radix hexadecimal
wave add dvp_rx_controller_tb.dut.cs.sm.bwd_pxl_vsync -tag F0 -radix hexadecimal -select
wave update on
wave top 10
