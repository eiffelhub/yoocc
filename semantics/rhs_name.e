indexing
	description: "Semantics for Rhs_name";
	authors: "Jon Avotins and Glenn Maughan";
	status: "See notice at end of class";
	copyright: "See notice at end of class";
	date: "$Date: 1995/08/28 00:54:25 $";
	revision: "$Revision: 1.4 $"

class RHS_NAME inherit

	RHS_CONSTRUCT
	redefine
		feature_calls, local_declaration, is_keyword
	end;

creation

	make

feature -- Access

	feature_calls: STRING is
			-- Production feature_calls for rhs_name.
		do
			!! Result.make (1);
			Result.append ("!! ");
			Result.append (lower_string_value);
			Result.append (".make; put (");			   
			Result.append (lower_string_value);
			Result.append ("); ");			   
			if is_optional then
				Result.append (lower_string_value);
				Result.append (".set_optional;");
			end;
		end; -- feature_calls

	local_declaration: STRING is
			-- Production local declarations for rhs_name.
		do
			!! Result.make (1);
			Result.append (lower_string_value);
			Result.append (": ");
			Result.append (upper_string_value);
			Result.append (";");
		end; -- local_declaration

feature -- Status Report

	is_keyword: BOOLEAN is
		do
			Result := false
		end; -- is_keyword

end -- class RHS_NAME

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
