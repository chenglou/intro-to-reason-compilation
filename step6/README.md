# 6 - Add a Third-Party Dependency

Thanks to our previous step, adding a new dependency is easy.

The OCaml compiler is package manager-agnostic. [OPAM](https://opam.ocaml.org) is the common one used by the community. Though if you're reading this tutorial, you likely know how to use [npm](https://www.npmjs.com). Good news: we support that as well. This tutorial will focus on the latter.

Usually we'd write a package.json here and let you do `npm install` to install all the dependencies into `./node_modules`; for the sake of simplicity, we're gonna hardcode a dependency (check it out, it's only two files). You get the idea.

We'll also make the corresponding additions to `.merlin`.
