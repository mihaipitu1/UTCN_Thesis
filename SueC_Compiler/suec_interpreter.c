#include <stdio.h>
#include "suec_header.h"
#include "y.tab.h"

extern FILE* yyin;
 
int execute_node(nodeType *p) {
	if(!p) return 0;
	switch(p->type) {
		case constType: return execute_const(p);
		case idType: return execute_id(p);
		case operType: return execute_oper(p);
	}
	return 0;
}

int execute_const(nodeType *p) {
	switch(p->constant.type) {
		case NUM: fprintf(stdout,"Got in NUM\n");return p->constant.iValue;
		case WORD: fprintf(stdout,"Got in WORD\n");return p->constant.sValue;
	}
	return 0;
}

int execute_id(nodeType *p) {
	switch(p->id.type) {
		case HCVAR: fprintf(stdout,"Got in HCVAR\n");return hcSym[p->id.value];
		case LCVAR: fprintf(stdout,"Got in LCVAR\n");return lcSym[p->id.value];
	}
	return 0;
}

int execute_oper(nodeType *p) {
	char ch;
	int exec;
	if(!p)
	{
		fprintf(stdout,"Got an error here");
		return 0;
	}
	switch(p->oper.oper) {
		//main keywords
	case FOR: fprintf(stdout,"Got in FOR\n"); 
			 for(execute_node(p->oper.op[0]);execute_node(p->oper.op[1]);execute_node(p->oper.op[2]))
				execute_node(p->oper.op[3]);
			  return 0;
	case WHILE: fprintf(stdout,"Got in WHILE\n"); 
			  while(execute_node(p->oper.op[0]))
				execute_node(p->oper.op[1]);
			  return 0;
	case IF: fprintf(stdout,"Got in IF\n");
			 if(execute_node(p->oper.op[0]))
				execute_node(p->oper.op[1]);
			 else if(p->oper.nops>2)
				execute_node(p->oper.op[2]);
			 return 0;
	case READ: fprintf(stdout,"Got in READ\n");
			 fscanf(yyin,"%d", execute_node(p->oper.op[0]));
			 return 0;
	case WRITE: fprintf(stdout,"Got in WRITE\n");
				fprintf(stdout,"%d\n", execute_node(p->oper.op[0]));
			 return 0;
		//main operations
	case '=': fprintf(stdout,"Got in =\n");
			  ch = execute_node(p->oper.op[0]);
			  exec = execute_node(p->oper.op[1]);
			  return ch = exec;	
	case '+': fprintf(stdout,"Got in +\n");return execute_node(p->oper.op[0]) + execute_node(p->oper.op[1]);
	case '-': fprintf(stdout,"Got in -\n");return execute_node(p->oper.op[0]) - execute_node(p->oper.op[1]);
	case '*': fprintf(stdout,"Got in *\n");return execute_node(p->oper.op[0]) * execute_node(p->oper.op[1]);
	case '/': fprintf(stdout,"Got in /\n");return execute_node(p->oper.op[0]) / execute_node(p->oper.op[1]);
	case '<': fprintf(stdout,"Got in <\n");return execute_node(p->oper.op[0]) < execute_node(p->oper.op[1]);
	case '>': fprintf(stdout,"Got in >\n");return execute_node(p->oper.op[0]) > execute_node(p->oper.op[1]);
	case GE: fprintf(stdout,"Got in GE\n");return execute_node(p->oper.op[0]) >= execute_node(p->oper.op[1]);
	case LE: fprintf(stdout,"Got in LE\n");return execute_node(p->oper.op[0]) <= execute_node(p->oper.op[1]);
	case NE: fprintf(stdout,"Got in NE\n");return execute_node(p->oper.op[0]) != execute_node(p->oper.op[1]);
	case EQ: fprintf(stdout,"Got in EQ\n");return execute_node(p->oper.op[0]) == execute_node(p->oper.op[1]);
	}
	return 0;
}
