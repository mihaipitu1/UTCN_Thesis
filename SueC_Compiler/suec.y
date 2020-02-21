%{
#include "suec_header.h"
#include "string.h"
#include "stdarg.h"
#include "stdio.h"
#include "stdlib.h"
#include "y.tab.h"

nodeType *leaf(int type, char* value);
nodeType *iden(int type, int value);
nodeType *operand(int oper, int nops, ...);
void freeNode(nodeType* node);
void yyerror(char* error);

extern FILE* yyin;
extern int yydebug;
%}

%union {
	int iValue;
	char variable;
	char* word;
	struct noperand *np;
};

%token INT STRING
%token IF ELSE FOR WHILE
%token READ WRITE

%token <iValue> NUM
%token <variable> HCVAR
%token <variable> LCVAR
%token <word> WORD

%left GE LE EQ NE '>' '<'
%left '+' '-'
%left '*' '/'

%type <np> statement expression statementlist condStatement forStatement 
%type <np> whileStatement simplestatement variable
%start program

%%

program : statementlist	{ execute_node($1); freeNode($1); }
	| /* NULL */
	;

statement : simplestatement ";"
        | loopStatement
		| condStatement
		| '{' statementlist '}' { $$ = $2; }
        ;
		
condStatement : IF '(' expression ')' statement ELSE statement { printf("Got in IF-ELSE\n");$$ = operand(IF,3,$3,$5,$7); }
		| IF '(' expression ')' statement { printf("Got in IF\n");$$ = operand(IF,2,$3,$5); }
		;
		
loopStatement : whileStatement;
			  | forStatement 
		;
		
forStatement :	FOR '(' simplestatement ';' expression ';' expression ')' statement {printf("Got in FOR\n"); $$ = operand(FOR,4,$3,$5,$7,$9); }
		;
		
whileStatement :  WHILE '(' expression ')' statement { printf("Got in WHILE\n");$$ = operand(WHILE, 2,$3,$5); }
		;
		
		
statementlist : statement
              | statementlist statement	{ $$ = operand(';', $1, $2); }
              ;

simplestatement : expression
                | WRITE "(" expression ")"		{ printf("Got in WRITE\n");$$ = operand(WRITE, 1, $3); }
				| variable '=' expression	{ printf("Got in =\n");$$ = operand('=',2 , $1, $3); }
				| READ "(" variable ")"		{ printf("Got in READ\n");$$ = operand(READ, 1, $3); }
				;
				
variable : HCVAR { printf("Got in HCVAR\n"); $$ = iden(HCVAR, $1); }
		| LCVAR  { printf("Got in LCVAR\n"); $$ = iden(LCVAR, $1); }
		;

expression : NUM			{ printf("Got in NUM\n");$$ = leaf(NUM, $1); }
	   | WORD 				{ printf("Got in WORD\n");$$ = leaf(WORD,$1); }
	   | INT variable		{printf("Got in INT\n");}	
	   | STRING variable	{printf("Got in STRING\n");}		
	   | expression '+' expression	{ printf("Got in +\n"); $$ = operand('+', 2, $1, $3); }
	   | expression '-' expression	{ printf("Got in -\n");$$ = operand('-', 2, $1, $3); }
	   | expression '*' expression	{ printf("Got in *\n");$$ = operand('*', 2, $1, $3); }
	   | expression '/' expression	{ printf("Got in /\n");$$ = operand('/', 2, $1, $3); }
	   | expression '<' expression	{ printf("Got in <\n");$$ = operand('<', 2, $1, $3); }
	   | expression '>' expression	{ printf("Got in >\n");$$ = operand('>', 2, $1, $3); }
	   | expression GE expression	{ printf("Got in >=\n");$$ = operand(GE, 2, $1, $3); }
	   | expression LE expression	{ printf("Got in <=\n");$$ = operand(LE, 2, $1, $3); }
	   | expression NE expression	{ printf("Got in !=\n");$$ = operand(NE, 2, $1, $3); }
	   | expression EQ expression	{ printf("Got in ==\n");$$ = operand(EQ, 2, $1, $3); }
	   | '(' expression ')'		{ $$ = $2; }
	   ;

%%

#define SIZE_NODE ((char*)&p->com - (char*)p)

nodeType *leaf(int type, char* value) {
	nodeType* node;
	if((node = malloc(sizeof(nodeType))) == NULL)
	{
		yyerror("No memory left");
	}
	node->type = constType;
	switch(type) {
		case NUM: node->constant.iValue = atoi(value);
		case WORD: strcpy(node->constant.sValue,value);
	}
	node->constant.type = type;
	return node;
}

nodeType *iden(int type, int value) {
	nodeType* node;
	
	if((node = malloc(sizeof(nodeType))) == NULL)
		yyerror("No memory left");
		
	node->type = idType;

	node->id.type = type;
	node->id.value = value;
	
	return node;
}


nodeType *operand(int oper, int nops, ...) {
	va_list argList;
	nodeType* node;
	int i;
	
	if((node = malloc(sizeof(nodeType))) == NULL)
		yyerror("No memory left");
		
	if((node->oper.op = malloc(nops*sizeof(nodeType))) == NULL)
		yyerror("No memory left");
		
	node->type = operType;

	node->oper.oper = oper;
	node->oper.nops = nops;
	
	va_start(argList, nops);
	
	for(i=0;i<nops;i++)
		node->oper.op[i] = va_arg(argList, nodeType*);
		
	va_end(argList);
	
	return node;
}

void freeNode(nodeType* node) {
	int i;
	
	if(!node) return;
	
	if(node->type == operType) {
		for(i=0; i<node->oper.nops;i++)
			freeNode(node->oper.op[i]);
		free(node->oper.op);
	}
	free(node);
}

void yyerror(char* error) {
	extern char* yytext;
	extern int yylineno;
	printf("%s At Line: %d - Char: %c\n", error,yylineno,*yytext);
}

int main(void)
{
	// yydebug = 1;
	yyparse();
	return 0;
}
	