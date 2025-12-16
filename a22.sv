/*
1) Create a class "my_object" by extending the UVM_OBJECT class. Add three logic datatype datamembers "a", "b", and "c" with sizes of 2, 4, and 8 respectively.

2) Create two objects of my_object class in TB Top. Generate random data for data members of one of the object and then copy the data to other object by using clone method.

3) Compare both objects and send the status of comparison to Console using Standard UVM reporting macro. Add User defined implementation for the copy method.
*/

// Questions for this assignment
// Comparing two objects of the class.

`include "uvm_macros.svh"
import uvm_pkg::*;

class my_object extends uvm_object;
  logic [1:0] a;
  logic [3:0] b;
  logic [7:0] c;
  
  function new(string name = "my_object");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(my_object)
    `uvm_field_int(a,UVM_DEFAULT);
    `uvm_field_int(b,UVM_DEFAULT);
    `uvm_field_int(c,UVM_DEFAULT);
  `uvm_object_utils_end

  
endclass

module tb_top;
  my_object m1, m2;
  bit status;
  initial
  begin
    m1 = my_object::type_id::create("m1");
    m1.a = $urandom();
    m1.b = $urandom();
    m1.c = $urandom();

    $cast(m2,m1.clone());

    status = m1.compare(m2);

    if(status)
    begin
      `uvm_info("tb_top", "Objects Matched", UVM_LOW);
    end
    else
    begin
      `uvm_info("tb_top", "Objects Mismatched", UVM_LOW);
    end
  end 

endmodule