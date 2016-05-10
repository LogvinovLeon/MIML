all:
	bnfc --haskell-gadt -d --ghc MIML.cf
	happy -gca MIML/Par.y
	alex -g MIML/Lex.x
	ghc --make MIML/Test.hs -o MIML/Test
	ghc --make Interpreter.hs -o interpreter
clean:
