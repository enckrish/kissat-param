// Defining a template for multipliers with a parameterized bit width.
`define BIT_WIDTH {{BIT_WIDTH}}
  
// BIT_WIDTH=8 takes ~10 sec for CEC  
// BIT_WIDTH=9 takes ~43 sec for CEC  
// BIT_WIDTH=10 takes ~2 min 20 sec for CEC  
  
// unrolled_mult.v  
module unrolled_mult #(parameter WIDTH = `BIT_WIDTH) (  
    input  [WIDTH-1:0] a, b,  
    output [2*WIDTH-1:0] p  
);  
    // 2D array to hold the partial sums between stages  
    reg [2*WIDTH-1:0] stage [WIDTH:0];  
    integer i;  
  
    always @(*) begin  
        stage[0] = 0; // Initial stage is 0  
          
        for (i = 0; i < WIDTH; i = i + 1) begin  
            if (b[i])  
                // Add the shifted multiplicand  
                stage[i+1] = stage[i] + ({ {WIDTH{1'b0}}, a } << i);  
            else  
                // Pass the previous sum through  
                stage[i+1] = stage[i];  
        end  
    end  
  
    // The final stage contains the complete product  
    assign p = stage[WIDTH];  
  
endmodule  
  
// behavioral_mult.v  
module behavioral_mult #(parameter WIDTH = `BIT_WIDTH) (  
    input  [WIDTH-1:0] a, b,  
    output [2*WIDTH-1:0] p  
);  
      
    // The synthesizer extracts this and builds a parallel reduction tree  
    assign p = a * b;  
  
endmodule