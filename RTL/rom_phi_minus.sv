module rom_phi_minus (addr , data);
  	
  /* -1 for sign bit and -1 as our range is from 0 to -16 
  which is half the our range which is from -16 to 15.99 */
  localparam WIDTH = 15;
  localparam AWIDTH = 16 -1;
  
  /* number of entries of the memory
  2 ** WIDTH is enough for values from 0 till 15.99 
  we need one additonal place for (-16) */
  localparam DEPTH = (2 ** WIDTH); 
  
  input logic [AWIDTH-1:0] addr;
  output logic [WIDTH-1:0] data;
  
  (* rom_style="{block}" *)
  logic [WIDTH-1:0] rom [0:DEPTH-1];
  
  always@* begin 
    data = rom[addr];
  end 
  
  initial begin 
    $readmemb("rom_phi_minus.txt",rom);
  end 
  
endmodule 

				
				