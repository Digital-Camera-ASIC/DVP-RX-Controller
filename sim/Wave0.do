onerror resume
wave tags  F0
wave update off
wave zoom range 386952045 389794998
wave group PAT_S -backgroundcolor #004466
wave add -group PAT_S dvp_rx_controller_tb.s_awaddr_o -tag F0 -radix hexadecimal
wave add -group PAT_S dvp_rx_controller_tb.s_awvalid_o -tag F0 -radix hexadecimal
wave add -group PAT_S dvp_rx_controller_tb.s_awready_i -tag F0 -radix hexadecimal
wave add -group PAT_S dvp_rx_controller_tb.s_wdata_o -tag F0 -radix hexadecimal
wave add -group PAT_S dvp_rx_controller_tb.s_wlast_o -tag F0 -radix hexadecimal
wave add -group PAT_S dvp_rx_controller_tb.s_wvalid_o -tag F0 -radix hexadecimal
wave add -group PAT_S dvp_rx_controller_tb.s_wready_i -tag F0 -radix hexadecimal
wave insertion [expr [wave index insertpoint] + 1]
wave group PDF_PAT -backgroundcolor #226600
wave add -group PDF_PAT dvp_rx_controller_tb.dut.pdf_pat_pxl -tag F0 -radix hexadecimal
wave add -group PDF_PAT dvp_rx_controller_tb.dut.pdf_pat_vld -tag F0 -radix hexadecimal
wave add -group PDF_PAT dvp_rx_controller_tb.dut.pat_pdf_rdy -tag F0 -radix hexadecimal
wave insertion [expr [wave index insertpoint] + 1]
wave group PGS_PDF -backgroundcolor #006666
wave add -group PGS_PDF dvp_rx_controller_tb.dut.pgs_pdf_gs_pxl -tag F0 -radix hexadecimal
wave add -group PGS_PDF dvp_rx_controller_tb.dut.pgs_pdf_vld -tag F0 -radix hexadecimal
wave add -group PGS_PDF dvp_rx_controller_tb.dut.pdf_pgs_rdy -tag F0 -radix hexadecimal
wave insertion [expr [wave index insertpoint] + 1]
wave add dvp_rx_controller_tb.dut.dsm_pgs_pxl -tag F0 -radix hexadecimal -select
wave update on
wave top 0
