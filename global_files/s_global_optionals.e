indexing
	description: "Syntax for construct Global_optionals";
	authors: "Jon Avotins and Glenn Maughan"
	status: "See notice at end of class";
	copyright: "See notice at end of class";
	date: "$Date: 1995/08/28 00:45:36 $";
	revision: "$Revision: 1.5 $"
	
class S_GLOBAL_OPTIONALS inherit

	CHOICE
	
feature -- Syntax

	production: LINKED_LIST [CONSTRUCT] is
			-- Production for:
			-- Global_optionals is  Comment 
		once
			debug ("construct_building") io.new_line; print_name; end;
			!! Result.make;
			Result.forth;
		end; -- production
	
feature -- Status report

	construct_name: STRING is
		once
			Result := "Global_optionals";
		end; -- construct_name
	
end -- class S_GLOBAL_OPTIONALS

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
