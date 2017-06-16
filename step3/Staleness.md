# For Your Curiosity Only

Skip if you aren't interested in this!

Here's a typical pitfall scenario that happens when the artifacts aren't cleaned correctly. This happens to lots of projects, in most programming languages & build tools.

See the artifacts in `src/`? `myDep.cmo`, and all. Do the following:

```sh
rm -f src/*.cm*
ocamlc -pp refmt -o ./out -I src/ -impl src/myDep2.re -impl src/myDep.re -impl src/test.re
```

You'll get the error message:

```
File "src/myDep2.re", line 1, characters 13-25:
Error: Unbound module MyDep
```

If you've read the comments in `run.sh`, you'd know why this happens. We've compiled `myDep.re` and `myDep2.re` in the wrong order! Now, re-compile in the right order:

```sh
rm -f src/*.cm*
ocamlc -pp refmt -o out -I src/ -impl src/myDep.re -impl src/myDep2.re -impl src/test.re
```

Everything fine. Now, *without* cleaning the stale artifacts, recompile in the wrong order!

```sh
ocamlc -pp refmt -o ./out -I src/ -impl src/myDep2.re -impl src/myDep.re -impl src/test.re
```

Output:

```
Error: Error while linking src/myDep2.cmo:
Reference to undefined global `MyDep'
```

Why is the error different now?

`ocamlc` has a compilation step, and a linking step, roughly speaking. Until now, we've used some `ocamlc` shorthands to do both in one shot.

The compilation step takes each file and compiles. *TODO: explain why this happens*.

Moral of the story: use a good build system ([*cough*](http://bucklescript.github.io/bucklescript/Manual.html#_bucklescript_build_system_code_bsb_code)) or debug the dependency graph yourself... =)
