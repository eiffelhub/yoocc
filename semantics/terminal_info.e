indexing
	description: "Information for Terminal productions";
	authors: "Jon Avotins and Glenn Maughan";
	status: "See notice at end of class";
	copyright: "See notice at end of class";
	date: "$Date: 1995/08/28 00:54:25 $";
	revision: "$Revision: 1.5 $"

class TERMINAL_INFO

inherit

	PRODUCTION_INFO
	redefine
		syntax_class, production_type
	end;

feature -- Initialization

	make (p_name: STRING) is
		require
			valid_production_name: p_name /= Void
		do
			!! production_name.make (1);
			production_name.append (p_name);
			production_name.to_upper;
		end; -- make

feature -- Access

	production_type: STRING is
		do
			!! Result.make (1);
			Result.append ("TERMINAL");
		end; -- production_type

feature {NONE} -- Implementation

	syntax_class: STRING is
			-- Syntax class for Current.
		do
			!! Result.make (1);
			Result.append (syntax_class_declaration);
			Result.append ("%N%Nfeature -- Access%N%N");
			Result.append (construct_name_feature);
			Result.append (end_class (syntax_class_name));
		end; -- syntax_class

end -- class TERMINAL_INFO

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
