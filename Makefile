simp:	simp.l
	flex simp.l
	gcc -o simp lex.yy.c
clean:
	rm -rf lex.yy.c simp
