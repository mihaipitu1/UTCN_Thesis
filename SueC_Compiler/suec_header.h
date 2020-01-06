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
		constNodeType const;
		idNodeType id;
		operNodeType oper;
	}
} nodeType;

extern int hcSym[26];
extern int lcSym[26];