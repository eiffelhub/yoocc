indexing
	description: "Construct Keyword_construct"
	authors: "Jon Avotins and Glenn Maughan"
	status: "See notice at end of class";
	copyright: "See notice at end of class";
	date: "$Date: 1995/08/28 00:41:13 $";
	revision: "$Revision: 1.5 $"

class KEYWORD_CONSTRUCT inherit

	SIMPLE_STRING 
		redefine
			construct_name, action
		end;
	SEMANTIC_INFORMATION

creation

	make

feature -- Status Report

	construct_name: STRING is
		once
			Result := "Keyword_construct"
		end; -- construct_name

feature {CONSTRUCT} -- semantics

	action (level: INTEGER) is
		local
			rhs_keyword: RHS_KEYWORD;
			lower_keyword: STRING;
		do
			!! rhs_keyword.make (token.string_value,info.working_production.latest_info_optional);
			info.working_production.rhs_productions.force (rhs_keyword);
			-- If the current keyword is not in the keyword list
			-- then put it in.  Otherwise do nothing.
			!! lower_keyword.make (1);
			lower_keyword.append (token.string_value);
			if (not info.keywords_case_sensitive) then
					lower_keyword.to_lower
   		 end;
    		if (not info.keyword_list.has (lower_keyword)) then
                info.keyword_list.force (lower_keyword);
            end; -- if
        end; -- action             

end -- class KEYWORD_CONSTRUCT

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
