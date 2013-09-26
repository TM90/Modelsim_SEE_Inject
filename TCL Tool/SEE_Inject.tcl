set numIndSEU 100
set numIndSET 100
set SETDuration {1 ns}
set Intervall {1000 ns}
set starttime {0 ns}
set upset_nr 1
set instanceDUT DUT
set instanceTB tmr_tb
set ref_file reffile 
set compare 0 

#Building the GUI
toplevel .t
wm title .t "Radiation Error Injector"

label .t.lSEUs -text "number of SEUs"
entry .t.eSEUs -textvariable numIndSEU
label .t.lSETs -text "number of SETs"
entry .t.eSETs -textvariable numIndSET
label .t.lSETdur -text "SET Duration in ns"
entry .t.eSETdur -textvariable SETDuration
label .t.lDtSEU -text "time between Errors"
entry .t.eDtSEU -textvariable Intervall
label .t.lStart -text "start time"
entry .t.eStart -textvariable starttime

label .t.lDUT -text "instance name DUT"
entry .t.eDUT -textvariable instanceDUT
label .t.lTB -text "instance name testbench"
entry .t.eTB -textvariable instanceTB
label .t.lRef -text "name reference file"
entry .t.eRef -textvariable ref_file

text .t.txt -width 80
button .t.bOk -text "ok" -command {onButtonHit $starttime $numIndSEU $Intervall $instanceTB $instanceDUT $numIndSET $SETDuration $ref_file $compare} 
button .t.bWave -text "Simulate/ add Wave Sig" -command {AddWave $instanceTB}
button .t.bGenRef -text "generate Reffile" -command {genRef $ref_file $numIndSEU $numIndSET $Intervall $starttime}
checkbutton  .t.chk -text "enable Compare" -onvalue 1 -offvalue 0 -variable compare

grid .t.lSEUs -column 0 -row 0 -padx 5 -pady 5
grid .t.eSEUs -column 0 -row 1 -padx 5 -pady 5	
grid .t.lSETs -column 0 -row 2 -padx 5 -pady 5
grid .t.eSETs -column 0 -row 3 -padx 5 -pady 5	
grid .t.lSETdur -column 0 -row 4 -padx 5 -pady 5
grid .t.eSETdur -column 0 -row 5 -padx 5 -pady 5	
grid .t.lDtSEU -column 0 -row 6 -padx 5 -pady 5
grid .t.eDtSEU -column 0 -row 7 -padx 5 -pady 5
grid .t.lStart -column 0 -row 8 -padx 5 -pady 5
grid .t.eStart -column 0 -row 9 -padx 5 -pady 5

grid .t.lDUT -column 1 -row 0 -padx 5 -pady 5
grid .t.eDUT -column 1 -row 1 -padx 5 -pady 5
grid .t.lTB -column 1 -row 2 -padx 5 -pady 5
grid .t.eTB -column 1 -row 3 -padx 5 -pady 5
grid .t.lRef -column 1 -row 4 -padx 5 -pady 5
grid .t.eRef -column 1 -row 5 -padx 5 -pady 5
grid .t.bWave -column 1 -row 8 -padx 5 -pady 5
grid .t.chk -column 1 -row 9 -padx 5 -pady 5

grid .t.txt -column 2 -row 0 -rowspan 8 -padx 5 -pady 5 
grid .t.bGenRef -column 2 -row 8 -padx 5 -pady 5
grid .t.bOk -column 2 -row 9 -padx 5 -pady 5

.t.txt insert end "SEU affected register @ Time ns\n"

