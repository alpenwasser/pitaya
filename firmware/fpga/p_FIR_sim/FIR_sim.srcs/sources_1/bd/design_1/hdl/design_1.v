//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.2 (lin64) Build 1577090 Thu Jun  2 16:32:35 MDT 2016
//Date        : Mon Jul 31 14:19:19 2017
//Host        : wi18ac33275 running 64-bit Red Hat Enterprise Linux Workstation release 6.3 (Santiago)
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=38,numReposBlks=38,numNonXlnxBlks=5,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Global}" *) (* HW_HANDOFF = "design_1.hwdef" *) 
module design_1
   ();

  wire CIC125_m_axis_data_tvalid;
  wire CIC25_m_axis_data_tvalid;
  wire COMP1_m_axis_data_tvalid;
  wire COMP5_m_axis_data_tvalid;
  wire [31:0]DEC_SEL_dout;
  wire FIR5flat_m_axis_data_tvalid;
  wire FIR5steep_m_axis_data_tvalid;
  wire [31:0]FIR_resized1_m_axis_data_tdata;
  wire [31:0]FIR_resized2_m_axis_data_tdata;
  wire [31:0]FIR_resized3_m_axis_data_tdata;
  wire [31:0]FIR_resized6_m_axis_data_tdata;
  wire [31:0]FIR_resized7_m_axis_data_tdata;
  wire HBsteep1_m_axis_data_tvalid;
  wire HBsteep_m_axis_data_tvalid;
  wire [23:0]MUX0_DataxDO;
  wire [23:0]MUX1_DataxDO;
  wire MUX1_ValidxSO;
  wire [23:0]MUX2_DataxDO;
  wire MUX2_ValidxSO;
  wire [23:0]MUX3_DataxDO;
  wire MUX3_ValidxSO;
  wire Net;
  wire [23:0]cic125_slice_dout;
  wire [23:0]cic25_slice_dout;
  wire [39:0]cic_compiler_0_m_axis_data_tdata;
  wire [47:0]cic_compiler_1_m_axis_data_tdata;
  wire [1:0]dec_to_fir_mux_1_Mux0;
  wire [1:0]dec_to_fir_mux_1_Mux1;
  wire [1:0]dec_to_fir_mux_1_Mux2;
  wire [1:0]dec_to_fir_mux_1_Mux3;
  wire [23:0]fir5steep_slice1_Dout;
  wire [31:0]hbflat_slice_m_axis_data_tdata;
  wire [23:0]nocic_slice_dout;
  wire [15:0]wavegen_m_axis_data_tdata;
  wire wavegen_m_axis_data_tvalid;
  wire [15:0]xlconcat_0_dout;
  wire [6:0]xlconstant_0_dout;
  wire [6:0]xlconstant_1_dout;
  wire [6:0]xlconstant_3_dout;
  wire [13:0]xlslice_0_Dout;
  wire [0:0]xlslice_10_Dout;
  wire [0:0]xlslice_11_Dout;
  wire [0:0]xlslice_12_Dout;
  wire [0:0]xlslice_13_Dout;
  wire [23:0]xlslice_14_Dout;
  wire [23:0]xlslice_15_Dout;
  wire [15:0]xlslice_17_Dout;
  wire [23:0]xlslice_4_Dout;
  wire [23:0]xlslice_6_Dout;
  wire [15:0]xlslice_7_Dout;
  wire [23:0]xlslice_8_Dout;
  wire [0:0]xlslice_9_Dout;

  design_1_cic_compiler_0_1 CIC125
       (.aclk(Net),
        .m_axis_data_tdata(cic_compiler_1_m_axis_data_tdata),
        .m_axis_data_tvalid(CIC125_m_axis_data_tvalid),
        .s_axis_data_tdata(xlconcat_0_dout),
        .s_axis_data_tvalid(wavegen_m_axis_data_tvalid));
  design_1_cic_compiler_0_0 CIC25
       (.aclk(Net),
        .m_axis_data_tdata(cic_compiler_0_m_axis_data_tdata),
        .m_axis_data_tvalid(CIC25_m_axis_data_tvalid),
        .s_axis_data_tdata(xlconcat_0_dout),
        .s_axis_data_tvalid(wavegen_m_axis_data_tvalid));
  design_1_FIR_resized1_1 COMP1
       (.aclk(Net),
        .m_axis_data_tdata(FIR_resized3_m_axis_data_tdata),
        .m_axis_data_tvalid(COMP1_m_axis_data_tvalid),
        .s_axis_data_tdata(cic25_slice_dout),
        .s_axis_data_tvalid(CIC25_m_axis_data_tvalid));
  design_1_FIR_resized0_0 COMP5
       (.aclk(Net),
        .m_axis_data_tdata(FIR_resized6_m_axis_data_tdata),
        .m_axis_data_tvalid(COMP5_m_axis_data_tvalid),
        .s_axis_data_tdata(cic125_slice_dout),
        .s_axis_data_tvalid(CIC125_m_axis_data_tvalid));
  design_1_MUX4SEL_0 DEC_SEL
       (.dout(DEC_SEL_dout));
  design_1_FIR_resized_0 FIR5flat
       (.aclk(Net),
        .m_axis_data_tdata(FIR_resized1_m_axis_data_tdata),
        .m_axis_data_tvalid(FIR5flat_m_axis_data_tvalid),
        .s_axis_data_tdata(MUX3_DataxDO),
        .s_axis_data_tvalid(MUX3_ValidxSO));
  design_1_FIR_resized1_0 FIR5steep
       (.aclk(Net),
        .m_axis_data_tdata(FIR_resized2_m_axis_data_tdata),
        .m_axis_data_tvalid(FIR5steep_m_axis_data_tvalid),
        .s_axis_data_tdata(MUX2_DataxDO),
        .s_axis_data_tvalid(MUX2_ValidxSO));
  design_1_HBsteep_0 HBflat
       (.aclk(Net),
        .m_axis_data_tdata(hbflat_slice_m_axis_data_tdata),
        .m_axis_data_tvalid(HBsteep1_m_axis_data_tvalid),
        .s_axis_data_tdata(MUX2_DataxDO),
        .s_axis_data_tvalid(MUX2_ValidxSO));
  design_1_FIR_resized2_0 HBsteep
       (.aclk(Net),
        .m_axis_data_tdata(FIR_resized7_m_axis_data_tdata),
        .m_axis_data_tvalid(HBsteep_m_axis_data_tvalid),
        .s_axis_data_tdata(MUX1_DataxDO),
        .s_axis_data_tvalid(MUX1_ValidxSO));
  design_1_MUX5_0 MUX0
       (.ClkxCI(Net),
        .Data0xDI(MUX1_DataxDO),
        .Data1xDI(xlslice_14_Dout),
        .DataxDO(MUX0_DataxDO),
        .ReadyxSI(1'b0),
        .SelectxDI(dec_to_fir_mux_1_Mux0),
        .Valid0xSI(MUX1_ValidxSO),
        .Valid1xSI(HBsteep_m_axis_data_tvalid));
  design_1_MUX0_0 MUX1
       (.ClkxCI(Net),
        .Data0xDI(xlslice_4_Dout),
        .Data1xDI(fir5steep_slice1_Dout),
        .Data2xDI(MUX2_DataxDO),
        .DataxDO(MUX1_DataxDO),
        .ReadyxSI(1'b0),
        .SelectxDI(dec_to_fir_mux_1_Mux1),
        .Valid0xSI(FIR5steep_m_axis_data_tvalid),
        .Valid1xSI(HBsteep1_m_axis_data_tvalid),
        .Valid2xSI(MUX2_ValidxSO),
        .ValidxSO(MUX1_ValidxSO));
  design_1_MUX1_0 MUX2
       (.ClkxCI(Net),
        .Data0xDI(MUX3_DataxDO),
        .Data1xDI(xlslice_6_Dout),
        .DataxDO(MUX2_DataxDO),
        .ReadyxSI(1'b0),
        .SelectxDI(dec_to_fir_mux_1_Mux2),
        .Valid0xSI(MUX3_ValidxSO),
        .Valid1xSI(FIR5flat_m_axis_data_tvalid),
        .ValidxSO(MUX2_ValidxSO));
  design_1_MUX4_0 MUX3
       (.ClkxCI(Net),
        .Data0xDI(nocic_slice_dout),
        .Data1xDI(xlslice_8_Dout),
        .Data2xDI(xlslice_15_Dout),
        .DataxDO(MUX3_DataxDO),
        .ReadyxSI(1'b0),
        .SelectxDI(dec_to_fir_mux_1_Mux3),
        .Valid0xSI(wavegen_m_axis_data_tvalid),
        .Valid1xSI(COMP1_m_axis_data_tvalid),
        .Valid2xSI(COMP5_m_axis_data_tvalid),
        .ValidxSO(MUX3_ValidxSO));
  design_1_xlconcat_1_1 cic125_slice
       (.In0(xlconstant_3_dout),
        .In1(xlslice_17_Dout),
        .In2(xlslice_10_Dout),
        .dout(cic125_slice_dout));
  design_1_xlconcat_0_1 cic25_slice
       (.In0(xlconstant_0_dout),
        .In1(xlslice_7_Dout),
        .In2(xlslice_9_Dout),
        .dout(cic25_slice_dout));
  design_1_clk_gen_0_0 clk
       (.clk(Net));
  design_1_xlslice_7_0 comp1_slice
       (.Din(FIR_resized3_m_axis_data_tdata),
        .Dout(xlslice_8_Dout));
  design_1_xlslice_14_0 comp5_slice
       (.Din(FIR_resized6_m_axis_data_tdata),
        .Dout(xlslice_15_Dout));
  design_1_dec_to_fir_mux_1_0 dec_to_fir_mux_1
       (.DecRate(DEC_SEL_dout),
        .Mux0(dec_to_fir_mux_1_Mux0),
        .Mux1(dec_to_fir_mux_1_Mux1),
        .Mux2(dec_to_fir_mux_1_Mux2),
        .Mux3(dec_to_fir_mux_1_Mux3));
  design_1_xlslice_6_0 fir5flat_slice
       (.Din(FIR_resized1_m_axis_data_tdata),
        .Dout(xlslice_6_Dout));
  design_1_xlslice_4_0 fir5steep_slice
       (.Din(FIR_resized2_m_axis_data_tdata),
        .Dout(xlslice_4_Dout));
  design_1_fir5steep_slice_0 hbflat_slice
       (.Din(hbflat_slice_m_axis_data_tdata),
        .Dout(fir5steep_slice1_Dout));
  design_1_xlslice_6_2 hbsteep_slice
       (.Din(FIR_resized7_m_axis_data_tdata),
        .Dout(xlslice_14_Dout));
  design_1_xlconcat_1_0 nocic_slice
       (.In0(xlconstant_1_dout),
        .In1(xlconcat_0_dout),
        .In2(xlslice_13_Dout),
        .dout(nocic_slice_dout));
  design_1_xlslice_1_0 out_slice
       (.Din(MUX0_DataxDO));
  design_1_dds_compiler_0_1 wavegen
       (.aclk(Net),
        .m_axis_data_tdata(wavegen_m_axis_data_tdata),
        .m_axis_data_tvalid(wavegen_m_axis_data_tvalid));
  design_1_xlconcat_0_0 wavegen_slice
       (.In0(xlslice_0_Dout),
        .In1(xlslice_11_Dout),
        .In2(xlslice_12_Dout),
        .dout(xlconcat_0_dout));
  design_1_xlconstant_0_0 xlconstant_0
       (.dout(xlconstant_0_dout));
  design_1_xlconstant_0_1 xlconstant_1
       (.dout(xlconstant_1_dout));
  design_1_xlconstant_0_2 xlconstant_3
       (.dout(xlconstant_3_dout));
  design_1_xlslice_0_1 xlslice_0
       (.Din(wavegen_m_axis_data_tdata),
        .Dout(xlslice_0_Dout));
  design_1_xlslice_9_1 xlslice_10
       (.Din(xlslice_17_Dout),
        .Dout(xlslice_10_Dout));
  design_1_xlslice_9_3 xlslice_11
       (.Din(wavegen_m_axis_data_tdata),
        .Dout(xlslice_11_Dout));
  design_1_xlslice_11_0 xlslice_12
       (.Din(wavegen_m_axis_data_tdata),
        .Dout(xlslice_12_Dout));
  design_1_xlslice_9_0 xlslice_13
       (.Din(xlconcat_0_dout),
        .Dout(xlslice_13_Dout));
  design_1_xlslice_7_2 xlslice_17
       (.Din(cic_compiler_1_m_axis_data_tdata),
        .Dout(xlslice_17_Dout));
  design_1_xlslice_6_1 xlslice_7
       (.Din(cic_compiler_0_m_axis_data_tdata),
        .Dout(xlslice_7_Dout));
  design_1_xlslice_3_0 xlslice_9
       (.Din(xlslice_7_Dout),
        .Dout(xlslice_9_Dout));
endmodule
