# Before automate the compile step dependencies ordering, let's clean up the
# artifacts. We're naively cleaning all the artifacts before every compilation
# to make sure that, when the compilation order changes because of a dependency
# graph change, we don't pick up the stale, existing artifacts. If you're
# interested in knowing more, see Staleness.md for more info.

rm -f src/*.cm*

# Introducing `ocamldep`! It's a utility that ships with OCaml, which analyses
# the files and outputs them in the order of dependency (aka, a topological
# sort). If A depends on B then A will certainly come after B.

# -pp: same flag as `ocamlc`'s.
# -sort: among many functionalities of `ocamldep`, use the sorting feature.
# -ml-synonym: akin to `ocamlc`'s `-impl`. "If your source files don't end with
#              `ml`, tell me what they end with."

# shellscript-fu time!
sortedFiles=$(ocamldep -pp refmt -sort -ml-synonym .re src/*.re)
# should give: `src/myDep.re src/myDep2.re src/test.re`
argsForOcaml=$(echo "$sortedFiles" | sed "s/src\//-impl src\//g")
# should give: `-impl src/myDep.re -impl src/myDep2.re -impl src/test.re`

# Skip the comments below if you've already seen them.

# `ocamlc` is the OCaml bytecode compiler. You can optionally compile to a
# platform-dependent, but more optimized output (native code) through
# `ocamlopt`, whose usage is similar; we'll defer this to later.

# Explanations of compiler flags (when in doubt, there's always `ocamlc --help`)

# -pp: before processing the source file, pass it through a preprocessor. This
#      is a powerful that's at the heart of how the Reason syntax transform
#      works. We're basically taking a raw text file and piping it through our
#      custom lexer & parser, before handling over the valid OCaml abstract
#      syntax tree for actual compilation.
# -o: output file name.
# -impl: `ocamlc` recognizes, by default, `ml` files (and `mli`, which we'll
#        talk about later). Reason uses new file extensions, `re` (and `rei`).
#        In order to make `ocamlc` understand that `.re` is a normal source file
#        equivalent to a `.ml`, we pass the `impl` flag, meaning "this is an
#        implementation file" (as opposed to an interface file, `mli/rei`).
# -I: "search in that directory for dependencies". You may wonder why this is
#     necessary, given that we've already passed both files to the compiler.
#     Doesn't it already know where the sources are? It doesn't. In reality,
#     we're really just compiling two files independently, one another another,
#     in the specified order. You can imagine a parallelized build system which
#     invokes two separate `ocamlc` commands, one for each `.re` respectively.
#     In this case, the compiler wouldn't know about these source files since
#     they're not compiled together anymore.
#     The order of compilation is important! if you place `-impl src/test.re`
#     before `-impl src/myDep.re`, you'll get an error saying "Reference to
#     undefined global `MyDep'". `myDep.re` has to be compiled first. We're
#     effectively manually soring the dependency graph (a topological sort)
#     right now. We'll change that soon.

ocamlc -pp refmt -o _build/out -I src/ $argsForOcaml

# Run!
_build/out
