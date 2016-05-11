
# ghc=/home/students/inf/PUBLIC/MRJP/ghc-7.10.2/bin/ghc
ghc=ghc
all:
	bnfc --haskell -d --ghc MIML.cf
	happy -gca MIML/Par.y
	alex -g MIML/Lex.x
	${ghc} --make Main.hs -o interpreter

clean:
	rm -rf MIML
	rm interpreter *.o *.hi

