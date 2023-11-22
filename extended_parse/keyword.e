indexing

	description:
		"Terminal constructs with just one specimen, %
		%representing a language keyword or special symbol";

	status: "See notice at end of class";
	revision: "1.1.1.1"

class KEYWORD inherit

	TERMINAL
		rename
			make as construct_make
		redefine
			display_indented,
			token_correct,
			construct_out,
			production_syntax
		end

creation

	make

feature -- Initialization

	make (s: STRING) is
			-- Set up terminal to represent `s'.
		do
			construct_make;
			construct_name := s;
			lex_code := document.keyword_code (s)
		ensure
			construct_name = s;
			lex_code = document.keyword_code (s)
		end; 

feature -- Access

	construct_name: STRING;
			-- Name of the keyword

	lex_code: INTEGER
			-- Code of keyword in the lexical anayser

feature {NONE} -- Implementation
	
	production_syntax: STRING is
			-- Void.  Maningless for Current.
		do
		end;
	
	construct_out: STRING is
			-- Used by display_production_rule to
			-- display the state of Current.
		do
			!! Result.make(15);
			if is_optional then
				Result.append("[%"");
				Result.append(construct_name);
				Result.append("%"]");
			else
				Result.append("%"");
				Result.append(construct_name);	
				Result.append("%"");
			end;
		end; -- construct_out
	
	token_correct: BOOLEAN is
			-- Is this keyword the active token?
		do
			Result := document.token.is_keyword (lex_code)
			debug ("terminals")
				if Result then
					io.put_string ("Valid keyword: ")
				else
					io.put_string ("Invalid keyword: ")
				end
				io.put_string (document.token.string_value)
				io.put_string (" at line: ")
				io.put_integer (document.token.line_number)
				io.put_string (" col: ")
				io.put_integer (document.token.column_number)
				io.new_line
			end
		end; 

	token_type: INTEGER is 0
			-- Unused token type
	
feature {ANY} -- Displaying
	
	display_indented (file: IO_MEDIUM; level: INTEGER) is
			-- Display the keyword name and value
		do
			display_indent (file, level);
			file.putstring (construct_name);
			file.putstring (" {KEYWORD}");
			if token = Void then
				file.putstring (" No keyword construct stored");
			else
				file.putstring (" value: '");
				file.putstring (token.string_value);
				file.putstring ("'");
			end;
			file.new_line;
		end; -- display_indented	
   
end -- class KEYWORD
 

--|----------------------------------------------------------------
--| EiffelParse: library of reusable components for ISE Eiffel 3,
--| Copyright (C) 1986, 1990, 1993, 1994, Interactive Software
--|   Engineering Inc.
--| All rights reserved. Duplication and distribution prohibited.
--|
--| 270 Storke Road, Suite 7, Goleta, CA 93117 USA
--| Telephone 805-685-1006
--| Fax 805-685-6869
--| Electronic mail <info@eiffel.com>
--| Customer support e-mail <support@eiffel.com>
--|----------------------------------------------------------------
