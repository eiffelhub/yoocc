indexing
	description: "Construct Repitition_construct"
	authors: "Jon Avotins and Glenn Maughan"
	status: "See notice at end of class";
	copyright: "See notice at end of class";
	date: "$Date: 1995/08/28 00:41:13 $";
	revision: "$Revision: 1.5 $"

class REPETITION_CONSTRUCT inherit

	S_REPETITION_CONSTRUCT
		redefine
			post_action
		end;
	SEMANTIC_INFORMATION

creation

	make

feature {CONSTRUCTS} -- semantics

	post_action (level: INTEGER) is
		local
			rp: REPETITION_INFO
		do
			from
				!! rp.make (info.productions_defined.last);
				info.set_working_production (rp);
				child_start
			until
				child_after
			loop
				child.post_action (level)
				child_forth
			end; -- loop
			-- If the working_production.has_separator and there is
			-- no repetition multiplicity (arity (number of 
			-- children) = 5), or the working_production does not
			-- have a spearator and no repetition multiplicity
			-- (arity = 4) then this repetition construct is 
			-- optional and therefore should be inserted into the 
			-- info.optional_repetition_construct_list.
			if (info.working_production.has_separator and arity = 5) or ((not info.working_production.has_separator) and arity = 4) then
				info.optional_repetition_construct_list.force (info.working_production.production_name)
			end; -- if
		end; -- post_action

end -- class REPETITION_CONSTRUCT

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
