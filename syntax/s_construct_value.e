indexing 
	description: "Syntax for construct Construct_value"
	authors: "Jon Avotins and Glenn Maughan"
	status: "See notice at end of class";
	copyright: "See notice at end of class";
	date: "$Date: 1995/08/28 10:58:12 $";
	revision: "$Revision: 1.5 $"

class S_CONSTRUCT_VALUE inherit

	CHOICE
	
feature -- Syntax

	production: LINKED_LIST [CONSTRUCT] is
			-- Production for:
			-- Construct_value is	Name_construct | 					--			Keyword_construct 
		local
			name_construct: NAME_CONSTRUCT;
			keyword_construct: KEYWORD_CONSTRUCT;
		once
			!! Result.make;
			Result.forth;
			!! name_construct.make; put (name_construct);
			!! keyword_construct.make; put (keyword_construct);
		end; -- production
		
feature -- Status Report

	construct_name: STRING is
		once
			Result := "Construct_value"
		end; -- construct_name
		
end -- class S_CONSTRUCT_VALUE

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
