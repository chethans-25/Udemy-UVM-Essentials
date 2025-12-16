/*
Send transaction data from COMPA to COMPB with the help of TLM PUT PORT to PUT IMP .
Transaction class code is added in Instruction tab. 
Use UVM core print method to print the values of data members of transaction class.
*/
`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_sequence_item;
 
  bit [3:0] a = 12;
  bit [4:0] b = 24;
  int c = 256;
  
  function new(string inst = "transaction");
    super.new(inst);
  endfunction
  
  `uvm_object_utils_begin(transaction)
    `uvm_field_int(a, UVM_DEFAULT | UVM_DEC);
    `uvm_field_int(b, UVM_DEFAULT | UVM_DEC);
    `uvm_field_int(c, UVM_DEFAULT | UVM_DEC); 
  `uvm_object_utils_end
  
endclass

class COMPA extends uvm_component;
  `uvm_component_utils(COMPA)
  transaction tx;
  function new(input string path = "COMPA", uvm_component parent = null);
    super.new(path, parent); 
  endfunction
  
  uvm_blocking_put_port #( transaction ) port;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tx = new();
    port = new("port", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
      `uvm_info("COMPA", "Data sent:", UVM_NONE)
      tx.print();
      port.put(tx);//define put method at the end point ( consumer )
    phase.drop_objection(this);
  endtask
  
endclass

class COMPB extends uvm_component;
  `uvm_component_utils(COMPB)
  transaction tr;
  function new(input string path = "COMPB", uvm_component parent = null);
    super.new(path, parent); 
  endfunction
  
  uvm_blocking_put_imp #( transaction, COMPB ) imp;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = new();
    imp = new("imp", this);
  endfunction

  function void put( transaction tr);
    `uvm_info("COMPB", "Data Received:", UVM_NONE)
    tr.print();
  endfunction

  
endclass

class env extends uvm_component;
`uvm_component_utils(env)

  COMPA compa;
  COMPB compb;

  function new(input string path = "env", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    compa = COMPA::type_id::create("compa", this);
    compb = COMPB::type_id::create("compb", this);
  endfunction

  virtual function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    compa.port.connect(compb.imp);
  endfunction
  
endclass


class test extends uvm_test;
`uvm_component_utils(test)
 
env e;
 
 function new(input string path = "test", uvm_component parent = null);
    super.new(path, parent);
endfunction
 
 
virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
  e = env::type_id::create("e",this);
endfunction
 
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();


  endfunction


endclass
 
//////////////////////////////////////////////
module tb;
 
 
initial begin
  run_test("test");
end
 
 
endmodule
 