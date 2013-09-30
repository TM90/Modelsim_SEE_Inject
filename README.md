Modelsim_SEE_Inject
===================

![Modelsim_SEE_Inject](https://raw.github.com/TM90/Modelsim_SEE_Inject/master/Wiki%20Pictures/StepbyStep/Step5.png)

_Figure 1: GUI SEE Inject Tool_

A tcl extension (GUI shown in figure 1)to simulate Single Event Effects (SEEs) in Modelsim

The tcl tool can be started when testbench and VHDL files are compiled in Modelsim.
The simulation can be set up over a Tk GUI and then upsets and transients can be simulated.

The tool will induce SEUs in VHDL Signals marked with an "_reg" in their signal name. 
It will also induce SETs in every other Signal, except there is an "_IO" in the signal name.

An example project can be found in the wiki:
https://github.com/TM90/Modelsim_SEE_Inject/wiki/Example-Project

