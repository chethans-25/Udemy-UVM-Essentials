
/*
Design an environment consisting of a single producer class "PROD" and three subscribers viz., iz. "SUB1", "SUB2", and "SUB3". 
Add logic such that the producer broadcasts the name of the coder and all the subscribers are able to receive the string data sent by the producer. 
If Zen is writing the logic, then the producer should broadcast the string "ZEN" and all the subscribers must receive "ZEN".
*/


`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_sequence_item;
 
  string coder = " ";
  
  function new(string inst = "transaction");
    super.new(inst);
  endfunction
  
  `uvm_object_utils_begin(transaction)
    `uvm_field_string(coder, UVM_ALL_ON); //UVM_ALL_ON inclusion: recording, printing, and comparing
  `uvm_object_utils_end

  
endclass //transaction

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class PROD extends uvm_component;
  `uvm_component_utils(PROD)
  transaction tx;
  function new(input string path = "PROD", uvm_component parent = null);
    super.new(path, parent); 
  endfunction
  
  uvm_analysis_port #( transaction ) port;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tx = new();
    port = new("port", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
      tx.coder = "Chethan";
      `uvm_info("PROD", $sformatf("Data Sent: Coder name: %0s", tx.coder), UVM_NONE)
      port.write(tx);//define write method at the end point ( SUB1 , 2, 3)
    phase.drop_objection(this);
  endtask
  
endclass //PROD

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class SUB1 extends uvm_component;
  `uvm_component_utils(SUB1)
  transaction tr;
  function new(input string path = "SUB1", uvm_component parent = null);
    super.new(path, parent); 
  endfunction
  
  uvm_analysis_imp #( transaction, SUB1 ) imp;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = new();
    imp = new("imp", this);
  endfunction

  function void write( transaction tr);
    `uvm_info("SUB1",  $sformatf("Data Received: Coder name: %0s", tr.coder), UVM_NONE)
  endfunction
endclass //SUB1

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


class SUB2 extends uvm_component;
  `uvm_component_utils(SUB2)
  transaction tr;
  function new(input string path = "SUB2", uvm_component parent = null);
    super.new(path, parent); 
  endfunction
  
  uvm_analysis_imp #( transaction, SUB2 ) imp;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = new();
    imp = new("imp", this);
  endfunction

  function void write( transaction tr);
    `uvm_info("SUB2",  $sformatf("Data Received: Coder name: %0s", tr.coder), UVM_NONE)
  endfunction
endclass //SUB2

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class SUB3 extends uvm_component;
  `uvm_component_utils(SUB3)
  transaction tr;
  function new(input string path = "SUB3", uvm_component parent = null);
    super.new(path, parent); 
  endfunction
  
  uvm_analysis_imp #( transaction, SUB3 ) imp;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = new();
    imp = new("imp", this);
  endfunction

  function void write( transaction tr);
    `uvm_info("SUB3",  $sformatf("Data Received: Coder name: %0s", tr.coder), UVM_NONE)
  endfunction //SUB3

  
endclass
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class env extends uvm_component;
`uvm_component_utils(env)

  PROD p;
  SUB1 s1;
  SUB2 s2;
  SUB3 s3;

  function new(input string path = "env", uvm_component parent = null);
    super.new(path, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    p = PROD::type_id::create("p", this);
    s1 = SUB1::type_id::create("s1", this);
    s2 = SUB2::type_id::create("s2", this);
    s3 = SUB3::type_id::create("s3", this);
  endfunction

  virtual function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    p.port.connect(s1.imp);
    p.port.connect(s2.imp);
    p.port.connect(s3.imp);
  endfunction
  
endclass //env

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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


endclass //test
 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module tb;

  initial begin
    run_test("test");
  end

endmodule //tb
 