indexing
	description: "Construct Production_item"
	authors: "Jon Avotins and Glenn Maughan"
	status: "See notice at end of class";
	copyright: "See notice at end of class";
	date: "$Date: 1995/08/28 00:41:13 $";
	revision: "$Revision: 1.5 $"

class PRODUCTION_ITEM inherit

	S_PRODUCTION_ITEM
		redefine
			post_action
		end;
	SEMANTIC_INFORMATION

creation

	make

feature {CONSTRUCTS} -- semantics

	post_action (level: INTEGER) is
		do
			from
				child_start
			until
				child_after
			loop
				child.post_action (level)
				child_forth
			end; -- loop
			-- If the info.working_production is a potential
			-- indirect terminal,  ie. a production with a single
			-- undefined non-optional construct on the rhs,  then 
			-- the working_production should be put into the indirect
			-- terminal list.  Otherwise the infoworking_production.
			-- should be put into the non-terminal list.
			if info.working_production.potential_indirect_terminal and (not info.productions_defined.has (info.working_production.rhs_productions.first.upper_string_value)) then
				info.indirect_terminal_list.put (aggregate_to_indirect_terminal (info.working_production),info.working_production.production_name);
			else
				info.non_terminal_list.put (info.working_production,info.working_production.production_name);
			end;
		end; -- post_action

feature {NONE} -- Implementation

		aggregate_to_indirect_terminal (agg: NON_TERMINAL_INFO): INDIRECT_TERMINAL_INFO is
		require
			agg_not_void: agg /= Void
			agg_non_terminal: agg.rhs_productions.count = 1
			agg_rhs_production_not_optional: not agg.rhs_productions.first.is_optional
				-- Transform an aggregate semantics into an 
				-- indirect terminal semantics.
		do
			!! Result.make (agg.production_name);
			Result.set_terminal_name (agg.rhs_productions.first.string_value);
		end; -- aggregate_to_indirect_terminal

end -- class PRODUCTION_ITEM

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
