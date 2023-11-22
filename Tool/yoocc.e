indexing
	description: "Yes an Object-Oriented Compiler Compiler (YOOCC)"
	authors: "Jon Avotins and Glenn Maughan"
	status: "See notice at end of class";
	copyright: "See notice at end of class";
	date: "$Date: 1995/08/30 07:20:57 $";
	revision: "$Revision: 1.11 $"
   
class YOOCC
   
inherit
   
	ARGUMENTS
		rename
			command_line as arguments_command_line
		undefine
			copy, consistent, is_equal, setup
		end
   
	EXECUTION_ENVIRONMENT
		undefine
			copy, consistent, is_equal, setup
		end
   
	YOOCC_LEX	
		redefine
			store_analyzer, retrieve_analyzer
		end
        
creation
   
	make
   
feature -- Intitialization
   
	make is
		do  
			io.putstring (Separator_line_message);
			io.putstring (Copyright_message);
			get_arguments
			if valid_arguments then
				setup_analyzer;
				if valid_processor_name (processor_name) then
					parse_grammar_file;
					if root_line.parsed then
						-- If the last token read was not EOF then
						-- there was a token that was read that was
						-- not supposed to be in the grammar. 
						if root_line.document.end_of_document then  
							root_line.info.set_processor_name (processor_name);
							root_line.info.set_processor_path (destination_directory_path)
							apply_semantics;
							display_finish_message;
						else
							io.putstring ("%NSyntax error (");
							io.putint (root_line.document.token.line_number);
							io.putstring (",");
							io.putint (root_line.document.token.column_number);
							io.putstring ("): End of document expected.%N");
						end
					else
							io.putstring ("%NSyntax error (");
							io.putint (root_line.document.token.line_number);
							io.putstring (",");
							io.putint (root_line.document.token.column_number);
							io.putstring (").%N");
					end;
				end;
			else
				display_usage
			end
			io.putstring (Separator_line_message);
		end; -- make
   
feature -- Access
   
	root_line: PRODUCTION_LIST;
			-- Root line for YOOCC.
   
	Analyzer_file_name: STRING is "yoocc_analyzer";
			-- The file name where the analyzer if
			-- existent resides.

