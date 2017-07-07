# Don't forget to run `npm install` beforehand!

# See previous step for the explanations of compiling & linking. Most of these
# lines are the same.

# Clean
rm -rf _build

# Our third-party dependency has a single file. For the sake of simplicity,
# we'll remove the previous step's looping logic. For reference, we still
# have the same loop logic below for our own files anyway.
mkdir -p _build/reason-js
# Notice that we've switched away `ocamlc` for `bsc` which works similarly to
# the former. There are a few extra flags here; the BS documentation explains
# them well: bucklescript.github.io/bucklescript/Manual.html#__bs_package_name



# Note: we're using the package name "self" because from our point of view,
# node_modules is really just another folder filled with files. This produces
# the right `require` calls in the output. Again, see the BS docs and feel free
# to fiddle with these options!
node_modules/bs-platform/bin/bsc.exe -g -bin-annot -pp "refmt --print binary" -bs-package-name self \
  -bs-package-output commonjs:_build/reason-js -o _build/reason-js/ReasonJs \
  -c -impl node_modules/reason-js/src/reasonJs.re

# Now build ourselves. Same as previous step.
mkdir -p _build/self
# We're adding the `-ppx` flag here (the rest is the same), because BuckleScript
# uses some ppx preprocessors (basically, macros with special treatment).
selfSortedFiles=$(ocamldep -ppx ./node_modules/bs-platform/bin/bsppx.exe -pp "refmt --print binary" -sort -ml-synonym .re src/*.re)
# should give: src/myDep.re src/myDep2.re src/test.re
# The flag -bs-files in `bsc` sorts the sources & compiles them, allowing us to
# avoid `ocamldep` in the future. It currently doesn't work with Reason files:
# https://github.com/bloomberg/bucklescript/issues/549

for source in $selfSortedFiles
do
  destination=$(echo $source | sed "s/src/_build\/self/" | sed "s/\.re$//")
  # should give: _build/self/myDep then _build/self/myDep2 then _build/self/test
  node_modules/bs-platform/bin/bsc.exe -g -bin-annot -pp "refmt --print binary" -bs-package-name self \
    -bs-package-output commonjs:_build/self -I _build/self -I _build/reason-js \
    -o $destination -c -impl $source
done

# no linking! BuckleScript maps 1 Reason/OCaml file to 1 JS file. Feel free to
# use your current JS module bundler (e.g. Browserify, Webpack)!

# Are you ready to run your JS output?
node ./_build/self/test.js
