//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.2 (lin64) Build 1577090 Thu Jun  2 16:32:35 MDT 2016
//Date        : Tue Jul 25 15:46:51 2017
//Host        : wi18ac33275 running 64-bit Red Hat Enterprise Linux Workstation release 6.3 (Santiago)
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=21,numReposBlks=21,numNonXlnxBlks=1,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Global}" *) (* HW_HANDOFF = "design_1.hwdef" *) 
module design_1
   ();

  wire [23:0]FIR_resized1_m_axis_data_tdata;
  wire FIR_resized1_m_axis_data_tvalid;
  wire [39:0]FIR_resized2_m_axis_data_tdata;
  wire FIR_resized2_m_axis_data_tvalid;
  wire [23:0]FIR_resized3_m_axis_data_tdata;
  wire FIR_resized3_m_axis_data_tvalid;
  wire Net;
  wire [15:0]axis_broadcaster_0_M00_AXIS_TDATA;
  wire [0:0]axis_broadcaster_0_M00_AXIS_TVALID;
  wire [31:16]axis_broadcaster_0_M01_AXIS_TDATA;
  wire [1:1]axis_broadcaster_0_M01_AXIS_TVALID;
  wire [15:0]axis_to_data_lanes_0_Data0xDO;
  wire [15:0]axis_to_data_lanes_0_Data1xDO;
  wire [39:0]cic_compiler_0_m_axis_data_tdata;
  wire cic_compiler_0_m_axis_data_tvalid;
  wire clk_gen_0_sync_rst;
  wire [39:0]fir_compiler_0_m_axis_data_tdata;
  wire [15:0]wavegen_m_axis_data_tdata;
  wire wavegen_m_axis_data_tvalid;
  wire [15:0]xlconcat_0_dout;
  wire [39:0]xlslice_0_Dout;
  wire [13:0]xlslice_0_Dout1;
  wire [0:0]xlslice_3_Dout;
  wire [15:0]xlslice_4_Dout;
  wire [0:0]xlslice_5_Dout;
  wire [15:0]xlslice_6_Dout;
  wire [15:0]xlslice_7_Dout;
  wire [15:0]xlslice_8_Dout;

  design_1_fir_compiler_0_0 FIR
       (.aclk(Net),
        .m_axis_data_tdata(fir_compiler_0_m_axis_data_tdata),
        .s_axis_data_tdata(axis_broadcaster_0_M00_AXIS_TDATA),
        .s_axis_data_tvalid(axis_broadcaster_0_M00_AXIS_TVALID));
  design_1_FIR_resized1_1 FIR_resized0
       (.aclk(Net),
        .m_axis_data_tdata(FIR_resized3_m_axis_data_tdata),
        .m_axis_data_tvalid(FIR_resized3_m_axis_data_tvalid),
        .s_axis_data_tdata(xlslice_7_Dout),
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
        .m_axis_data_tvalid(FIR_resized2_m_axis_data_tvalid),
        .s_axis_data_tdata(xlslice_6_Dout),
        .s_axis_data_tvalid(FIR_resized1_m_axis_data_tvalid));
  design_1_axis_broadcaster_0_0 axis_broadcaster_0
       (.aclk(Net),
        .aresetn(clk_gen_0_sync_rst),
        .m_axis_tdata({axis_broadcaster_0_M01_AXIS_TDATA,axis_broadcaster_0_M00_AXIS_TDATA}),
        .m_axis_tvalid({axis_broadcaster_0_M01_AXIS_TVALID,axis_broadcaster_0_M00_AXIS_TVALID}),
        .s_axis_tdata(xlconcat_0_dout),
        .s_axis_tvalid(wavegen_m_axis_data_tvalid));
  design_1_axis_to_data_lanes_0_0 axis_to_data_lanes_0
       (.AxiTDataxDI(xlslice_4_Dout),
        .AxiTValid(FIR_resized2_m_axis_data_tvalid),
        .ClkxCI(Net),
        .Data0xDO(axis_to_data_lanes_0_Data0xDO),
        .Data1xDO(axis_to_data_lanes_0_Data1xDO),
        .RstxRBI(clk_gen_0_sync_rst));
  design_1_cic_compiler_0_0 cic_compiler_0
       (.aclk(Net),
        .m_axis_data_tdata(cic_compiler_0_m_axis_data_tdata),
        .m_axis_data_tvalid(cic_compiler_0_m_axis_data_tvalid),
        .s_axis_data_tdata(axis_broadcaster_0_M01_AXIS_TDATA),
        .s_axis_data_tvalid(axis_broadcaster_0_M01_AXIS_TVALID));
  design_1_clk_gen_0_0 clk
       (.clk(Net),
        .sync_rst(clk_gen_0_sync_rst));
  design_1_xlslice_1_0 correct_sink
       (.Din(xlslice_0_Dout));
  design_1_xlslice_0_0 correct_value
       (.Din(fir_compiler_0_m_axis_data_tdata),
        .Dout(xlslice_0_Dout));
  design_1_dds_compiler_0_1 wavegen
       (.aclk(Net),
        .m_axis_data_tdata(wavegen_m_axis_data_tdata),
        .m_axis_data_tvalid(wavegen_m_axis_data_tvalid));
  design_1_xlconcat_0_0 xlconcat_0
       (.In0(xlslice_0_Dout1),
        .In1(xlslice_3_Dout),
        .In2(xlslice_5_Dout),
        .dout(xlconcat_0_dout));
  design_1_xlslice_0_1 xlslice_0
       (.Din(wavegen_m_axis_data_tdata),
        .Dout(xlslice_0_Dout1));
  design_1_xlslice_1_1 xlslice_1
       (.Din(axis_to_data_lanes_0_Data0xDO));
  design_1_xlslice_1_2 xlslice_2
       (.Din(axis_to_data_lanes_0_Data1xDO));
  design_1_xlslice_0_2 xlslice_3
       (.Din(wavegen_m_axis_data_tdata),
        .Dout(xlslice_3_Dout));
  design_1_xlslice_4_0 xlslice_4
       (.Din(FIR_resized2_m_axis_data_tdata[23:0]),
        .Dout(xlslice_4_Dout));
  design_1_xlslice_0_4 xlslice_5
       (.Din(wavegen_m_axis_data_tdata),
        .Dout(xlslice_5_Dout));
  design_1_xlslice_6_0 xlslice_6
       (.Din(FIR_resized1_m_axis_data_tdata),
        .Dout(xlslice_6_Dout));
  design_1_xlslice_6_1 xlslice_7
       (.Din(cic_compiler_0_m_axis_data_tdata),
        .Dout(xlslice_7_Dout));
  design_1_xlslice_7_0 xlslice_8
       (.Din(FIR_resized3_m_axis_data_tdata),
        .Dout(xlslice_8_Dout));
endmodule
