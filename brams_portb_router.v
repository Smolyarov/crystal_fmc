
module brams_portb_router
  #(
    parameter BRAM_DW = 64,
    parameter BRAM_AW = 10,
    parameter BRAMS = 8
    )
  (
   // 4-to-8 mux
   input [BRAM_AW-1:0] math_adr_a,
   input [BRAM_AW-1:0] math_adr_b,
   input [BRAM_AW-1:0] math_adr_c,
   input [BRAMS*2-1:0] adr_sel, // a, b, c, zeros
   output [BRAMS*BRAM_AW-1:0] bram_adr,

   // 1-to-8 decoder
   input math_we,
   input [$clog2(BRAMS)-1:0] we_sel,
   output [BRAMS-1:0] bram_we,

   // 8-to-2 mux
   input [BRAMS*BRAM_DW-1:0] bram_do,
   input [$clog2(BRAMS)-1:0] dat_a_sel,
   input [$clog2(BRAMS)-1:0] dat_b_sel,
   output [BRAM_DW-1:0] math_dat_a,
   output [BRAM_DW-1:0] math_dat_b
   );
endmodule
