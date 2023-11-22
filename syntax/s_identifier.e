indexing
	description: "Syntax for construct Identifier";
	authors: "Jon Avotins and Glenn Maughan";
	status: "See notice at end of class";
	copyright: "See notice at end of class";
	date: "$Date: 1995/08/28 10:58:12 $";
	revision: "$Revision: 1.5 $"
	
class S_IDENTIFIER inherit

	TERMINAL
	redefine
		token_correct
		-- Redefined to ensure that an 'Identifier' 
		-- cannot be a 'Keyword'.
	end;
	YOOCC_LEX_CONSTANTS
	
feature -- Token

	token_type: INTEGER is
			-- Token code associated with terminal
		once
			Result := Identifier;
		end; -- token_type

feature -- Status Report

	construct_name: STRING is
		once
			Result := "Identifier"
		end; -- construct_name

feature {NONE} -- Implementation

	token_correct: BOOLEAN is
			-- Is token recognized?
		do
			Result := document.token.type = token_type and	
				document.keyword_code (document.token.string_value) = -1 and
				not eiffel_keyword_clash
		end; -- token_correct

feature {YOOCC}

	eiffel_keyword_clash: BOOLEAN is
		local
			token_lower_case: STRING
		do
			token_lower_case := clone (document.token.string_value);
			token_lower_case.to_lower;
			if Eiffel_keywords.has (token_lower_case) then
				Result := true;
				io.putstring ("%N%NError (");
				io.putint (document.token.line_number);
				io.putstring (",");
				io.putint (document.token.column_number);
				io.putstring ("): Identifier must not be a keyword of Eiffel grammar.%N");
			end;
		end; -- eiffel_keyword_clash

	Eiffel_keywords: ARRAY [STRING] is
			-- Keywords that belong to the Eiffel 3 grammar.
		once	
			Result := <<"all","alias","as","and","BIT","check", 
			"class","current","creation","debug","deferred","do",
			"else","elseif","end","ensure","expanded","export",
			"external","false","feature","from","frozen","if",
			"implies","indexing","infix","inherit","inspect", 
			"invariant","is","language","like","local","loop",
			"not","obsolete","old","once","or","prefix", 
			"redefine","require","rename","rescue","result", 
			"retry","select","strip","then","true","undefine", 
			"unique","until","variant","when","xor","and then", 
			"or else">>
			Result.compare_objects
		end; -- Eiffel_keywords
		
end -- class S_IDENTIFIER

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
