indexing
	description: "Syntax for construct Global_list";
	authors: "Jon Avotins and Glenn Maughan"
	status: "See notice at end of class";
	copyright: "See notice at end of class";
	date: "$Date: 1995/08/28 00:45:36 $";
	revision: "$Revision: 1.5 $"
	
class S_GLOBAL_LIST inherit

	REPETITION
	redefine
		parse_body,
		has_separator
	end;
	
feature -- Syntax

	production: LINKED_LIST [CONSTRUCT] is
			-- Production for:
			-- Global_list is  Comment 
		local
			global_optionals: GLOBAL_OPTIONALS 
		once
			debug ("construct_building") io.new_line; print_name; end;
			!! Result.make;
			Result.forth;
			!! global_optionals.make; put(global_optionals); 
		end; -- production

	has_separator: BOOLEAN is
	do
		Result := false
	end; -- has_separator

	separator: STRING is ";";
	
    parse_body (level: INTEGER) is
	 -- Attempt to find a sequence of constructs with separators
	 -- starting at current position. Set committed
	 -- at first separator if `commit_on_separator' is set.
      local
	 child_found, first_child_found: BOOLEAN;
	 separator_found, wrong: BOOLEAN
      do
	 from
	    child_found := parse_one (level + 1);
	    first_child_found := child_found
	 until
	    not child_found 
	 loop
	    separator_found := false;
	    child_found := false;
	    if has_separator then
	       	separator_found := document.token.is_keyword (separator_code);
	       	if separator_found then 
		  if commit_on_separator then
		     committed := true
		  end;
		  document.get_token 
	       end
	    end;
-- 18/10/94 Changed from:
-- if (not has_separator) or separator_found then
-- to account for repitition constructs that have an optional
-- separator 	   
	    if 	(not has_separator) or 
		optional_separator or separator_found then
	        child_found := parse_one (level + 1)
	    end
	 end;
-- 18/10/94 Changed from:
-- wrong := has_separator and separator_found and not child_found;
-- to account for the optional_separator case.
	wrong := has_separator and (not optional_separator) and separator_found and not child_found;
--	io.putstring("%Nhas_separator: "); put_bool(has_separator);
--	io.putstring("%Noptional_separator: "); put_bool(optional_separator);
--	io.putstring("%Nseparator_found: "); put_bool(separator_found);
--	io.putstring("%Nfirst_child_found: "); put_bool(first_child_found);
--	io.putstring("%Nwrong: "); put_bool(wrong);
--	io.putstring("%Ncommitted: "); put_bool(committed);
	 complete := first_child_found and not (committed and wrong)
--	io.putstring("%Ncomplete: "); put_bool(complete);
      end; 
feature -- Status report

	construct_name: STRING is
		once
			Result := "Global_list";
		end; -- construct_name
	
end -- class S_GLOBAL_LIST

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
