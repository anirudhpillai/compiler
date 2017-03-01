/*
This is the jFlex code which does the lexing
Docs here: http://jflex.de/manual.html
Useful video: https://www.youtube.com/watch?v=IV1Rwq7ERR4
*/

/* --------------------------Usercode Section------------------------ */

import java_cup.runtime.*;

%%

/* -----------------Options and Declarations Section----------------- */

/*
   The name of the class JFlex will create will be Lexer.
   Will write the code to the file Lexer.java.
*/
%class Lexer

/*
  The current line number can be accessed with the variable yyline
  and the current column number with the variable yycolumn.
*/
%line
%column

/*
   Will switch to a CUP compatibility mode to interface with a CUP
   generated parser.
*/
%cup

/*
  Declarations

  Code between %{ and %}, both of which must be at the beginning of a
  line, will be copied letter to letter into the lexer class source.
  Here you declare member variables and functions that are used inside
  scanner actions.
*/
%{
    /* To create a new java_cup.runtime.Symbol with information about
       the current token, the token will have no value in this
       case. */
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }

    /* Also creates a new java_cup.runtime.Symbol with information
       about the current token, but this object has a value. */
    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}


/*
  Macro Declarations

  These declarations are regular expressions that will be used latter
  in the Lexical Rules Section.
*/

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

//Decimal integers
DecIntegerLiteral = 0 | [1-9][0-9]*
DecIntegerIdentifier = [A-Za-z_][A-Za-z_0-9]*

SingleCharacter = [:jletterdigit:] | \p{Punctuation}

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
    "="                { System.out.print(" = ");  return symbol(sym.EQ); }
    "=="               { System.out.print(" == "); return symbol(sym.EQEQ); }
    "+"                { System.out.print(" + ");  return symbol(sym.PLUS); }
    "-"                { System.out.print(" - ");  return symbol(sym.MINUS); }
    "*"                { System.out.print(" * ");  return symbol(sym.TIMES); }
    "/"                { System.out.print(" / ");  return symbol(sym.DIVIDE); }
    "("                { System.out.print(" ( ");  return symbol(sym.L_ROUND); }
    ")"                { System.out.print(" ) ");  return symbol(sym.R_ROUND); }
    "^"                { System.out.print(" ^ "); return symbol(sym.CARET); }

    //hmm

    //Types
    "int"              { System.out.print(" int ");     return symbol(sym.INTEGER); }
    "bool"             { System.out.print(" bool ");    return symbol(sym.BOOLEAN); }
    "char"             { System.out.print(" char ");    return symbol(sym.CHARACTER); }
    "rat"              { System.out.print(" rat ");     return symbol(sym.RATIONAL); }
    "float"            { System.out.print(" float ");   return symbol(sym.FLOAT); }
    "dict"             { System.out.print(" dict ");    return symbol(sym.DICTIONARY); }
    "seq"              { System.out.print(" seq ");     return symbol(sym.SEQUENCE); }
    "void"             { System.out.print(" void ");    return symbol(sym.VOID); }

    //Special words
    "main"             { System.out.print(" main ");   return symbol(sym.MAIN); }
    "len"              { System.out.print(" len ");    return symbol(sym.LEN); }
    "tdef"             { System.out.print(" tdef ");   return symbol(sym.TYPEDEF); }
    "fdef"             { System.out.print(" fdef ");   return symbol(sym.FUNCTION_DEF); }
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

    //Literals
    {DecIntegerLiteral}          { System.out.print(yytext()); return symbol(sym.NUMBER, new Integer(yytext())); }
    {DecIntegerIdentifier}       { System.out.print(yytext()); return symbol(sym.ID, new Integer(1));}
    {WhiteSpace}       { /* just skip what was found, do nothing */ }
    "_"                { System.out.print(" _ "); return symbol(sym.UNDERSCORE); }
}


/* No token was found for the input so through an error.  Print out an
   Illegal character message with the illegal character that was found. */
[^]                    { throw new Error("Illegal character <"+yytext()+">"); }