indexing
	description: "Indirect_terminal_info";
	authors: "Jon Avotins and Glenn Maughan";
	status: "See notice at end of class";
	copyright: "See notice at end of class";
	date: "$Date: 1995/08/28 00:54:25 $";
	revision: "$Revision: 1.7 $"

class INDIRECT_TERMINAL_INFO

inherit

	TERMINAL_INFO
	redefine
		construct_class, output_files, check_class_clashes
	end;

creation

	make 

feature -- Access

	terminal_name: STRING;
			-- The terminal that this indirect terminal
			-- will inherit from.

feature -- Status Setting

	set_terminal_name (t_name: STRING) is
		do
			!! terminal_name.make (1);
			terminal_name.append (t_name);
			terminal_name.to_upper;
		end; -- set_terminal_name

feature -- Output

	output_files is
			-- There is no syntax file for an indirect TERMINAL
			-- construct.
		do
			build_construct_class;
		end; -- output_files

feature {NONE} -- Implementation

	construct_class: STRING is
			-- Represents the Construct class for production.
		do
			!! Result.make (1);
			Result.append (class_header (construct_class_name));
			Result.append (terminal_name);
			Result.append ("%N%Tredefine%N%T%Tconstruct_name");
			Result.append ("%N%Tend;");
			Result.append ("%N%TSEMANTIC_INFORMATION");
			Result.append ("%N%Ncreation%N%N%Tmake");
			Result.append ("%N%Nfeature -- Access");
			Result.append (construct_name_feature);
			Result.append ("%N%Nfeature {CONSTRUCT} -- Semantics");
			Result.append (end_class (construct_class_name));
		end; -- construct_class

feature {YOOCC_SEMANTIC_INFORMATION}

	check_class_clashes is
		do
			check_class_clash (construct_class_name);
		end; -- check_class_clashes

end -- class INDIRECT_TERMINAL_INFO

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