#Add Signals to wave procedure
proc AddWave {instanceTB} {
	vsim -novopt work.$instanceTB -t 1ps
	view wave
	set AllInstances [find instances -r /$instanceTB/*]
	set AllInstances [lsort $AllInstances]
	for {set i 0} {$i < [llength $AllInstances]} {incr i} {
		add wave -group [lindex $AllInstances $i] [lindex [lindex $AllInstances $i] 0]/*
	}
}
proc genRef {ref_file numIndSEU numIndSET Intervall starttime} {
	restart -force
	run [expr {[lindex $Intervall 0]*($numIndSEU+$numIndSET)+[lindex $starttime 0]}] ns
	dataset save sim $ref_file.wlf
}

#Start the Radiation Error Simulation at Button hit
proc onButtonHit {starttime numIndSEU Intervall instanceTB instanceDUT numIndSET SETDuration ref_file compare} {
	set allSignals [find signals -r /$instanceTB/$instanceDUT/*]
	set RegIndex [lsearch -all $allSignals *_reg*]
	set RegSignals [lindex $allSignals [lindex $RegIndex 0]]
	set WireSignals $allSignals
	
	for {set i 1} {$i < [llength $RegIndex]} {incr i} {
		lappend RegSignals [lindex $allSignals [lindex $RegIndex $i]]
	}
	set RegIndex [lsearch $WireSignals *_reg*]
	while {$RegIndex != -1} {
		set WireSignals [lreplace $WireSignals $RegIndex $RegIndex]	
		set RegIndex [lsearch $WireSignals *_reg*]
	}
	set RegIndex [lsearch $WireSignals *CLK*]
	while {$RegIndex != -1} {
		set WireSignals [lreplace $WireSignals $RegIndex $RegIndex]	
		set RegIndex [lsearch $WireSignals *CLK*]
	}
	set RegIndex [lsearch $WireSignals *_IO*]
	while {$RegIndex != -1} {
		set WireSignals [lreplace $WireSignals $RegIndex $RegIndex]	
		set RegIndex [lsearch $WireSignals *_IO*]
	}
	set BitRegList [format2Bitlist $RegSignals]
	set BitWireList [format2Bitlist $WireSignals]

	set reglength [llength $BitRegList] 
	set wirelength [llength $BitWireList]
	set number [expr {$numIndSEU+$numIndSET}]
	restart -force 
	run [lindex $starttime 0] ns
	for {set i 0} {$i < $number} {incr i} {
		set randomRegindex [expr {int(rand()*$reglength)}]
		set randomWireindex [expr {int(rand()*$wirelength)}]
		set randomtime [expr {int(rand()*([lindex $Intervall 0]))}]
		set randomtype [expr {int(rand()*($numIndSEU+$numIndSET))}]
		run $randomtime ns
		if {$numIndSEU == 0} {
			set randomtype 1
		}
		if {$numIndSET == 0} {
			set randomtype 0
		}
		if {$randomtype <= $numIndSEU} {
			.t.txt insert end "[lindex $BitRegList $randomRegindex] @ [expr {$randomtime+$i*[lindex $Intervall 0]+[lindex $starttime 0]}] ns SEU\n "
			SEU_Inject $BitRegList $randomRegindex
			incr numIndSEU -1
		}
		if {$randomtype > $numIndSEU} {
			.t.txt insert end "[lindex $BitWireList $randomWireindex] @ [expr {$randomtime+$i*[lindex $Intervall 0]+[lindex $starttime 0]}] ns SET\n "
			SET_Inject $BitWireList $randomWireindex $SETDuration
			incr numIndSET -1
		}
		run [expr [lindex $Intervall 0]-$randomtime] ns
		.t.txt yview end 
	}
	if {$compare == 1} {
		dataset open $ref_file.wlf $ref_file
		compare start $ref_file sim
		compare add -wave -in -out -inout $ref_file:/$instanceTB/$instanceDUT
		compare options -maxtotal $number -maxsignal $number
		compare run 
		.t.txt insert end "[compare info]"
	}
}

proc format2Bitlist {Signal} {
	set l1 0
	set BitList [list]
	for {set i 0} {$i < [llength $Signal]} {incr i} {
		set l1 0
		while {[catch {examine [lindex $Signal $i]($l1)}] == 0} {
			incr l1
		}
		set l2 0
		while {[catch {examine [lindex $Signal $i](0)($l2)}] == 0} {
			incr l2
		}
		if {$l2 == 0} {
			if {$l1 == 0} {
				lappend BitList [lindex $Signal $i]
			} else {
				for {set j 0} {$j < $l1} {incr j} {
					lappend BitList [lindex $Signal $i]($j)
				}
			} 
		} else {
			for {set j 0} {$j < $l1} {incr j} {
				for {set n 0} {$n < $l2} {incr n} {
					lappend BitList [lindex $Signal $i]($j)($n)
				}
			}
		}
	}
	return $BitList
}

proc SEU_Inject {BitRegList Index} {
		set status  [examine [lindex $BitRegList $Index]] 
		if {$status == 0} {
			force -deposit [lindex $BitRegList $Index] 1
		} else {
			force -deposit [lindex $BitRegList $Index] 0
		}
		
}

proc SET_Inject {BitWireList Index duration} {
	set status [examine [lindex $BitWireList $Index]] 
		if {$status == 0} {
			force -freeze [lindex $BitWireList $Index] 1 -cancel [expr {[lindex $duration 0]*1000}]
		} else {
			force -freeze [lindex $BitWireList $Index] 0 -cancel [expr {[lindex $duration 0]*1000}]
		}
}

proc Stuckbit_Inject {BitWireList Index} {
	set status [examine [lindex $BitWireList $Index]] 
		if {$status == 0} {
			force -freeze [lindex $BitWireList $Index] 1 
		} else {
			force -freeze [lindex $BitWireList $Index] 0
		}
}