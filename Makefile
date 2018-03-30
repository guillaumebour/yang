all: build build/compiler

build:
	mkdir -p build/

build/lex.yy.c: src/compiler.l
	flex -o build/lex.yy.c src/compiler.l

build/y.tab.c: src/compiler.y
	yacc -o build/y.tab.c -v -d src/compiler.y

build/compiler: build/lex.yy.c build/y.tab.c
	gcc -o build/compiler src/asm_output.c src/symbol_table.c src/logs.c \
		build/y.tab.c build/lex.yy.c -lfl -ly -Isrc/ -L/home/revest/.local/lib/

clean:
	rm -r build/
