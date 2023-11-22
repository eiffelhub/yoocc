indexing 
   
	description: "Objects that can be displayed and have the ability to %
		% display their sub-components indented recursively";
	author: "Glenn Maughan";
	status: "See notice at end of class";
	copyright: "See notice at end of class";
	date: "$Date: 1995/08/28 00:49:03 $";
	revision: "$Revision: 1.2 $"
   
deferred class DISPLAYABLE
   
feature {ANY} -- Display
   
   display, frozen standard_display (output_file: IO_MEDIUM) is
	 -- Output textual representation of Current on `output_file'.  This
	 -- routine will display all sub-components (attributes)
	 -- recursively indented.
	 --| this routine will not open or close `output_file'.
      require
	 valid_file: output_file /= Void and then (output_file.exists and output_file.is_open_write)
      do
	 display_indented (output_file, Indent_start_level)
      end -- display
   
   Indent_start_level: INTEGER is 0
	 -- Level to start the display of this object at in spaces.
   
   Indent_step: INTEGER is 4
	 -- The default step of indents for displaying indented.  Add this
	 -- number to the current level when displaying an indented component.
   
feature {DISPLAYABLE} -- Display
   
   display_indented (file: IO_MEDIUM; level: INTEGER) is
	 -- Output textual representation indented `level' spaces on `file'.
	 --| descendants should effect this feature to display the
	 --| current object and its subcomponents indented (call
	 --| display_indented recursively).
 	 --| WARNING: Do not change the export status unknowingly.
      require
	 valid_file: file /= Void and then (file.exists and file.is_open_write)
	 valid_indent: level >= 0
      deferred
      end -- display_indented
   
feature {NONE} -- Implementation
   
   display_indent (file: IO_MEDIUM; level: INTEGER) is
	 -- Output `level' spaces on stdout
      require
	 valid_file: file /= Void and then (file.exists and file.is_open_write)
	 valid_indent: level >= 0
      local
	 temp_string: STRING
      do
	 -- build an string with level number of spaces
	 !! temp_string.make (level)
	 temp_string.fill_blank
	 -- output the indent
	 file.putstring (temp_string)
      end -- display_indent
	 
end -- class DISPLAYABLE

--|----------------------------------------------------------------
--| YOOCC: Yes! An Object-Oriented Compiler Compiler. 
--| Copyright (C) 1995, Monash University
--| All rights reserved. 
--|
--| Monash University, Caulfield Campus
--| Department of Software Development
--| PO Box 197, Caulfield East
--| Melbourne, Australia 3145
--|
--| COPYRIGHT NOTICE: This code is provided "AS IS" without any 
--| warranty and is subject to the terms of the Monash Software 
--| Development General Public License contained in the file: 
--| "LICENSE" of this distribution. The license is also available 
--| from Monash University, Department of Software Development, 
--| Monash University, 900 Dandenong Rd, Caulfield East, Melbourne, 
--| VIC 3145, Australia.
--|
--| Phone: +61-3-99032787 Fax: +61-3-99032745
--| Email: <yoocc@insect.sd.monash.edu.au>
--| WWW: http://insect.sd.monash.edu.au/~yoocc
--|----------------------------------------------------------------
