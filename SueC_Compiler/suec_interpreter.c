#include <stdio.h>
#include "suec_header.h"
#include "y.tab.h"

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
		case NUM: printf("Got in NUM\n");return atoi(p->constant.value);
		case WORD: printf("Got in WORD\n");return p->constant.value;
	}
	return 0;
}

int execute_id(nodeType *p) {
	switch(p->id.type) {
		case HCVAR: printf("Got in HCVAR\n");return hcSym[p->id.value];
		case LCVAR: printf("Got in LCVAR\n");return lcSym[p->id.value];
	}
	return 0;
}

int execute_oper(nodeType *p) {
	char ch;
	int exec;
	if(!p)
	{
		printf("Got an error here");
		return 0;
	}
	switch(p->oper.oper) {
		//main keywords
	case FOR: printf("Got in FOR\n"); 
			 for(execute_node(p->oper.op[0]);execute_node(p->oper.op[1]);execute_node(p->oper.op[2]))
				execute_node(p->oper.op[3]);
			  return 0;
	case WHILE: printf("Got in WHILE\n"); 
			  while(execute_node(p->oper.op[0]))
				execute_node(p->oper.op[1]);
			  return 0;
	case IF: printf("Got in IF\n");
			 if(execute_node(p->oper.op[0]))
				execute_node(p->oper.op[1]);
			 else if(p->oper.nops>2)
				execute_node(p->oper.op[2]);
			 return 0;
	case READ: printf("Got in READ\n");
			 scanf("%d", execute_node(p->oper.op[0]));
			 return 0;
	case WRITE: printf("Got in WRITE\n");
				printf("%d\n", execute_node(p->oper.op[0]));
			 return 0;
		//main operations
	case ';': execute_node(p->oper.op[0]);
			  return execute_node(p->oper.op[1]);
	case '=': printf("Got in =\n");
			  ch = execute_node(p->oper.op[0]);
			  exec = execute_node(p->oper.op[1]);
			  return ch = exec;	
	case '+': printf("Got in +\n");return execute_node(p->oper.op[0]) + execute_node(p->oper.op[1]);
	case '-': printf("Got in -\n");return execute_node(p->oper.op[0]) - execute_node(p->oper.op[1]);
	case '*': printf("Got in *\n");return execute_node(p->oper.op[0]) * execute_node(p->oper.op[1]);
	case '/': printf("Got in /\n");return execute_node(p->oper.op[0]) / execute_node(p->oper.op[1]);
	case '<': printf("Got in <\n");return execute_node(p->oper.op[0]) < execute_node(p->oper.op[1]);
	case '>': printf("Got in >\n");return execute_node(p->oper.op[0]) > execute_node(p->oper.op[1]);
	case GE: printf("Got in GE\n");return execute_node(p->oper.op[0]) >= execute_node(p->oper.op[1]);
	case LE: printf("Got in LE\n");return execute_node(p->oper.op[0]) <= execute_node(p->oper.op[1]);
	case NE: printf("Got in NE\n");return execute_node(p->oper.op[0]) != execute_node(p->oper.op[1]);
	case EQ: printf("Got in EQ\n");return execute_node(p->oper.op[0]) == execute_node(p->oper.op[1]);
	}
	return 0;
}
