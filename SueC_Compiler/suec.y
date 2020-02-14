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

%%

program : program statement	{ execute_node($2); freeNode($2); }
	| /* NULL */
	;

statement : simplestatement ';'
        | loopStatement
		| condStatement
		| '{' statementlist '}' { $$ = $2; }
        ;
		
condStatement : IF '(' expression ')' statement ELSE statement { $$ = operand(IF,$3,$5,$7); }
		| IF '(' expression ')' statement { $$ = operand(IF,$3,$5,NULL); }
		;
		
loopStatement : whileStatement;
			  | forStatement 
		;
		
forStatement :	FOR '(' simplestatement ';' expression ';' expression ')' statement { $$ = operand(FOR,$3,$5,$7,$9); }
		;
		
whileStatement :  WHILE '(' expression ')' statement { $$ = operand(WHILE, $3, $5); }
		;
		
		
statementlist : statement
              | statementlist statement	{ $$ = operand(';', $1, $2); }
              ;

simplestatement : expression
                | WRITE expression		{ $$ = operand(WRITE,$2,NULL); }
				| variable '=' expression	{ $$ = operand('=', $1, $3); }
				| READ variable 		{ $$ = operand(READ,$2,NULL); }
				;
				
variable : HCVAR { $$ = iden(HCVAR, $1); }
		| LCVAR  { $$ = iden(LCVAR, $1); }
		;

expression : NUM			{ $$ = leaf(NUM, $1); }
	   | WORD 				{ $$ = leaf(WORD,$1); }
	   | INT variable			
	   | STRING variable			
	   | expression '+' expression	{ $$ = operand('+', $1, $3); }
	   | expression '-' expression	{ $$ = operand('-', $1, $3); }
	   | expression '*' expression	{ $$ = operand('*', $1, $3); }
	   | expression '/' expression	{ $$ = operand('/', $1, $3); }
	   | expression '<' expression	{ $$ = operand('<', $1, $3); }
	   | expression '>' expression	{ $$ = operand('>', $1, $3); }
	   | expression GE expression	{ $$ = operand(GE, $1, $3); }
	   | expression LE expression	{ $$ = operand(LE, $1, $3); }
	   | expression NE expression	{ $$ = operand(NE, $1, $3); }
	   | expression EQ expression	{ $$ = operand(EQ, $1, $3); }
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
	node->constant.type = type;
	strcpy(node->constant.value, value);
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
	printf("%s\n", error);
}

int main(int argc, char** argv) {

	if(argc != 2) 
	{
		printf("ERROR! No input file");
		exit(1);
	}
	if(!(yyin = fopen(argv[1],"r")))
	{
		printf("ERROR! Cannot open file.");
		exit(1);
	}
	printf("The Parsing has been started on file with path=%s!\n",argv[1]);
	
	yyparse();
	fclose(yyin);
	
	return 0;
}