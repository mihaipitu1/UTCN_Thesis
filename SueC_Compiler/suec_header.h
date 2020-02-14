typedef enum { constType, idType, operType } nodeEnum;

typedef struct {
	int type;
	char* value;
} constNodeType;

typedef struct {
	int type;
	int value;
} idNodeType;

typedef struct {
	int oper;
	int nops;
	struct nodeTypeTag **op;
} operNodeType;

typedef struct nodeTypeTag {
	nodeEnum type;
	
	union {
		constNodeType constant;
		idNodeType id;
		operNodeType oper;
	}
} nodeType;

int hcSym[26];
int lcSym[26];