indexing

	description:
		"Constructs to be parsed by lexical analysis classes";

	status: "See notice at end of class";
	revision: "1.1.1.1"

deferred class TERMINAL  inherit

	CONSTRUCT
		rename 
			post_action as action, 
			pre_action as unused_pre_action
		redefine 
			action,
			production_syntax,
			build_abstract_syntax
		end

feature -- Access

	token: TOKEN; 
			-- Token associated with terminal

feature -- Status report

	token_type: INTEGER is
			-- Token code associated with terminal
		deferred 
		end 

feature {NONE} -- Implementation
	
	production_syntax: STRING is
			-- Formal production syntax of Current.
		do
			!! Result.make (20);
			Result.append (production_syntax_prefix);
			Result.append ("TERMINAL");
		end; -- production_syntax
	
	production: LINKED_LIST [CONSTRUCT] is
			-- Void
			-- (Meaningless for terminal constructs)
		once 
		end; 

	left_recursion: BOOLEAN is false;

	check_recursion is
			-- Do nothing.
			-- (Meaningless for terminal constructs)
		do
		end; 

	expand is
			-- Do nothing.
		do
		end; 
	
	parse_body (level: INTEGER) is
			-- Parse a terminal construct.
		do
			-- From Kim Walden if token_correct or is_optional then
			if token_correct then
				token := document.token;
				document.get_token;
				complete := true
				if (not no_globals) then
					parent.parse_global_optionals(level);
				end
			else
				complete := false
			end
		end; 

	token_correct: BOOLEAN is
			-- Is token recognized?
		do  
			Result := (document.token.type = token_type) and (document.token.keyword_code = -1) 
			debug ("terminals")
				if Result then
					io.put_string ("Valid terminal: ")
				else
					io.put_string ("Invalid terminal: ")
				end
				io.put_string (document.token.string_value)
				io.put_string (" at line: ")
				io.put_integer (document.token.line_number)
				io.put_string (" col: ")
				io.put_integer (document.token.column_number)
				io.new_line
			end
		end; 
	
	action (level: INTEGER) is
			-- To be redefined in descendants.
		do
			debug ("semantics")
				display_indent (io.output, level)
				io.putstring ("action: ")
				print_name
				io.new_line
			end
		end; 
	
	in_action (level: INTEGER) is
			-- Do nothing.
		do 
			debug ("semantics")
				display_indent (io.output, level)
				io.putstring ("in_action: ")
				print_name
				io.new_line
			end
		end 
	
feature -- displaying
	
	build_abstract_syntax is
			-- Not meaningful for Current.
		do
		end; -- build_abstract_syntax
	
	display_indented (file: IO_MEDIUM; level: INTEGER) is
			-- Display this construct and all 
			-- of its subconstructs at indent level
			-- 'level'.
		do
			display_indent (file, level);
			file.putstring (construct_name);
			file.putstring (" {TERMINAL}");
			if token = Void then
				io.putstring (" No terminal construct stored");
			else
				file.putstring (" (");
				file.putint (token.line_number);
				file.putstring (",");
				file.putint (token.column_number);
				file.putstring (")");
				file.putstring (" value: '");
				file.putstring (string_quoted (token.string_value));
				file.putstring ("'");
			end;
			file.new_line;
		end; -- display_indented
	
feature {NONE} -- Implementation
	
	string_quoted (s: STRING): STRING is
			-- Answer a string that is a representation of `s' with all
			-- control characters quoted with Eiffel special character codes.
		require
			valid_string: s /= Void
		local
			current_index: INTEGER
		do
			Result := clone (s)
			from 
				current_index := 1
			until
				current_index > Result.count
			loop
				-- check if the current character is a control character
				if is_control_character (Result.item (current_index)) then
					-- replace it with its escaped code
					Result.replace_substring (escaped_code (Result.item (current_index)), 
								  current_index, current_index) 
					-- skip past the new control character quote 
					current_index := current_index + 2
				else
					-- skip to next character
					current_index := current_index + 1
				end
			end   
		ensure
			new_string: s /= Result
		end -- string_quoted
	
	is_control_character (c: CHARACTER): BOOLEAN is
			-- Is `c' a recognised control character that has to be excaped
			-- within a string?
		do
			Result := ( c = '%B' 
				    or else c = '%F' 
				    or else c = '%N'
				    or else c = '%R'
				    or else c = '%T'
				    or else c = '%U'
				    or else c = '%%'
				    or else c = '%"') -- " clean up formatting (emacs)  
		end -- is_control_character 
	
	escaped_code (c: CHARACTER): STRING is
			-- Answer the string consisting of the control character's
	 -- escape code
		require
			is_control_character: is_control_character (c)
		do
			!! Result.make (2)
			inspect c
			when '%B' then
				Result := "%%B"
			when '%F' then
				Result := "%%F"
			when '%N' then
				Result := "%%N"
			when '%R' then
				Result := "%%R"
			when '%T' then
				Result := "%%T"
			when '%U' then
				Result := "%%U"
			when '%%' then
				Result := "%%%%"
			when '%"' then -- " clean up formatting (emacs)
				Result := "%%%""
			else
				-- otherwise it is just the same character
				Result.extend (c)
			end
		ensure
			--two_character_result: Result.count = 2
		end -- escaped_code
	
end -- class TERMINAL
 

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
