all:
	happy -gca MIML/Par.y
	alex -g MIML/Lex.x
	ghc --make MIML/Test.hs -o MIML/Test

clean:
	-rm -f MIML/*.log MIML/*.aux MIML/*.hi MIML/*.o MIML/*.dvi

distclean: clean
	-rm -f MIML/Doc.* MIML/Lex.* MIML/Par.* MIML/Layout.* MIML/Skel.* MIML/Print.* MIML/Test.* MIML/Abs.* MIML/Test MIML/ErrM.* MIML/SharedString.* MIML/ComposOp.* MIML/MIML.dtd MIML/XML.* Makefile*
		-rmdir -p MIML/
