-- automatically generated by BNF Converter
module Main where


import           System.Environment (getArgs)
import           System.Exit        (die)
import           System.IO()

import           MIML.Abs
import           MIML.ErrM
import           MIML.Lex
import           MIML.Par
import           MIML.Print()
import           MIML.Skel()
import Interpreter
import Control.Monad.Reader
import qualified Data.Map as Map

type ParseFun a = [Token] -> Err a


runFile :: FilePath -> IO ()
runFile f = putStrLn f >> readFile f >>= run

run :: String -> IO ()
run s = let ts = myLexer s in case pExp ts of
           Bad err    -> error err
           Ok  tree -> print $ runReader (eval tree) iEnv
                            where iEnv = Map.fromList [(Ident "true", Bool True), 
                                                       (Ident "false", Bool False)]

main :: IO ()
main = do
  args <- getArgs
  if null args then do
    contents <- getContents
    run contents
  else do
    input <- readFile (head args)
    run input
