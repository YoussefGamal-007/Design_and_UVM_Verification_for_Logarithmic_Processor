`timescale 1ns / 1ps

module log_alu_tb;

  localparam WIDTH = 16;
  typedef enum logic [2:0] {ADD , SUB , MULT , DIV , POW , SQRT} opcode_t;
  
  // inputs 
   logic [WIDTH-1:0] logx;
   logic [WIDTH-1:0] logy;
   logic [2:0] op;
  
  logic [WIDTH-1:0] logz;
  logic pos_inf , neg_inf;
  logic NaN;
  
  log_alu UUT (logx , logy , logz , op , pos_inf , neg_inf , NaN);
  
  initial begin 
    
    #5;
    $display("------------ test 1 (ADD) ------------");
    logx = 16'b0000101001010111;  // 6
    logy = 16'b0000111100000101;  // 13.5 
    op = ADD;
    #5; $display("the output of 6 + 13.5 >> %16b " , logz);  // 19.5
        $display("+inf = %0b ====== -inf = %0b  ====== NaN = %0b", pos_inf , neg_inf , NaN);
    
    #5;
    $display("------------ test 2 (SUB) ------------");
    logx = 16'b0001101010010011;   // 100
    logy = 16'b0001011100100000;   // 55
    op = SUB;
    #5; $display("the output of 100 - 55 >> %16b " , logz);  // 45
        $display("+inf = %0b ====== -inf = %0b  ====== NaN = %0b", pos_inf , neg_inf , NaN);
    
    
    #5;
    $display("------------ test 3 (MULT) ------------");
    logx = 16'b0011100011111111;   // 19482
    logy = 16'b1111010001000110;   // -0.131
    op = MULT;
    #5; $display("the output of 19482 * -0.131 >> %16b " , logz);  // -2552.142
        $display("+inf = %0b ====== -inf = %0b  ====== NaN = %0b", pos_inf , neg_inf , NaN);
    

    #5;
    $display("------------ test 4 (DIV) ------------");
    logx = 16'b0010011101010100;   // 912
    logy = 16'b0111110000000000;   // 0.5
    op = DIV;
    #5; $display("the output of 912 / 0.5 >> %16b " , logz);  // 1824
        $display("+inf = %0b ====== -inf = %0b  ====== NaN = %0b", pos_inf , neg_inf , NaN);
    
    
    #5;
    $display("------------ test 5 (POW) ------------");
    logx = 16'b1111010010101000;   // -0.14 
    logy = 16'b0111110000000000;   // 0.5
    op = POW;
    #5; $display("the output of POW(-0.14) >> %16b " , logz);  // -0.0196
        $display("+inf = %0b ====== -inf = %0b  ====== NaN = %0b", pos_inf , neg_inf , NaN);
   
   
    #5;
    $display("------------ test 6 (SQRT) ------------");
    logx = 16'b0011111111110011;   // 65000 
    logy = 16'b0111110000000000;   // 0.5    // he sees 0.5 > 65000 as the comparison is UNSGINED [solved by $signed()]
    op = SQRT;
    #5; $display("the output of SQRT(65000) >> %16b " , logz);  // 254.951
        $display("+inf = %0b ====== -inf = %0b  ====== NaN = %0b", pos_inf , neg_inf , NaN);
    
    
    #5;
    $display("------------ test 7 (ADD -- OVERFLOW) ------------");
    logx = 16'b0011111111110011;   // 65000 
    logy = 16'b0011111111110011;   // 65000   /
    op = ADD;
    #5; $display("the output of 65000 + 65000  >> %16b " , logz);  // overflow
        $display("+inf = %0b ====== -inf = %0b  ====== NaN = %0b", pos_inf , neg_inf , NaN);
    
    
    #5;
    $display("------------ test 8 (ADD -- OVERFLOW) ------------");
    logx = 16'b1011111111110011;   // -65000 
    logy = 16'b1011100111110111;   // -23042   /
    op = ADD;
    #5; $display("the output of -65000 + -23042  >> %16b " , logz);  // overflow
        $display("+inf = %0b ====== -inf = %0b  ====== NaN = %0b", pos_inf , neg_inf , NaN);
    
    
    #5;
    $display("------------ test 9 (SUB -- EQUAL_NUMBERS) ------------");
    logx = 16'b1001010010000100;   //  -35
    logy = 16'b0001010010000100;   //   35      // will result in log2(0) >> -inf 
    op = SUB;
    #5; $display("the output of -35 - 35  >> %16b " , logz);  // overflow
        $display("+inf = %0b ====== -inf = %0b  ====== NaN = %0b", pos_inf , neg_inf , NaN);
    
    
    #5;
    $display("------------ test 10 (MULT -- OVERFLOW) ------------");
    logx = 16'b0010101111100100;   //  2010
    logy = 16'b0010011110010001;   //   950      
    op = MULT;
    #5; $display("the output of 2010 * 950  >> %16b " , logz);  // overflow
        $display("+inf = %0b ====== -inf = %0b  ====== NaN = %0b", pos_inf , neg_inf , NaN);
       
        
    #5;
    $display("------------ test 11 (MULT -- UNDERFLOW) ------------");
    logx = 16'b0101110000000000;   //  2 ** -9
    logy = 16'b0101100000000000;   //   2 ** -10      
    op = MULT;
    #5; $display("the output of 2 ^-9 * 2^-10  >> %16b " , logz);  // underflow
        $display("+inf = %0b ====== -inf = %0b  ====== NaN = %0b", pos_inf , neg_inf , NaN);
    
    
    #5;
    $display("------------ test 12 (DIV -- OVERFLOW) ------------");
    logx = 16'b0011110000000000;   //  2  ** 15
    logy = 16'b0110100000000000;   //   2 ** -6      
    op = DIV;
    #5; $display("the output of 2 ^15 / 2 ^-6  >> %16b " , logz);  // overflow
        $display("+inf = %0b ====== -inf = %0b  ====== NaN = %0b", pos_inf , neg_inf , NaN);
        
        
    #5;
    $display("------------ test 13 (DIV -- UNDERFLOW) ------------");
    logx = 16'b0101000000000000;   //  2 ** -12
    logy = 16'b0010100000000000;   //  2 ** 10      
    op = DIV;
    #5; $display("the output of 2 ^-12 / 2 ^10  >> %16b " , logz);  // overflow
        $display("+inf = %0b ====== -inf = %0b  ====== NaN = %0b", pos_inf , neg_inf , NaN);
        
    
    #5;
    $display("------------ test 14 (POW -- OVERFLOW) ------------");
    logx = 16'b0011100000000000;   //  2 ** 14
    logy = 16'b0010100000000000;   //  2 ** 10      
    op = POW;
    #5; $display("the output of (2 ** 14) ^ 2  >> %16b " , logz);  // overflow
        $display("+inf = %0b ====== -inf = %0b  ====== NaN = %0b", pos_inf , neg_inf , NaN);
        
        
    #5;
    $display("------------ test 15 (POW -- UNDERFLOW) ------------");
    logx = 16'b0100010000000000;   //  2 ** -15
    logy = 16'b0010100000000000;   //  2 ** 10      
    op = POW;
    #5; $display("the output of (2 ** -15) ^ 2  >> %16b " , logz);  // underflow
        $display("+inf = %0b ====== -inf = %0b  ====== NaN = %0b", pos_inf , neg_inf , NaN);
        
        
    #5;
    $display("------------ test 16 (ADD -- ZERO) ------------");
    logx = 16'b0100000000000000;   //  2 ** -16 [0]
    logy = 16'b0010100000000000;   //  2 ** 10      
    op = ADD;
    #5; $display("the output of 0 + 1024  >> %16b " , logz);  
        $display("+inf = %0b ====== -inf = %0b  ====== NaN = %0b", pos_inf , neg_inf , NaN);
        
    
    #5;
    $display("------------ test 17 (SUB -- ZERO) ------------");
    logx = 16'b0001111100100000;   //  220
    logy = 16'b0100000000000000;   //  2 ** -16 [0]     
    op = SUB;
    #5; $display("the output of 220 - 0  >> %16b " , logz);  
        $display("+inf = %0b ====== -inf = %0b  ====== NaN = %0b", pos_inf , neg_inf , NaN);
        
    
    #5;
    $display("------------ test 18 (MULT -- ZERO) ------------");
    logx = 16'b0100000000000000;   //  2 ** -16 [0] 
    logy = 16'b1011100010101010;   //  -18392      
    op = MULT;
    #5; $display("the output of 0 * -18392 >> %16b " , logz);  
        $display("+inf = %0b ====== -inf = %0b  ====== NaN = %0b", pos_inf , neg_inf , NaN);
        
        
    #5;
    $display("------------ test 19 (DIV -- ZERO/) ------------");
    logx = 16'b0100000000000000;   //  2 ** -16 [0] 
    logy = 16'b0000000000000000;   //  1    
    op = DIV;
    #5; $display("the output of 0 / 1 >> %16b " , logz);  
        $display("+inf = %0b ====== -inf = %0b  ====== NaN = %0b", pos_inf , neg_inf , NaN);    
        
    
    #5;
    $display("------------ test 20 (DIV -- /ZERO) ------------");
    logx = 16'b0000000000000000;   //  1
    logy = 16'b0100000000000000;   //  2 ** -16 [0]      
    op = DIV;
    #5; $display("the output of 1 / 0  >> %16b " , logz);  
        $display("+inf = %0b ====== -inf = %0b  ====== NaN = %0b", pos_inf , neg_inf , NaN);
    
    
    #5;
    $display("------------ test 21 (POW -- ZERO) ------------");
    logx = 16'b0100000000000000;   //  2 ** -16 [0] 
    logy = 16'b0010100000000000;   //  2 ** 10      
    op = POW;
    #5; $display("the output of (0) ^ 2  >> %16b " , logz);  
        $display("+inf = %0b ====== -inf = %0b  ====== NaN = %0b", pos_inf , neg_inf , NaN);
        
        
    #5;
    $display("------------ test 22 (SQRT -- ZERO) ------------");
    logx = 16'b0100000000000000;   //  2 ** -16 [0] 
    logy = 16'b0010100000000000;   //  2 ** 10      
    op = SQRT;
    #5; $display("the output of SQRT(0)  >> %16b " , logz);  
        $display("+inf = %0b ====== -inf = %0b  ====== NaN = %0b", pos_inf , neg_inf , NaN); 
        
    
    #5;
    $display("------------ test 23 (SQRT -- NEGATIVE_VALUE) ------------");
    logx = 16'b1000110101001001;   //  -10
    logy = 16'b0010100000000000;   //  2 ** 10      
    op = SQRT;
    #5; $display("the output of SQRT(-10)  >> %16b " , logz);  
        $display("+inf = %0b ====== -inf = %0b  ====== NaN = %0b", pos_inf , neg_inf , NaN);
  end 
endmodule
