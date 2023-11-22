indexing
	description: "Non_terminal_info"
	authors: "Jon Avotins and Glenn Maughan"
	status: "See notice at end of class";
	copyright: "See notice at end of class";
	date: "$Date: 1995/08/28 00:54:25 $";
	revision: "$Revision: 1.6 $"

deferred class NON_TERMINAL_INFO

inherit

	PRODUCTION_INFO
	export
		{YOOCC_SEMANTIC_INFORMATION} construct_class_name
	redefine
		syntax_class, construct_class
	end;

feature -- Initialization

	make (p_name: STRING) is
		require
			valid_production_name: p_name /= Void
		do
			!! production_name.make (1);
			production_name.append (p_name);
			production_name.to_upper;
			!! rhs_productions.make;
		end; -- make

feature -- Access

	nbr_constructs_required: INTEGER;

	rhs_productions: LINKED_LIST [RHS_CONSTRUCT];
		-- Right hand side constructs for Current.

	separator: STRING;

feature -- Status Setting

	set_has_separator is
		do
			has_separator := true
		end; -- set_has_separator

	set_optional is
		do
			is_optional := true;
		end; -- set_optional_construct

	set_latest_info_optional is
		do
			latest_info_optional := true;
		end; -- set_latest_info_optional

	set_latest_info_not_optional is
		do
			latest_info_optional := false;
		end; -- set_latest_info_not_optional

	set_nbr_constructs_required (nbr: INTEGER) is
		require
			valid_cardinality: nbr >= 1
		do
			nbr_constructs_required := nbr;	
		end; -- set_nbr_constructs_required

	set_optional_separator is
		do
			optional_separator := true
		end; -- set_optional_separator

	set_separator (a_string: STRING) is
		do
			!! separator.make (1);
			separator.copy(a_string);		
		end; -- set_separator

feature -- Status Report

	has_separator: BOOLEAN;
			-- Does Current have a separator.

	is_optional: BOOLEAN;

	latest_info_optional: BOOLEAN;

	optional_construct: BOOLEAN;

	optional_separator: BOOLEAN;

feature -- Implementation
		
	construct_class: STRING is
			-- Construct class for Current.
		do
			!! Result.make (1);
			Result.append (class_header (construct_class_name));
			Result.append (syntax_class_name);
			if is_root_construct then
				Result.append ("%N%T%Texport%N%T%T {");
				Result.append (root_export);
				Result.append ("} all%N%T%Tend;");
			end;
			Result.append ("%N%TSEMANTIC_INFORMATION");
			Result.append ("%N%Ncreation%N%N%Tmake");
			Result.append ("%N%Nfeature {CONSTRUCT} -- semantics");
			Result.append (end_class (construct_class_name));
		end; -- construct_class

	syntax_class: STRING is
			-- Syntax class for Current. 
		do
			!! Result.make (1);
			Result.append (syntax_class_declaration);
			Result.append ("%Nfeature -- Access");
			Result.append (production_feature);
			Result.append (construct_name_feature);
			Result.append (end_class (syntax_class_name));
		end; -- build_syntax_class

	production_feature: STRING is
			-- The production feature for Current.
		require
			has_rhs_constructs: rhs_productions.count > 0
		do
			!! Result.make (1); 
			Result.append ("%N%N%Tproduction: LINKED_LIST [CONSTRUCT] is");
			if has_local_declarations then
				resolve_duplicate_variable_names;
				Result.append (local_declarations);
			end;
			Result.append ("%N%T%Tonce");
			Result.append ("%N%T%T%T!! Result.make;");
			Result.append ("%N%T%T%TResult.forth;");
			Result.append (production_list_declarations);
			Result.append ("%N%T%Tend; -- production");
		end; -- production_feature

	production_list_declarations: STRING is
		do
			from 
				!! Result.make (1);
				rhs_productions.start
			until 
				rhs_productions.off
			loop
				Result.append ("%N%T%T%T");
				Result.append (rhs_productions.item.feature_calls);
				rhs_productions.forth;
			end; 
		end; -- production_list_declarations

	local_declarations: STRING is
		do
			!! Result.make (1);
			Result.append ("%N%T%Tlocal");
			from 
				rhs_productions.start
			until 
				rhs_productions.off
			loop
				if rhs_productions.item.has_local_declaration then
					Result.append ("%N%T%T%T");
					Result.append (rhs_productions.item.local_declaration);
				end;
				rhs_productions.forth;
			end; 
		end; -- local_declarations

	has_local_declarations: BOOLEAN is
			-- Does the Current construct require any local
			-- declarations for the production feature?
		do
			from
				rhs_productions.start
			until
				rhs_productions.off or Result
			loop
				if rhs_productions.item.has_local_declaration then
					Result := true
				else
					rhs_productions.forth
				end;
			end; 
		end; -- has_local_declarations

	potential_indirect_terminal: BOOLEAN is 
			-- If this construct is an aggregate with a right 
			-- hand side definition that constains only one 
			-- production,  that is not optional then this 
			-- production is potentially an indirect terminal 
			-- construct.
		do
			Result := false
		end; -- potential_indirect_terminal

feature {YOOCC,YOOCC_SEMANTIC_INFORMATION} -- Implementation

	is_root_construct: BOOLEAN;
			-- Is this construct the root?

	set_root_construct is
			-- Set this production to be a root construct.
		do
			is_root_construct := true
		end; -- set_root_construct

	set_root_export (a_class: STRING) is
			-- Set the export status for a root construct
			-- to a_class.
		require
			not_void_class_name: a_class /= Void
		do
			!! root_export.make (1);
			root_export.append(a_class);
			root_export.to_upper
		end; -- set_root_export

	root_export: STRING;
			-- Class that root_production will export to.

feature {NONE} -- Implementation


	resolve_duplicate_variable_names is
			-- Resolve duplicate variable names in rhs_productions.
		local
			local_variable_names: LINKED_LIST [STRING];
				-- Local variable names of rhs_productions.
			i: INTEGER;
			new_variable_name: STRING
		do
			from 
				!! local_variable_names.make;
				local_variable_names.compare_objects;
				rhs_productions.start
			until 
				rhs_productions.off
			loop
				if rhs_productions.item.has_local_declaration then
					if local_variable_names.has (rhs_productions.item.lower_string_value) then
					from
						i := 1
						new_variable_name := clone (rhs_productions.item.lower_string_value)
						new_variable_name.append ("_");
						new_variable_name.append (i.out);			
					until
						not local_variable_names.has (new_variable_name)
					loop
						i := i + 1
						new_variable_name.remove (new_variable_name.count);
						new_variable_name.append_integer (i);
					end
					rhs_productions.item.set_lower_string_value (new_variable_name);
					end;
					local_variable_names.force (rhs_productions.item.lower_string_value);
				end;
				rhs_productions.forth;
			end; 
		end; -- resolve_duplicate_variable_names 

end -- class NON_TERMINAL_INFO

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
