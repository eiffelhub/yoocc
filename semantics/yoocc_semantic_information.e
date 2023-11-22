indexing
	description: "Semantic information for YOOCC";
	authors: "Jon Avotins and Glenn Maughan";
	status: "See notice at end of class";
	copyright: "See notice at end of class";
	date: "$Date: 1995/08/28 00:54:25 $";
	revision: "$Revision: 1.10 $"
   
class YOOCC_SEMANTIC_INFORMATION 
   
creation
   
	make
   
feature -- Initialization
   
	make is
		do
			!! non_terminal_list.make (1);
			!! indirect_terminal_list.make (1);
			!! direct_terminal_list.make (1);
			!! productions_defined.make;
			productions_defined.compare_objects;
			!! keyword_list.make;
			keyword_list.compare_objects;
			!! optional_repetition_construct_list.make;
			optional_repetition_construct_list.compare_objects;
		end; -- make
   
feature -- Access

	tools_case_sensitive: BOOLEAN;
		-- Is letter case significant in tools comprising the 
		-- lexical analyzer for generated processor?

	keywords_case_sensitive: BOOLEAN;
		-- Is letter case significant in keywords comprising the 
		-- lexical analyzer for generated processor?
    
	set_processor_path (new_directory: STRING) is
			-- Set working_directory to `new_directory'.
		require
			directory_non_void: new_directory /= Void
			directory_meaningful: not new_directory.empty
		do
			destination_path := clone (new_directory)
		end -- set_processor_path
   
	working_production: NON_TERMINAL_INFO;
			-- Production semantics currently working on.
   
	root_construct: NON_TERMINAL_INFO is
			-- Root construct for processor being generated.
		require
			root_exists: non_terminal_list.has (productions_defined.first);
		do
			Result := non_terminal_list.item (productions_defined.first)
			Result.set_root_construct;
			Result.set_root_export (processor_name);
		ensure
			Result /= Void
		end; -- root_construct
   
	processor_name: STRING;
			-- Name of processor being generated.
   
	productions_defined: LINKED_LIST [STRING];
			-- Productions defined in abstract_syntax. 
   
	non_terminal_list: HASH_TABLE [NON_TERMINAL_INFO,STRING];
			-- Productions that have had semantics applied 
			-- and found to be non-terminal productions.
   
	direct_terminal_list: HASH_TABLE [DIRECT_TERMINAL_INFO,STRING];
			-- Those productions which appear as part of a 
			-- productions right hand side and are not defined.
   
	indirect_terminal_list: HASH_TABLE [INDIRECT_TERMINAL_INFO,STRING]
			-- Those productions that are indirect terminals
			-- or productions that have one right hand side 
			-- construct which is a terminal.  If a non-terminal
			-- production is defined solely as an aggregation of
			-- a single non optional terminal item then that 
			-- production is viewed as an indirect terminal.
   
	keyword_list: LINKED_LIST [STRING]; 
			-- All keywords that are part of the rhs_productions 
			-- of non-terminals list productions rhs_productions.  
			-- All separator_strings are also part of this list.
   
feature -- Output
   
	process is
			-- Process the productions specified by the
			-- abstract syntax supplied by the user.
		do
			resolve_optional_repetition_construct; 
			check_class_clashes;
			build_root_class;
			build_semantic_file;
			build_processor_semantic_file;
			build_ace_file;
			build_lex_constants_file;
			build_lex_file;
			process_list (non_terminal_list);
			process_list (direct_terminal_list);
			process_list (indirect_terminal_list);
		end; -- process_classes
   
feature -- Status Setting
   
	set_working_production (a_nt_production: NON_TERMINAL_INFO) is
		require
			a_nt_non_void: a_nt_production /= Void
		do
			working_production := a_nt_production
		end; -- set_working_production

	set_tools_case_sensitive is
			-- Set letter case significant for tools comprising the 
			-- lexical analyzer for generated processor.
		do
			tools_case_sensitive := True
		end; -- set_tools_case_sensitive

	set_keywords_case_sensitive is
			-- Set letter case significant for keywords comprising 
			-- the lexical analyzer for generated processor.
		do
			keywords_case_sensitive := True
		end; -- set_keywords_case_sensitive

feature {PRODUCTION_INFO} -- Implementation

	lex_constants_class_name: STRING is
		do
			!! Result.make (1);
			Result.append (processor_name);
			Result.append ("_");
			Result.append ("lex_constants");
			Result.to_upper;
		end; -- lex_constants_class_name
   
	destination_path: STRING
			-- The path to store generated files in.
   
	lex_constants_file_name: STRING is
		local
			s: STRING
		do
			!! Result.make (1);
			Result.append (destination_path)
			Result.append ("/lexical/")
			s := clone (lex_constants_class_name)
			s.to_lower
			Result.append (s);
			Result.append (".e");
		end; -- lex_constants_file_name
   
	lex_constants_starter: INTEGER is 1000;
			-- Constant value for direct_terminals to start off
			-- at.
   
	build_lex_constants_file is
		local
			lex_constants_file: PLAIN_TEXT_FILE;
		do
			if direct_terminal_list.count /= 0 and root_construct.processible_file (lex_constants_file_name) then
				io.putstring ("Building: ");
				io.putstring (lex_constants_file_name);
				io.new_line
				!! lex_constants_file.make_open_read_append (lex_constants_file_name);
				lex_constants_file.putstring (lex_constants_class);
				lex_constants_file.close;
			end; 
		end; -- build_lex_constants_file
   
	lex_constants_class: STRING is
		local
			i: INTEGER
		do
			!! Result.make (1);
			from
				i := 1
				Result.append ("class ");
				Result.append (lex_constants_class_name);
				Result.append ("%N%Nfeature%N");
			until
				i > direct_terminal_list.current_keys.count
			loop
				Result.append ("%N%T");
				Result.append (direct_terminal_list.item (direct_terminal_list.current_keys.item(i)).production_name_formatted);
				Result.append (": INTEGER is ");
				Result.append_integer (lex_constants_starter + (i - 1));
				Result.append (";");
				i := i + 1;
			end; 
			if (not keyword_list.empty) then
				Result.append ("%N%T");
				Result.append ("Special: INTEGER is ")
				Result.append_integer (lex_constants_starter + (i - 1));
				Result.append (";");
			end; 
			Result.append (root_construct.end_class (lex_constants_class_name));
		end; -- lex_constants_class
       
	process_list (ht: HASH_TABLE [PRODUCTION_INFO,STRING]) is
		local
			i: INTEGER; 
		do
			from
				i := 1
			until
				i > ht.current_keys.count
			loop
				ht.item (ht.current_keys.item(i)).output_files;    
				i := i + 1;
			end; 
		end; -- process_list
 
	build_lex_file is
			-- Build the lexical file for processor being generated.
		local
			lex_file: PLAIN_TEXT_FILE;
		do
			if root_construct.processible_file (lex_file_name) then
				io.putstring ("Building: ");
				io.putstring (lex_file_name);
				io.new_line
				!! lex_file.make_open_read_append (lex_file_name);
				lex_file.putstring (lex_class);
				lex_file.close;
			end; 
		end; -- build_lex_constants_file
   
	lex_class: STRING is
		do
			!! Result.make (1);
			Result.append (root_construct.class_header(lex_class_name));
			Result.append ("%N%TL_INTERFACE;%N%T");
			Result.append (lex_constants_class_name);
			Result.append ("%N%Tundefine");
			Result.append ("%N%T%Tconsistent, copy, is_equal, setup%N%Tend");
			Result.append ("%N%Nfeature {NONE}");
			Result.append (obtain_analyzer_feature);
			Result.append (build_expressions_feature);
			if keyword_list.count > 0 then 
				Result.append (build_tools_feature);
				Result.append (build_keywords_feature);
			end
			Result.append (root_construct.end_class (lex_class_name));
		end; -- lex_class
   
	lex_file_name: STRING is
		local
			s: STRING
		do
			!! Result.make (1);
			Result.append (destination_path)
			Result.append ("/lexical/")
			s := clone (lex_class_name)
			s.to_lower
			Result.append (s);
			Result.append (".e");
		end; -- lex_file_name
   
	lex_class_name: STRING is
		do
			!! Result.make (1);
			Result.append (processor_name);
			Result.append ("_");
			Result.append ("lex");
			Result.to_upper;
		end; -- lex_class_name
  
	obtain_analyzer_feature: STRING is
			-- The obtain analyzer feature of the lexical class
			-- for the processor being generated.
		do
			!! Result.make (1);
			Result.append ("%N%N%Tobtain_analyzer is");
			Result.append ("%N%T%T%T-- Create lexical analyzer for the ");
			Result.append (processor_name);
			Result.append (".%N%T%Tdo");
			if tools_case_sensitive then
				Result.append ("%N%T%T%Tdistinguish_case;");
			else
				Result.append ("%N%T%T%Tignore_case;");
			end;
			if keywords_case_sensitive then
				Result.append ("%N%T%T%Tkeywords_distinguish_case;");
			else
				Result.append ("%N%T%T%Tkeywords_ignore_case;");
			end;
			Result.append ("%N%T%T%Tbuild_expressions;");
			Result.append ("%N%T%T%Tbuild_tools;");
			Result.append ("%N%T%T%Tbuild_keywords;");
			Result.append ("%N%T%Tend; -- obtain_analyzer");
		end; -- obtain_analyzer_feature
   
	build_expressions_feature: STRING is
			-- The build expressions feature of the lexical class
			-- for the processor being generated.
		local
			i: INTEGER;
		do
			!! Result.make (1);
			Result.append ("%N%N%Tbuild_expressions is");
			Result.append ("%N%T%T%T-- Define regular expressions");
			Result.append ("%N%T%T%T-- for the ");
			Result.append (processor_name);
			Result.append (" processor.%N%T%Tdo");
			from
				i := 1
			until    
				i > direct_terminal_list.count
			loop
				Result.append ("%N%T%T%T");
				Result.append (put_expression_call_prefix);
				Result.append (put_expression_call_suffix (direct_terminal_list.item (direct_terminal_list.current_keys.item (i)).production_name_formatted));
				i := i + 1;
			end; 
			Result.append ("%N%T%Tend; -- build_expressions%N");
		end; -- build_expressions_feature
 
	build_tools_feature: STRING is
		local
			counter: INTEGER;
		do
			!! Result.make (50);
			Result.append ("%N%N%Tbuild_tools is%N");
			Result.append ("%T%T%T-- Build special keyword.%N"); 
			Result.append ("%T%Tlocal%N%T");
			Result.append ("%T%Tfirst_tool, last_tool, the_special_tool: INTEGER%N")
			Result.append ("%T%Tdo%N");
			from
				keyword_list.start
			until 
				keyword_list.exhausted
			loop
				Result.append ("%T%T%Tset_word (");
				Result.append (keyword_list.item);
				Result.append (")%N"); 
				if keyword_list.isfirst then 
					Result.append ("%T%T%Tfirst_tool := last_created_tool;%N");
				elseif keyword_list.islast then
					Result.append ("%T%T%Tlast_tool := last_created_tool;%N");
				end;
				keyword_list.forth
			end        
			Result.append ("%T%T%Tunion (first_tool,last_tool)%N");
			Result.append ("%T%T%Tthe_special_tool := last_created_tool;%N");
			Result.append ("%T%T%Tselect_tool (the_special_tool);%N");
			Result.append ("%T%T%Tassociate (the_special_tool,Special);%N");
			Result.append ("%T%Tend; -- build_tools%N%N");
		end; -- build_features_tool
   
   
	put_expression_call_prefix: STRING is
		do
			!! Result.make (1);
			Result.append ("put_expression (%" ");
		end; -- put_expression_call_prefix 
	   
	put_expression_call_suffix (t_name: STRING): STRING is
		do
			!! Result.make (1);
			Result.append ("%", ");
			Result.append (t_name);
			Result.append (", %"");
			Result.append (t_name);
			Result.append ("%");");
		end; -- put_expression_call_suffix
  
	build_keywords_feature: STRING is
		do
			!! Result.make (1);
			Result.append ("%N%N%Tbuild_keywords is");
			Result.append ("%N%T%T%T-- Define keywords (special symbols) for the");
			Result.append (processor_name);
			Result.append ("processor.%N%T%Tdo");
			from
				keyword_list.start
			until
				keyword_list.off
			loop
				Result.append ("%N%T%T%Tput_keyword (");
				Result.append (keyword_list.item);
				Result.append (", Special);");
				keyword_list.forth;
			end; 
			Result.append ("%N%T%Tend -- build_keywords");
		end; -- build_keywords_feature
   
	build_root_class is
		local
			root_class_file: PLAIN_TEXT_FILE;
		do
			if root_construct.processible_file (root_file_name) then
				io.putstring ("Building: ");
				io.putstring (root_file_name);
				io.new_line
				!! root_class_file.make_open_read_append (root_file_name);
				root_class_file.putstring (root_class);
				root_class_file.close;
			end; 
		end; -- build_root_class
   
	root_file_name: STRING is
		local
			s: STRING
		do
			Result := clone (destination_path);
			Result.append ("/")
			s := clone (root_class_name)
			s.to_lower
			Result.append (s);
			Result.append (".e"); 
		end; -- root_file_name
   
	root_class_name: STRING is
		do
			!! Result.make (1);
			Result.append (processor_name);
			Result.to_upper; 
		end; -- root_class_name
   
	root_class: STRING is
		require
			not_root_void: root_construct /= Void
		local
			i: INTEGER
		do
			!! Result.make (1);
			Result.append (root_construct.class_header (root_class_name));
			Result.append ("ARGUMENTS%N%T%Tundefine");
			Result.append ("%N%T%T%Tcopy, consistent, is_equal, setup%N%T%Tend%N%N%T");
			Result.append (lex_class_name);
			Result.append ("%N%T%Tredefine%N%T%T%Tstore_analyzer,%N%T%T%Tretrieve_analyzer%N%T%Tend");
			Result.append ("%N%Ncreation%N%N%Tmake%N%N");
			Result.append ("feature%N%N%Troot_line: ");
			Result.append (root_construct.construct_class_name);
			Result.append (";%N%N%Tanalyzer_file_name: STRING is %"");
			Result.append (analyzer_file_name);
			Result.append ("%";");
			Result.append (root_make_feature);
			Result.append (Separator_line_message);
			Result.append (test_left_recursion_feature);
			Result.append (store_analyzer_feature);
			Result.append (retrieve_analyzer_feature);
			Result.append (root_construct.end_class (root_class_name));
		end; -- root_class
	 
	analyzer_file_name: STRING is
		local
			s: STRING
		do
			!! Result.make (1);
			Result.append (destination_path)
			Result.append ("/lexical/")
			s := clone (processor_name)
			s.to_lower
			Result.append (s);
			Result.append ("_analyzer"); 
		end; -- analyzer_file_name
   
	root_make_feature: STRING is
		do
			!! Result.make (1);
			Result.append ("%N%N%Tmake is%N%T%Tlocal");
			Result.append ("%N%T%T%Ttext_name: STRING;");
			Result.append ("%N%T%T%Tanalyzer_file: RAW_FILE;");
			Result.append ("%N%T%T%Tanalyzer_needs_storing: BOOLEAN;");
			Result.append ("%N%T%T%Ttext_file: PLAIN_TEXT_FILE;");
			Result.append ("%N%T%T%Targument_position: INTEGER");
			Result.append ("%N%T%Tdo");
			Result.append ("%N%T%T%Tif argument_count = 0 then");
			Result.append ("%N%T%T%T%Tio.putstring (%"Usage: ");
			Result.append (processor_name);
			Result.append (" file_name%%N%");");
			Result.append ("%N%T%T%Telse%N%T%T%T%T!! root_line.make;");
			Result.append ("%N%T%T%T%Tio.putstring (Separator_line_message);");
			Result.append ("%N%T%T%T%Tio.putstring (%"");
			Result.append (root_class_name);
			Result.append ("%");");
			Result.append ("%N%T%T%T%Tio.putstring (%" (Version 1.0).%T (C)%");")
			Result.append ("%N%T%T%T%T!! analyzer_file.make (analyzer_file_name);");
			Result.append ("%N%T%T%T%Tif analyzer_file.exists then");
			Result.append ("%N%T%T%T%T%Tio.putstring (%"%%NRetrieving analyzer . . .%");");
			Result.append ("%N%T%T%T%T%Tretrieve_analyzer (analyzer_file_name);");
			Result.append ("%N%T%T%T%T%Troot_line.document.set_lexical (analyzer);");
			Result.append ("%N%T%T%T%T%Tio.putstring (%"DONE%");");
			Result.append ("%N%T%T%T%Telse%N%T%T%T%T%Tio.putstring "); 
			Result.append ("(%"%%NBuilding analyzer ... %");");
			Result.append ("%N%T%T%T%T%Tbuild (root_line.document);");
			Result.append ("%N%T%T%T%T%Tanalyzer_needs_storing := true");
			Result.append ("%N%T%T%T%T%Tio.putstring (%"DONE%");");
			Result.append ("%N%T%T%T%Tend;%N%T%T%T%Ttext_name := argument (1);");
			Result.append ("%N%T%T%T%T!! text_file.make (text_name);");
			Result.append ("%N%T%T%T%Tif (not text_file.exists) then");
			Result.append ("%N%T%T%T%T%Tio.putstring (text_name);");
			Result.append ("%N%T%T%T%T%Tio.putstring (%": No such file or directory%%N%");");
			Result.append ("%N%T%T%T%Telse%N%T%T%T%T%Troot_line.document.set_input_file (text_name);");
			Result.append ("%N%T%T%T%T%Troot_line.document.set_input_file (text_name);");
			Result.append ("%N%T%T%T%T%Troot_line.document.get_token;");
			Result.append ("%N%T%T%T%T%Tio.putstring (%"%%NParsing document in file: %")");
			Result.append ("%N%T%T%T%T%Tio.putstring (text_name);");
			Result.append ("%N%T%T%T%T%Tio.putstring (%" ... %");");
			Result.append ("%N%T%T%T%T%Troot_line.parse;");
			Result.append ("%N%T%T%T%T%Tif root_line.parsed then");
			Result.append ("%N%T%T%T%T%T%Tio.putstring (%"DONE%");");
			Result.append ("%N%T%T%T%T%T%Tio.putstring (%"%%NParse tree ... %%N%");");
			Result.append ("%N%T%T%T%T%T%Troot_line.display (io.output);");
			Result.append ("%N%T%T%T%T%T%Tio.putstring (%"%%NApplying semantics ... %");");
			Result.append ("%N%T%T%T%T%T%Troot_line.semantics;");
			Result.append ("%N%T%T%T%T%T%Tio.putstring (%"DONE%%N%");");
			Result.append ("%N%T%T%T%T%Telse");
			Result.append ("%N%T%T%T%T%T%Tio.putstring (%"%%NSyntax error with document%");");
			Result.append ("%N%T%T%T%T%Tend;");
			Result.append ("%N%T%T%T%Tend%N%T%T%T%Tif analyzer_needs_storing then");    
			Result.append ("%N%T%T%T%Tio.putstring (%"%%NStoring analyzer ... %");");
			Result.append ("%N%T%T%T%T-- store_analyzer (analyzer_file_name);");
			Result.append ("%N%T%T%T%Tio.putstring (%"DONE%%N%");");
			Result.append ("%N%T%T%T%Tio.putstring (Separator_line_message);");
			Result.append ("%N%T%T%T%Tend;%N%T%T%T%Tio.new_line;");
			Result.append ("%N%T%T%Tend;%N%T%Tend; -- make");
		end; -- root_make_feature


	separator_line_message: STRING is
		do
			!! Result.make (1);
			Result.append ("%N%TSeparator_line_message: STRING is %"---------------------------------------------------------------------------%%N%";");
		end; -- separator_line_message

	test_left_recursion_feature: STRING is
		do
			!! Result.make (1);
			Result.append ("%N%N%Ttest_left_recursion is");
			Result.append ("%N%T%T%T-- Test root_line for left recursion.");
			Result.append ("%N%T%Tlocal");
			Result.append ("%N%T%T%Tt_b: BOOLEAN;%N%T%Tdo");
			Result.append ("%N%T%T%Troot_line.print_mode.put (true);")
			Result.append ("%N%T%T%Troot_line.expand_all;");
			Result.append ("%N%T%T%Tt_b := not root_line.left_recursion;");
			Result.append ("%N%T%T%Troot_line.check_recursion;");
			Result.append ("%N%T%T%Tif not root_line.left_recursion.item then");
			Result.append ("%N%T%T%T%Tio.putstring (%"No left recursion detected%%N%");");
			Result.append ("%N%N%T%T%Tend;%N%T%Tend; -- test_left_recursion");
		end; -- test_left_recursion_feature
   
	store_analyzer_feature: STRING is
		do
			!! Result.make (1);
			Result.append ("%N%N%Tstore_analyzer (file_name: STRING) is");
			Result.append ("%N%T%T%T-- Store `analyzer' in file named `file_name'.");
			Result.append ("%N%T%Trequire else%N%T%T%Tinitialized: initialized");
			Result.append ("%N%T%Tlocal%N%T%T%Tstore_file: RAW_FILE");
			Result.append ("%N%T%Tdo%N%T%T%Tif analyzer = Void then");
			Result.append ("%N%T%T%T%T!! analyzer.make%N%T%T%Tend;");
			Result.append ("%N%T%T%T!! store_file.make_open_write (file_name);");
			Result.append ("%N%T%T%Tanalyzer.basic_store (store_file);");
			Result.append ("%N%T%T%Tstore_file.close;");
			Result.append ("%N%T%Tend; -- store_analyzer");
	end; -- store_analyzer_feature
   
	retrieve_analyzer_feature: STRING is
		do
			!! Result.make (1);
			Result.append ("%N%N%Tretrieve_analyzer (file_name: STRING) is");
			Result.append ("%N%T%T%T--  Retrieve `analyzer' from file named `file_name'.");
			Result.append ("%N%T%Tlocal%N%T%T%Tretrieved_file: RAW_FILE");
			Result.append ("%N%T%Tdo%N%T%T%Tif analyzer = Void then");
			Result.append ("%N%T%T%T%T!! analyzer.make%N%T%T%Tend;");
			Result.append ("%N%T%T%T!! retrieved_file.make_open_read (file_name);");
			Result.append ("%N%T%T%Tanalyzer ?= analyzer.retrieved (retrieved_file);");
			Result.append ("%N%T%T%Tretrieved_file.close;");
			Result.append ("%N%T%Tend; -- store_analyzer_feature");
		end; -- retrieve_analyzer_feature
   
	semantic_class_name: STRING is
		do
			!! Result.make (1);
			Result.append ("semantic_information");
			Result.to_upper;
		end -- semantic_info_class_name
   
	semantic_file_name: STRING is
		local
			s: STRING
		do
			!! Result.make (1);
			Result.append (destination_path)
			Result.append ("/semantics/")
			s := clone (semantic_class_name)
			s.to_lower
			Result.append (s);
			Result.append (".e"); 
		end; -- semantic_file_name
   
	processor_semantic_class_name: STRING is
		do
			!! Result.make (1);
			Result.append (processor_name);
			Result.append ("_");
			Result.append (semantic_class_name);
			Result.to_upper; 
		end; -- processor_semantic_class_name
   
	processor_semantic_file_name: STRING is
		local
			s: STRING
		do
			!! Result.make (1);
			Result.append (destination_path)
			Result.append ("/semantics/")
			s := clone (processor_semantic_class_name)
			s.to_lower
			Result.append (s);
			Result.append (".e");
		end; -- processor_semantic_file_name
   
	build_semantic_file is
			-- Build the semantic file for processor 
			-- being generated.
		local
			semantic_file: PLAIN_TEXT_FILE;
		do
			if root_construct.processible_file (semantic_file_name) then
				io.putstring ("Building: ");
				io.putstring (semantic_file_name);
				io.new_line
				!! semantic_file.make_open_read_append (semantic_file_name);
				semantic_file.putstring (semantic_class);
				semantic_file.new_line;
				semantic_file.close;
			end; 
		end; -- build_semantic_file
   
	build_processor_semantic_file is
			-- Build the processor semantic file
			-- file for processor being generated.
		local
			processor_semantic_file: PLAIN_TEXT_FILE;
		do
			if root_construct.processible_file (processor_semantic_file_name) then
				io.putstring ("Building: ");
				io.putstring (processor_semantic_file_name);
				io.new_line
				!! processor_semantic_file.make_open_read_append (processor_semantic_file_name);
				processor_semantic_file.putstring (processor_semantic_class);
				processor_semantic_file.close;
			end; 
		end; -- build_processor_semantic_file
  
	semantic_class: STRING is
			-- Semantic class contents for 
			-- for processor being generated.
		do
			!! Result.make (1);
			Result.append ("%N%Nclass ");
			Result.append (semantic_class_name);
			Result.append ("%N%Nfeature {NONE} -- Semantics");
			Result.append (info_feature);
			Result.append (root_construct.end_class (semantic_class_name));
		end; -- semantic_class
   
	info_feature: STRING is
		do
			!! Result.make (1);
			Result.append ("%N%N%Tinfo: ");
			Result.append (processor_semantic_class_name);
			Result.append (" is%N%T%Tonce%N%T%T%T!! Result.make;");
			Result.append ("%N%T%Tend; -- info");
		end; -- info_feature
   
	processor_semantic_class: STRING is
			-- Processor semantic class for 
			-- processor being generated.
		do
			!! Result.make (1);
			Result.append ("%N%Nclass ");
			Result.append (processor_semantic_class_name);
			Result.append ("%N%Ncreation%N%N%Tmake%N%Nfeature");
			Result.append ("%N%N%Tmake is%N%T%Tdo%N%T%Tend; -- make");
			Result.append (root_construct.end_class (processor_semantic_class_name));
		end; -- processor_semantic_class
   
	ace_file_name: STRING is
			-- File name where ACE file resides.
		do
			!! Result.make (1);
			Result.append (destination_path)
			Result.append ("/Ace"); 
		end; -- ace_file_name
   
	build_ace_file is
			-- Build the ACE file
			-- file for processor being generated.
		local
			ace_file: PLAIN_TEXT_FILE;
		do
			if root_construct.processible_file (ace_file_name) then
				io.putstring ("Building: ");
				io.putstring (ace_file_name);
				io.new_line
				!! ace_file.make_open_read_append (ace_file_name);
				ace_file.putstring (ace_file_contents);
				ace_file.close;
			end; 
		end; -- build_ace_file

	processor_environment_variable: STRING is
			-- Environment variable which must be defined
			-- by processor developer in order to compile.
		do	
			Result := clone (processor_name);
			Result.to_upper;
			Result.prepend ("%D");
		end; -- processor_environment_variable 
   
	ace_file_contents: STRING is
		do
			!! Result.make (1);
			Result.append ("system%N%T")
			Result.append (processor_name);
			Result.append ("%N%Nroot%N%T");
			Result.append (processor_name);
			Result.append (" (ROOT_CLUSTER): %"make%"");
			Result.append ("%N%Ndefault");
			Result.append ("%N--%Tdebug (%"parse%");");
			Result.append ("%N%Tassertion (require);");
			Result.append ("%N%Tprecompiled (%"%DEIFFEL3/precomp/spec/solaris/base%")");
			Result.append ("%N%Ncluster");
			Result.append ("%N%TROOT_CLUSTER:%T%T%"");
			Result.append (processor_environment_variable);
			Result.append ("%";");
			Result.append ("%N%Tlex:%T%T%T%"%DEIFFEL3/library/lex%";");
			Result.append ("%N%Tsemantics:%T%T%"");
			Result.append (processor_environment_variable);
			Result.append ("/semantics%";");
			Result.append ("%N%Tconstructs:%T%T%"");
			Result.append (processor_environment_variable);
			Result.append ("/constructs%";");
			Result.append ("%N%Tlexical:%T%T%"");
			Result.append (processor_environment_variable);
			Result.append ("/lexical%";");
			Result.append ("%N%Tsyntax:%T%T%T%"");
			Result.append (processor_environment_variable);
			Result.append ("/syntax%";");
			Result.append ("%N%Textended_parse:%T%T%"");
			Result.append ("$YOOCC/extended_parse%";");
			Result.append ("%N%Tpatterns:%T%T%"");
			Result.append ("$YOOCC/patterns%";");
			Result.append ("%N%Nexternal");
			Result.append ("%N%N%Tobject: %"%D(EIFFEL3)/library/lex/spec/%D(PLATFORM)/lib/lex.a%"");
			Result.append ("%N%Nend");
		end; -- ace_file_contents
   
	resolve_optional_repetition_construct is
			-- Resolve the repetition constructs that are
			-- optional.  What happens is that all rhs_productions
			-- that contain a name_construct that is an
			-- optional repetition construct will need to
			-- set this appropriate repetition name construct
			-- to optional. 
		local
			i: INTEGER
		do
			-- Traverse over the non_terminal_list ensuring that
			-- for every optional repetition construct that appears
			-- in the non_terminal_list,  that each appearance 
			-- of this optional repetition construct in any
			-- rhs_productions of a non_terminal construct
			-- is also optional.
			from     
				i := 1
			until
				i > non_terminal_list.current_keys.count
			loop
				update_rhs_productions (non_terminal_list.item (non_terminal_list.current_keys.item (i)).rhs_productions);
				i := i + 1
			end;
		end; --resolve_optional_repetition_construct  
   
	update_rhs_productions (rhs_pro: LINKED_LIST [RHS_CONSTRUCT]) is
			-- Update the rhs_pro so that all optional
			-- repetition constructs in the rhs_pro
			-- are of course set to optional.
		require
			not_void_rhs_pro: rhs_pro /= Void
			not_empty_rhs_pro: rhs_pro.count >= 1
		do
			from
				rhs_pro.start
			until
				rhs_pro.off
			loop
				if (not rhs_pro.item.is_keyword) and (optional_repetition_construct_list.has (rhs_pro.item.string_value)) then
					rhs_pro.item.set_optional
				end;
				rhs_pro.forth;
			end; 
		end; -- update_rhs_productions

feature {YOOCC} 

	set_processor_name (pn: STRING) is
			-- Set processor name of generated processor to 'pn'.
		require
			pn_non_void: pn /= Void;
			pn_meaningful: not pn.empty
		do
			processor_name := clone (pn);
		end; -- set_processor_name
   
feature {REPETITION_CONSTRUCT} -- Access
   
	optional_repetition_construct_list: LINKED_LIST [STRING];
			-- Contains the optional repetition constructs
			-- in the grammar.  This list is used by 
			-- resolve_optional_repetition_construct to 
			-- traverse over the non_terminal_list ensuring 
			-- that every occurance of an optional repetition
			-- construct in the rhs_productions is_optional. 

feature {NONE} -- Implementation
	
	check_class_clashes is
			-- Ensure that classes being generated do
			-- not clash with other classes being generated.
		do
			check_clashes (non_terminal_list);
			check_clashes (direct_terminal_list);
			check_clashes (indirect_terminal_list);
		end; -- check_class_clashes

	check_clashes (ht: HASH_TABLE [PRODUCTION_INFO,STRING]) is
			-- Check for class clashes for all items 
			-- in 'ht'.
		require
			ht_non_void: ht /= Void
		local
			i: INTEGER; 
		do
			from
				i := 1
			until
				i > ht.current_keys.count
			loop
				ht.item (ht.current_keys.item(i)).check_class_clashes;    
				i := i + 1;
			end; 
		end; -- check_clashes

end -- class YOOCC_SEMANTIC_INFORMATION

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
