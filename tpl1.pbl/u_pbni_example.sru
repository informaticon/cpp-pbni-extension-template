forward
global type u_pbni_example from nonvisualobject
end type
end forward

global type u_pbni_example from nonvisualobject native "pbni-extension-template.dll"
public function  long of_add(long al_a, long al_b) throws u_exf_ex
end type

global u_pbni_example u_pbni_example

on u_pbni_example.create
call super::create
TriggerEvent( this, "constructor" )
end on

on u_pbni_example.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on