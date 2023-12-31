indexing

	description:
		"Constructs whose specimens are specimens of constructs %
		%chosen among a specified list.";

	status: "See notice at end of class";
	revision: "1.1.1.1"

deferred class CHOICE inherit

	CONSTRUCT
		rename
			put_component as branch,
			is_leaf as no_components
		redefine
			parse_global_optionals,
			production_syntax
		end

feature -- Access

	retained: CONSTRUCT;
			-- Child which matches the input document;
			-- Void if none.

feature -- Status report

	left_recursion: BOOLEAN is
			-- Is the construct's definition left-recursive?
		do
			if structure_list.has (production) then
				global_left_recursion.put (true);
				child_recursion.put (true);
				recursion_message.append (construct_name);
				recursion_message.append ("%N");
				Result := true
			else
				from
					structure_list.put_right (production);
					child_start;
					Result := false
				until
					no_components or child_after or Result
				loop
					Result := not message_construction;
					child_forth
				end
			end;
			structure_list.start;
			structure_list.search (production);
			structure_list.remove;
			structure_list.go_i_th (0)
		end;
	
feature {CONSTRUCT,TROOPER,YOOCC,QSRES} -- Implementation
	
	production_syntax: STRING  is
			-- Formal production syntax of Current.
		do
			from 
				!! Result.make (20);
				Result.append (production_syntax_prefix);
				production.start
			until 
				production.off
			loop
				Result.append(production.item.construct_out);
				production.forth
				if (not production.off) then
					Result.append (" | ");
				end; -- if
			end; -- loop 
		end; -- production_syntax
	
	check_recursion is
			-- Check choice construct for left recursion.
		local
			b: BOOLEAN
		do
			if not check_recursion_list.has (production) then
				check_recursion_list.extend (production);
				if print_mode.item then
					print_children
				end;
				from
					child_start
				until
					no_components or child_after
				loop
					child.check_recursion;
					child_forth
				end
			end
		end

feature {NONE} -- Implementation

	print_children is
			-- Print children separated with a bar.
		do
			print_name;
			io.put_string (" :    ");
			from
				child_start
			until
				no_components or child_after
			loop
				child.print_name;
				child_forth;
				if not child_after then
					io.put_string (" | ")
				end
			end;
			io.new_line
		end; 

	expand is
			-- Create list of possible choices.
		do
			expand_next
		end; 
	
	parse_body (level: INTEGER) is
			-- Try each possible expansion and keep
			-- the one that works.
		local
			initial_document_position: INTEGER
		do
			from
				initial_document_position := document.index;
				expand
			until
				no_components or child_after or retained /= Void
			loop
				parse_child (level + 1);
				if child.parsed then
					retained := child
				else
					document.go_i_th (initial_document_position)
				end;
				expand
			end;
			complete := retained /= Void;
			wipe_out;
		-- A choice, once parsed, is not used as a tree node: it
		-- has only one child which is accessed through 'retained'
		end; 
	
	in_action (level: INTEGER) is
		do
			debug ("semantics")
				display_indent (io.output, level)
				io.putstring ("in_action: ")
				print_name
				io.new_line
			end
			if retained /= Void then
				retained.semantics_indented (level + Indent_step)
			end
		end;
	
feature -- Displaying
	
	display_indented (file: IO_MEDIUM; level: INTEGER) is
			-- Display this construct and all 
			-- of its subconstructs at indent level
			-- 'level'.
		do
			display_indent (file, level);
			file.putstring (construct_name);
			file.putstring (" {CHOICE}");
			if retained = Void then
				file.putstring (" No retained construct");
			else
				file.new_line;
				retained.display_indented (file, level + Indent_step);
			end;			
		end;	
	
	parse_global_optionals (level: INTEGER) is
			-- Start the parsing process for global_optionals
		do
			if not (no_globals) then
				parent.parse_global_optionals (level);		
			end
		end; -- parse_global_optionals
	
end -- class CHOICE
 

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
