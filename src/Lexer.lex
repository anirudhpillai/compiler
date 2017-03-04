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
Integer = -?(0|[1-9]{Digit}*)
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
AlphanumericUnderscore = [:jletterdigit:] | "_"
Identifier = [:jletter:]{AlphanumericUnderscore}*

%state STRING, CHAR

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
    ";"                { System.out.print(" ; ");  return symbol(sym.SEMI); }

    //Operators

    ":="               { System.out.print(" := ");  return symbol(sym.EQ); }
    ":"                { System.out.print(" : ");  return symbol(sym.COLON); }
    "=="               { System.out.print(" == "); return symbol(sym.EQEQ); }
    "!="               { System.out.print(" != "); return symbol(sym.NOT_EQ); }
    "&&"               { System.out.print(" && ");  return symbol(sym.AND); }
    "||"               { System.out.print(" || ");  return symbol(sym.OR); }
    "!"                { System.out.print(" ! ");  return symbol(sym.NOT); }
    "+"                { System.out.print(" + ");  return symbol(sym.PLUS); }
    "-"                { System.out.print(" - ");  return symbol(sym.MINUS); }
    "*"                { System.out.print(" * ");  return symbol(sym.TIMES); }
    "/"                { System.out.print(" / ");  return symbol(sym.DIVIDE); }
    "("                { System.out.print(" ( ");  return symbol(sym.L_ROUND); }
    ")"                { System.out.print(" ) ");  return symbol(sym.R_ROUND); }
    "{"                { System.out.print(" { ");  return symbol(sym.L_CURLY); }
    "}"                { System.out.print(" } ");  return symbol(sym.R_CURLY); }
    "["                { System.out.print(" [ ");  return symbol(sym.L_SQUARE); }
    "]"                { System.out.print(" ] ");  return symbol(sym.R_SQUARE); }
    "<="               { System.out.print(" < ");  return symbol(sym.L_ANGLE_EQ); }
    ">="               { System.out.print(" > ");  return symbol(sym.R_ANGLE_EQ); }
    "<"                { System.out.print(" < ");  return symbol(sym.L_ANGLE); }
    ">"                { System.out.print(" > ");  return symbol(sym.R_ANGLE); }
    "^"                { System.out.print(" ^ "); return symbol(sym.CARET); }
    ","                { System.out.print(" , "); return symbol(sym.COMMA); }

    //hmm

    //Types
    "int"              { System.out.print(" int ");     return symbol(sym.INTEGER); }
    "bool"             { System.out.print(" bool ");    return symbol(sym.BOOLEAN); }
    "char"             { System.out.print(" char ");    return symbol(sym.CHARACTER); }
    "rat"              { System.out.print(" rat ");     return symbol(sym.RATIONAL); }
    "float"            { System.out.print(" float ");   return symbol(sym.FLOAT); }
    "dict"             { System.out.print(" dict ");    return symbol(sym.DICT); }
    "seq"              { System.out.print(" seq ");     return symbol(sym.SEQ); }
    "void"             { System.out.print(" void ");    return symbol(sym.VOID); }

    //Special words
    "main"             { System.out.print(" main ");   return symbol(sym.MAIN); }
    "len"              { System.out.print(" len ");    return symbol(sym.LEN); }
    "tdef"             { System.out.print(" tdef ");   return symbol(sym.TYPEDEF); }
    "fdef"             { System.out.print(" fdef ");   return symbol(sym.FUNCTION_DEF); }
    "top"              { System.out.print(" top ");   return symbol(sym.TOP); }
    "while"            { System.out.print(" while ");  return symbol(sym.WHILE); }
    "forall"           { System.out.print(" forall "); return symbol(sym.FORALL); }
    "in"               { System.out.print(" in ");     return symbol(sym.IN); }
    "alias"            { System.out.print(" alias ");  return symbol(sym.ALIAS); }
    "if"               { System.out.print(" if ");     return symbol(sym.IF); }
    "fi"               { System.out.print(" fi ");     return symbol(sym.FI); }
    "then"             { System.out.print(" then ");   return symbol(sym.THEN); }
    "elif"             { System.out.print(" elif ");   return symbol(sym.ELSE_IF); }
    "else"             { System.out.print(" else ");   return symbol(sym.ELSE); }
    "do"               { System.out.print(" do ");     return symbol(sym.DO); }
    "od"               { System.out.print(" od ");     return symbol(sym.OD); }
    "read"             { System.out.print(" read ");   return symbol(sym.READ); }
    "print"            { System.out.print(" print ");  return symbol(sym.PRINT); }
    "return"           { System.out.print(" return "); return symbol(sym.RETURN); }
    "break"            { System.out.print(" return "); return symbol(sym.BREAK); }

    //Literals
    {Number}           { System.out.print(yytext());  return symbol(sym.NUMBER); }
    {Character}        { System.out.print(yytext()); return symbol(sym.CHARACTER); }
    {Identifier}       { System.out.print(yytext()); return symbol(sym.IDENTIFIER);}
    {WhiteSpace}       { /* just skip what was found, do nothing */ }
}


/* No token was found for the input so through an error.  Print out an
   Illegal character message with the illegal character that was found. */
[^]                    { throw new Error("Illegal character <"+yytext()+">"); }
