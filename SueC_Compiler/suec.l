%{
#include "y.tab.h"
%}

%%
//main keywords

"int"  {return INT;}
"string" {return STRING;}
"if"   {return IF;}
"else" {return ELSE;}
"for"  {return FOR;}
"while" {return WHILE;}
"read"  {return READ;}
"write" {return WRITE;}

[A-Z]	{
		yylval.variable = *yytext - 'A';
		return VAR;
	}

[a-z]	{
		yylval.variable = *yytext - 'a';
		return VAR;
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

[ \t\r\n]	;

.			yyerror("Unkwpn character");

%%
int yywrap(void)
{
	return 1; 
}
	