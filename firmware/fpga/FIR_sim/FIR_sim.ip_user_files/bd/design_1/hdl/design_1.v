//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.2 (lin64) Build 1577090 Thu Jun  2 16:32:35 MDT 2016
//Date        : Wed Jul 26 23:46:13 2017
//Host        : wi18as33032 running 64-bit Red Hat Enterprise Linux Workstation release 6.3 (Santiago)
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=25,numReposBlks=25,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Global}" *) (* HW_HANDOFF = "design_1.hwdef" *) 
module design_1
   ();

  wire [31:0]FIR_resized1_m_axis_data_tdata;
  wire FIR_resized1_m_axis_data_tvalid;
  wire [31:0]FIR_resized2_m_axis_data_tdata;
  wire [31:0]FIR_resized3_m_axis_data_tdata;
  wire [31:0]FIR_resized3_m_axis_data_tdata1;
  wire FIR_resized3_m_axis_data_tvalid;
  wire FIR_resized3_m_axis_data_tvalid1;
  wire [31:0]FIR_resized4_m_axis_data_tdata;
  wire Net;
  wire [15:0]axis_broadcaster_0_m_axis_tdata;
  wire axis_broadcaster_0_m_axis_tvalid;
  wire [39:0]cic_compiler_0_m_axis_data_tdata;
  wire cic_compiler_0_m_axis_data_tvalid;
  wire [15:0]wavegen_m_axis_data_tdata;
  wire [23:0]xlconcat_1_dout;
  wire [23:0]xlconcat_2_dout;
  wire [6:0]xlconstant_0_dout;
  wire [6:0]xlconstant_1_dout;
  wire [1:0]xlconstant_2_dout;
  wire [13:0]xlslice_0_Dout;
  wire [23:0]xlslice_11_Dout;
  wire [0:0]xlslice_13_Dout;
  wire [15:0]xlslice_14_Dout;
  wire [15:0]xlslice_15_Dout;
  wire [23:0]xlslice_6_Dout;
  wire [15:0]xlslice_7_Dout;
  wire [23:0]xlslice_8_Dout;
  wire [0:0]xlslice_9_Dout;

  design_1_FIR_resized1_1 FIR_resized0
       (.aclk(Net),
        .m_axis_data_tdata(FIR_resized3_m_axis_data_tdata),
        .m_axis_data_tvalid(FIR_resized3_m_axis_data_tvalid),
        .s_axis_data_tdata(xlconcat_1_dout),
        .s_axis_data_tvalid(cic_compiler_0_m_axis_data_tvalid));
  design_1_FIR_resized_0 FIR_resized1
       (.aclk(Net),
        .m_axis_data_tdata(FIR_resized1_m_axis_data_tdata),
        .m_axis_data_tvalid(FIR_resized1_m_axis_data_tvalid),
        .s_axis_data_tdata(xlslice_8_Dout),
        .s_axis_data_tvalid(FIR_resized3_m_axis_data_tvalid));
  design_1_FIR_resized1_0 FIR_resized2
       (.aclk(Net),
        .m_axis_data_tdata(FIR_resized2_m_axis_data_tdata),
        .s_axis_data_tdata(xlslice_6_Dout),
        .s_axis_data_tvalid(FIR_resized1_m_axis_data_tvalid));
  design_1_FIR_resized1_3 FIR_resized3
       (.aclk(Net),
        .m_axis_data_tdata(FIR_resized3_m_axis_data_tdata1),
        .m_axis_data_tvalid(FIR_resized3_m_axis_data_tvalid1),
        .s_axis_data_tdata(xlconcat_2_dout),
        .s_axis_data_tvalid(axis_broadcaster_0_m_axis_tvalid));
  design_1_FIR_resized2_2 FIR_resized4
       (.aclk(Net),
        .m_axis_data_tdata(FIR_resized4_m_axis_data_tdata),
        .s_axis_data_tdata(xlslice_11_Dout),
        .s_axis_data_tvalid(FIR_resized3_m_axis_data_tvalid1));
  design_1_cic_compiler_0_0 cic_compiler_0
       (.aclk(Net),
        .m_axis_data_tdata(cic_compiler_0_m_axis_data_tdata),
        .m_axis_data_tvalid(cic_compiler_0_m_axis_data_tvalid),
        .s_axis_data_tdata(xlslice_15_Dout),
        .s_axis_data_tvalid(axis_broadcaster_0_m_axis_tvalid));
  design_1_clk_gen_0_0 clk
       (.clk(Net));
  design_1_dds_compiler_0_1 wavegen
       (.aclk(Net),
        .m_axis_data_tdata(wavegen_m_axis_data_tdata),
        .m_axis_data_tvalid(axis_broadcaster_0_m_axis_tvalid));
  design_1_xlconcat_0_0 xlconcat_0
       (.In0(xlconstant_2_dout),
        .In1(xlslice_0_Dout),
        .dout(axis_broadcaster_0_m_axis_tdata));
  design_1_xlconcat_0_1 xlconcat_1
       (.In0(xlconstant_0_dout),
        .In1(xlslice_7_Dout),
        .In2(xlslice_9_Dout),
        .dout(xlconcat_1_dout));
  design_1_xlconcat_1_0 xlconcat_2
       (.In0(xlconstant_1_dout),
        .In1(xlslice_14_Dout),
        .In2(xlslice_13_Dout),
        .dout(xlconcat_2_dout));
  design_1_xlconstant_0_0 xlconstant_0
       (.dout(xlconstant_0_dout));
  design_1_xlconstant_0_1 xlconstant_1
       (.dout(xlconstant_1_dout));
  design_1_xlconstant_2_0 xlconstant_2
       (.dout(xlconstant_2_dout));
  design_1_xlslice_0_1 xlslice_0
       (.Din(wavegen_m_axis_data_tdata),
        .Dout(xlslice_0_Dout));
  design_1_xlslice_6_3 xlslice_11
       (.Din(FIR_resized3_m_axis_data_tdata1),
        .Dout(xlslice_11_Dout));
  design_1_xlslice_4_2 xlslice_12
       (.Din(FIR_resized4_m_axis_data_tdata));
  design_1_xlslice_9_0 xlslice_13
       (.Din(xlslice_14_Dout),
        .Dout(xlslice_13_Dout));
  design_1_xlslice_7_1 xlslice_14
       (.Din(axis_broadcaster_0_m_axis_tdata),
        .Dout(xlslice_14_Dout));
  design_1_xlslice_14_0 xlslice_15
       (.Din(axis_broadcaster_0_m_axis_tdata),
        .Dout(xlslice_15_Dout));
  design_1_xlslice_4_0 xlslice_4
       (.Din(FIR_resized2_m_axis_data_tdata));
  design_1_xlslice_6_0 xlslice_6
       (.Din(FIR_resized1_m_axis_data_tdata),
        .Dout(xlslice_6_Dout));
  design_1_xlslice_6_1 xlslice_7
       (.Din(cic_compiler_0_m_axis_data_tdata),
        .Dout(xlslice_7_Dout));
  design_1_xlslice_7_0 xlslice_8
       (.Din(FIR_resized3_m_axis_data_tdata),
        .Dout(xlslice_8_Dout));
  design_1_xlslice_3_0 xlslice_9
       (.Din(xlslice_7_Dout),
        .Dout(xlslice_9_Dout));
endmodule
