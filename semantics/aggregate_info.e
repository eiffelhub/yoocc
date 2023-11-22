indexing
	description: "Information for Aggregate productions"
	authors: "Jon Avotins and Glenn Maughan"
	status: "See notice at end of class";
	copyright: "See notice at end of class";
	date: "$Date: 1995/08/28 00:54:25 $";
	revision: "$Revision: 1.7 $"

class AGGREGATE_INFO

inherit

	NON_TERMINAL_INFO
	redefine 
		production_type, 
		potential_indirect_terminal,
		syntax_class_declaration
	end;

creation

	make

feature -- Access
	
	production_type: STRING is
		do
			!! Result.make (1);
			Result.append ("AGGREGATE%N");
		end; -- production_type

feature -- Status Report

	potential_indirect_terminal: BOOLEAN is
			-- If this construct has a right hand side definition 
			-- that constains only one productions,  that is not 
			-- optional, and not a keyword, then this production 
			-- is potentially indirect terminal construct.
		do
			if rhs_productions.count = 1 and then (not rhs_productions.first.is_optional) and (not rhs_productions.first.is_keyword) then
				Result := true
			end;
		end; -- potential_indirect_terminal

feature {NONE} -- Implementation

	syntax_class_declaration: STRING is
			-- The `Class_header' and `Inheritance' clause for 
			-- syntax classes.
		do
			!! Result.make (1);			
			Result.append (class_header (syntax_class_name));
			if all_optional_rhs_constructs then
				Result.append ("AGGREGATE_1%N")
			else
				Result.append (production_type);
			end;
		end; -- syntax_class_declaration

	all_optional_rhs_constructs: BOOLEAN is
			-- Are all constructs in rhs_productions
			-- optional?
		do
			from 
				Result := True
				rhs_productions.start
			until 
				rhs_productions.off or not Result
			loop
				if not (rhs_productions.item.is_optional) then
					Result := False
				end;
				rhs_productions.forth;
			end; 
		end; -- all_optional_rhs_constructs

end -- class AGGREGATE_INFO

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
