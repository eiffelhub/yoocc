indexing
	description: "Repetition_info";
	authors: "Jon Avotins and Glenn Maughan";
	status: "See notice at end of class";
	copyright: "See notice at end of class";
	date: "$Date: 1995/08/28 00:54:25 $";
	revision: "$Revision: 1.5 $"

class REPETITION_INFO

inherit

	NON_TERMINAL_INFO
	redefine
		syntax_class,
		production_type
	end;

creation

	make

feature -- Access

	production_type: STRING is
		do
			!! Result.make (1);
			Result.append ("REPETITION");
		end; -- production_type

feature {NONE} -- Implementation

	separator_feature: STRING is
		do
			!! Result.make (1);
			Result.append ("%N%N%Tseparator: STRING is ");
			if has_separator then
				Result.append (separator);
				Result.append (";");
			else
				Result.append ("%"%"");
				Result.append (";");
				Result.append ("%N%T%T%T-- Meaningless for Current.");
			end; -- if
		end; -- separator_feature

	nbr_constructs_feature: STRING is
		do
			!! Result.make (1);
			Result.append ("%N%N%Tnbr_constructs_required: INTEGER is");
			Result.append ("%N%T%T%T-- Number of constructs required in production");
			Result.append ("%N%T%T%T-- before optional separator for Current to be");
			Result.append ("%N%T%T%T-- parsed correctly.");
			Result.append ("%N%T%Tdo%N%T%T%TResult := ");
			Result.append_integer (nbr_constructs_required);
			Result.append ("%N%T%Tend; -- nbr_constructs_required");			
		end; -- nbr_constructs_feature

	redefine_clause: STRING is
			-- Redefine clause for Current.
		local
			redefine_list: LINKED_LIST [STRING];
		do
			!! redefine_list.make;
			!! Result.make (1);
			if nbr_constructs_required > 1 then
				redefine_list.put_front ("nbr_constructs_required")	
			end;
			if optional_separator then
				redefine_list.put_front ("optional_separator")
			end;   
			if (not has_separator) then
				redefine_list.put_front ("has_separator"); 
			end;
			if (not redefine_list.empty) then
				from 
					Result.append ("%N%T%Tredefine");
					redefine_list.start
				until
					redefine_list.off
				loop
					if (not redefine_list.isfirst) then
						Result.append (",");
					end;
					Result.append ("%N%T%T%T");
					Result.append (redefine_list.item);
					redefine_list.forth;
				end; -- loop
				Result.append ("%N%T%Tend;");
			end; -- if
		end; -- redefine_clause

	optional_separator_feature: STRING is
		do
			!! Result.make (1);
			Result.append ("%N%Toptional_separator: BOOLEAN is%N%T%Tdo");
			Result.append ("%N%T%T%TResult := true%N%T%Tend; -- optional_separator");
		end; -- optional_separator

	has_separator_feature: STRING is
		do
			!! Result.make (1);
			Result.append ("%N%N%Thas_separator: BOOLEAN is%N%T%Tdo");
			Result.append ("%N%T%T%TResult := false%N%T%Tend; -- has_separator");
		end; -- has_separator_feature

	syntax_class: STRING is
			-- Syntax class for Current. 
		do
			!! Result.make (1);
			Result.append (syntax_class_declaration);
			Result.append (redefine_clause);
			Result.append ("%N%Nfeature -- Access");
			Result.append (production_feature);
			Result.append (construct_name_feature);
			Result.append ("%N%Nfeature -- Implementation");
			Result.append (separator_feature);
			if nbr_constructs_required >= 2 then
				Result.append (nbr_constructs_feature);
			end;
			if optional_separator then
				Result.append (optional_separator_feature);
			end;
			if (not has_separator) then
					Result.append (has_separator_feature);
			end;
			Result.append (end_class (syntax_class_name));
		end; -- syntax_class

end -- class REPETITION_INFO

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
