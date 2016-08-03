`timescale 1ns/1ps

module fmc2bram_tb;

  parameter FMC_AW = 20;
  parameter BRAM_AW = 12;
  parameter DW = 32;
  parameter BRAMS = 8;

  /*AUTOREGINPUT*/
  // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
  reg [BRAMS*DW-1:0]	bram_di;		// To uut of fmc2bram.v
  reg [FMC_AW-1:0]	fmc_a;			// To uut of fmc2bram.v
  reg			fmc_clk;		// To uut of fmc2bram.v
  reg			fmc_ne;			// To uut of fmc2bram.v
  reg			fmc_noe;		// To uut of fmc2bram.v
  reg			fmc_nwe;		// To uut of fmc2bram.v
  reg			rst;			// To uut of fmc2bram.v
  // End of automatics
  /*AUTOWIRE*/
  // Beginning of automatic wires (for undeclared instantiated-module outputs)
  wire [BRAM_AW-1:0]	bram_a;			// From uut of fmc2bram.v
  wire [DW-1:0]		bram_do;		// From uut of fmc2bram.v
  wire [BRAMS-1:0]	bram_en;		// From uut of fmc2bram.v
  wire [0:0]		bram_we;		// From uut of fmc2bram.v
  wire [DW-1:0]		fmc_d;			// To/From uut of fmc2bram.v
  // End of automatics

  fmc2bram
  #(/*AUTOINSTPARAM*/
    // Parameters
    .FMC_AW				(FMC_AW),
    .BRAM_AW				(BRAM_AW),
    .DW					(DW),
    .BRAMS				(BRAMS))
  uut
  (/*AUTOINST*/
   // Outputs
   .bram_a				(bram_a[BRAM_AW-1:0]),
   .bram_do				(bram_do[DW-1:0]),
   .bram_en				(bram_en[BRAMS-1:0]),
   .bram_we				(bram_we[0:0]),
   // Inouts
   .fmc_d				(fmc_d[DW-1:0]),
   // Inputs
   .rst					(rst),
   .fmc_clk				(fmc_clk),
   .fmc_a				(fmc_a[FMC_AW-1:0]),
   .fmc_noe				(fmc_noe),
   .fmc_nwe				(fmc_nwe),
   .fmc_ne				(fmc_ne),
   .bram_di				(bram_di[BRAMS*DW-1:0]));

class TxType;
  rand bit [$clog2(BRAMS)-1:0] bram_idx;
  rand bit [BRAM_AW-1:0] addr;
  rand bit [DW-1:0] data;
  rand bit [3:0] len;
endclass
  
  function void init();
    rst = 0;
    fmc_clk = 0;
    fmc_ne = 1;
    fmc_noe = 1;
    fmc_nwe = 1;  
  endfunction // init

  task reset();
    rst = 1;
    @(posedge fmc_clk);
    rst = 0;
  endtask
  
  task tx_read(TxType tx);
    @(negedge fmc_clk);
    fmc_ne = 0;
    fmc_a = {tx.bram_idx, tx.addr};
    repeat(2) @(negedge fmc_clk);
    fmc_noe = 0;
    repeat(2) @(posedge fmc_clk);
    read_check: assert (fmc_d == bram_array[tx.bram_idx][tx.addr]);
  endtask // tx_read

  task tx_write(TxType tx);
  endtask
  
  bit [DW-1:0] 		bram_array [BRAMS][bit [BRAM_AW-1:0]];

  initial begin
    init();
    reset();
  end

  always #5 fmc_clk = ~fmc_clk;
  
endmodule
