# MIML (Mini Interpreted ML) or (MIM Language) or (Mega Interpreter Made by Leon)

MIML is a simple functional language with the syntax similar to Standard ML.
The intention is that it will meet all the requirements for 24 points and use Hindley-Miller algorithm for type inference.

It will support:
* Infinitely nested pattern matching
* Currying
* High-order functions
* Lists with syntax sugar
* Polymorphic types
* ADTs
* If's
* Functions in functions
* Lists of functions
* Exhaustiveness checking

It will not support:
* GADT's
* Existential types
* Rank >2 Types

#[BNF grammar](src/MIML.cf)
#[Formal syntax description](leonid_logvinov.pdf)
#Some examples of [correct programs](good)
#Some examples of [incorrect programs](bad)
