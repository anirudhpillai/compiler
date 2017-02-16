/*
This is the jFlex code which does the lexing
Docs here: http://jflex.de/manual.html
Useful video: https://www.youtube.com/watch?v=IV1Rwq7ERR4
*/

import java_cup.runtime.*;

%%
/* Options and Declarations */

%class Lexer
%unicode
%cup
%line
%column

%%
/* Lexical Rules */