#Daniel Doveiko July 6th 2020
#daniel.doveiko.2018@uni.strath.ac.uk
#script to save coordinates of 2 COM of any selected residues
#it creates a file coordinates.dat with the data
#to use: >source COMcoord.tcl
#	 >measure_coordinates "protein and resid X" "protein and resid Y"	

 proc measure_coordinates { selstring1 selstring2 {molID {top}} {weight
 {}}} {
 
 set sel1 [atomselect $molID $selstring1]
 set sel2 [atomselect $molID $selstring2]
 #setlect 2 residues
 set numframes [molinfo top get numframes]
 #get number of frames
 set output [open "coordinates.dat" w]
 #opens file for writing
 puts $output "Frame\tx-coord\ty-coord\tz-coord\tx-coord\ty-coord\tz-coord"
 #puts headers on all columns
 for {set i 0} {$i < $numframes} {incr i} {
 #loop to go over all frames
animate goto $i
 if {![llength $weight]} {
 set cent_sel1 [measure center $sel1]
 set cent_sel2 [measure center $sel2]
 #if geometric center is in line with COM put coordinates
 } else {
 set cent_sel1 [measure center $sel1 weight $weight]
 set cent_sel2 [measure center $sel2 weight $weight]
 #if not measure COM and put coordinates
 }
 puts $output "$i\t$cent_sel1 $i\t$cent_sel2"
 #puts measured coordinates in the file coordinates.dat
} 
 $sel1 delete
 $sel2 delete
 unset numframes
 unset output
 #clears variables
 } 
   
