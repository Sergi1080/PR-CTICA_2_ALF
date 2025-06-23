simp:	simp.tab.c simp.lex.c
	gcc -o simp simp.tab.c lex.yy.c -lm
simp.tab.c:	simp.y
	bison -dv simp.y
simp.lex.c:	simp.l
	flex simp.l
clean:
	rm  simp.tab.c simp.tab.h simp.output lex.yy.c simp
