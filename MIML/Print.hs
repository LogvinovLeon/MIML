{-# LANGUAGE GADTs, TypeSynonymInstances, FlexibleInstances #-}
{-# OPTIONS_GHC -fno-warn-incomplete-patterns #-}
module MIML.Print where

-- pretty-printer generated by the BNF converter

import MIML.Abs
import Data.Char


-- the top-level printing method
printTree :: Print a => a -> String
printTree = render . prt 0

type Doc = [ShowS] -> [ShowS]

doc :: ShowS -> Doc
doc = (:)

render :: Doc -> String
render d = rend 0 (map ($ "") $ d []) "" where
  rend i ss = case ss of
    "["      :ts -> showChar '[' . rend i ts
    "("      :ts -> showChar '(' . rend i ts
    "{"      :ts -> showChar '{' . new (i+1) . rend (i+1) ts
    "}" : ";":ts -> new (i-1) . space "}" . showChar ';' . new (i-1) . rend (i-1) ts
    "}"      :ts -> new (i-1) . showChar '}' . new (i-1) . rend (i-1) ts
    ";"      :ts -> showChar ';' . new i . rend i ts
    t  : "," :ts -> showString t . space "," . rend i ts
    t  : ")" :ts -> showString t . showChar ')' . rend i ts
    t  : "]" :ts -> showString t . showChar ']' . rend i ts
    t        :ts -> space t . rend i ts
    _            -> id
  new i   = showChar '\n' . replicateS (2*i) (showChar ' ') . dropWhile isSpace
  space t = showString t . (\s -> if null s then "" else ' ':s)

parenth :: Doc -> Doc
parenth ss = doc (showChar '(') . ss . doc (showChar ')')

concatS :: [ShowS] -> ShowS
concatS = foldr (.) id

concatD :: [Doc] -> Doc
concatD = foldr (.) id

replicateS :: Int -> ShowS -> ShowS
replicateS n f = concatS (replicate n f)

-- the printer class does the job
class Print a where
  prt :: Int -> a -> Doc
  prtList :: Int -> [a] -> Doc
  prtList i = concatD . map (prt i)

instance Print a => Print [a] where
  prt = prtList

instance Print Char where
  prt _ s = doc (showChar '\'' . mkEsc '\'' s . showChar '\'')
  prtList _ s = doc (showChar '"' . concatS (map (mkEsc '"') s) . showChar '"')

mkEsc :: Char -> Char -> ShowS
mkEsc q s = case s of
  _ | s == q -> showChar '\\' . showChar s
  '\\'-> showString "\\\\"
  '\n' -> showString "\\n"
  '\t' -> showString "\\t"
  _ -> showChar s

prPrec :: Int -> Int -> Doc -> Doc
prPrec i j = if j<i then parenth else id


instance Print Integer where
  prt _ x = doc (shows x)


instance Print Double where
  prt _ x = doc (shows x)


instance Print Ident where
  prt _ (Ident i) = doc (showString ( i))



instance Print Exp where
  prt i e = case e of
    EIf exp1 exp2 exp3 -> prPrec i 1 (concatD [doc (showString "if"), prt 2 exp1, doc (showString "then"), prt 2 exp2, doc (showString "else"), prt 2 exp3, doc (showString "fi")])
    EEq exp1 exp2 -> prPrec i 3 (concatD [prt 4 exp1, doc (showString "=="), prt 4 exp2])
    ENe exp1 exp2 -> prPrec i 3 (concatD [prt 4 exp1, doc (showString "!="), prt 4 exp2])
    ELe exp1 exp2 -> prPrec i 3 (concatD [prt 4 exp1, doc (showString "<"), prt 4 exp2])
    EGe exp1 exp2 -> prPrec i 3 (concatD [prt 4 exp1, doc (showString ">"), prt 4 exp2])
    EPlus exp1 exp2 -> prPrec i 4 (concatD [prt 4 exp1, doc (showString "+"), prt 5 exp2])
    EMinus exp1 exp2 -> prPrec i 4 (concatD [prt 4 exp1, doc (showString "-"), prt 5 exp2])
    ETimes exp1 exp2 -> prPrec i 5 (concatD [prt 5 exp1, doc (showString "*"), prt 6 exp2])
    EDiv exp1 exp2 -> prPrec i 5 (concatD [prt 5 exp1, doc (showString "/"), prt 6 exp2])
    ENeg exp -> prPrec i 6 (concatD [doc (showString "-"), prt 7 exp])
    EApp id exps -> prPrec i 6 (concatD [prt 0 id, prt 7 exps])
    EVar id -> prPrec i 7 (concatD [prt 0 id])
    EInt n -> prPrec i 7 (concatD [prt 0 n])
    ELet id exp1 exp2 -> prPrec i 7 (concatD [doc (showString "let"), prt 0 id, doc (showString "="), prt 0 exp1, doc (showString "in"), prt 0 exp2, doc (showString "end")])
  prtList 7 [x] = (concatD [prt 7 x])
  prtList 7 (x:xs) = (concatD [prt 7 x, prt 7 xs])

