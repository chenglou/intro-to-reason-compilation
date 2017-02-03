# Move all tbe artifacts into _build/, so that we can have an emergency
# "wipe-the-world" clean
rm -rf _build

mkdir -p _build/self

# Time to split the `ocamlc` we've had so far into distinct steps. In reality,
# that single convenience `ocamlc` command is (roughly) composed of compiling,
# then linking. Compiling turns a source into an artifact, while checking that
# everything type-checks and that the dependencies are satisfied. Linking
# bundles the files together into a final executable.

# 1. Compiling

# Compiling each file separately has many future benefits. First, we can
# parallelize the compilation for better speed. Second, (thanks to OCaml's great
# module system that forms the compilation boundaries), we can safely skip
# recompiling sources whose dependencies's type signatures haven't changed!
# Heck, you can swap out entire implementations without recompiling dependents.
# Feel free to explore this vast domain! One link to get you started:
# stackoverflow.com/questions/9843378/ocaml-module-types-and-separate-compilation

selfSortedFiles=$(ocamldep -pp "refmt --print binary" -sort -ml-synonym .re src/*.re)
# should give: src/myDep.re src/myDep2.re src/test.re
for source in $selfSortedFiles
do
  destination=$(echo $source | sed "s/src/_build\/self/" | sed "s/\.re$//")
  # should give: _build/self/myDep then _build/self/myDep2 then _build/self/test
  # The only new flag here is `-c`, which says "compile, but don't link".
  ocamlc -g -bin-annot -pp "refmt --print binary" -o $destination -I _build/self -c -impl $source
done

# 2. Linking.

# We can drop the flags -pp, -impl, -bin-annot, etc. Linking doesn't need them.
# What we need are the `cmo` files, in the topological order (again, see
# github.com/facebook/reason/wiki/OCaml-Ecosystem-Extensions-List#the-list).
selfSortedArtifacts=$(echo $selfSortedFiles | sed "s/src/_build\/self/g" | sed "s/\.re/\.cmo/g")
# should give: _build/self/myDep.cmo _build/self/myDep2.cmo _build/self/test.cmo
ocamlc -o _build/out -I _build/self $selfSortedArtifacts

# Knowing the right compiling & linking command might be tricky and initially
# frustrating (if you ever link stuff manually for whatever reason, instead of
# using a proper build system). If you run into trouble, don't forget that we're
# always in IRC freenode #reasonml and gitter.im/facebook/reason

# Run!
./_build/out
