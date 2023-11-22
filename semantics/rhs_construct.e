indexing
	description: "Semantics for Rhs_construct";
	authors: "Jon Avotins and Glenn Maughan";
	status: "See notice at end of class";
	copyright: "See notice at end of class";
	date: "$Date: 1995/08/28 00:54:25 $";
	revision: "$Revision: 1.5 $"

deferred class RHS_CONSTRUCT

feature -- Initialization

	make (s_value: STRING; optional: BOOLEAN) is
		require
			s_value_non_void: s_value /= Void
			s_value_meaningful: not s_value.empty
		do
			string_value := clone (s_value);
			lower_string_value := clone (s_value);
			lower_string_value.to_lower;
			upper_string_value := clone (s_value);
			upper_string_value.to_upper;
			is_optional := optional;	
		end; -- make

feature -- Access

	string_value: STRING;
			-- The rhs_construct's character string.

	feature_calls: STRING is
			-- Production feature calls for rhs_construct.
		deferred
		end; -- feature_calls

	local_declaration: STRING is
			-- Production local declaration for rhs_construct.
		deferred
		end; -- local_declaration

feature -- Status Report

	is_optional: BOOLEAN;
			-- Is rhs_construct optional?

	is_keyword: BOOLEAN is
			-- Is rhs_construct a keyword?
		deferred
		end; -- is_keyword
	
feature {PRODUCTION_ITEM} 

	upper_string_value: STRING;

feature {YOOCC_SEMANTIC_INFORMATION} -- Status Setting

	set_optional is
			-- Set rhs_construct to be optional.
		do
			is_optional := true
		end; -- set_optional	

feature {NON_TERMINAL_INFO} -- Status Setting

	set_lower_string_value (s: STRING) is
		require
			s_non_void: s/= Void
			s_meaningful: not s.empty
		do
			 lower_string_value := clone (s);
		end; -- set_lower_string_value

feature {YOOCC_SEMANTIC_INFORMATION,NON_TERMINAL_INFO} -- Status Reporting

	has_local_declaration: BOOLEAN is
		do
			Result := local_declaration /= Void
		end; -- has_local_declaration

	lower_string_value: STRING; 

end -- class RHS_CONSTRUCT

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
