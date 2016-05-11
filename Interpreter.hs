{-#LANGUAGE GADTs#-}
module Interpreter where

import Control.Monad.Reader
import MIML.Abs
import qualified Data.Map as Map
import Foreign.Marshal.Utils
import Data.Maybe


data Value where 
    Val :: Integer -> Value
    Fun :: Ident -> Exp -> Env -> Value deriving (Show)

type Env = Map.Map Ident Value

evalOp :: Exp -> Exp -> (Integer -> Integer -> Integer) -> Reader Env Value
evalOp e1 e2 f = do
    Val lhs <- eval e1
    Val rhs <- eval e2
    return (Val (lhs `f` rhs))

evalBOp :: Exp -> Exp -> (Integer -> Integer -> Bool) -> Reader Env Value
evalBOp e1 e2 f = do
    Val lhs <- eval e1
    Val rhs <- eval e2
    return $ Val $ fromBool $ lhs `f` rhs

eval :: Exp -> Reader Env Value
eval (EInt v) = return (Val v)
eval (EVar x) = do
    env <- ask
    case Map.lookup x env of
        Just v -> return v
        Nothing -> error "Variable is undefined"

eval (ELet x el e) = do
    val <- eval el
    local (Map.insert x val) (eval e)
eval (EPlus e1 e2) = evalOp e1 e2 (+)
eval (EMinus e1 e2) = evalOp e1 e2 (-)
eval (ETimes e1 e2) = evalOp e1 e2 (*)
eval (EDiv e1 e2) = evalOp e1 e2 div
eval (EIf c t e) = do
    Val cond <- eval c
    if toBool cond then eval t else eval e
eval (EEq e1 e2) = evalBOp e1 e2 (==)
eval (ENe e1 e2) = evalBOp e1 e2 (/=)
eval (ELe e1 e2) = evalBOp e1 e2 (<)
eval (EGe e1 e2) = evalBOp e1 e2 (>)
eval (ENeg e) = do
    Val v <- eval e
    return $ Val $ negate v
eval (EApp f e) = do
    env <- ask
    param <- eval e
    let Fun param_name body fun_env = case f of
                EVar x -> fromMaybe (error $ "Undefined function: " ++ show x) (Map.lookup x env)
                ff -> case runReader (eval ff) env of
                    fun@Fun{} -> fun
                    Val x -> error $ "You can only apply functions, not plane value: " ++ show x 
    let new_env = Map.insert param_name param fun_env
    return $ runReader (eval body) new_env
-- Ident -> Exp -> Env     ->      Value
eval (EFun name param_names body e) = do
    env <- ask
    let newBody = foldr ELam body param_names
    let f = runReader (eval newBody) nEnv
        nEnv = Map.insert name f env
    local (const nEnv) (eval e)
eval (ELam param_name body) = do
    env <- ask
    return $ Fun param_name body env