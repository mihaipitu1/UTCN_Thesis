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
	switch(p->const.type) {
		case NUM: return atoi(p->const.value);
		case WORD: return p->const.value;
	}
	return 0;
}

int execute_id(nodeType *p) {
	switch(p->id.type) {
		case HCVAR: return hcSym[p->id.value];
		case LCVAR: return lcSym[p->id.value];
	}
	return 0;
}

int execute_oper(nodeType *p) {
	switch(p->oper.oper) {
		//main keywords
	case FOR: for(execute_node(p->oper.op[0]);execute_node(p->oper.op[1]);execute_node(p->oper.op[2]))
				execute_node(p->oper.op[3]);
			  return 0;
	case WHILE: while(execute_node(p->oper.op[0]))
				execute_node(p->oper.op[1]);
			  return 0;
	case IF: if(execute_node(p->oper.op[0]))
				execute_node(p->oper.op[1]);
			 else if(p->oper.nops>2)
				execute_node(p->oper.op[2]);
			 return 0;
	case READ: scanf("%d", &execute_node(p->oper.op[0]));
			 return 0;
	case WRITE: printf("%d\n", execute_node(p->oper.op[0]));
			 return 0;
		//main operations
	case ';': execute_node(p->oper.op[0]);
			 return execute_node(p->oper.op[1]);
	case '=': return execute_node(p->oper.op[0]) = execute_node(p->oper.op[1]);	
	case '+': return execute_node(p->oper.op[0]) + execute_node(p->oper.op[1]);
	case '-': return execute_node(p->oper.op[0]) - execute_node(p->oper.op[1]);
	case '*': return execute_node(p->oper.op[0]) * execute_node(p->oper.op[1]);
	case '/': return execute_node(p->oper.op[0]) / execute_node(p->oper.op[1]);
	case '<': return execute_node(p->oper.op[0]) < execute_node(p->oper.op[1]);
	case '>': return execute_node(p->oper.op[0]) > execute_node(p->oper.op[1]);
	case GE: return execute_node(p->oper.op[0]) >= execute_node(p->oper.op[1]);
	case LE: return execute_node(p->oper.op[0]) <= execute_node(p->oper.op[1]);
	case NE: return execute_node(p->oper.op[0]) != execute_node(p->oper.op[1]);
	case EQ: return execute_node(p->oper.op[0]) == execute_node(p->oper.op[1]);
	}
	return 0;
}
