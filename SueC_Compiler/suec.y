%{
#include "header.h"
int variables[26];
%}

%union {
	int ivalue;
	char variable;
	char* word;
	struct nnode *np;
};

%token INT STRING
%token IF ELSE FOR WHILE
%token READ WRITE

%token <iValue> NUM
%token <variable> VAR
%token <word> WORD

%left GE LE EQ NE '>' '<'
%left '+' '-'
%left '*' '/'

%%

program : program statement	{ execute($2); freeall($2); }
	| program error ';'	{ yyerrok; }
	| /* NULL */
	;

statement : simplestatement ';'
        | WHILE '(' expression ')' statement { $$ = node(WHILE, $3, $5); }
		| FOR '('simplestatement ';' expression ';' expression ')' statement { $$ = quad(FOR,$2,$4,$6,$8); }
		| IF '(' expression ')' statement ELSE statement { $$ = triple(IF,$3,$5,$7); }
		| IF '(' expression ')' statement { $$ = triple(IF,$3,$5,NNULL); }
		| '{' statementlist '}' { $$ = $2; }
        ;

statementlist : statement
              | statementlist statement	{ $$ = node(';', $1, $2); }
              ;

simplestatement : expression
                | WRITE expression		{ $$ = node(WRITE,$2,NNULL); }
				| VAR '=' expression	{ $$ = node('=', $1, $3); }
				;

expression : NUM			{ $$ = leaf(NUM, $1); }
	   | INT VAR			{ $$ = leaf(INT, VAR); }
	   | STRING VAR			{ $$ = leaf(STRING, VAR); }
	   | expression '+' expression	{ $$ = node('+', $1, $3); }
	   | expression '-' expression	{ $$ = node('-', $1, $3); }
	   | expression '*' expression	{ $$ = node('*', $1, $3); }
	   | expression '/' expression	{ $$ = node('/', $1, $3); }
	   | expression '<' expression	{ $$ = node('<', $1, $3); }
	   | expression '>' expression	{ $$ = node('>', $1, $3); }
	   | expression GE expression	{ $$ = node(GE, $1, $3); }
	   | expression LE expression	{ $$ = node(LE, $1, $3); }
	   | expression NE expression	{ $$ = node(NE, $1, $3); }
	   | expression EQ expression	{ $$ = node(EQ, $1, $3); }
	   | '(' expression ')'		{ $$ = $2; }
	   ;

%%

