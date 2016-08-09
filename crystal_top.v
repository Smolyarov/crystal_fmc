
module crystal_top
  (
   input 	      rst, web, enb,
   input [10:0]       addrb,
   input [63:0]       dinb, 
   /*AUTOINPUT("^fmc")*/
   // Beginning of automatic inputs (from unused autoinst inputs)
   input [FMC_AW-1:0]	fmc_a,			// To fmc2bram_0 of fmc2bram.v
   input		fmc_clk,		// To fmc2bram_0 of fmc2bram.v
   input		fmc_ne,			// To fmc2bram_0 of fmc2bram.v
   input		fmc_noe,		// To fmc2bram_0 of fmc2bram.v
   input		fmc_nwe,		// To fmc2bram_0 of fmc2bram.v
   // End of automatics
   /*AUTOINOUT("^fmc")*/
   // Beginning of automatic inouts (from unused autoinst inouts)
   inout [DW-1:0]	fmc_d,			// To/From fmc2bram_0 of fmc2bram.v
   // End of automatics
   /*AUTOOUTPUT("^mmu")*/
   // Beginning of automatic outputs (from unused autoinst outputs)
   output		mmu_int		// From fmc2bram_0 of fmc2bram.v
   // End of automatics
   /*AUTOARG*/);

  parameter FMC_AW = 20;
  parameter BRAM_AW = 12;
  parameter DW = 32;
  parameter BRAMS = 8+1;
  parameter CTL_REGS = 6;

  /*AUTOWIRE*/
  // Beginning of automatic wires (for undeclared instantiated-module outputs)
  wire [BRAM_AW-1:0]	bram_a;			// From fmc2bram_0 of fmc2bram.v
  wire [DW-1:0]		bram_do;		// From fmc2bram_0 of fmc2bram.v
  wire [BRAMS-1:0]	bram_en;		// From fmc2bram_0 of fmc2bram.v
  wire [0:0]		bram_we;		// From fmc2bram_0 of fmc2bram.v
  // End of automatics
  wire [BRAMS*DW-1:0] bram_di;

  fmc2bram
    #(/*AUTOINSTPARAM*/
      // Parameters
      .FMC_AW				(FMC_AW),
      .BRAM_AW				(BRAM_AW),
      .DW				(DW),
      .BRAMS				(BRAMS),
      .CTL_REGS				(CTL_REGS))
  fmc2bram_0
    (/*AUTOINST*/
     // Outputs
     .mmu_int				(mmu_int),
     .bram_a				(bram_a[BRAM_AW-1:0]),
     .bram_do				(bram_do[DW-1:0]),
     .bram_en				(bram_en[BRAMS-1:0]),
     .bram_we				(bram_we[0:0]),
     // Inouts
     .fmc_d				(fmc_d[DW-1:0]),
     // Inputs
     .rst				(rst),
     .fmc_clk				(fmc_clk),
     .fmc_a				(fmc_a[FMC_AW-1:0]),
     .fmc_noe				(fmc_noe),
     .fmc_nwe				(fmc_nwe),
     .fmc_ne				(fmc_ne),
     .bram_di				(bram_di[BRAMS*DW-1:0]));

  genvar i;

  generate
    for (i=0; i<BRAMS; i=i+1) begin : bram
      bram_mtrx bram_inst
	   (
	    .clka(fmc_clk), // input clka
	    .ena(bram_en[i]), // input ena
	    .wea(bram_we), // input [0 : 0] wea
	    .addra(bram_a), // input [11 : 0] addra
	    .dina(bram_do), // input [31 : 0] dina
	    .douta(bram_di[DW*(i+1)-1 -: DW]), // output [31 : 0] douta
	    .clkb(fmc_clk), // input clkb
	    .enb(enb), // input enb
	    .web(web), // input [0 : 0] web
	    .addrb(addrb), // input [10 : 0] addrb
	    .dinb(dinb), // input [63 : 0] dinb
	    .doutb() // output [63 : 0] doutb
	    /*AUTOINST*/);
    end
  endgenerate
  
  
  
endmodule
