all:
	cd src && bnfc -m --haskell-gadt -d --ghc MIML.cf
	sed --in-place '4d' src/Makefile
	cd src && make

clean:
	rm -rf src/MIML src/Makefile
