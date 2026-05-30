module PDL(SO,OUT,P,MD,SI,SC,AE,IN,piso_shift,reset);
  // ports
  input [7:0]P;
  input MD;
  input SC,AE,IN;
  input reset;
  input SI;
  output SO;
  output OUT;
  input piso_shift; // control in testbench
  
  //internal signals
  wire [7:0]ipreg;
  wire [7:0]reg_pipo;
  wire [7:0]reg_sipo;
  wire so_siso;
  wire so_piso;
  reg [7:0]latch;
  
  // data for serial output 
  // piso_shift = 1 then data shift to so_piso
  // piso_shift = 0 then data loadded in internal registers of piso
  SISO R1(so_siso,SI,SC,reset);
  PISO R2(so_piso,P,piso_shift,SC,reset);
  assign SO = (MD == 1'b0) ? so_siso : so_piso;
  
  // data for input register and into latch
  PIPO R3(reg_pipo,P,SC,reset);
  SIPO R4(reg_sipo,SI,SC,reset);
  assign ipreg = (MD == 1'b0) ? reg_sipo : reg_pipo;
  
  // latch data to particular value on AE high
  always @(posedge AE or posedge reset)
    begin
      if (reset==1)
        begin
          latch<=0;
        end
      else
        begin
          latch<=ipreg;
        end
    end
  
  // delay module
  DELAY D1(IN,latch,OUT);

//   generate
//     if (MD==1)
//       begin
//         PISO ipparallel(ipreg,P,MD,MD,reset);
//       end
//     else
//       begin
//         if (SC==1)
//           begin
//             SISO ipserial(ipreg,SI,SC,reset);
//           end
//       end
//   endgenerate
  
//   // mode selection
//   always @(MD or reset)
//     begin
//       if (MD==1) 
//         begin
//           PISO ipparallel(ipreg,P,MD,MD,reset);
//         end   
          
//       if (MD==0)
//         begin
//           if (SC==1)
//             begin
//               SISO ipserial(ipreg,SI,SC,reset);
//             end
//         end
//     end
  
  
  
endmodule

//delay module
module DELAY(in,latch,out);
  input wire in;
  input wire [7:0]latch;
  output reg out;
  integer offset=10;
  integer step=2;
  integer delay;
  // rise edge delay
  always @(in) 
    begin
      delay = offset + latch*step;
      if (in == 1'b1) begin
        #(delay) out <= 1'b1; // handles rise edge delay
      end
      else begin
        #(delay) out <= 1'b0; // handles fall edge delay
      end
    end
endmodule
        
module PIPO(dataout,datain,clock,reset);
  input [7:0]datain;
  input clock,reset;
  output [7:0]dataout;
  DFF d1(dataout[7],datain[7],clock,reset);
  DFF d2(dataout[6],datain[6],clock,reset);
  DFF d3(dataout[5],datain[5],clock,reset);
  DFF d4(dataout[4],datain[4],clock,reset);
  DFF d5(dataout[3],datain[3],clock,reset);
  DFF d6(dataout[2],datain[2],clock,reset);
  DFF d7(dataout[1],datain[1],clock,reset);
  DFF d8(dataout[0],datain[0],clock,reset);
endmodule

module PISO(dataout,datain,shift,clock,reset);
  input [7:0]datain;
  input clock,reset,shift;
  output dataout;
  wire [6:0]w;
  wire [6:0]w2;
  // shift=1 then data shift
  // shift=0 then data load
  DFF d1(w[0],datain[7],clock,reset);
  mux2x1 m1(w2[0],shift,datain[6],w[0]);
  
  DFF d2(w[1],w2[0],clock,reset);
  mux2x1 m2(w2[1],shift,datain[5],w[1]);
  
  DFF d3(w[2],w2[1],clock,reset);
  mux2x1 m3(w2[2],shift,datain[4],w[2]);
  
  DFF d4(w[3],w2[2],clock,reset);
  mux2x1 m4(w2[3],shift,datain[3],w[3]);
  
  DFF d5(w[4],w2[3],clock,reset);
  mux2x1 m5(w2[4],shift,datain[2],w[4]);
  
  DFF d6(w[5],w2[4],clock,reset);
  mux2x1 m6(w2[5],shift,datain[1],w[5]);
  
  DFF d7(w[6],w2[5],clock,reset);
  mux2x1 m7(w2[6],shift,datain[0],w[6]); 
  
  DFF d8(dataout,w2[6],clock,reset);
endmodule

module SISO(dataout,datain,clock,reset);
  input datain;
  input clock,reset;
  output dataout;
  wire [6:0]w;
  DFF d1(w[0],datain,clock,reset);
  DFF d2(w[1],w[0],clock,reset);
  DFF d3(w[2],w[1],clock,reset);
  DFF d4(w[3],w[2],clock,reset);
  DFF d5(w[4],w[3],clock,reset);
  DFF d6(w[5],w[4],clock,reset);
  DFF d7(w[6],w[5],clock,reset);
  DFF d8(dataout,w[6],clock,reset);
endmodule

module SIPO(dataout,datain,clock,reset);
  input datain;
  input clock,reset;
  output [7:0]dataout;
  DFF d1(dataout[0],datain,clock,reset);
  DFF d2(dataout[1],dataout[0],clock,reset);
  DFF d3(dataout[2],dataout[1],clock,reset);
  DFF d4(dataout[3],dataout[2],clock,reset);
  DFF d5(dataout[4],dataout[3],clock,reset);
  DFF d6(dataout[5],dataout[4],clock,reset);
  DFF d7(dataout[6],dataout[5],clock,reset);
  DFF d8(dataout[7],dataout[6],clock,reset);
endmodule
        
module mux2x1(out,S0,I0,I1);
  input I0,I1,S0;
  output out;
  assign out = (~S0)&I0 | S0&I1;
endmodule

module DFF(q,d,clk,rst);
  input d,clk,rst;
  output reg q;
  always @(posedge clk or posedge rst)
    begin
      if (rst==1)
        q<=0;
      else
        q<=d;
    end
endmodule
  
  
  