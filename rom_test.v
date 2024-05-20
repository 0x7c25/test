`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/16 11:05:24
// Design Name: 
// Module Name: rom_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rom_test();

reg  clk;
reg rstn;
wire [7:0] wave;
initial begin
    clk  = 0;
    rstn = 0;
    #20
    rstn = 1;
forever #10 clk = ~clk;
end

reg ena_fang,ena_juchi,ena_sanjiao,ena_sin;
wire [8:0] addra_fang,addra_juchi,addra_sanjiao,addra_sin;
wire [7:0] douta_fang,douta_juchi,douta_sanjiao,douta_sin;

reg [8:0] cnt_wave;
reg [1:0] flag_wave,flag_wave2;
always @(posedge clk or negedge rstn)begin
    if(~rstn)
      cnt_wave <= 0;
    else
      cnt_wave <= cnt_wave + 1;
end
always @(posedge clk or negedge rstn)begin
    if(~rstn)
      flag_wave <= 0;
    else if(&cnt_wave)
      flag_wave <= flag_wave + 1;
end
always @(posedge clk or negedge rstn)begin
    if(~rstn)
      flag_wave2 <= 0;
    else if((&cnt_wave) && (&flag_wave))
      flag_wave2 <= flag_wave2 + 1;
end
always@(*)begin
  case(flag_wave2)
    0 : {ena_fang,ena_juchi,ena_sanjiao,ena_sin} = {1'b1,1'b0,1'b0,1'b0};
    1 : {ena_fang,ena_juchi,ena_sanjiao,ena_sin} = {1'b0,1'b1,1'b0,1'b0};
    2 : {ena_fang,ena_juchi,ena_sanjiao,ena_sin} = {1'b0,1'b0,1'b1,1'b0};
    3 : {ena_fang,ena_juchi,ena_sanjiao,ena_sin} = {1'b0,1'b0,1'b0,1'b1};
    default: ;
  endcase
end

assign addra_fang    = ena_fang    ? cnt_wave : 'd0;
assign addra_juchi   = ena_juchi   ? cnt_wave : 'd0;
assign addra_sanjiao = ena_sanjiao ? cnt_wave : 'd0;
assign addra_sin     = ena_sin     ? cnt_wave : 'd0;

assign wave = ena_fang    ? douta_fang    :
               ena_juchi   ? douta_juchi   :
               ena_sanjiao ? douta_sanjiao :
               ena_sin     ? douta_sin     :
               'd0;

rom_fang rom_fang (
  .clka(clk),    // input wire clka
  .ena(ena_fang),      // input wire ena
  .addra(addra_fang),  // input wire [8 : 0] addra
  .douta(douta_fang)  // output wire [7 : 0] douta
);

rom_juchi rom_juchi (
  .clka(clk),    // input wire clka
  .ena(ena_juchi),      // input wire ena
  .addra(addra_juchi),  // input wire [8 : 0] addra
  .douta(douta_juchi)  // output wire [7 : 0] douta
);

rom_sanjiao rom_sanjiao (
  .clka(clk),    // input wire clka
  .ena(ena_sanjiao),      // input wire ena
  .addra(addra_sanjiao),  // input wire [8 : 0] addra
  .douta(douta_sanjiao)  // output wire [7 : 0] douta
);

rom_sin rom_sin (
  .clka(clk),    // input wire clka
  .ena(ena_sin),      // input wire ena
  .addra(addra_sin),  // input wire [8 : 0] addra
  .douta(douta_sin)  // output wire [7 : 0] douta
);


endmodule
