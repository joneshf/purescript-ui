#!/usr/bin/wish
frame .frame0
frame .frame0.frame1
label .frame0.frame1.label2 -text "This is one row of stuff" -foreground #0000ff
pack .frame0.frame1.label2 -side left
label .frame0.frame1.label3 -text "Here's another thing!" -foreground #0000ff
pack .frame0.frame1.label3 -side left
label .frame0.frame1.label4 -text "It's all blue!" -foreground #0000ff
pack .frame0.frame1.label4 -side left
pack .frame0.frame1 -side top
frame .frame0.frame5
label .frame0.frame5.label6 -text "We started a new row"
pack .frame0.frame5.label6 -side left
label .frame0.frame5.label7 -text "Here's some blue text" -foreground #0000ff
pack .frame0.frame5.label7 -side left
label .frame0.frame5.label8 -text "Here's some red text" -foreground #ff0000
pack .frame0.frame5.label8 -side left
label .frame0.frame5.label9 -text "Here's some yellow text with a black background" -background #000000 -foreground #ffff00
pack .frame0.frame5.label9 -side left
pack .frame0.frame5 -side top
pack .frame0 -side top

