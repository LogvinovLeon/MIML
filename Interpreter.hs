{-#LANGUAGE GADTs#-}
module Interpreter where

import Control.Monad.Reader
import MIML.Abs
import qualified Data.Map as Map
import Data.Maybe


data Value where 
    Int :: Integer -> Value
    Bool :: Bool -> Value
    List :: [Value] -> Value
    Fun :: Ident -> Exp -> Env -> Value deriving (Show)

type Env = Map.Map Ident Value

getInt :: Exp -> Reader Env Integer
getInt e = do
    x <- eval e
    return $ case x of
        Int c -> c
        s -> error $ "Type error. Integer required: " ++ show s

getList :: Exp -> Reader Env [Value]
getList e = do
    x <- eval e
    return $ case x of
        List c -> c
        s -> error $ "Type error. List required: " ++ show s

evalOp :: Exp -> Exp -> (Integer -> Integer -> Integer) -> Reader Env Value
evalOp e1 e2 f = do
    lhs <- getInt e1
    rhs <- getInt e2
    return (Int (lhs `f` rhs))

evalBOp :: Exp -> Exp -> (Integer -> Integer -> Bool) -> Reader Env Value
evalBOp e1 e2 f = do
    lhs <- getInt e1
    rhs <- getInt e2
    return $ Bool $ lhs `f` rhs

eval :: Exp -> Reader Env Value
eval (EInt v) = return (Int v)
eval (EVar x) = do
    env <- ask
    case Map.lookup x env of
        Just v -> return v
        Nothing -> error $ "Variable is undefined: " ++ show x
eval (ELet x el e) = do
    val <- eval el
    local (Map.insert x val) (eval e)
eval (EPlus e1 e2) = evalOp e1 e2 (+)
eval (EMinus e1 e2) = evalOp e1 e2 (-)
eval (ETimes e1 e2) = evalOp e1 e2 (*)
eval (EDiv e1 e2) = evalOp e1 e2 div
eval (EIf c t e) = do
    cond <- eval c
    case cond of
        Bool bc -> if bc then eval t else eval e
        f -> error $ "The condition used inside of if should be boolean: " ++ show f
eval (EEq e1 e2) = evalBOp e1 e2 (==)
eval (ENe e1 e2) = evalBOp e1 e2 (/=)
eval (ELe e1 e2) = evalBOp e1 e2 (<)
eval (EGe e1 e2) = evalBOp e1 e2 (>)
eval (ENeg e) = do
    val <- eval e
    case val of
        Int v -> return $ Int $ negate v
        Bool v -> return $ Bool $ not v
        f -> error $ "You can only negate integers or booleans, not functions: " ++ show f
eval ENil = return $ List []
eval (ECons h t) = do
    lt <- getList t
    x <- eval h
    return $ List $ x:lt
eval (EList es) = do
    env <- ask
    return $ List $ fmap (\e -> runReader (eval e) env) es
eval (EApp f e) = do
    env <- ask
    param <- eval e
    let Fun param_name body fun_env = case f of
                EVar x -> fromMaybe (error $ "Undefined function: " ++ show x) (Map.lookup x env)
                ff -> case runReader (eval ff) env of
                    fun@Fun{} -> fun
                    x -> error $ "You can only apply functions: " ++ show x
    let new_env = Map.insert param_name param fun_env
    return $ runReader (eval body) new_env
eval (EFun name param_names body e) = do
    env <- ask
    let newBody = foldr ELam body param_names
    let f = runReader (eval newBody) nEnv
        nEnv = Map.insert name f env
    local (const nEnv) (eval e)
eval (ELam param_name body) = do
    env <- ask
    return $ Fun param_name body env