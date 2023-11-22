indexing
	description: "Syntax for construct Choice_construct"
	authors: "Jon Avotins and Glenn Maughan"
	status: "See notice at end of class";
	copyright: "See notice at end of class";
	date: "$Date: 1995/08/28 10:58:12 $";
	revision: "$Revision: 1.5 $"
	
class S_CHOICE_CONSTRUCT inherit

	REPETITION
	redefine
		nbr_constructs_required
	end
	
feature -- Syntax

	production: LINKED_LIST [CONSTRUCT] is
			-- Production for:
			-- Choice_construct is	{Construct_item "|" ...}2
		local
			construct_item: CONSTRUCT_ITEM;
		once
			!! Result.make;
			Result.forth;
			!! construct_item.make; put (construct_item); 
		end; -- production

	separator: STRING is "|";

	nbr_constructs_required: INTEGER is
		do
			Result := 2
		end; -- nbr_constructs_required

feature -- Status Report

	construct_name: STRING is
		once
			Result := "Choice_construct"
		end; -- construct_name
		
end -- class S_CHOICE_CONSTRUCT

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
