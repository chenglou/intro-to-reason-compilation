# See previous step for the explanations of compiling & linking.

# Clean
rm -rf _build

# First, build the third-party dependency! Notice that This is mostly the same
# as building our first-party code. We could have deduped most of this logic
# too.
mkdir -p _build/muffin
muffinSortedFiles=$(ocamldep -pp "refmt --print binary" -sort -ml-synonym .re node_modules/muffin/*.re)
# should give: node_modules/muffin/secret.re node_modules/muffin/muffin.re
for source in $muffinSortedFiles
do
  destination=$(echo $source | sed "s/node_modules/_build/" | sed "s/\.re$//")
  # should give: _build/muffin/secret then _build/muffin/muffin
  ocamlc -g -bin-annot -pp "refmt --print binary" -o $destination -I _build/muffin -c -impl $source
done

# Now build ourselves. Same as previous section
mkdir -p _build/self
selfSortedFiles=$(ocamldep -pp "refmt --print binary" -sort -ml-synonym .re src/*.re)
# should give: src/myDep.re src/myDep2.re src/test.re
for source in $selfSortedFiles
do
  destination=$(echo $source | sed "s/src/_build\/self/" | sed "s/\.re$//")
  # should give: _build/self/myDep then _build/self/myDep2 then _build/self/test
  ocamlc -g -bin-annot -pp "refmt --print binary" -o $destination -I _build/muffin \
    -I _build/self -c -impl $source
done

# Link. Note that we need to pass *all* the cmos in order, including third-party
# ones. This goes against good abstractions and becomes burdensome for many
# dependencies; the solution is library files (.cma), which, for the sake of
# brevity, we won't talk about here.
muffinSortedArtifacts=$(echo $muffinSortedFiles | sed "s/node_modules/_build/g" | sed "s/\.re/\.cmo/g")
# should give: _build/muffin/secret.cmo _build/muffin/muffin.cmo
selfSortedArtifacts=$(echo $selfSortedFiles | sed "s/src/_build\/self/g" | sed "s/\.re/\.cmo/g")
# should give: _build/self/myDep.cmo _build/self/myDep2.cmo _build/self/test.cmo
ocamlc -o _build/out -I _build/muffin/ -I _build/self $muffinSortedArtifacts $selfSortedArtifacts

# Run. Modify node_modules/muffin/secret.re and see your changes reflected!
./_build/out
