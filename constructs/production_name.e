indexing
	description: "Construct Production_name"
	authors: "Jon Avotins and Glenn Maughan"
	status: "See notice at end of class";
	copyright: "See notice at end of class";
	date: "$Date: 1995/08/28 00:41:13 $";
	revision: "$Revision: 1.5 $"

class PRODUCTION_NAME inherit
	
	IDENTIFIER
		redefine
			construct_name, action
		end;
	SEMANTIC_INFORMATION
	EXCEPTIONS

creation

	make

feature -- Status Report

	construct_name: STRING is
		once
			Result := "Production_name"
		end; -- construct_name

feature {CONSTRUCT} -- semantics

	action (level: INTEGER) is
		do
			if production_name_clash then
				io.putstring ("%NError (");
				io.putint (token.line_number);
				io.putstring (",");
				io.putint (token.column_number);
				io.putstring ("): Multiply defined production name.%N");
				new_die (24);
			else
				info.productions_defined.force (upper_string_value);
				-- If a production name is realised then a new 
				-- production is going to be defined.  
				-- Therefore this production can no longer be
				-- a direct terminal construct and should be
				-- removed if it exists in the direct terminal
				-- list.
				if info.direct_terminal_list.has (upper_string_value) then
					info.direct_terminal_list.remove (upper_string_value);
				end;
				-- As the productions name represents
				-- a production that is non-terminal then 
				-- any aggregate productions in the
				-- indirect_terminal_list need to be removed
				-- and put into the production list.  
				update_indirect_terminal_list;	
			end; -- if
		end; -- action			 

feature {NONE} -- Implementation

	update_indirect_terminal_list is
			-- Traverse the indirect_terminal list and 
			-- if any productions are defined solely by
			-- a construct named production_name,  then this 
			-- production should be relocated in the 
			-- non-terminal list.
		local
			ck: ARRAY [STRING]
			i: INTEGER
			agg_s: AGGREGATE_INFO
		do
			from
				ck := info.indirect_terminal_list.current_keys;
				i := 1
			until
				i > ck.count
			loop
				if info.indirect_terminal_list.item (ck.item(i)).terminal_name.is_equal (upper_string_value) then
					info.non_terminal_list.put (indirect_terminal_to_aggregate (info.indirect_terminal_list.item (ck.item (i))),info.indirect_terminal_list.item (ck.item(i)).production_name);
					info.indirect_terminal_list.remove (ck.item (i));
				end;
				i := i + 1
			end; -- loop
		end; -- update_indirect_terminal_list

	indirect_terminal_to_aggregate (it: INDIRECT_TERMINAL_INFO): AGGREGATE_INFO is
			-- Make Current by adapting it.
		require
			it_not_void: it /= Void
		local
			rhs_name: RHS_NAME;
		do
			!! Result.make (it.production_name);
			!! rhs_name.make (it.terminal_name,false);
			Result.rhs_productions.force (rhs_name);
		end; -- make_from_indirect_terminal

	upper_string_value: STRING is
		do
			!! Result.make (1);
			Result.append (token.string_value);
			Result.to_upper;
		end; -- upper_string_value

	syntax_production_name: STRING is
		do
			Result := clone (upper_string_value);
			Result.prepend ("S_");
		end; -- syntax_production_name

	production_name_clash: BOOLEAN is
			-- Has Current already been defined?
		do
			Result := info.productions_defined.has (upper_string_value); 
		end; -- valid_production_name

end -- class PRODUCTION_NAME

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
