# 7 - Compile to JavaScript

Would you like some sweet, sweet interop with the JS ecosystem?

We're gonna use [BuckleScript](https://github.com/bloomberg/bucklescript), an OCaml-to-JS compiler that emits [really](https://github.com/bloomberg/bucklescript#output), [really](https://github.com/bloomberg/bucklescript-addons) clean output.

**Note** that BuckleScript comes with a great, one-click build system already, [bsb](http://bucklescript.github.io/bucklescript/Manual.html#_bucklescript_build_system_code_bsb_code). Again, this guide is just for the curious folks who'd like to know how things work under the hood.

We're gonna use real third-party dependencies this time around. Check the new package.json's `dependencies` field (a reason binding to JS functions) and `devDependencies` field (BuckleScript compiler). `npm install` in the current directory to get them.

Making this work is simple. See the updated `run.sh`. We've also made modifications to `.gitignore` and `.merlin`.

**Make sure you read the compiled output**. Yes, read it. Trust us on this one!
