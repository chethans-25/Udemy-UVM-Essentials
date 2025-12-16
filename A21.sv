/*
Create a class "my_object" by extending the UVM_OBJECT class. 
Add three logic datatype datamembers "a", "b", and "c" with sizes of 2, 4, and 8 respectively. 
Generate a random value for all the data members and send the values of the variables to the console by using the print method.
*/
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

module tb;
  my_object m1;

  initial begin
    m1 = my_object::type_id::create("m1");
    m1.a = $urandom();
    m1.b = $urandom();
    m1.c = $urandom();
    m1.print();
  end
endmodule