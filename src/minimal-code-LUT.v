module codeLUT(CLK, RST,
  input [3:0] ancilla,
  output [4:0] correction,
  output [1:0] axis);
  
  // 2 cycle in-to-out delay. fully pipelined.
  input [3:0] ancilla_r;
  reg [1:0] axis_r;
  reg [4:0] correction_r;
  
  always @(posedge CLK) begin
    if (RST) begin
      ancilla_r <= 0;
      axis_r <= 0;
      correction_r <= 0;
    end else begin
      ancilla_r <= ancilla;
      if (axis_r == 0) begin // x
        case(ancilla_r)
          4'b0001: correction_r <= 5'b10000;
          4'b1000: correction_r <= 5'b01000;
          4'b1100: correction_r <= 5'b00100;
          4'b0110: correction_r <= 5'b00010;
          4'b0011: correction_r <= 5'b00001;
          else:    correction_r <= 5'b00000;
        endcase
      end else if (axis_r == 1) begin // y
        case(ancilla_r)
          4'b1011: correction_r <= 5'b10000;
          4'b1101: correction_r <= 5'b01000;
          4'b1110: correction_r <= 5'b00100;
          4'b1111: correction_r <= 5'b00010;
          4'b0111: correction_r <= 5'b00001;
          else:    correction_r <= 5'b00000;
        endcase
      end else begin // z
        case(ancilla_r)
          4'b1011: correction_r <= 5'b10000;
          4'b1101: correction_r <= 5'b01000;
          4'b1110: correction_r <= 5'b00100;
          4'b1111: correction_r <= 5'b00010;
          4'b0111: correction_r <= 5'b00001;
          else:    correction_r <= 5'b00000;
        endcase
      end
      correction <= correction_r;
      axis <= axis_r;
      axis_r <= axis_r + 1; // loop over X, Y, Z 
    end
  end

endmodule
      

        