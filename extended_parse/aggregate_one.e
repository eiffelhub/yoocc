indexing
	description: "Constructs whose specimens are obtained %
	%by concatenating specimens of constructs %
	%of one or more specified constructs. At least one of the constructs must be present%
	%Printable Aggregate construct"
	
deferred class AGGREGATE_ONE inherit
	
	AGGREGATE
		redefine
			parse_body, display_indented
		end
	
feature {NONE} -- Implementation
	
	parse_body (level: INTEGER) is
			-- Attempt to find input matching the components of
			-- the aggregate starting at current position.
			-- The construct must have at least one of its optional
			-- constructs to parse successfully.
			-- Set parsed to true if successful.
		require else
			no_child: no_components
		local
			wrong: BOOLEAN;
			err: STRING
		do
			-- parse each component of the aggregate
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
			-- determine whether the parse operation was successful
			if not wrong then
				complete := is_child_complete
			else
				-- something went wrong in the initial parse dont worry
				-- about checking the children
				complete := False
			end
			remove_incomplete_optionals
		end;
	
	is_child_complete: BOOLEAN is
			-- Has one of the child constructs been parsed successfully and completely?
		do
			from
				child_start
				Result := False
			until
				no_components or child_after or Result
			loop  
				-- find at least one optional construct that has parsed and
				-- is successful
				if child.parsed and then child.complete then
					Result := True
				end
				child_forth
			end
		end -- is_child_complete
	
	remove_incomplete_optionals is
			-- remove optional components that parsed but are not complete
		do
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
		end -- remove_incomplete_optionals
	
feature {ANY} -- Displaying
	
	display_indented (file: IO_MEDIUM; level: INTEGER) is
			-- Display this construct and all 
			-- of its subconstructs at indent level
			-- 'level'.
		do
			from
				child_start;
				display_indent (file, level);
				file.putstring (construct_name)
				file.putstring (" {AGGREGATE_ONE}");
				file.new_line;
			until
				no_components or child_after
			loop
				child.display_indented (file, level + Indent_step);
				child_forth
			end;
		end;	
	
end -- class AGGREGATE_ONE
