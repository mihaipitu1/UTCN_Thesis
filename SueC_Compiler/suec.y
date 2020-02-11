%{
#include "suec_header.h"
#include "string.h"

nodeType *leaf(int type, char* value);
nodeType *iden(int type, int value);
nodeType *operand(int oper, int nops, ...);
void freeNode(nodeType* node);
void yyerror(char* error);
int main(void);
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

program : program statement	{ execute($2); freeall($2); }
	| program error ';'	{ yyerrok; }
	| /* NULL */
	;

statement : simplestatement ';'
        | loopStatement
		| condStatement
		| '{' statementlist '}' { $$ = $2; }
        ;
		
condStatement : IF '(' expression ')' statement ELSE statement { $$ = triple(IF,$3,$5,$7); }
		| IF '(' expression ')' statement { $$ = triple(IF,$3,$5,NULL); }
		;
		
loopStatement : whileStatement;
			  | forStatement 
		;
		
forStatement :	FOR '(' simplestatement ';' expression ';' expression ')' statement { $$ = quad(FOR,$3,$5,$7,$9); }
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

nodeType* leaf(int type, char* value) {
	nodeType* node;
	
	if((node = malloc(sizeof(nodeType))) == NULL)
		yyerror("No memory left");
		
	node->type = constType;
	
	node->const.type = type;
	strcpy(node->const.value, value);
	return node;
}

nodeType* iden(int type, int value) {
	nodeType* node;
	
	if((node = malloc(sizeof(nodeType))) == NULL)
		yyerror("No memory left");
		
	node->type = idType;

	node->id.type = type;
	node->id.value = value;
	
	return node;
}


nodeType* operand(int oper, int nops, ...) {
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
	fprintf(stdout, "%s\n", error);
}

int main(void) {
	yyparse();
	return 0;
}