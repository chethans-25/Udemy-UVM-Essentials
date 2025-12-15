/*
Add the code in the template mentioned below to achieve the following objectives:

1. Include four independent warning messages in the run task of component a.

2. The warning ID must be "a" and the messages must be "Warning 1" , "Warning 2" and so on.

3. Warning messages should be sent one after another starting from Warning 1 to Warning 4 at an interval of 10 ns i.e. Warning 1 at 0 ns, Warning 2 at 10 ns and so on.

4. Override the UVM_WARNING action so that it is included in the UVM quit count.

5. Set the quit count threshold at 4.

*/

// exit simulation with UVM_WARNING

`include "uvm_macros.svh"
import uvm_pkg::*;
 
//////////////////////////////////////////////////
class a extends uvm_component;
  `uvm_component_utils(a)
  
  function new(string path , uvm_component parent);
    super.new(path, parent);
  endfunction
 
 
  
  
  task run();
    /////////////////add four independent warning messages in this task(Main task)
    ////////////Add ID as "a" and Messages as Warning 1, Warning 2, Warning 3 and Warning 4
    ////////////Send the warning message one after another starting from warning 1 at an interval of 10 ns (warning 1 must trigger at 0 ns , warning 2 must trigger at 10 ns and so on)
    `UVM_WARNING("a", "WARNING 1")
    #10;
    `UVM_WARNING("a", "WARNING 2")
    #10;
    `UVM_WARNING("a", "WARNING 3")
    #10;
    `UVM_WARNING("a", "WARNING 4")
  endtask
  
 
  
endclass
 
/////////////////////////////////////////////
 
 
module tb;
 
///////////// Add a code to execute main task of a
//////////// Override the behavior of the UVM_WARNING such that it should be counted in UVM_QUIT COUNT
////////Set the quit count threshold to be 4
a a1;

initial
begin
  a1 = new ("a", null);
  a1.set_report_severity_action(UVM_WARNING, UVM_COUNT);//arguments are case sensitive
  a1.set_report_max_quit_count(4);
end 
endmodule