onerror resume
wave tags F0 
wave update off
wave zoom range 6217206734 6267008997
wave add dvp_rx_controller_tb.clk -tag F0 -radix hexadecimal
wave group DVP -backgroundcolor #004466
wave add -group DVP dvp_rx_controller_tb.dvp_xclk_o -tag F0 -radix hexadecimal
wave add -group DVP dvp_rx_controller_tb.dvp_pclk_i -tag F0 -radix hexadecimal
wave add -group DVP dvp_rx_controller_tb.dvp_d_i -tag F0 -radix hexadecimal
wave add -group DVP dvp_rx_controller_tb.dvp_vsync_i -tag F0 -radix hexadecimal
wave add -group DVP dvp_rx_controller_tb.dvp_href_i -tag F0 -radix hexadecimal
wave add -group DVP dvp_rx_controller_tb.dvp_hsync_i -tag F0 -radix hexadecimal
wave add -group DVP dvp_rx_controller_tb.dvp_pwdn_o -tag F0 -radix hexadecimal
wave insertion [expr [wave index insertpoint] + 1]
wave group PF_DSM -backgroundcolor #006666
wave add -group PF_DSM dvp_rx_controller_tb.dut.pf_dsm_pxl_info -tag F0 -radix hexadecimal
wave add -group PF_DSM dvp_rx_controller_tb.dut.pf_dsm_pxl_vld -tag F0 -radix hexadecimal
wave insertion [expr [wave index insertpoint] + 1]
wave group DSM_PGS -backgroundcolor #004466
wave add -group DSM_PGS dvp_rx_controller_tb.dut.dsm_pgs_pxl -tag F0 -radix hexadecimal
wave add -group DSM_PGS dvp_rx_controller_tb.dut.dsm_pgs_pxl_vld -tag F0 -radix hexadecimal
wave add -group DSM_PGS dvp_rx_controller_tb.dut.pgs_dsm_pxl_rdy -tag F0 -radix hexadecimal
wave insertion [expr [wave index insertpoint] + 1]
wave group PGS_PDF -backgroundcolor #006666
wave add -group PGS_PDF dvp_rx_controller_tb.dut.pgs_pdf_gs_pxl -tag F0 -radix hexadecimal
wave add -group PGS_PDF dvp_rx_controller_tb.dut.pgs_pdf_vld -tag F0 -radix hexadecimal
wave add -group PGS_PDF dvp_rx_controller_tb.dut.pdf_pgs_rdy -tag F0 -radix hexadecimal
wave insertion [expr [wave index insertpoint] + 1]
wave group PDF_PAT -backgroundcolor #226600
wave add -group PDF_PAT dvp_rx_controller_tb.dut.pdf_pat_pxl -tag F0 -radix hexadecimal
wave add -group PDF_PAT dvp_rx_controller_tb.dut.pdf_pat_vld -tag F0 -radix hexadecimal
wave add -group PDF_PAT dvp_rx_controller_tb.dut.pat_pdf_rdy -tag F0 -radix hexadecimal
wave insertion [expr [wave index insertpoint] + 1]
wave group PAT_S -backgroundcolor #004466
wave add -group PAT_S dvp_rx_controller_tb.s_awaddr_o -tag F0 -radix hexadecimal
wave add -group PAT_S dvp_rx_controller_tb.s_awvalid_o -tag F0 -radix hexadecimal
wave add -group PAT_S dvp_rx_controller_tb.s_awready_i -tag F0 -radix hexadecimal
wave add -group PAT_S dvp_rx_controller_tb.s_wdata_o -tag F0 -radix hexadecimal
wave add -group PAT_S dvp_rx_controller_tb.s_wlast_o -tag F0 -radix hexadecimal
wave add -group PAT_S dvp_rx_controller_tb.s_wvalid_o -tag F0 -radix hexadecimal
wave add -group PAT_S dvp_rx_controller_tb.s_wready_i -tag F0 -radix hexadecimal
wave add -group PAT_S dvp_rx_controller_tb.wdata_cnt -tag F0 -radix decimal -select
wave insertion [expr [wave index insertpoint] + 1]
wave group {AR channel} -backgroundcolor #004466
wave add -group {AR channel} dvp_rx_controller_tb.m_araddr_i -tag F0 -radix hexadecimal
wave add -group {AR channel} dvp_rx_controller_tb.m_arid_i -tag F0 -radix hexadecimal
wave add -group {AR channel} dvp_rx_controller_tb.m_arready_o -tag F0 -radix hexadecimal
wave add -group {AR channel} dvp_rx_controller_tb.m_arvalid_i -tag F0 -radix hexadecimal
wave insertion [expr [wave index insertpoint] + 1]
wave group {R channel} -backgroundcolor #006666
wave add -group {R channel} dvp_rx_controller_tb.m_rdata_o -tag F0 -radix hexadecimal
wave add -group {R channel} dvp_rx_controller_tb.m_rid_o -tag F0 -radix hexadecimal
wave add -group {R channel} dvp_rx_controller_tb.m_rready_i -tag F0 -radix hexadecimal
wave add -group {R channel} dvp_rx_controller_tb.m_rresp_o -tag F0 -radix hexadecimal
wave add -group {R channel} dvp_rx_controller_tb.m_rvalid_o -tag F0 -radix hexadecimal
wave insertion [expr [wave index insertpoint] + 1]
wave group CONF -backgroundcolor #666600
wave group CONF:M_AW -backgroundcolor #004466
wave add -group CONF:M_AW dvp_rx_controller_tb.m_awaddr_i -tag F0 -radix hexadecimal
wave add -group CONF:M_AW dvp_rx_controller_tb.m_awid_i -tag F0 -radix hexadecimal
wave add -group CONF:M_AW dvp_rx_controller_tb.m_awready_o -tag F0 -radix hexadecimal
wave add -group CONF:M_AW dvp_rx_controller_tb.m_awvalid_i -tag F0 -radix hexadecimal
wave insertion [expr [wave index insertpoint] + 1]
wave group CONF:M_W -backgroundcolor #006666
wave add -group CONF:M_W dvp_rx_controller_tb.m_wdata_i -tag F0 -radix hexadecimal
wave add -group CONF:M_W dvp_rx_controller_tb.m_wready_o -tag F0 -radix hexadecimal
wave add -group CONF:M_W dvp_rx_controller_tb.m_wvalid_i -tag F0 -radix hexadecimal
wave insertion [expr [wave index insertpoint] + 1]
wave group CONF:M_B -backgroundcolor #226600
wave add -group CONF:M_B dvp_rx_controller_tb.m_bid_o -tag F0 -radix hexadecimal
wave add -group CONF:M_B dvp_rx_controller_tb.m_bready_i -tag F0 -radix hexadecimal
wave add -group CONF:M_B dvp_rx_controller_tb.m_bresp_o -tag F0 -radix hexadecimal
wave add -group CONF:M_B dvp_rx_controller_tb.m_bvalid_o -tag F0 -radix hexadecimal
wave insertion [expr [wave index insertpoint] + 1]
wave insertion [expr [wave index insertpoint] + 1]
wave update on
wave top 3
