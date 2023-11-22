indexing

	description:
		"The general notion of language construct,  %
		%characterized by a grammatical production %
		%and associated semantic actions"

	status: "See notice at end of class"
	revision: "1.1.1.1"

deferred class CONSTRUCT inherit

	TWO_WAY_TREE [CONSTRUCT]
		rename
			put as twt_put,
			make as twt_make
		export
			{CONSTRUCT} twt_put, twt_make
		redefine 
			parent, new_cell
		end
   
	DISPLAYABLE
	
feature -- Initialization

	make is
			-- Set up construct.
		do
			twt_make (Current)
		end

feature -- Access

	document: INPUT is
			-- The document to be parsed
		once
			!! Result.make
		end

	production: LINKED_LIST [CONSTRUCT] is 
			-- Right-hand side of the production for the construct
		deferred 
		end

	construct_name: STRING is 
			-- Name of the construct in the grammar
		deferred
		end

feature -- Status report
	
	no_globals: BOOLEAN 
			-- Will globals be applied to this construct
	
	is_optional: BOOLEAN
			-- Is construct optional? 

	left_recursion: BOOLEAN is 
			-- Is the construct's definition left-recursive?
		deferred 
		end

	parsed: BOOLEAN
			-- Has construct been successfully parsed?
			-- (True for optional components not present)

	committed: BOOLEAN
			-- Have enough productions been recognized to interpret
			-- failure of parsing as a syntax error in this construct?
			-- (Otherwise the parsing process will backtrack, trying
			-- other possible interpretations of the part already read.)

	print_mode: CELL [BOOLEAN] is 
			-- Must the left-recursion test also print the production?
			-- (Default: no.)
		once 
			!! Result.put (false)
		end
	
