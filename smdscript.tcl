### Open the log file for reading and the output .dat file for writing
### change the name in set file lines to the name of your output file
### to execute the script type source smdscript.tcl in VMD TK console
### you will be asked to input your vectors corresponding to direction of pulling
### press enter after every vector, a file ft.dat will be generated with the step and force values
set file [open SMD.11331388-out r]
set output [open ft.dat w]

### Gather input from user.
puts "Enter a value for n_x:"
set nx [gets stdin]
puts "Enter a value for n_y:"
set ny [gets stdin]
puts "Enter a value for n_z:"
set nz [gets stdin]

### Loop over all lines of the log file
set file [open SMD.11331388-out r]
while { [gets $file line] != -1 } {

### Determine if a line contains SMD output. If so, write the
### timestep followed by f(dot)n to the output file
  if {[lindex $line 0] == "SMD"} {
      puts $output "[lindex $line 1] [expr $nx*[lindex $line 5] + $ny*[lindex $line 6] + $nz*[lindex $line 7]]"
    }
  }

### Close the log file and the output .dat file
close $file
close $output
