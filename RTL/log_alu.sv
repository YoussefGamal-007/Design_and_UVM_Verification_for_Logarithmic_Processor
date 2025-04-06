module log_alu (logx , logy , logz , op , pos_inf , neg_inf , NaN);
	
  // parameter & typedefs
  localparam WIDTH = 16;
  localparam ZERO = 15'b10000_0000000000;       // reserved value for x or y = 0
  typedef enum logic [2:0] {ADD , SUB , MULT , DIV , POW , SQRT} opcode_t;
  
  // inputs 
  input logic [WIDTH-1:0] logx;
  input logic [WIDTH-1:0] logy;
  input logic [2:0] op;
  
  // outputs
  output logic pos_inf , neg_inf;   // overflow and underflow flags
  output logic NaN;                 // Undefined Flag (Not A Number)
  output logic[WIDTH-1:0] logz;
  
  
  // ================== Comparator ===================
  
  // we must ensure |lx| is greater than |ly| [during add or sub only] ??
  // abs comparison not signed
  // so ly - lx is always negative 
  logic [WIDTH-2:0] lx , ly;
  always_comb begin 
    if (op == 0 || op == 1) begin // add or sub
    // signed comparison solving the problem in test 6
        if($signed(logx[WIDTH-2:0]) >= $signed(logy[WIDTH-2:0])) begin 
            lx = logx[WIDTH-2:0];
            ly = logy[WIDTH-2:0];   
         end else begin
            lx = logy[WIDTH-2:0];
            ly = logx[WIDTH-2:0];
        end 
    end else begin 
            lx = logx[WIDTH-2:0];
            ly = logy[WIDTH-2:0];   
    end  
  end 
  
  // alternative >> if ly is bigger subtract lx - ly instead of ly - lx
  
  
  // ================== Add/Sub 1 ==================
  logic sub1;
  logic [WIDTH-2:0] result1;
  always@* begin
    if(sub1)
        result1 = ly - lx;
    else 
        result1 = ly + lx;
  end 
  
  // ================== ROMs ==================
  logic [WIDTH-2:0] rom_out_plus , rom_out_minus;
  logic [WIDTH-2:0] rom_out;
  logic [WIDTH-1:0] addr;       // addr is 2's_comp(result1)
  logic minus; // control signal 
  
  assign addr = ~result1 + 1;
  rom_phi_plus  phi_plus (addr , rom_out_plus);
  rom_phi_minus phi_minus(addr , rom_out_minus);
  
  always_comb begin 
    if(minus)
        rom_out = rom_out_minus;
    else 
        rom_out = rom_out_plus;
  end
  
  // ================== MUXes ==================
  logic mux;
  logic [WIDTH-2:0] op1 , op2;
  logic [WIDTH-2:0] lm = 0;  // scaling factor [not used till now]
  always_comb begin
    if(mux) begin
        op1 = result1;
        op2 = lm;
    end else begin
        if(lx == ly && op == 1) begin  // operation is sub
            op1 = 15'b00001_00000_00000;  // 1   // solving issue when sub 2 equal numbers in magnitude
            op2 = lx;
        end else begin
            op1 = rom_out;
            op2 = lx;
        end 
    end
  end   
  
  // ================== Add/Sub 2 ==================
  logic sub2;
  logic [WIDTH-2:0] result2;
  always@* begin
    if(sub2)
        result2 = op1 - op2;
    else 
        result2 = op1 + op2;
  end 
  
  // ================== Control logic ==================
  /* 
   -- handles signs 
   -- control signals for other blocks according to the operation 
   -- handles overflow and underflow (+- inf) 
   -- handles NaN 
   -- handles precision loss (not implemented in current design version) ?
  */
   
  logic sx , sy , sz;
  //logic precision_loss
  logic [WIDTH-2:0] powx;
  logic [WIDTH-2:0] sqrtx;

  assign sx = logx[WIDTH-1];
  assign sy = logy[WIDTH-1];
  
  opcode_t operation;
  assign operation = opcode_t'(op);
  always_comb begin
    sz = sx; sub1 = 0; minus = 0; mux = 0; sub2 = 0; powx = 0; sqrtx = 0; pos_inf = 0; neg_inf = 0; NaN = 0;
    case(operation) 
        ADD: 
            begin 
                sz = sx; sub1 = 1; minus = 0; mux = 0; sub2 = 0; powx = 0; sqrtx = 0;
                
                if( (op1[WIDTH-2] && op2[WIDTH-2] && !result2[WIDTH-2]) )        // msb(1) + msb(1) = msb(0)
                    neg_inf = 1;
                else if ( (!op1[WIDTH-2] && !op2[WIDTH-2] && result2[WIDTH-2]) ) // msb(0) + msb(0) = msb(1)
                    pos_inf = 1;
            end 
        SUB:
            begin 
                sz = sx; sub1 = 1; minus = 1; mux = 0; sub2 = 0; powx = 0; sqrtx = 0;
                
                if( (op1[WIDTH-2] && op2[WIDTH-2] && !result2[WIDTH-2]) )        // same as ADD
                    neg_inf = 1;
                else if ( (!op1[WIDTH-2] && !op2[WIDTH-2] && result2[WIDTH-2]) ) 
                    pos_inf = 1; 
            end 
        MULT:
            begin 
                sz = sx ^ sy; sub1 = 0; minus = 1'bx; mux = 1; sub2 = 0; powx = 0; sqrtx = 0;
                
                if( (ly[WIDTH-2] && lx[WIDTH-2] && !result1[WIDTH-2]) )           // same as ADD
                    neg_inf = 1;
                else if ( (!ly[WIDTH-2] && !lx[WIDTH-2] && result1[WIDTH-2]) )
                    pos_inf = 1;
            end 
        DIV:
            begin 
                sz = sx ^ sy; sub1 = 1; minus = 1'bx; mux = 1; sub2 = 0; powx = 0; sqrtx = 0;
                
                if( (!lx[WIDTH-2] && ly[WIDTH-2] && !result1[WIDTH-2]) )        // msb(0) - msb(1) = msb(1)
                    pos_inf = 1;
                else if ( (lx[WIDTH-2] && !ly[WIDTH-2] && result1[WIDTH-2]) )   // msb(1) - msb(0) = msb(0)
                    neg_inf = 1; 
                    
                if (ly == ZERO)         // divide by 0 
                    NaN = 1;
            end
        POW: 
            begin 
                powx = {lx[WIDTH-3:0] , 1'b0};    // shift left (logical) ??
                sz = sx; sub1 = 0; minus = 0; mux = 0; sub2 = 0; sqrtx = 0;
                
                if(!lx[WIDTH-2] && lx[WIDTH-3])         // msb_old(0)[+ve] & msb_new(1) >> pow made it negative 
                    pos_inf = 1;
                else if (lx[WIDTH-2] && !lx[WIDTH-3])   // msb_old(1)[-ve] & msb_new(0) >> pow made it positive 
                    neg_inf = 1; 
            end 
        SQRT: 
            begin 
                sqrtx = {lx[WIDTH-2] , lx[WIDTH-2:1]};   // shift right (arithmetic)
                sz = sx; sub1 = 0; minus = 0; mux = 0; sub2 = 0; powx = 0;
                
                if (sx == 1)        // SQRT of negative value is invalid
                    NaN = 1;        
              end 
        default: 
            begin 
             sz = sx; sub1 = 0; minus = 0; mux = 0; sub2 = 0; powx = 0; sqrtx = 0;
             end 
    endcase
  end
  
  
  // generating output 
  logic [WIDTH-2:0] lz;
  always_comb begin
    if (lx == ZERO || ly == ZERO) begin 
        case(operation) 
            ADD , SUB : begin
                            if (lx == ZERO)
                                lz = ly;
                            else
                                lz = lx;
                        end 
            MULT: lz = ZERO;                            
            DIV : begin 
                    if (lx == ZERO)
                        lz = ZERO;
                    else 
                        lz = result2;  // i dont care with the value as NaN will be 1 here
                  end
            POW: begin 
                    if (lx == ZERO)
                        lz = ZERO;
                    else 
                        lz = powx;
                 end 
            SQRT: begin
                    if (lx == ZERO)
                        lz = ZERO;
                    else 
                        lz = sqrtx;
                 end 
            default: lz = 0;
        endcase
    end else begin 
        if (operation == SQRT)
            lz = sqrtx;
         else if (operation == POW)
            lz = powx;
         else
            lz = result2;
     end
   end 
   
  assign logz = {sz , lz};
  
endmodule 