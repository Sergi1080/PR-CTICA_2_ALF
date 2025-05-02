eazy:	eazy.tab.c eazy.lex.c
	gcc -o eazy eazy.tab.c lex.yy.c
eazy.tab.c:	eazy.y
	bison -dv eazy.y
eazy.lex.c:	eazy.l
	flex eazy.l
clean:
	rm  eazy.tab.c eazy.tab.h eazy.output lex.yy.c eazy
