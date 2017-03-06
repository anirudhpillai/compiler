/*
This is the jFlex code which does the lexing
Docs here: http://jflex.de/manual.html
Useful video: https://www.youtube.com/watch?v=IV1Rwq7ERR4
*/

/* --------------------------Usercode Section------------------------ */

import java_cup.runtime.*;

%%

/* -----------------Options and Declarations Section----------------- */

%class Lexer
%unicode
%line
%column
%cup


%{
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }

    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}


/*
  Macro Declarations

  These declarations are regular expressions that will be used latter
  in the Lexical Rules Section.
*/

Letter = [A-Za-z]
Digit = [0-9]

// Character
Punctuation = [!\"#\$%&\'()\*\+\,\-\.\/:;<=>\?@\[\]\\\^_`{}\~¦]
Character = '{Letter}' | '{Punctuation}' | '{Digit}'

Boolean = T | F

// Numbers
Integer = 0|[1-9]{Digit}*
Float = {Integer}(\.{Digit}*)?
Rational = ({Integer}_){Digit}"/"{Digit}* | {Integer}"/"{Digit}*

Number = {Integer} | {Rational} | {Float}

// Spaces
LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f] //line terminator, space, tab, or line feed.

// Comments
Comment = {MultilineComment} | {EndOfLineComment}
MultilineComment = "/#" [^#] ~"#/" | "/#" "#" + "/"
EndOfLineComment = "#" {InputCharacter}* {LineTerminator}?

// Identifier
//jletterdigit predefined by flex
AlphanumericUnderscore = {Letter} | "_" | {Digit}
Dot = "."
Identifier = {Letter}{AlphanumericUnderscore}*{Dot}?{AlphanumericUnderscore}*

String = \"(\\.|[^\"])*\"

%%
/* ------------------------Lexical Rules Section---------------------- */

/*
   This section contains regular expressions and actions, i.e. Java
   code, that will be executed when the scanner matches the associated
   regular expression. */

   /* YYINITIAL is the state at which the lexer begins scanning.  So
   these regular expressions will only be matched if the scanner is in
   the start state YYINITIAL. */

<YYINITIAL> {

    //End statement
    ";"                { return symbol(sym.SEMI); }

    //Operators

    ":="               { return symbol(sym.EQ); }
    "::"               { return symbol(sym.CONCAT); }
    ":"                { return symbol(sym.COLON); }
    "="                { return symbol(sym.EQEQ); }
    "!="               { return symbol(sym.NOT_EQ); }
    "&&"               { return symbol(sym.AND); }
    "||"               { return symbol(sym.OR); }
    "!"                { return symbol(sym.NOT); }
    "+"                { return symbol(sym.PLUS); }
    "-"                { return symbol(sym.MINUS); }
    "*"                { return symbol(sym.TIMES); }
    "/"                { return symbol(sym.DIVIDE); }
    "("                { return symbol(sym.L_ROUND); }
    ")"                { return symbol(sym.R_ROUND); }
    "{"                { return symbol(sym.L_CURLY); }
    "}"                { return symbol(sym.R_CURLY); }
    "["                { return symbol(sym.L_SQUARE); }
    "]"                { return symbol(sym.R_SQUARE); }
    "=>"               { return symbol(sym.IMPLY); }
    "<="               { return symbol(sym.L_ANGLE_EQ); }
    ">="               { return symbol(sym.R_ANGLE_EQ); }
    "<"                { return symbol(sym.L_ANGLE); }
    ">"                { return symbol(sym.R_ANGLE); }
    ","                { return symbol(sym.COMMA); }
    "?"                { return symbol(sym.QUESTION); }

    //hmm

    //Types
    "int"              { return symbol(sym.INTEGER); }
    "char"             { return symbol(sym.CHARACTER); }
    "rat"              { return symbol(sym.RATIONAL); }
    "float"            { return symbol(sym.FLOAT); }
    "dict"             { return symbol(sym.DICT); }
    "seq"              { return symbol(sym.SEQ); }

    //Special words
    "main"             { return symbol(sym.MAIN); }
    "len"              { return symbol(sym.LEN); }
    "tdef"             { return symbol(sym.TYPEDEF); }
    "fdef"             { return symbol(sym.FUNCTION_DEF); }
    "top"              { return symbol(sym.TOP); }
    "in"               { return symbol(sym.IN); }
    "alias"            { return symbol(sym.ALIAS); }
    "if"               { return symbol(sym.IF); }
    "fi"               { return symbol(sym.FI); }
    "then"             { return symbol(sym.THEN); }
    "else"             { return symbol(sym.ELSE); }
    "read"             { return symbol(sym.READ); }
    "print"            { return symbol(sym.PRINT); }
    "return"           { return symbol(sym.RETURN); }
    "break"            { return symbol(sym.BREAK); }
    "loop"             { return symbol(sym.LOOP); }
    "pool"             { return symbol(sym.POOL); }


    //Literals
    {Boolean}          { return symbol(sym.BOOLEAN); }
    {String}           { return symbol(sym.STRING); }
    {Number}           { return symbol(sym.NUMBER); }
    {Character}        { return symbol(sym.CHARACTER); }
    {Identifier}       { return symbol(sym.IDENTIFIER);}
    {Comment}          { /* just skip what was found, do nothing */ }
    {WhiteSpace}       { /* just skip what was found, do nothing */ }
}


/* No token was found for the input so through an error.  Print out an
   Illegal character message with the illegal character that was found. */
[^]                    { throw new Error("Illegal character <"+yytext()+">"); }
