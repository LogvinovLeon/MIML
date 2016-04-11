all:
	cd src && bnfc -m --haskell-gadt -d --ghc MIML.cf
	#sed --in-place '4d' src/Makefile
	cd src && make
	cd src && bnfc --latex -o doc MIML.cf
	cd src/doc && pdflatex MIML.tex

clean:
	rm -rf src/MIML src/Makefile src/doc
	cabal clean
