/* Note that `myDep.re` becomes the module `MyDep`. In OCaml and Reason syntax, a module is upper-cased. */

/* We now have 2 dependencies, where MyDep2 also depends on myDep. So the compilation order should be [myDep,
   myDep2, test] */
print_endline(MyDep.secret);
print_endline(MyDep2.secret);
