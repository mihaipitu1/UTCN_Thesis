%{
#include "y.tab.h"
%}

%%

//type definition
"int"  {return INT;}
"string" {return STRING;}

//main operations
"if"   {return IF;}
"else" {return ELSE;}
"for"  {return FOR;}
"while" {return WHILE;}
"read"  {return READ;}
"write" {return WRITE;}


//variables
[A-Z]	{
		yylval.variable = *yytext - 'A';
		return HCVAR;
	}

[a-z]	{
		yylval.variable = *yytext - 'a';
		return LCVAR;
	}

//numbers and strings

[0-9]+ 	{
			yylval.iValue = strtol(yytext, (char**)NULL,10);
			return NUM;
		}
		
[a-zA-Z0-9]+ 	{
					yylval.word = *yytext;
					return WORD;
				}

//operators
[-()+*/<>;]	 {return *yytext;}

"="		 {return ATTR;}
">="		return GE;
"<="		return LE;
"=="		return EQ;
"!="		return NE;

[ \t\r\n]+	;

.			yyerror("Unknown character");

%%
int yywrap(void)
{
	return 1; 
}
	