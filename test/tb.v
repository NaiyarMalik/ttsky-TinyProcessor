`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

   // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;
`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  parameter DATA_WIDTH_TB = 8;
  parameter ADDR_WIDTH_TB = 4;

  initial 
    begin
    clk = 0;
  end

  always #10 clk = ~clk;


  // Dump the signals to a FST file. You can view it with gtkwave or surfer.
  initial 
    begin

      rst_n = 0;
      ena = 1;
      ui_in = 8'b0;
      uio_in = 8'b0;

    #100;
      rst_n = 1;

      $dumpfile("tb.fst");
      $dumpvars(0, tb);
      #1;

    // Write CMD
    write_cmd(4'h5, 8'hFF);
    check_wr(4'h5, 8'hFF);

    end

task UART_BIT_DELAY;
  begin
    repeat(32*14)
      @(posedge clk);
  end

endtask

task LD_FRAME ;
  input  [DATA_WIDTH_TB-1:0]  FRAME_DATA ;
 
  integer   i  ;

	
  begin
  
	    ui_in[0] <= 1'b0 ;                    // start_bit
      UART_BIT_DELAY();

	  for(i=0; i<8; i=i+1)
		  begin
		      ui_in[0] <= FRAME_DATA[i] ;       // frame data bits 
          UART_BIT_DELAY();         
		  end 

	  if(user_project.U0_RegFile.REG2[0])
		  begin
          
            case(user_project.U0_RegFile.REG2[1])
              1'b0 : ui_in[0] <= ^FRAME_DATA  ;     // Even Parity
              1'b1 : ui_in[0] <= ~^FRAME_DATA ;     // Odd Parity
            endcase	

            UART_BIT_DELAY();
       
		  end
	
	  ui_in[0] <= 1'b1 ;              // stop_bit
    UART_BIT_DELAY();
  end
endtask 

task check_wr;
  input  [ADDR_WIDTH_TB-1:0]  ADDR ;
  input  [DATA_WIDTH_TB-1:0]  DATA ;
 
  begin
    wait(user_project.U0_RegFile.WrEn)
	  repeat(2) @(posedge clk); 
	  if(user_project.U0_RegFile.regArr[ADDR[ADDR_WIDTH_TB-1:0]] == DATA)
		  begin
		  	$display("Write Operation is succeeded with configurations PARITY_ENABLE=%d PARITY_TYPE=%d  PRESCALE=%d  ",user_project.U0_RegFile.REG2[0],user_project.U0_RegFile.REG2[1],user_project.U0_RegFile.REG2[7:2]);
		  end
	  else
		  begin
			  $display("Write Operation is failed with configurations PARITY_ENABLE=%d PARITY_TYPE=%d  PRESCALE=%d  ",user_project.U0_RegFile.REG2[0],user_project.U0_RegFile.REG2[1],user_project.U0_RegFile.REG2[7:2]);
	  	end	
  end
  endtask

task write_cmd;
  input [ADDR_WIDTH_TB-1:0] ADDR;
  input [DATA_WIDTH_TB-1:0] DATA;

  begin

    LD_FRAME(8'hAA);
    LD_FRAME(ADDR);
    LD_FRAME(DATA);

  end 
endtask


 

  // Replace tt_um_example with your module name:
  tt_um_TinyProcessor_naiyar_ user_project (

      // Include power ports for the Gate Level test:
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif

      .ui_in  (ui_in),    // Dedicated inputs - UART_RX
      .uo_out (uo_out),   // Dedicated outputs - UART_TX, Parity_Error, Framing Error
      .uio_in (uio_in),   // IOs: Input path
      .uio_out(uio_out),  // IOs: Output path
      .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
      .ena    (ena),      // enable - goes high when design is selected
      .clk    (clk),      // clock
      .rst_n  (rst_n)     // not reset
  );

endmodule
