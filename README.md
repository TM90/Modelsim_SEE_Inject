Modelsim_SEE_Inject
===================

A tcl extension to simulate Single Event Effects (SEEs) in Modelsim

The tcl tool can be started when testbench and VHDL files are compiled in Modelsim.
The simulation can be set up over a Tk GUI and then upsets and transients can be simulated.

The tool will induce SEUs in VHDL Signals marked with an _reg in their signal name. 
It will also induce SETs in every other Signal, except there is an _IO in the signal name.

An example project will be added.