feature {NONE} -- Implementation
   
	Copyright_message: STRING is "YOOCC (Version 1.0).%T(C) Jon Avotins and Glenn Maughan 1995.%N%T%T%TMonash University, Australia%N%N";

	Separator_line_message: STRING is "---------------------------------------------------------------------------%N";

	valid_arguments: BOOLEAN;
			-- Are the command line arguments valid?
   
	grammar_file_name: STRING;
			-- Grammar file to parse as supplied on command line.

	destination_directory_path: STRING;
			-- Destination directory path as supplied on command 
			-- line.

	processor_name: STRING;
			-- Processor name as supplied on command line.

	Grammar_option: STRING is "g";
			-- Command line option for grammar file.

	Directory_option: STRING is "d";
			-- Command line option for destination directory.

	Case_sensitive_keywords_option: STRING is "k";
			-- Command line option for case sensitive keywords.

	Case_sensitive_tools_option: STRING is "t";
			-- Command line option for case sensitive tools.

	Processor_name_option: STRING is "p";
			-- Command line option for processor name.	

	get_arguments is
			-- Get command line arguments and store in attributes.
		local
			file: RAW_FILE;
			directory: DIRECTORY
		do    
			set_option_sign ('-');
			valid_arguments := True;
			-- Check for the grammar file option.
			processor_name := separate_word_option_value (Processor_name_option);
			if processor_name = Void then
				valid_arguments := False
			else
				grammar_file_name := separate_word_option_value (Grammar_option); 
				if grammar_file_name = Void then
					valid_arguments := False
				else
					-- Check that the grammar file name supplied on
					-- command line exists.
					!! file.make (grammar_file_name);
					if not file.exists then 
						valid_arguments := False;
						io.putstring ("%NError: Grammar file does not exist.%N%N")
					else
						-- Check for the optional destination 
						-- directory option.
						destination_directory_path := separate_word_option_value (Directory_option);
						if destination_directory_path = Void then
							destination_directory_path := clone (current_working_directory)
						else  
							!! directory.make (destination_directory_path)
							if not valid_directory (destination_directory_path) then 
								io.putstring ("%NError: Destination directory does not exist.%N%N")
								valid_arguments := False
							end
						end
					end;
				end;
			end;
			if valid_arguments then
				build_directories (destination_directory_path);
			end;
		end; -- get_arguments

	Lexical_path_suffix: STRING is "/lexical";

	Constructs_path_suffix: STRING is "/constructs";

	Semantics_path_suffix: STRING is "/semantics";

	Syntax_path_suffix: STRING is "/syntax";
   
	build_directories (destination_path: STRING) is
			-- Build the cluster directories in path
			-- `destination_path'.
		require
			path_exists: valid_directory (destination_path)
		local
			new_dir: DIRECTORY;
			lexical_path, constructs_path, semantics_path,
			syntax_path: STRING;
			a_file: RAW_FILE;
		do
			lexical_path := clone (destination_path);
			lexical_path.append (Lexical_path_suffix);
			if not valid_directory (lexical_path) then
				!! new_dir.make (lexical_path);
				new_dir.create
			else
				!! a_file.make (lexical_path);
				if not a_file.is_directory then
					put_dir_is_file_error (lexical_path)
				end;
			end;
			constructs_path := clone (destination_path);
			constructs_path.append (Constructs_path_suffix);
			if not valid_directory (constructs_path) then 
				!! new_dir.make (constructs_path);
				new_dir.create
			else
				!! a_file.make (constructs_path);
				if not a_file.is_directory then
					put_dir_is_file_error (constructs_path)
				end;
			end;
			semantics_path := clone (destination_path);
			semantics_path.append (Semantics_path_suffix);
			if not valid_directory (semantics_path) then 
				!! new_dir.make (semantics_path);
				new_dir.create;
			else
				!! a_file.make (semantics_path);
				if not a_file.is_directory then
					put_dir_is_file_error (semantics_path)
				end;
			end
			syntax_path := clone (destination_path);
			syntax_path.append (Syntax_path_suffix);
			if not valid_directory (syntax_path) then 
				!! new_dir.make (syntax_path);
				new_dir.create;
			else
				!! a_file.make (syntax_path);
				if not a_file.is_directory then
					put_dir_is_file_error (syntax_path)
				end;
			end;
		end; -- build_directories
   
	display_usage is
			-- Display the usage message on stdout.
		do
			io.putstring ("SYNOPSIS%N");
			io.putstring ("%Tyoocc -p<identifier> -g<file> [-d<directory>] [-k] [-t]");
			io.putstring ("%N%NOPTIONS");
			io.putstring ("%N%TThe following options apply to yoocc:");
			io.putstring ("%N%T-p%TProcessor name.");
			io.putstring ("%N%T-g%TGrammar file to parse.");
			io.putstring ("%N%T-d%TDestination directory for generated processor.");
			io.putstring ("%N%T-k%TCase sensitive keywords in lexical analyzer.");
			io.putstring ("%N%T-t%TCase sensitive tools in lexical analyzer.");
			io.putstring ("%N%NNOTE:%TIf the destination directory is not supplied, the processor will %N");
			io.putstring ("%Tbe generated in the current working directory.%N");
		end; -- display_usage
   
	display_finish_message is
			-- Display the notes on parsing.
		local
			env_var_value: STRING;
				-- Value of processor environment variable.
			env_var: STRING;
				-- The environment variable that needs to be
				-- set.
		do
			env_var := clone (processor_name);
			env_var.to_upper;
			io.putstring ("%NNOW%N");
			io.putstring ("%NCopy the files %"global_list.e%" and %"global_optionals.e%"%N");
			io.putstring ("from %DYOOCC/global_files to directory %D");
			io.putstring (env_var);
			io.putstring ("/construct.%N");
			io.putstring ("%NCopy the files %"s_global_list.e%" and %"s_global_optionals.e%"%N");
			io.putstring ("from %DYOOCC/global_files to directory %D");
			io.putstring (env_var);
			io.putstring ("/syntax.%N");
			env_var_value := clone (get (env_var));
			if env_var_value = Void then
				io.putstring ("%NEnvironment variable %D");
				io.putstring (env_var);
				io.putstring (" currently not set.%N");
				io.putstring ("Needs to be set to: ");
				io.putstring (destination_directory_path);
				io.new_line;
			else	
				if not (env_var_value.is_equal (destination_directory_path)) then
					io.putstring ("%NAlthough environment variable %D");
					io.putstring (env_var);
					io.putstring (" is currently set to:%N");
					io.putstring (env_var_value);
					io.putstring ("%NIt should be set to: %N");
					io.putstring (destination_directory_path);
					io.new_line;
				end;
			end;
			io.putstring ("%NYou should now edit the lexical analyzer for this system and%N");
			io.putstring ("add definitions for each terminal token type.%N");
			io.putstring ("%NYou may need to add definitions for global %Noptionals in the ");
			io.putstring ("%"global_list.e%" file.%N");
			io.putstring ("%NIt would be a good idea to check the %"Ace%" file before compiling also.%N");
			io.putstring ("Especially to ensure that the extended_parse and patterns clusters%N");
			io.putstring ("are set to the correct paths.%N");
		end; -- display_finish_message

feature {NONE} -- Implementation

	store_analyzer (file_name: STRING) is
			-- Store `analyzer' in file named `file_name'.
		require else
			initialized: initialized
		local
			store_file: RAW_FILE
		do
			if analyzer = Void then
				!! analyzer.make
			end;
			!! store_file.make_open_write (file_name);
			analyzer.basic_store (store_file);
			store_file.close;
		end; -- store_analyzer
   
	retrieve_analyzer (file_name: STRING) is
			--  Retrieve `analyzer' from file named `file_name'.
		local
			retrieved_file: RAW_FILE
		do
			if analyzer = Void then
				!! analyzer.make
			end;
			!! retrieved_file.make_open_read (file_name);
			analyzer ?= analyzer.retrieved (retrieved_file);
			retrieved_file.close;
		end; -- store_analyzer_feature
   
	setup_analyzer is
			-- Build the lexical analyzer.
		local
			analyzer_file: RAW_FILE;
		do
			!! root_line.make;
			!! analyzer_file.make (Analyzer_file_name);
			if analyzer_file.exists then
				io.putstring ("Retrieving lexical analyzer ... ");
				io.output.flush;
				retrieve_analyzer (Analyzer_file_name);
				root_line.document.set_lexical (analyzer);
			else
				io.putstring ("Building lexical analyzer ... ");
				io.output.flush;
				build (root_line.document);
				-- The next line has been commented out as 
				-- there was a bug in the Eiffel 3 code as at
				-- 3/1995.
				-- store_analyzer (Analyzer_file_name);
			end;
			io.putstring ("Done.%N");
		end -- setup_analyzer
   
	parse_grammar_file is
			-- Perform the parsing process on the sdf file.
		do 
			io.putstring ("Parsing grammar in file: ");
			io.putstring (grammar_file_name);
			io.putstring (" ... ");
			io.output.flush;
			root_line.document.set_input_file (grammar_file_name);
			root_line.document.get_token;
			root_line.parse;
			if root_line.parsed then 
				io.putstring ("Done.")
			end;
			io.new_line;
		end; -- parse_grammar_file

	apply_semantics is
			-- Apply the semantics to the parse tree.
		do
			io.putstring ("Applying semantics to parse tree ... ");
			io.output.flush;
			if has_word_option (Case_sensitive_keywords_option) > 0 then
				root_line.info.set_keywords_case_sensitive
			end;
			if has_word_option (Case_sensitive_tools_option) > 0 then
				root_line.info.set_tools_case_sensitive
			end;
 			root_line.semantics;
			io.putstring ("%NFramework for processor generated.%N");
		end; -- apply_semantics

