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
sortedFiles=$(ocamldep -pp "refmt --print binary" -sort -ml-synonym .re src/*.re)
# should give: `src/myDep.re src/myDep2.re src/test.re`
argsForOcaml=$(echo "$sortedFiles" | sed "s/src\//-impl src\//g")
# should give: `-impl src/myDep.re -impl src/myDep2.re -impl src/test.re`

# The flags are the same ones used in step 2.
ocamlc -pp "refmt --print binary" -o ./out -I src/ $argsForOcaml

# Run!
./out
