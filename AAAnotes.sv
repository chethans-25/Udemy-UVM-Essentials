UVM ESSENTIALS 


REPORTING MECHANISM

uvm_info( id, msg, verbosity)
uvm_warning(id, msg)
uvm_error(id, msg)
uvm_fatal(id, msg)

default verbosity is 200 which is known as UVM_MEDIUM
default value can be changed

verbosity should be less than default in order for the message to get displayed on the console

uvm_fatal- simulation exits via $finish after 0 delay

`include "uvm_macros.svh"  
consists of definitions of all macros, eg: uvm_info

import uvm_pkg::*;
gets access to definition of classes.

the above two lines should be included in all uvm projects


All macros should start with ` and should not end with ;


Working with uvm_info()
it shows the id which we specify in the argument, what file is sending the message, line number, at what time, file hierarchy

this is how uvm_info is different from $display

sformatf("value : %0d", data);
//system function to send string as well as a variable


uvm_root is the parent to all classes
cannot directly access it. some cases, we may need to access it.
so, uvm provides global variable uvm_top which is accessible to all classes of TB environment
uvm_top can be used when we want to work with uvm_root

// to know current verbosity level
$display(" default verbosity level : %0d ", uvm_top.get_report_verbosity_level);

//to change verbosity level
uvm_top.set_report_verbosity_level(UVM_HIGH);

//factory registration
`uvm_component_utils(driver)

//to set verbosity for specific ID
set_report_id_verbosity(ID, new_verbosity);

//to set verbosity for specific object
drv.set_report_verbosity_level(UVM_HIGH);

//to change verbosity of entire TB environment
//run options on the left side of eda website
+UVM_VERBOSITY = UVM_HIGH


WORKING WITH HIERARCHY

//to set verbosity for an entire hierarchy
//the following line sets UVM_HIGH to all components present in environment env
env.set_report_verbosity_level_hier(UVM_HIGH)



OTHER REPORTING MACROS

uvm_warning --- potential error --- yellow color

uvm_error ---- actual error --- red color

uvm_fatal  ---- fatal error --- red color



SYSTEM FUNCTIONS

//To override severity of entire class
drv.set_report_severity_override(UVM_FATAL, UVM_ERROR);

//To override severity of particular id
drv.set_report_severity_id_override(UVM_FATAL," ID ", UVM_ERROR);


ACTIONS ASSOCIATED WITH REPORTING MACROS

Refer LRM for available actions.

//function to set action for a specific severity
drv.set_report_severity_action(UVM_INFO, UVM_DISPLAY | UVM_EXIT);
//the above line, makes changes to UVM_INFO such that UVM_INFO sends messages on console and EXITS from the simulation.


//to set error threshold to exit simulation
drv.set_report_max_quit_count( 10 );
//after 10 error, die method is called, which exits the simulation.

//default for error is 0. For Fatal, it is 1

//warning and info doesn't have uvm_count
//they can also be added by overriding actions



WORKING WITH LOG FILE
agenda: to copy everything from console to a file.

store file descripter id in an int variable
int file;
file = $fopen ( "log.txt", "w");


drv.set_report_default_file(file);//everything is copied
drv.set_report_severity_file(UVM_ERROR, file); //copies only UVM_ERROR


*****GETTING STARTED WITH BASE CLASSES: UVM_OBJECT

dynamic:  UVM_OBJECT
uvm_transaction
uvm_sequence_item
uvm_sequence

static: UVM_COMPONENT
uvm_driver
uvm_sequencer
uvm_monitor
uvm_agent
uvm_scoreboard
uvm_env
uvm_test



core methods: provide automation
field macros:
print, record, copy, compare, create, clone, pack+unpack
available in uvm_pkg

user defined do_ methods:
do_print, do_copy, etc

instead of registering entire class to factory, we can register only certain members of class:
`uvm_object_utils_begin(drv)
`uvm_field_int(<variable_name>, <flag>)
`uvm_object_utils_end

refer LRM for different macros and flags

print() method
provides value, type of members registered with factory in a table format.
//factory registration should be done with utils_begin()



ARRAYS

