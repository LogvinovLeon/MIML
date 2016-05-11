# MIML (good/Mini Interpreted ML) or (good/MIM Language) or (good/Mega Interpreter Made by Leon)

MIML is a simple functional language with the syntax similar to Standard ML.
The intention was that it will meet all the requirements for 24 points and use Hindley-Miller algorithm for type inference, but it's not present in the first version. I'll update it later

It requires ghc >= 7.10 to run, but it's installed on students and Makefile knows about it.
Simple `make` will be enough.
You can also run `test.sh` which runs all tests.

Currently it supports:
* Integers, Booleans, Lists and functions as types
[bool_result](good/bool_result.miml) [function_result](good/function_result.miml)
* Let _ in [let](good/let.miml) [let_area](good/let_area.miml)
* Functions with recursion and application [application](good/application.miml) [fact](good/fact.miml)
* Multi parameter functions [multi_parameter_function](good/multi_parameter_function.miml)
* Arithmetic [let_area](good/let_area.miml) [fact](good/fact.miml) [double_unary_minus](good/double_unary_minus.miml)
* Comparasions [fact](good/fact.miml)
* Currying [partially_apply](good/partially_apply.miml)
* High-order functions [high_order](good/high_order.miml) [map](good/map.miml)
* Lists with syntax sugar, cons & nil [list](good/list.miml) [nil_cons](good/nil_cons.miml)
* If's [if](good/if.miml)
* Functions in functions [lambda](good/lambda.miml) [partially_apply](good/partially_apply.miml)
* Lists of functions [list](good/list.miml)
* Lambdas (only single parameter) [lambda](good/lambda.miml)

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
