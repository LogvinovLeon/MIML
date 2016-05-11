# MIML (Mini Interpreted ML) or (MIM Language) or (Mega Interpreter Made by Leon)

MIML is a simple functional language with the syntax similar to Standard ML.
The intention was that it will meet all the requirements for 24 points and use Hindley-Miller algorithm for type inference, but it's not present in the first version. I'll update it later

It requires ghc >= 7.10 to run, but it's installed on students and Makefile knows about it.
Simple `make` will be enough.
You can also run `test.sh` which runs all tests.

Currently it supports:
* Integers, Booleans, Lists and functions as types
[bool_result](bool_result.miml) [function_result](function_result.miml)
* Let _ in [let](let.miml) [let_area](let_area.miml)
* Functions with recursion and application [application](application.miml) [fact](fact.miml)
* Multi parameter functions [multi_parameter_function](multi_parameter_function.miml)
* Arithmetic [let_area](let_area.miml) [fact](fact.miml) [double_unary_minus](double_unary_minus.miml)
* Comparasions [fact](fact.miml)
* Currying [partially_apply](partially_apply.miml)
* High-order functions [high_order](high_order.miml) [map](map.miml)
* Lists with syntax sugar, cons & nil [list](list.miml) [nil_cons](nil_cons.miml)
* If's [if](if.miml)
* Functions in functions [lambda](lambda.miml) [partially_apply](partially_apply.miml)
* Lists of functions [list](list.miml)
* Lambdas (only single parameter) [lambda](lambda.miml)

It will support in the next version:
* Builtin functions
* Multi parameter lambdas
* Polymorphic types
* ADTs
* Static type checking
* Pattern matching

It will not support:
* GADT's
* Existential types
* Rank > 2 Types

Error handling:
* I think, that error messages are quite good now, but I'll make them even better in future version

#[BNF grammar](MIML.cf)
#Some examples of [correct programs](good)
#Some examples of [incorrect programs](bad)
#Testing script [test.sh](test.sh)
