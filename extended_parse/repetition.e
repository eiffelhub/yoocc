indexing

	description:
		"Constructs whose specimens are sequences of specimens %
		%of a specified base construct, delimited by a specified separator";

	status: "See notice at end of class";
	revision: "1.1.1.1"

deferred class REPETITION inherit

	CONSTRUCT
		rename
			put_component as field,
			is_leaf as no_components
		redefine
			expand_all,
			production_syntax
		end

feature -- Status report

	left_recursion: BOOLEAN is
			-- Is the construct's definition left-recursive?
		do
			if structure_list.has (production) then
				global_left_recursion.put (true);
				child_recursion.put (true);
				recursion_message.append (construct_name);
				recursion_message.append ("%N");
				Result := true;
			else
				structure_list.put_right (production);
				child_start;
				Result := not message_construction
			end;
			structure_list.search (production);
			structure_list.remove;
			structure_list.go_i_th (0)
		end 
	
feature {CONSTRUCT,TROOPER,YOOCC,QSRES} -- Implementation
	
	production_syntax: STRING is
			-- Formal production syntax of Current.
		do
			from 
				!! Result.make (20);
				Result.append (production_syntax_prefix);
				Result.append ("{");
				production.start	
			until 
				production.after
			loop
				Result.append(production.item.construct_out);
				production.forth;
			end; -- loop 
			if optional_separator then
				Result.append(" [%"");
				Result.append(separator);
				Result.append("%"]");
			elseif has_separator then
				Result.append(" %"");
				Result.append(separator);
				Result.append("%"");
			end;
			Result.append(" ... }");
			if nbr_constructs_required > 1 then
				Result.append_integer (nbr_constructs_required)
			elseif (not is_optional) then
				Result.append ("+"); 
			end;
		end; -- process_production_rule
	
	expand_all is
			-- Expand all child constructs.
		do
			if no_components then
				expand
			end
		end; 

	check_recursion is
			-- Check the sequence for left recursion.
		do
			if not check_recursion_list.has (production) then
				check_recursion_list.extend (production);
				if print_mode.item then
					print_children
				end;
				child_start;
				child.expand_all;
				child.check_recursion
			end
		end 

feature {NONE} -- Implementation
	
	
	nbr_constructs_required: INTEGER is
			-- Number of constructs required in production
			-- before optional separator for Current to be
			-- parsed correctly.
		do
			Result := 1
		end; -- nbr_constructs_required
	
	
	separator: STRING is 
			-- List separator in the descendant,
			-- must be defined as a keyword in the lexical analyzer
		deferred 
		end; 

	separator_code: INTEGER is 
			-- Code of the keyword-separator; -1 if none
			-- (according to lexical code)
		local
			separator_not_keyword: EXCEPTIONS
		do
			if separator /= Void then 
				Result := document.keyword_code (separator);
				if Result = -1 then
					!!separator_not_keyword;
					separator_not_keyword.raise( "separator_not_keyword" );
				end
			else
				Result := -1
			end
		end;

	commit_on_separator : BOOLEAN is
			-- Is one element of the sequence and a separator enough to
			-- commit the sequence?
			-- (This is true by default, but not where the same
			-- production may have different parents with a
			-- choice construct as a common ancestor of the parents)
		do
			Result := true
		end; 

	has_separator: BOOLEAN is
			-- Has the sequence a separator?
		do
			Result := separator_code /= -1
		end; 

	expand is
			-- Create next construct to be parsed and insert it in
			-- the list of the items of the sequence.
		local
			n: CONSTRUCT
		do
			n := clone (production.first);
			field (n)
		end; 
	
	optional_separator: BOOLEAN is
			-- 18 October 1994
			-- Is the separator for this construct optional.
			-- If 'yes' then the class will still attempt to
			-- parse a repitition construct, otherwise, the absence
			-- of the separator will infer the conclusion of the
			-- construct.    
			-- Non-optional separators imply the standard version
			-- of this class as supported by ETL.
			-- Optional separators imply a new implementation 
			-- of this class.
		do
			Result := false
		end; -- optional_separator
	
	
	parse_body (level: INTEGER) is
			-- Attempt to find a sequence of constructs with separators
			-- starting at current position. Set committed
			-- at first separator if `commit_on_separator' is set.
		local
			child_found, first_child_found: BOOLEAN;
			separator_found, wrong: BOOLEAN
			nbr_constructs_found: INTEGER
		do
			from
				child_found := parse_one (level + 1);
				first_child_found := child_found
			until
				not child_found 
			loop
				nbr_constructs_found := nbr_constructs_found + 1
				separator_found := false;
				child_found := false;
				if has_separator then
					separator_found := document.token.is_keyword (separator_code);
					if separator_found then 
						if commit_on_separator then
							committed := true
						end;
						document.get_token 
						if (not no_globals) then
							parse_global_optionals (level + 1)
						end;
					end
				end
				-- 18/10/94 Changed from:
				-- if (not has_separator) or separator_found then
				-- to account for repitition constructs that have an optional
				-- separator 	   
				if (not has_separator) or 
					optional_separator or separator_found then
					child_found := parse_one (level + 1)
					-- commit after a child is found
					if commit_on_separator then
						committed := true
					end
				end
			end;
			-- 18/10/94 Changed from:
			-- wrong := has_separator and separator_found and not child_found;
			-- to account for the optional_separator case.
			wrong := has_separator and (not optional_separator) 
				and separator_found and not child_found;
			-- 22/11/94 Changed from:
			--	 complete := first_child_found and not (committed and wrong)
			--	to account for REPETITION constructs that require more than one 
			-- 	construct to be found in order for the construct to be complete
			complete := nbr_constructs_found >= nbr_constructs_required 
					and not (committed and wrong)
		end; 
	
	
   parse_one (level: INTEGER): BOOLEAN is
			-- Parse one element of the sequence and
			-- return true if successful.
		local
			tmp_committed: BOOLEAN
		do
			expand;
			if has_separator then
				parse_child (level + 1)
			else
				tmp_committed := committed;
				committed := False;
				parse_child (level + 1);
				committed := committed or tmp_committed
			end;
			Result := child.parsed;
			if not child.parsed then
				remove_child
			end
		end; 
	
	in_action (level: INTEGER) is
			-- Execute semantic actions on current construct
			-- by executing actions on children in sequence.
		do
			debug ("semantics")
				display_indent (io.output, level)
				io.putstring ("in_action: ")
				print_name
				io.new_line
			end
			if not no_components then
				from
					child_start
				until
					child_after
				loop
					child.semantics_indented (level + 2);
					middle_action (level);
					child_forth
				end
			end
		end; 
	
	middle_action (level: INTEGER) is
			-- Execute this after parsing each child.
			-- Do nothing here.
		do 
			debug ("semantics")
				display_indent (io.output, level)
				io.putstring ("middle_action: ")
				print_name
				io.new_line
			end
		end;

	print_children is
			-- Print content of sequence,
			-- optional are between square brackets.
		do
			print_name;
			io.put_string (" :	");
			child_start;
			if child.is_optional then
				io.put_character ('[')
			end;
			child.print_name;
			if child.is_optional then
				io.put_character (']')
			end;
			io.put_string (" ..");
			child_forth;
			if has_separator then
				io.put_string (" ");
				print_keyword
			end;
			io.new_line
		end; 

	print_keyword is
			-- Print separator string.
		do
			io.put_character ('"');
			io.put_string (document.keyword_string (separator_code));
			io.put_string ("%" ")
		end 
	
feature {ANY} -- Displaying
	
	display_indented (file: IO_MEDIUM; level: INTEGER) is
			-- Display this construct and all 
			-- of its subconstructs at indent level
			-- 'level'.
		do
			from
				child_start;
				display_indent (file, level);
				file.putstring (construct_name);
				file.putstring (" {REPETITION}");
				file.new_line;
			until
				no_components or child_after
			loop
				child.display_indented (file, level + Indent_step);
				child_forth
			end;
		end;	
	
end -- class REPETITION
 

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
