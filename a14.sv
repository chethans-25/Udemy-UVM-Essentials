/*
Write a TB_TOP Code to send message with ID : CMP1 to console while blocking message with ID : CMP2. 
Do not change component code.
*/


`include "uvm_macros.svh"
import uvm_pkg::*;
 
//////////////////////////////////////////////////
class component extends uvm_component;
  `uvm_component_utils(component)
  
  function new(string path , uvm_component parent = null);
    super.new(path, parent);
  endfunction
 
  
  task run();
    `uvm_info("CMP1", "Executed CMP1 Code", UVM_DEBUG);
    `uvm_info("CMP2", "Executed CMP2 Code", UVM_DEBUG);

  endtask

endclass
 


module TB_TOP;
  component comp;
  initial begin
    comp = new("comp", null);
    uvm_top.set_report_verbosity_level(UVM_DEBUG);
    comp.set_report_severity_id_override(UVM_DEBUG, "CMP2", UVM_NONE);
    comp.run();
  end
endmodule