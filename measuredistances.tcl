# measure_distances.tcl
# Script to measure the smallest distance from the center of mass of one selection
# to all atoms of another selection for each frame in the trajectory, and save the results to a file.

# Function to perform the distance calculation
proc calculate_distances {sel1 sel2 output_file} {
    # Get the total number of frames in the trajectory
    set num_frames [molinfo top get numframes]

    # Open the output file for writing
    set file_id [open $output_file "w"]

    # Loop over all frames
    for {set frame 0} {$frame < $num_frames} {incr frame} {
        # Set the current frame
        animate goto $frame

        # Get the atom selections
        set sel1_atoms [atomselect top $sel1 frame $frame]
        set sel2_atoms [atomselect top $sel2 frame $frame]

        # Calculate the center of mass for the first selection
        set com1 [measure center $sel1_atoms weight mass]

        # Get the coordinates of all atoms in the second selection
        set sel2_coords [$sel2_atoms get {x y z}]

        # Initialize the minimum distance to a large value
        set min_dist 1e6

        # Loop over each atom's coordinates in the second selection
        foreach coord $sel2_coords {
            # Calculate the distance from the center of mass to this atom
            set dist [veclength [vecsub $coord $com1]]

            # Update the minimum distance if the current distance is smaller
            if {$dist < $min_dist} {
                set min_dist $dist
            }
        }

        # Output the frame number and the smallest distance to the file
        puts $file_id "$frame $min_dist"

        # Clean up the selections for the current frame
        $sel1_atoms delete
        $sel2_atoms delete
    }

    # Close the output file
    close $file_id

    # Print a message indicating completion
    puts "Distance calculations completed. Results are saved in $output_file"
}

# Main script
if {[llength $argv] != 3} {
    puts "Usage: source measure_distances.tcl; calculate_distances <selection1> <selection2> <output_file>"
} else {
    lassign $argv sel1 sel2 output_file
    calculate_distances $sel1 $sel2 $output_file
}
