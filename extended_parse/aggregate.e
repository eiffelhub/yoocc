indexing

	description:
		"Constructs whose specimens are obtained %
		%by concatenating specimens of constructs %
		%of zero or more specified constructs";

	status: "See notice at end of class";
	revision: "1.1.1.1"

deferred class AGGREGATE inherit

	CONSTRUCT
		rename
			is_leaf as no_components
		redefine
			commit,
			parse_body,
			expand_next,
			production_syntax
		end

feature -- Status report 

	left_recursion: BOOLEAN is
			-- Is the construct's definition left-recursive?
		local
			end_loop: BOOLEAN;
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
					end_loop or no_components or child_after or Result
				loop
					Result := not message_construction;
					end_loop := not child.is_optional;
					child_forth
				end
			end;
			structure_list.search (production);
			structure_list.remove;
			structure_list.go_i_th (0)
		end

feature -- Transformation 

	commit is
			-- If this construct is one among several possible ones,
			-- discard the others.
		require else
			only_commit_once: not has_commit 
		do
			has_commit := true;
			commit_value := production.index - 1
		end

	has_commit: BOOLEAN
			-- Is current aggregate committed?


feature {NONE} -- Implementation
	
	production_syntax: STRING is
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
				Result.append(" ");
				production.forth
			end; -- loop 
		end; -- production_syntax
	
	commit_value: INTEGER;
			-- Threshold of successfully parsed subconstructs
			-- above which the construct is commited


	expand is
			-- Expand the next field of the aggregate.
		do
			expand_next;
			if has_commit and commit_value < child_index then
				committed := true
			end
		end;
	
	in_action (level: INTEGER) is
			-- Perform semantics of the child constructs.
		do
			debug ("semantics")
				display_indent (io.output, level)
				io.putstring ("in_action: ")
				print_name
				io.new_line
			end
			from
				child_start
			until
				no_components or child_after 
			loop
				child.semantics_indented (level + Indent_step);
				child_forth
			end
		end
	
feature {CONSTRUCT,TROOPER,YOOCC,QSRES} -- Implementation
	
	check_recursion is
			-- Check the aggregate for left recursion.
		local
			not_optional_found, b: BOOLEAN
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
					if not_optional_found then
						child.expand_all;
						b := not child.left_recursion;
						if child_recursion.item then
							child_recursion.put (false)
						else
							child.check_recursion
						end;
						child_forth
					else
						child.expand_all;
						child.check_recursion;
						not_optional_found := not child.is_optional;
						child_forth
					end
				end
			end
		end  -- check_recursion

feature {NONE} -- Implementation

	print_children is
			-- Print content of aggregate.
		do
			from
				child_start;
				print_name;
				io.put_string (" :    ")
			until
				no_components or child_after
			loop
				print_child;
				io.put_string (" ");
				child_forth
			end;
			io.new_line
		end;

	print_child is
			-- Print active child name,
			-- with square brackets if optional.
		do
			if child.is_optional then
				io.put_character ('[')
			end;
			child.print_name;
			if child.is_optional then
				io.put_character (']')
			end
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
				file.putstring (" {AGGREGATE}");
				file.new_line;
			until
				no_components or child_after
			loop
				child.display_indented (file, level + Indent_step);
				child_forth
			end;
		end;	
	
feature {NONE} -- Implementation
	
	parse_body (level: INTEGER) is
			-- Attempt to find input matching the components of
			-- the aggregate starting at current position.
			-- Set parsed to true if successful.
		require else
			no_child: no_components
		local
			wrong: BOOLEAN;
			err: STRING
		do
			from	
				expand
			until
				wrong or no_components or child_after
			loop
				parse_child (level + 1);
				wrong :=  not child.parsed;
				if not wrong then
					expand
				end
			end;
			complete := not wrong
			-- remove optional constructs from the tree if they parsed
			-- but are not complete
			from 
				child_start
			until
				no_components or child_after 
			loop
				if child.is_optional and then
					child.parsed and then not child.complete then
					remove_child
				else
					child_forth
				end
			end 
		end;
	
	production_position: INTEGER;
			-- Position expanded to in production
			-- As expand_next was originally dependent upon
			-- the number_of_children as an indicator of which
			-- position in the construction the parser was up to
			-- and the addition of global_optionals,  expand_next
			-- had to be redefined and a production_position
			-- stored that indicated the position in the production the
			-- parser was up to.
	
	expand_next is
			-- Expand the next child of current node
			-- after current child.
			-- This is the most likely version of expand
			-- for types of construct where each subconstruct
			-- must be expanded in turn.
		local
			n: CONSTRUCT
		do
			if not production.empty then
				production_position := production_position + 1;
				production.go_i_th (production_position);
				if not production.after then
					n := clone (production.item);
					put_component (n)
				else
					child_finish;
					child_forth
				end
			else
				child_finish;
				child_forth
			end
		end;
	
	
end -- class AGGREGATE


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
