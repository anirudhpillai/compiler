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

LineTerminator = \r|\n|\r\n
WhiteSpace     = {LineTerminator} | [ \t\f]

Letter = [A-Za-z]
Digit = [0-9]
InputCharacter = [^\r\n]

// Comment
EndOfLineComment = "#"{InputCharacter}*{LineTerminator}?
MultiLineComment = "/#" [^#] ~"#/" | "/#" "#"+ "/"

Comment = {EndOfLineComment} | {MultiLineComment}

// Identifier
ValidChars = "_" | Letter | Digit
Identifier = {Letter}{ValidChars}*

// Character
Punctuation = [!\"#\$%&\'()\*\+\,\-\.\/:;<=>\?@\[\]\\\^_`{}\~¦]
Character = '{Letter}' | '{Punctuation}' | '{Digit}'

Boolean = T | F

// Numbers
Integer = -?(0|[1-9]{Digit}*)
Float = {Integer}(\.{Digit}*)?
Rational = ({Integer}_){Digit}"/"{Digit}* | {Integer}"/"{Digit}*

Number = {Integer} | {Rational} | {Float}


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
    /* Return the token SEMI declared in the class sym that was found. */
    ";"                { return symbol(sym.SEMI); }

    "+"                { System.out.print(" + "); return symbol(sym.PLUS); }
    "-"                { System.out.print(" - "); return symbol(sym.MINUS); }
    "*"                { System.out.print(" * "); return symbol(sym.TIMES); }
    "/"                { System.out.print(" / "); return symbol(sym.DIVIDE); }
    "("                { System.out.print(" ( "); return symbol(sym.LPAREN); }
    ")"                { System.out.print(" ) "); return symbol(sym.RPAREN); }
}


/* No token was found for the input so through an error.  Print out an
   Illegal character message with the illegal character that was found. */
[^]                    { throw new Error("Illegal character <"+yytext()+">"); }