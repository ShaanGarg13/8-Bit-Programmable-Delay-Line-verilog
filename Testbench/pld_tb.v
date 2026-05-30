module pld_tb();
  wire SO,OUT;
  reg [7:0]P;
  reg MD,SI,SC,AE,IN,piso_shift,reset;
  
  PDL uut(SO,OUT,P,MD,SI,SC,AE,IN,piso_shift,reset);
    
  // clock generation
  initial begin
    SC=0;
    forever #5 SC=~SC;
  end
  
  // IN singal generation
  initial begin
    IN=0;
    forever #30 IN=~IN;
  end
  
  initial begin
    // initial setup
    reset = 1; AE=0; MD=0; SI=0; P=8'h00; piso_shift=1; IN=0;
    @(posedge SC);
    @(posedge SC);
  	reset = 0;
  	@(posedge SC);
        
    // PARALLEL MODE WITHOUT AE
    MD=1;
    @(posedge SC);
    P=8'h55;
    @(posedge SC);
    @(posedge SC);
    @(posedge SC);
    
    // PARALLEL MODE WITH AE
    MD=1;
    P = 8'h0A;
    @(posedge SC);
    @(posedge SC);
    AE = 1;
    @(posedge SC);
    AE = 0;
    @(posedge SC);
    @(posedge SC);
    
    // SERIAL MODE WITHOUT AE
    MD=0;
    @(posedge SC);
    // MSB first
	SI = 1; @(posedge SC);
    SI = 1; @(posedge SC);
    SI = 0; @(posedge SC);
    SI = 1; @(posedge SC);
    SI = 0; @(posedge SC);
    SI = 1; @(posedge SC);
    SI = 0; @(posedge SC);
    SI = 1; @(posedge SC);
    
        
    // SERIAL MODE WITH AE
    MD=0;reset=0;AE=0;
    @(posedge SC);
    
    // MSB first
    SI = 0; @(posedge SC);
    SI = 0; @(posedge SC);
    SI = 0; @(posedge SC);
    SI = 1; @(posedge SC);
    SI = 0; @(posedge SC);
    SI = 1; @(posedge SC);
    SI = 0; @(posedge SC);
    SI = 0; 
    #1
    AE = 1;
    @(posedge SC);
    AE = 0;
    @(posedge SC);
    
  // SO OUTPUT MODE CHECK
    
  // SISO path
  MD = 0;
  SI = 1; @(posedge SC);
  SI = 0; @(posedge SC);
  SI = 1; @(posedge SC);
  SI = 0; @(posedge SC);

  // PISO path
  MD = 1;
  P = 8'b1010_0101; @(posedge SC);
  piso_shift = 0; @(posedge SC); piso_shift = 1; // load once
  repeat(8) @(posedge SC); // shift out on SO

    #200
    $finish;
  end
  
endmodule
