indexing
	description: "Construct Repetition_multiplicity"
	authors: "Jon Avotins and Glenn Maughan"
	status: "See notice at end of class";
	copyright: "See notice at end of class";
	date: "$Date: 1995/08/28 00:41:13 $";
	revision: "$Revision: 1.5 $"

class REPETITION_MULTIPLICITY inherit

	S_REPETITION_MULTIPLICITY
		redefine
			post_action
		end;
	SEMANTIC_INFORMATION

creation

	make


feature {CONSTRUCT} -- semantics

	post_action (level: INTEGER) is
		do
			if retained = Void then
				io.putstring ("%N");
				io.putstring (info.working_production.production_name);
				io.putstring (" will go in optional repetition list");
			else
				retained.post_action (level)
			end;
		end; -- post_action

end -- class REPETITION_MULTIPLICITY

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
