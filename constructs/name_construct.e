indexing
	description: "Construct Name_construct"
	authors: "Jon Avotins and Glenn Maughan"
	status: "See notice at end of class";
	copyright: "See notice at end of class";
	date: "$Date: 1995/08/28 00:41:13 $";
	revision: "$Revision: 1.5 $"

class NAME_CONSTRUCT inherit
	
	IDENTIFIER
		redefine
			construct_name, action
		end;
	SEMANTIC_INFORMATION

creation

	make

feature -- Status Report

	construct_name: STRING is
		once
			Result := "Name_construct"
		end; -- construct_name

feature {CONSTRUCT} -- semantics

	action (level: INTEGER) is
		local
			rhs_name: RHS_NAME;
			dts: DIRECT_TERMINAL_INFO;
			upper_name: STRING;
		do
			!! upper_name.make (1);
			upper_name.append (token.string_value);
			upper_name.to_upper;
			!! rhs_name.make (upper_name,info.working_production.latest_info_optional);
			info.working_production.rhs_productions.force (rhs_name);
			-- If a name construct is found that is yet to be 
			-- defined then that name construct is a potential
			-- direct terminal.  If a name construct is deemed to 
			-- be a direct terminal and is not already in the 
			-- direct terminal list then this name construct should
			-- be inserted into the info.direct_terminal_list.
			if not ((info.productions_defined.has (upper_name)) and	(not info.direct_terminal_list.has (upper_name))) then 
				!! dts.make (upper_name);
				info.direct_terminal_list.put (dts, upper_name)
			end;
		end; -- action			 

end -- class NAME_CONSTRUCT

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
