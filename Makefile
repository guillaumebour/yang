all: compiler

lex.yy.c: compiler.l
	./flex compiler.l

y.tab.c: compiler.y
	/home/revest/.local/bin/yacc -v -d compiler.y

compiler: lex.yy.c y.tab.c
	gcc -o compiler y.tab.c lex.yy.c libfl.a -ly -L/home/revest/.local/lib/
