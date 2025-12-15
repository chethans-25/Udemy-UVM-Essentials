/*
Create a class "my_object" by extending the UVM_OBJECT class. 
Add three logic datatype datamembers "a", "b", and "c" with sizes of 2, 4, and 8 respectively. 
Generate a random value for all the data members and send the values of the variables to the console by using the print method.
*/

class my_object extends uvm_object;
  logic [1:0] a;
  logic [3:0] b;
  logic [7:0] c;
  
  function new(string name = "my_object", uvm_parent parent = null);
    super.new(name, parent);
  endfunction
  
endclass