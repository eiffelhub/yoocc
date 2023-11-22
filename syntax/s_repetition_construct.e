indexing
	description: "Syntax for construct Repetition_construct";
	authors: "Jon Avotins and Glenn Maughan";
	status: "See notice at end of class";
	copyright: "See notice at end of class";
	date: "$Date: 1995/08/28 10:58:12 $";
	revision: "$Revision: 1.5 $"
	
class S_REPETITION_CONSTRUCT inherit

	AGGREGATE
	
feature -- Syntax

	production: LINKED_LIST [CONSTRUCT] is
			-- Production for:
			-- Repetition_construct is	
			--	"{" Construct_item [Repetition_separator] "..." "}" [Repetition_multiplicity]
		local
			construct_item: CONSTRUCT_ITEM;
			repetition_separator: REPETITION_SEPARATOR;
			repetition_multiplicity: REPETITION_MULTIPLICITY;
		once
			!! Result.make;
			Result.forth;
			keyword ("{");
			!! construct_item.make; put (construct_item);
			!! repetition_separator.make; put (repetition_separator); repetition_separator.set_optional;
			keyword ("...");
			keyword ("}");
			
			!! repetition_multiplicity.make; put (repetition_multiplicity); repetition_multiplicity.set_optional;
		end; -- production
		
feature -- Status Report

	construct_name: STRING is
		once
			Result := "Repetition_construct"
		end; -- construct_name
		
end -- class S_REPETITION_CONSTRUCT

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
