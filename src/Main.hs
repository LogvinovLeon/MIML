module Main where

import MIML.Lex
import MIML.Par
import MIML.Abs
import Interpreter
import MIML.ErrM

main = do
	interact miml
	putStrLn ""
	
miml s =
	let Ok e = pProg $ myLexer s
	in show $ iProg e
