all:
	bnfc --haskell -d --ghc MIML.cf
	happy -gca MIML/Par.y
	alex -g MIML/Lex.x
	ghc --make MIML/Test.hs -o MIML/Test
	ghc --make Main.hs -o interpreter

clean:
	rm -rf MIML
	rm interpreter Main.o Main.hi