feature {CONSTRUCT}
	
	complete: BOOLEAN
			-- Has the construct been completely recognized?
			-- (Like `parsed', but in addition the construct,
			-- if optional, must be present.)
	
	parent_has_no_globals: BOOLEAN is
			-- If parent does not want to parse globals then
			-- neither do their children.	
		do
			-- If this construct is not to parse global_optionals
			-- then do not parse_global_optionals.
			if no_globals then
				Result := true
			else
				-- If this construct has no parents then
				-- whatever this construct says goes.
				if is_root then
					Result := false
				else
					-- If this construct has parents
					-- then test immediate parent to
					-- see whether or not to parse
					-- global_optionals.
					Result := false or parent.parent_has_no_globals
				end
			end
		end -- parent_has_no_globals
	
feature -- Status setting

	set_optional is
			-- Define this construct as optional.
			-- If the production does not match the tokens,
			-- the construct will be parsed anyway.
		do
			is_optional := true
		ensure
			optional_construct: is_optional
		end
	
	set_no_globals is
			-- Define this construct as one which there should 
			-- be no parsing of global_optionals
		do
			no_globals := true
		ensure
			do_not_parse_globals: no_globals
		end -- set_no_globals
	
feature -- Transformation

	process is
			-- Parse a specimen of the construct, then apply
			-- semantic actions if parsing successful.
		do
			parse
			if parsed then
				semantics
			end
		end
	
	parse_global_optionals (level: INTEGER) is
			-- Start the parsing process for global_optionals
		local
			pc: CONSTRUCT
			global_optionals: GLOBAL_OPTIONALS
		do
			!! global_optionals.make
			if (not parent_has_no_globals) and (not global_optionals.production.empty) then
				--	!! global_list.make global_list.set_optional
				pc := clone (global_list)
				put_component (pc)
				parse_child (level + 1)
				if (child /= Void and then not (child.complete)) then
					remove_child
				end
			end
		end -- parse_global_optionals
	
	parse is
			-- Start the parsing process for this construct
		do
			parse_indented (0)
		end -- parse
	
	parse_indented (level: INTEGER) is
			-- Attempt to analyze incoming lexical
			-- tokens according to current construct. 
			-- Set `parsed' to true if successful 
			-- return to original position in input otherwise.
		local
			initial_document_position: INTEGER
		do
			debug ("parse") 
				display_indent (io.output, level)
				io.put_string("Attempting to parse ") 
				print_name 
				io.new_line 
			end
			initial_document_position := document.index
			parsed := false
			complete := false
			committed := false
			parse_body (level + 1)
			if not complete and is_optional then
				document.go_i_th (initial_document_position)
				parsed := not committed
			else
				parsed := complete
			end
			-- display the last error message if we have
			-- not rolled back
			if not complete and not is_optional and committed then
				display_last_error
			end                                    
			debug ("parse") 
				display_indent (io.output, level)
				io.put_string(construct_name) 
				if parsed then
					io.put_string(" PARSED") 
				else
					io.put_string(" not parsed") 
				end
				debug ("commit")
					if committed then
						io.put_string (" (committed)")
					end
				end
				io.new_line
			end
			
		end

	commit is
			-- If this construct is one among several possible ones,
			-- discard the others.
			-- By default this does nothing.
		do
		end

	semantics is
			-- Apply semantic actions in order:
			-- `pre_action', `in_action', `post_action'.
		do
			semantics_indented (0)
		end
	
	semantics_indented (level: INTEGER) is
			-- Apply semantic actions in order:
			-- `pre_action', `in_action', `post_action'.
			-- Pass `level' as the level of recursion.
		do
			pre_action (level)
			in_action (level)
			post_action (level)
		end -- semantics_indented
	
	pre_action (level: INTEGER) is
			-- Do nothing here.
		do
			debug ("semantics")
				display_indent (io.output, level)
				io.put_string ("pre_action: ")
				print_name
				io.new_line
			end
		end
	
	post_action (level: INTEGER) is
			-- Do nothing here.
		do 
			debug ("semantics")
				display_indent (io.output, level)
				io.put_string ("post_action: ")
				print_name
				io.new_line
			end
		end



feature -- Output 

	print_name is
			-- Print the construct name on standard output.
		do
			io.put_string (construct_name)
		end
	
	display_last_error is
			-- Display the last error stored in the document on stdout
		do
			document.display_error_message
		end -- display_last_error
	
feature {CONSTRUCT,CONSTRUCT_QUERY_TOOL} -- Implementation
	
	abstract_syntax: HASH_TABLE [STRING,STRING] is
			-- Recursive abstract syntax of construct.
		once
			!! Result.make(1)
		end -- abstract_syntax
	
	construct_out: STRING is
			-- Used by display_production_rule to
			-- display the state of Current.
		do
			!! Result.make(15)
			if is_optional then
				Result.append("[")
				Result.append(construct_name)
				Result.append("]")
			else
				Result.append(construct_name)	
			end
		end -- construct_out
	
	production_syntax: STRING is
			-- Formal production syntax of Current.
		deferred
		end -- production_syntax
	
	global_list: GLOBAL_LIST is
			-- Optional constructs that may appear anywhere inbetween
			-- constructs. GLOBAL_LIST (REPETITION) is a 
			-- class depicting the optional contructs.
		once
			!! Result.make
			Result.set_optional
		end -- global_list
	
	parent: CONSTRUCT
			-- Parent of current construct

	new_cell (v: like item): like item is
		do
			Result := v
			Result.twt_put (v)
			Result.attach_to_parent (Current)
		end

	check_recursion is 
			-- Check construct for left recursion.
		deferred 
		end

	expand_all is
			-- Used by recursion checking
		do
			if is_leaf then
				from
					expand
				until
					is_leaf or child_after
				loop
					expand
				end
			end
		end

feature {NONE} -- Implementation

	put (c: CONSTRUCT) is
			-- Add a construct to the production.
		do  
			production.put_left (c)
			last_sub_construct := c
		end

	last_sub_construct: CONSTRUCT
			-- Subconstruct most recently added to the production

	make_optional is
			-- Make the last entered subconstruct optional.
		do
			last_sub_construct.set_optional
		end

	keyword (s: STRING) is
			-- Insert a keyword into the production.
		local
			key: KEYWORD
		do     
			!! key.make (s)
			put (key)
		end

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
				production.go_i_th (child_index + 1)
				if not production.after then
					n := clone (production.item)
					put_component (n)
				else
					child_finish
					child_forth
				end
			else
				child_finish
				child_forth
			end
		end

	expand is
			-- Create next construct to be parsed.
			-- Used by `parse' to build the production
			-- that is expected at each node, according to `production'.
		deferred
		end

	put_component (new: CONSTRUCT) is
			-- Add a new component to expand the production.
			-- Note that the components are always added in
			-- the tree node in left to right order.
		do
			child_finish
			child_put_right (new)
			child_forth
		end

	raise_syntax_error (s: STRING) is
			-- Print error message s.
		local
			s2 : STRING
		do  
			s2 := clone (s)
			s2.append (" in ") 
			s2.append (construct_name) 
			if parent /= Void then
				s2.append (" of ") 
				s2.append (parent.construct_name)
			end
			document.raise_error (s2)
		end

	expected_found_error is
			-- Print an error message saying what was 
			-- expected and what was found.
		local
			err: STRING
		do
			!! err.make (20)
			err.append (child.construct_name)
			err.append (" expected, ")
			if document.token.type = -1 then
				err.append ("end of document found")
			elseif document.token.string_value.count > 0 then
				err.append ("%"")
				err.append (document.token.string_value)
				err.append ("%" found at column ")
				err.append_integer (document.token.column_number)
			end
			raise_syntax_error (err)
		end

	structure_list: LINKED_LIST [LINKED_LIST [CONSTRUCT]] is
			-- List of the structures already examined when
			-- searching for left recursion
		once
			!! Result.make
		end

	check_recursion_list: LINKED_LIST [LINKED_LIST [CONSTRUCT]] is
			-- List of the structures already examined when
			-- checking for left recursion
		once
			!! Result.make
		end

	global_left_recursion: CELL [BOOLEAN] is 
			-- Is there any left recursion in the whole program?
		once 
			!! Result.put (false)
		end

	child_recursion: CELL [BOOLEAN] is 
			-- Is there any recursion in the whole program?
		once 
			!! Result.put (false)
		end

	recursion_message: STRING is
			-- Error message when left recursion has been detected,
			-- with all productions involved in the recursion chain
		once
			!! Result.make (100)
		end

	message_construction: BOOLEAN is
			-- Has the message on left recursion been already printed?
		do
			child.expand_all
			Result := not child.left_recursion
			if not Result then
				if not structure_list.has (production) then
					structure_list.put_right (production)
					io.put_string ("Left recursion has been detected ")
					io.put_string ("in the following constructs:%N")
					io.put_string (recursion_message)
					io.new_line
					recursion_message.wipe_out
					Result := true
				else
					recursion_message.append (construct_name)
					recursion_message.append ("%N")
				end
			elseif Result and not structure_list.has (production) then
				io.put_string ("child.left_recursion = false")
				io.put_string ("		and recursion_visited = false%N")
			end
		end
	
	in_action (level: INTEGER) is
			-- Perform a certain semantic operation.
		deferred
		end
	
	parse_body (level: INTEGER) is
			-- Perform any special parsing action for a particular
			-- type of construct.
			-- Call `parse_child' on each child construct.
			-- Set `committed' to true if enough has been 
			-- recognized to freeze the parse tree built so far.
			-- Set `complete' to true if the whole construct has been
			-- correctly recognized.
		deferred
		end
	
	parse_child (level: INTEGER) is
			-- Parse child recursively to build the tree.
			-- An error is output the first time a parse fails 
			-- in an uncommitted child of a committed parent 
			-- i.e. at the deepest point known to be meaningful.
		do
			child.parse_indented (level + 1)
			if child.committed then
				committed := true
			end
			debug ("parse")
				display_indent (io.output, level)
				io.put_string ("Parent committed=")
				io.put_boolean (committed)
				io.put_string (" child.parsed=")
				io.put_boolean (child.parsed)
				io.put_string (" child.committed=")
				io.put_boolean (child.committed)
				io.new_line
			end
			if committed and not (child.parsed or child.committed) then
				expected_found_error
			end
		end
	
	production_syntax_prefix: STRING is
			-- Production syntax prefix for Current.
		do	
			!! Result.make (10)
			Result.append (construct_name) 
			Result.append (" ::= ")
		end -- production_syntax_prefix
	
feature -- Displaying
	
	build_abstract_syntax is
			-- Fill abstract_syntax with production syntax 
			-- recursively.
		do
			if (not abstract_syntax.has(construct_name)) then
				from
					abstract_syntax.put(production_syntax,construct_name)
					production.start
				until
					production.after
				loop
					production.item.build_abstract_syntax
					production.forth
				end -- loop
			end -- if
		end -- build_abstract_syntax
	
end -- class CONSTRUCT


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
