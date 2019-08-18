%{
#include "y.tab.h"
%}

%%
//main keywords

"int"  {return INT;}
"real" {return REAL;}
"string" {return STRING;}
"if"   {return IF;}
"else" {return ELSE;}
"for"  {return FOR;}
"while" {return WHILE;}
"read"  {return READ;}
"write" {return WRITE;}

//numbers and strings

[0-9]+ 	{
			yylval.iVa
			return NUM;
		}
[a-zA-Z0-9 ]+ {return WORD;}

%%
int yywrap(void)
{
	return 1;
}
	