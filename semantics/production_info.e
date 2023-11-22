indexing
	description: "Production_info";
	authors: "Jon Avotins and Glenn Maughan";
	status: "See notice at end of class";
	copyright: "See notice at end of class";
	date: "$Date: 1995/08/28 00:54:25 $";
	revision: "$Revision: 1.10 $"
   
deferred class PRODUCTION_INFO
   
inherit
   
	SEMANTIC_INFORMATION

	EXCEPTIONS
   
feature -- Access
   
	production_name: STRING;
			-- Name of production in grammar.
		 
	production_type: STRING is
			-- Type of production in grammar.
		deferred
		end; -- production_type
   
feature -- Output
   
	output_files is
		do
			build_syntax_class;
			build_construct_class;
		end; -- output_files
   
feature -- Building
   
	build_syntax_class is
		local
			syntax_file: PLAIN_TEXT_FILE;
		do
			if processible_file (syntax_file_name) then
				!! syntax_file.make_open_read_append (syntax_file_name);
				io.putstring ("Building: ");
				io.putstring (syntax_file_name);
				io.new_line
				syntax_file.putstring (syntax_class);
				syntax_file.close;
			end; 
		end; -- build_syntax_class
   
	build_construct_class is
		local
			construct_file: PLAIN_TEXT_FILE;
		do
			if processible_file (construct_file_name) then
				!! construct_file.make_open_read_append (construct_file_name);
				io.putstring ("Building: ");
				io.putstring (construct_file_name);
				io.new_line;
				construct_file.putstring (construct_class);
				construct_file.close;
			end; 
		end; -- build_construct_class
   
feature -- Access
   
	construct_class: STRING is
			 -- Construct class for Current.
		do
			!! Result.make (1);
			Result.append (class_header (construct_class_name));
			Result.append (syntax_class_name);
			Result.append ("%N%TSEMANTIC_INFORMATION");
			Result.append ("%N%Ncreation%N%N%Tmake");
			Result.append ("%N%Nfeature {CONSTRUCT} -- semantics");
			Result.append (end_class (construct_class_name));
		end; -- construct_class
   
	syntax_class: STRING is
			-- Syntax class for Current.
		deferred
		end; -- syntax_class
		   
feature {NONE} -- Implementation
   
	syntax_class_declaration: STRING is
			-- The `Class_header' and `Inheritance' clause for 
			-- syntax classes.
		do
			!! Result.make (1);			
			Result.append (class_header (syntax_class_name));
			Result.append (production_type);
		end; -- syntax_class_declaration
   
	construct_name_feature: STRING is
		do
			!! Result.make (1);
			Result.append ("%N%N%Tconstruct_name: STRING is");
			Result.append ("%N%T%Tonce%N%T%T%TResult := %"");
			Result.append (production_name_formatted);
			Result.append ("%"%N%T%Tend; -- construct_name");
		end; -- construct_name_feature
 
	construct_class_name: STRING is
		do
			!! Result.make (1);
			Result.append (production_name);
			Result.to_upper;
		end; -- construct_class_name
 
	syntax_class_name: STRING is
		do
			!! Result.make (1);
			Result.append (construct_class_name);
			Result.prepend ("S_");
		end; -- syntax_class_name
   
feature {NONE} -- Output files 
   
	syntax_file_name: STRING is
		local
			s: STRING
		do
			!! Result.make (1);
			Result.append (info.destination_path)
			Result.append ("/syntax/")
			s := clone (syntax_class_name)
			s.to_lower
			Result.append (s);
			Result.append (".e");
		end; -- syntax_file_name
   
	construct_file_name: STRING is
		local
			s: STRING
		do
			!! Result.make (1);
			Result.append (info.destination_path)
			Result.append ("/constructs/")
			s := clone (construct_class_name)
			s.to_lower
			Result.append (s);
			Result.append (".e");
		end; -- construct_file_name
   
feature {YOOCC_SEMANTIC_INFORMATION} -- Implementation

	class_header (a_class_name: STRING): STRING is
		do
			!! Result.make (1);
			Result.append ("class ");
			Result.append (a_class_name);
			Result.append (" inherit%N%N%T");
		end; -- class_header
   
	end_class (a_class_name: STRING): STRING is
		do
			!! Result.make (1);
			Result.append (a_class_name);
			Result.to_upper;
			Result.prepend ("%N%Nend -- class ");
		end; -- end_class
   
	production_name_formatted: STRING is 
			-- The production name with an uppercase first letter
			-- and a lower case remainder.
		local
			uppercase_first: STRING;
		do		
			!! Result.make (1);
			Result.append (production_name);
			Result.to_lower;
			!! uppercase_first.make (1); 
			uppercase_first.copy (Result.substring (1,1));
			uppercase_first.to_upper;
			Result.remove (1);
			Result.prepend (uppercase_first);
		end; -- production_name_formatted
   
	processible_file (a_file_name: STRING): BOOLEAN is
			-- Can file_name be corrently processed?
		local
			a_file: PLAIN_TEXT_FILE;
		do
			!! a_file.make (a_file_name);
			if a_file.exists then
				io.putstring ("Warning: ");
				io.putstring (a_file_name);
				io.putstring (" exists already. Overwrite? (y/n) [y]: ");
				io.readchar
				if not io.last_character.is_equal ('%N') then
					if io.last_character.is_equal ('n') or io.last_character.is_equal ('N') then
						Result := False
					else
						a_file.delete
						Result := True
					end
					-- flush the input
					io.next_line
				end
			else
				Result := True
			end; 
		end; -- processible_file

feature {YOOCC_SEMANTIC_INFORMATION} 

	check_class_clashes is
		do
			check_class_clash (syntax_class_name);
			check_class_clash (construct_class_name);
		end; -- check_class_clashes

	check_class_clash (c_name: STRING) is
			-- Does 'c_name' clash with the processor, lexical,
			-- lexical constants, semantic, or processor
			-- semantic class names.
		require
			c_name_non_void: c_name /= Void
			c_name_meaningful: not c_name.empty
		do
			if info.root_class_name.is_equal (c_name) then
				put_error_and_die (c_name,"processor");
			end;
			if info.lex_constants_class_name.is_equal (c_name) then
				put_error_and_die (c_name,"lexical constants");
			end;
			if info.lex_class_name.is_equal (c_name) then
				put_error_and_die (c_name,"lexical");
			end;
			if info.semantic_class_name.is_equal (c_name) then
				put_error_and_die (c_name,"semantic");
			end;
			if info.processor_semantic_class_name.is_equal (c_name) then
				put_error_and_die (c_name,"processor semantic");
			end;
		end; -- check_class_clash

		put_error_and_die (p_name, s_name: STRING) is
				-- Put the clashe error and die for production
				-- name 'p_name' and system name 's_name'.
			require
				non_void: p_name /= Void and s_name /= Void
				meaningful: not p_name.empty and not s_name.empty
			do
				io.putstring ("%NError: Production ");
				io.putstring (p_name);
				io.putstring (" has class name clash with ");
				io.putstring (s_name);
				io.putstring (" class.%N");
				new_die (24);
			end; -- put_error_and_die 

end -- class PRODUCTION_INFO


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
--| Phone: +61-3-99032787 Fax: +61-3-99032745
--| Email: <yoocc@insect.sd.monash.edu.au>
--|----------------------------------------------------------------

