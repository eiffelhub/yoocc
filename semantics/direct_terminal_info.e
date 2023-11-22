indexing
	description: "Direct_terminal_info";
	authors: "Jon Avotins and Glenn Maughan";
	status: "See notice at end of class";
	copyright: "See notice at end of class";
	date: "$Date: 1995/08/28 00:54:25 $";
	revision: "$Revision: 1.7 $"
   
class DIRECT_TERMINAL_INFO
   
inherit
	TERMINAL_INFO
		redefine
			syntax_class_declaration, syntax_class
		end;
   
creation 
   
	make
   
feature {NONE} -- Implementation
   
	syntax_class_declaration: STRING is
			-- The `Class_header' and `Inheritance' clause for 
			-- syntax classes.
		do
			!! Result.make (1);			
			Result.append (class_header (syntax_class_name));
			Result.append (production_type);
			Result.append ("%N%T");
			Result.append (info.lex_constants_class_name);
		end; -- syntax_class_declaration
   
	token_type_feature: STRING is
			-- The 'token_type' feature for current.
		do
			!! Result.make (1);
			Result.append ("%N%Nfeature -- Status Report");
			Result.append ("%N%N%Ttoken_type: INTEGER is");
			Result.append ("%N%T%T%T-- Token code associated with terminal.");
			Result.append ("%N%T%Tonce");
			Result.append ("%N%T%T%TResult := ");
			Result.append (production_name_formatted);
			Result.append ("%N%T%Tend; -- token_type");
		end; -- token_type_feature
   
	syntax_class: STRING is
			-- Syntax class for Current. 
		do
			!! Result.make (1);
			Result.append (syntax_class_declaration);
			Result.append ("%N%Nfeature -- Access");
			Result.append (construct_name_feature);
			Result.append (token_type_feature);
			Result.append (end_class (syntax_class_name));
		end; -- syntax_class

end -- class DIRECT_TERMINAL_INFO

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
