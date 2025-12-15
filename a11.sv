// Send the name of the first RTL that you designed in Verilog.


`include "uvm_macros.svh"
import uvm_pkg::*;
 

module TB ();
  initial begin
  `uvm_info("TB", "FULL ADDER", UVM_NONE);
  #10 $finish;
  end
endmodule