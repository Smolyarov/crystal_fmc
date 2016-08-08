
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
   output reg [BRAMS*BRAM_AW-1:0] bram_adr,

   // 1-to-8 decoder
   input math_we,
   input [$clog2(BRAMS)-1:0] we_sel,
   output reg [BRAMS-1:0] bram_we,

   // 8-to-2 mux
   input [BRAMS*BRAM_DW-1:0] bram_do,
   input [$clog2(BRAMS)-1:0] dat_a_sel,
   input [$clog2(BRAMS)-1:0] dat_b_sel,
   output reg [BRAM_DW-1:0] math_dat_a,
   output reg [BRAM_DW-1:0] math_dat_b
   );

  integer 		    i;

  
  always @* // address
    for (i=0; i<BRAMS; i=i+1)
      case (adr_sel[2*(i+1)-1 -: 2])
	0: bram_adr[BRAM_AW*(i+1)-1 -: BRAM_AW] <= math_adr_a;
	1: bram_adr[BRAM_AW*(i+1)-1 -: BRAM_AW] <= math_adr_b;
	2: bram_adr[BRAM_AW*(i+1)-1 -: BRAM_AW] <= math_adr_c;
	3: bram_adr[BRAM_AW*(i+1)-1 -: BRAM_AW] <= 0;
      endcase
  

  always @* begin // WE
    bram_we <= 0;
    bram_we[we_sel] <= math_we;
  end
  

  always @* begin // data BRAM->MUL
    math_dat_a <= bram_do[BRAM_DW*(dat_a_sel+1)-1 -: BRAM_DW];
    math_dat_b <= bram_do[BRAM_DW*(dat_b_sel+1)-1 -: BRAM_DW];
  end
  
endmodule
