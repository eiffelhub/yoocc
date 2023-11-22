indexing
	description: "Lexical analyzer for YOOCC";
	authors: "Jon Avotins and Glenn Maughan";
	status: "See notice at end of class";
	copyright: "See notice at end of class";
	date: "$Date: 1995/08/28 00:46:58 $";
	revision: "$Revision: 1.5 $"

class YOOCC_LEX inherit

	L_INTERFACE;

	YOOCC_LEX_CONSTANTS
		undefine
			consistent, copy, is_equal, setup
		end;

feature {NONE}

	obtain_analyzer is
			-- Create lexical analyzer for syntax texts
		do
			ignore_case;
			keywords_ignore_case;
			build_expressions;
			build_tools;
			build_keywords;
		end; -- obtain_analyzer

	build_tools is
			-- Build character_type token.
		local
			At_sign, Backspace, Circum_flex, Dol_lar, Form_feed, 
			Tilda, New_line, Back_quote, Carrage_return, 
			Horizontal_tab, Null_character, Vertical_bar, 
			Percent_sign, Single_quote, Double_quote, 
			Opening_bracket, Closing_bracket, Greater_than, 
			Less_than, Back_slash, Sharp, And_sign, 
			Valid_manifest_printable_characters, 
			Valid_manifest_printable_characters_1, 
			Valid_manifest_printable_characters_2, 
			Valid_manifest_characters, Character_A, Character_B, 
			Character_C, Character_D, Character_F, Character_H,
			Character_L, Character_N, Character_Q, Character_R, 
			Character_S, Character_T, Character_U, Character_V, 
			A_printable_character, Special_character_1, 
			Special_character_2, Special_character_3, 
			Special_character_4, Special_character_5, 
			Special_character_6, Special_character_7, 
			Special_character_8, Special_character_9, 
			Special_character_10, Special_character_11, 
			Special_character_12, Special_character_13, 
			Special_character_14, Special_character_15, 
			Special_character_16, Special_character_17, 
			Special_character_18, Special_character_19, 
			Special_character_20, Possible_special_characters, 
			Valid_printable_characters, Valid_characters, 
			Left_slash, Character_code_prefix, Zero_thru_nine, 
			Zero_thru_nine_1, Zero_thru_nine_2, Zero_thru_nine_3,
			First_two_one,
			Character_1, Zero_thru_ninety_nine, Double_zero, 
			Character_0, Optional_single_zero, Optional_double_zero,
			Zero_thru_ninety_nine_1, Zero_thru_ninety_nine_2, 
			Hundred_thru_Hundred_99, Character_2, Zero_thru_five, 
			Zero_thru_six, Zero_thru_256, Prefix_256,  
			Two_hundred_thru_256, First_two, Last_two,  
			Prefix_plus_integer, Valid_character_codes,  
			Character_possibilities, Special_character_28,  
			Simple_string_char_poss, Special_character_21, 
			Special_character_22, Special_character_23, 
			Special_character_24, Special_character_25, 
			Special_character_26, Special_character_27, 
			Invalid_FO_special_characters, 
			Valid_FO_printable_characters, Vertical_and, 
			At_sharp, The_character_sequence, Free_operator_prefix,
 			Suffix_FO, Free_operator_tool, Manifest_end_break, 
			Manifest_characters, Manifest_character_sequence,  
			Possible_manifest_characters, Prefix_character, 
			Encapsulated_character, Character_sequence, 
			Simple_string_prefix,  A_simple_string,  
			Manifest_break, Concluding_manifest_line, 
			Opening_manifest_line, Blank_space_character, 
			Tab_character, Blanks_or_spaces, 
			Middle_manifest_prefix, Middle_manifest_suffix, 
			Optional_middle_manifest_line, 
			Concluding_manifest_prefix,  
			Opening_middle_manifest_lines, Middle_manifest_line, 
			A_manifest_string, Blank_character_or_space, 
			Optional_blanks_or_spaces, 
			Manifest_string_concatenated, Manifest_string_prefix,  
			Free_operator_guts, Free_operator_end : INTEGER;
		do
				-- C2 as per ETL page 422.
				-- Special_character_? will be used to store all possible
				-- options appendable to %.
				-- Must be in upper case
				-- NOT WORKING CURRENTLY  !!!!!!!!! 25/9/94
				distinguish_case;
				interval('A','A'); Character_A := last_created_tool
				interval('B','B'); Character_B := last_created_tool
				interval('C','C'); Character_C := last_created_tool
				interval('D','D'); Character_D := last_created_tool
				interval('F','F'); Character_F := last_created_tool
				interval('H','H'); Character_H := last_created_tool
				interval('L','L'); Character_L := last_created_tool
				interval('N','N'); Character_N := last_created_tool
				interval('Q','Q'); Character_Q := last_created_tool
				interval('R','R'); Character_R := last_created_tool
				interval('S','S'); Character_S := last_created_tool
				interval('T','T'); Character_T := last_created_tool
				interval('U','U'); Character_U := last_created_tool
				interval('V','V'); Character_V := last_created_tool
				interval('%%','%%'); Percent_sign := last_created_tool;
				interval('%R','%R'); Carrage_return := last_created_tool;
				interval('%N','%N'); New_line := last_created_tool;
				interval('%"','%"'); Double_quote := last_created_tool;
				interval('%'','%''); Single_quote := last_created_tool;
				interval('(','('); Opening_bracket := last_created_tool
				interval(')',')'); Closing_bracket := last_created_tool
				interval('<','<'); Less_than := last_created_tool
				interval('>','>'); Greater_than := last_created_tool
				union2(Character_A,Character_B); Special_character_1 := last_created_tool;
				union2(Special_character_1,Character_C); Special_character_2 := last_created_tool;
				union2(Special_character_2,Character_D); Special_character_3 := last_created_tool;
				union2(Special_character_3,Character_F); Special_character_4 := last_created_tool;
				union2(Special_character_4,Character_H); Special_character_5 := last_created_tool;
				union2(Special_character_5,Character_L); Special_character_6 := last_created_tool;
				union2(Special_character_6,Character_N); Special_character_7 := last_created_tool;
				union2(Special_character_7,Character_Q); Special_character_8 := last_created_tool;
				union2(Special_character_8,Character_R); Special_character_9 := last_created_tool;
				union2(Special_character_9,Character_S); Special_character_10 := last_created_tool;
				union2(Special_character_10,Character_T); Special_character_11 := last_created_tool;
				union2(Special_character_11,Character_U); Special_character_12 := last_created_tool;
				union2(Special_character_12,Character_V); Special_character_13 := last_created_tool;
				union2(Special_character_13,Single_quote); Special_character_14 := last_created_tool;
				union2(Special_character_14,Opening_bracket); Special_character_15 := last_created_tool;
				union2(Special_character_15,Closing_bracket); Special_character_16 := last_created_tool;
				union2(Special_character_16,Less_than); Special_character_17 := last_created_tool;
				union2(Special_character_17,Greater_than); Special_character_18 := last_created_tool;
				union2(Special_character_18,Percent_sign); Special_character_19 := last_created_tool;
				union2(Special_character_19,Double_quote); Special_character_20 := last_created_tool;
				append(Percent_sign,Special_character_20); Possible_special_characters := last_created_tool;
				ignore_case;
				-- C1 as per ETL page 422.
				-- Any printable character excluding the percentage character.
				any_character; A_printable_character := last_created_tool;
				difference(A_printable_character,'%%'); Valid_printable_characters := last_created_tool;  		
				difference(Valid_printable_characters,'%"'); Valid_manifest_printable_characters_1 := last_created_tool;  		
				difference(Valid_manifest_printable_characters_1 ,'%N'); Valid_manifest_printable_characters_2 := last_created_tool;  		
				difference(Valid_manifest_printable_characters_2,'%R'); Valid_manifest_printable_characters := last_created_tool;  		
				union2(Valid_printable_characters,Possible_special_characters); 
					Valid_characters := last_created_tool;
				union2(Valid_manifest_printable_characters,Possible_special_characters); 
					Valid_manifest_characters := last_created_tool;
				-- C3 as per ETL page 422.
				-- Integer codes of the form %/the_code/ where code an unassigned integer
				-- representing the character of code the_code.  the_code must be in the range
				-- 0 thru 256.
				-- Therefore there are three possibilities.
				--	(i)	0-9.
				--		00-09
				--		001-009
				--	(ii)	10-99;
				--		010-099
				--	(iii)	100-199
				--	(iv)	200-256
				interval('/','/'); Left_slash := last_created_tool
				append(Percent_sign,Left_slash); Character_code_prefix := last_created_tool;
				-- (i)
				interval('0','0'); Character_0 := last_created_tool;
				optional(Character_0);  Optional_single_zero := last_created_tool;
				append(Character_0,Character_0); Double_zero := last_created_tool;
				optional(Double_zero); Optional_double_zero := last_created_tool;

				interval('0','9'); Zero_thru_nine_1 := last_created_tool;
				append (Optional_single_zero,Zero_thru_nine_1); Zero_thru_nine_2 := last_created_tool;
				append (Optional_double_zero,Zero_thru_nine_1); Zero_thru_nine_3 := last_created_tool;
			
				-- (ii)
				interval('1','1'); Character_1 := last_created_tool;
				iteration_n(2,Zero_thru_nine_1); Zero_thru_ninety_nine_1 := last_created_tool;
				append(Optional_single_zero,Zero_thru_ninety_nine_1); Zero_thru_ninety_nine_2 := last_created_tool;
				-- (iii)
				append(Character_1,Zero_thru_ninety_nine_1); Hundred_thru_Hundred_99 := last_created_tool;
				-- (iv)
				interval('2','2'); Character_2 := last_created_tool;
				interval('0','5'); Zero_thru_five := last_created_tool;
				interval('0','6'); Zero_thru_six := last_created_tool;
				append(Character_2,Zero_thru_five); Prefix_256 := last_created_tool;
				append(Prefix_256,Zero_thru_six); Two_hundred_thru_256 := last_created_tool;
				-- Append four together.
				
				union2(Zero_thru_nine_1,Zero_thru_nine_2); First_two_one := last_created_tool;
				union2(First_two_one,Zero_thru_nine_3); Zero_thru_nine := last_created_tool; 
				union2(Zero_thru_ninety_nine_1,Zero_thru_ninety_nine_2); Zero_thru_ninety_nine := last_created_tool;
				union2(Zero_thru_nine,Zero_thru_ninety_nine); First_two := last_created_tool;
				union2(Hundred_thru_Hundred_99,Two_hundred_thru_256); Last_two := last_created_tool;
				union2(First_two,Last_two); Zero_thru_256 := last_created_tool;
				append(Character_code_prefix,Zero_thru_256); Prefix_plus_integer := last_created_tool;
				append(Prefix_plus_integer,Left_slash);	Valid_character_codes := last_created_tool; 
				union2(Valid_characters,Valid_character_codes); Character_possibilities := last_created_tool;
				append(Single_quote,Character_possibilities); Prefix_character := last_created_tool;
				append(Prefix_character,Single_quote);  Encapsulated_character := last_created_tool;
				-- Build simple string.
				iteration(Valid_manifest_characters); Character_sequence := last_created_tool;
				append(Double_quote,Character_sequence); Simple_string_prefix := last_created_tool;
				append(Simple_string_prefix,Double_quote); A_simple_string := last_created_tool;
				select_tool(A_simple_string);
				associate(A_simple_string,Simple_string_type);
			end; -- build_tools


	build_expressions is
			-- Set expression type for analyser
		do
			put_expression ("+('1'..'9') %V (((%'1%'..%'9%') %V 2(%'1%'..%'9%') %V 3(%'1%'..%'9%'))+((%'_%')3(%'1%'..%'9%')))", Multiplicity_integer, "Multiplicity_integer"); 
			put_expression ("%L(%'a%'..%'z%') *(%L(%'a%'..%'z%') %V %'_%' %V (%'0%'..%'9%'))", Identifier, "Identifier"); 
			put_expression ("((':' ':' '=') | ('.' '.' '.') | '[' | ']' | '+' | '{' | '}' | '|' | ';')", Special, "Special");
		end; -- build_expressions

	build_keywords is
			-- Set keyword constructs for analyser
		do
			put_keyword ("::=",Special);
			put_keyword ("...",Special);
			put_keyword ("[",Special);
			put_keyword ("]",Special);
			put_keyword ("+",Special);
			put_keyword ("{",Special);
			put_keyword ("}",Special);
			put_keyword ("|",Special);
			put_keyword (";",Special);
		end; -- build_keywords

end -- class YOOCC_LEX

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
