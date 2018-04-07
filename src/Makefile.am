AM_CFLAGS = -W -Wall -Wextra -ansi
AM_CXXFLAGS = -W -Wall -Wextra -ansi

bin_PROGRAMS = yang

yang_SOURCES = \
	parser.y scanner.l parser.h scanner.h y.tab.h \
	asm_output.c asm_output.h logs.c logs.h options.c \
	options.h symbol_table.c symbol_table.h

yang_LDADD = -ly

BUILT_SOURCES = parser.h

AM_YFLAGS = -d

extraclean:
	rm -f parser.c parser.h scanner.c

rebuild: clean extraclean all
