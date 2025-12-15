/*
Override the UVM_WARNING action to make quit_count equal to the number of times UVM_WARNING executes. 
Write an SV code to send four random messages to a terminal with potential error severity, 
Simulation must stop as soon as we reach to quit_count of four. 
Do not use UVM_INFO, UVM_ERROR, UVM_FATAL, or $finish in the code.
*/

// Override the UVM_WARNING action


`include "uvm_macros.svh"
import uvm_pkg::*;
 
//////////////////////////////////////////////////
class driver extends uvm_driver;
  `uvm_component_utils(driver)
  
  function new(string path , uvm_component parent);
    super.new(path, parent);
  endfunction
 
 
  
  
  task run();
    `uvm_info("DRV", "Informational Message", UVM_NONE);
    `uvm_warning("DRV", "Potential Error 1");
    `uvm_warning("DRV", "Potential Error 2");
    `uvm_warning("DRV", "Potential Error 3");
    `uvm_warning("DRV", "Potential Error 4");
    `uvm_warning("DRV", "Potential Error 5");
  endtask
  
 
  
endclass
 
/////////////////////////////////////////////
 
 
module tb;
  driver drv;
  
  initial begin
    drv = new("DRV", null);
    drv.set_report_severity_action(UVM_WARNING, UVM_COUNT);//arguments are case sensitive
    drv.set_report_max_quit_count(4);
    drv.run();
  end

endmodule