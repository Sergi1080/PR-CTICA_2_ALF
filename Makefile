eazy:	eazy.lex.c
	gcc -o eazy lex.yy.c
eazy.lex.c:	eazy.l
	flex eazy.l
clean:
	rm lex.yy.c eazy
