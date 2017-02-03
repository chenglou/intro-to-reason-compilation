# `ocamlc` is the OCaml bytecode compiler. You can optionally compile to a
# platform-dependent, but more optimized output (native code) with `ocamlopt`,
# whose usage is similar; we'll defer this to later.

# Explanations of compiler flags (when in doubt, there's always `ocamlc --help`)

# -pp: before processing the source file, pass it through a preprocessor. This
#      is a powerful feature that's at the heart of how the Reason syntax
#      transform works. We're basically taking a raw text file and piping it
#      through our custom lexer & parser, before handling over the valid OCaml
#      abstract syntax tree for actual compilation. For Reason's `refmt`
#      command, `refmt --print binary` prints the binary AST.
# -o: output file name.
# -impl: `ocamlc` recognizes, by default, `ml` files (and `mli`, which we'll
#        talk about later). Reason uses new file extensions, `re` (and `rei`).
#        In order to make `ocamlc` understand that `.re` is a normal source file
#        equivalent to a `.ml`, we pass the `impl` flag, meaning "this is an
#        implementation file" (as opposed to an interface file, `mli/rei`).
ocamlc -pp "refmt --print binary" -o ./out -impl src/test.re

# Run!
./out