static/fixed array
dynamic array
queue
associative array


`uvm_field_sarray_int(<variable_name>, <flag>)
`uvm_field__array_int(<variable_name>, <flag>)
`uvm_field_queue_int(<variable_name>, <flag>)
`uvm_field_aa_int(<variable_name>, <flag>)


CORE METHODS:
CLONE, COPY

COPY
create constructor for both members

f=new();
s=new();
s.copy(f);




CLONE
consttructor is not needed for 2nd member

f=new();
$cast(s,f.clone());


Shallow copy
s=f

Deep copy
s.copy(f)
$cast(s,f.clone())


COMPARE
obj1.compare(obj2);


CREATE
drv = agent::type_id::create("drv");

advantage of create method
Supports type overriding of objects
C.set_type_override_by_type(child::get_type, parent::get_type);


If we use do methos, field macros are not required, but registering class to factory is mandatory to get capabilities of factory override

If we use inbuilt core methods, field macros are required,and registering class to factory is also mandatory 


DO METHODS

do_print
//table format

virtual function void do_print (uvm_printer printer);
  super.do_print(printer);
  printer.print_field_int("a",a,$bits(a), UVM_DEC)//name,source, number of bits, radix
  printer.print_field_string("b",b)//name,source
  printer.print_field_real("c",c)//name,source
  printer.print_object("data", data);//name,source
endfunction

convert2string
//output in single line

virtual function void convert2string ();
  string s = super.convert2string();
  s = {s, $sformatf("a : %0d ", a)};
  s = {s, $sformatf("b : %0d ", b)};
  s = {s, $sformatf("c : %0d ", c)};
  return s;
endfunction

//inside tb
`uvm_info ("TB_TOP", $sformatf("%0s", o.convert2string), UVM_NONE);

do_copy
virtual function void do_copy(uvm_object rhs);
  obj temp;
  $cast(temp, rhs);
  // has access to handle of rhs

  super.do_copy(rhs);
  this.a = temp.a;
  this.b = temp.b;
endfunction

// inside tb
obj o1, o2;

//create object with create method
initial begin
    o1 = obj::type_id::create("o1");
    o2 = obj::type_id::create("o2");

    o1.randomize();
    o1.print();
    o2.copy(o1);
    o2.print();
   
  end



do_compare

Refer LRM for syntax


UVM COMPONENT 

Uvm_top  is the root node
Uvm_top --> test
Test --> env
Env-->(agent, scoreboard)
Agent-->(drv, mon, seqr)

// to run the code 
run_test("class_name");
//factory automatically calls the phases.

Parent = null means it is a child of uvm_top




CONFIG DB

uvm_config_db#(datatype) :: set( context, inst name, key, value or container);

context = null // accessible everywhere 
Inst name : name of the class

set() method and get() method
Value for set method
Container for get method

String concatenation of <parent>+<inst_name>+<key>
Should match for both get and set, in order for the data to be transferred

Use * in inst_name ( eg: uvm_test_top.env.agent*) to give access to all sub components of agent while using set() method


While declaring Virtual interface in a static component,  use parentheses ()


UVM_PHASES


run_test() will call phases in a sequential manner

Build phase executes in top down approach
Other phases execute in bottom up approach

Classification based on Time consumption 

Time consuming (task) and non time consuming (function) methods

When we override a method,  we need to call super. methods

Use raise and drop objections inside time consuming methods.
because uvm will not automatically wait for time specified as delay, we need to raise objections

Classification based on operation

Construction phases:
Build phase,  connect phase,  end of elaborating,  start of simulation


Run phases:( all are time consuming )
Reset, configure, main, shut down
With pre and post phases

Reset: reset to default state
Configure: initialize variable, memory, array in tb
Main: generate stimuli and collect response 
Shutdown: make sure stimuli Generation and response collection is successful 

Cleanup phases:
Extract,  check,  report,  final

Collect and report data
Check coverage is achieved or not

Time consuming phases in single component
// each phase takes complete time until phase ends, and then moves to next phase 

Time consuming phases in multiple component
// each phase takes complete time until phase ends for slowest component,
//  and then moves to next phase of all components


Timeout