feature {NONE} -- Implementation
	
	Ace_keywords: ARRAY [STRING] is
			-- Keywords that belong to the Assembly of Classes
			-- in Eiffel grammar.
		once	
			 Result := <<"end","system","root","cluster","use",
			"include","exclude","adapt", "ignore","rename","as",
			"default","option","collect","assertion","debug",
			"optimize","trace","yes","no","all","require","ensure",
			"invariant","loop","check","external","eiffel","ada",
			"pascal","fortran","c","object","make","generate",
			"visible","creation","export">>
			Result.compare_objects
		end; -- Ace_keywords

	valid_processor_name (pn: STRING): BOOLEAN is
			-- The processor name parsed on the command line must be
			-- an Identifier which must not be an Eiffel or Ace
			-- grammar keyword.
		require
			pn_non_void: pn /= Void
			pn_meaningful: not pn.empty
		local
			lower_processor_name: STRING;
				-- Lower case processor name used to check
				-- whether processor name is a keyword
				-- of the Ace of Eiffel grammars.
			identifier_terminal: IDENTIFIER;
				-- Used to check whether identifier value
				-- is an Eiffel keyword or not.
		do
			lower_processor_name := clone (pn);
			lower_processor_name.to_lower;
			root_line.document.set_input_string (lower_processor_name);
			root_line.document.get_token;
			if root_line.document.token.type /= Identifier then 
				io.putstring ("%NError: Processor name must be an Identifier.");
			else
				!! identifier_terminal.make;
				if identifier_terminal.Eiffel_keywords.has (lower_processor_name) then
					io.putstring ("%NError: Processor name must not be a keyword of Eiffel grammar.%N%N");
				else
					if Ace_keywords.has (lower_processor_name) then
						io.putstring ("%NError: Processor name must not be a keyword of Ace grammar.%N%N");
					else			
						Result := True
					end;
				end;

			end;
		end; -- valid_processor_name

	valid_directory (dn: STRING): BOOLEAN is
			-- Does directory dn exist?
		local
			a_directory: DIRECTORY
		do
			!! a_directory.make (dn);
			Result := a_directory.exists; 
		end; -- valid_directory

	put_dir_is_file_error (a_path: STRING) is
		require
			a_path_non_void: a_path /= Void
			a_path_meaningful: not a_path.empty
		do
			io.putstring ("%NError: Presumed directory %"");
			io.putstring (a_path);
			io.putstring ("%" is a file.");
			io.putstring ("%N Files cannot be written to this path.%N");
			valid_arguments := False
		end; -- put_dir_is_file_error

	valid_file (a_file_name: STRING): BOOLEAN is
			-- Is a_file_name exist?
		require
			a_file_name /= Void
		local
			a_file: RAW_FILE
		do
			!! a_file.make (a_file_name);
			Result := a_file.exists and not a_file.is_directory and (not (a_file_name.count = 0))
		end; -- valid_file

end -- class YOOCC

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
