# See Step 3 for more info on these commands

# clean
rm -f src/*.cm*

# shellscript-fu time!
sortedFiles=$(ocamldep -pp "refmt --print binary" -sort -ml-synonym .re src/*.re)
# should give: `src/myDep.re src/myDep2.re src/test.re`
argsForOcaml=$(echo "$sortedFiles" | sed "s/src\//-impl src\//g")
# should give: `-impl src/myDep.re -impl src/myDep2.re -impl src/test.re`

# The flags are the same ones used in step 2, plus:

# -g: enables stack trace, aka always, always have this flag turned on. Why this
#     flag isn't included by default is due to historical & slight performance
#     reasons (which don't matter anymore. Come on, stack traces!).
# -bin-annot: again, see
#             github.com/facebook/reason/wiki/OCaml-Ecosystem-Extensions-List.
#             This flag generates the .cmt files with the type info tools like
#             Merlin can use to provide you e.g. autocomplete and
#             jump-to-definition.

ocamlc -g -bin-annot -pp "refmt --print binary" -o ./out -I src/ $argsForOcaml

# Run!
./out
