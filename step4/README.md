# 4 - Small Break; Add Miscellaneous Files

Check point! This step will set up some common tools you'd use during Reason's development.

- [Merlin](https://github.com/the-lambda-church/merlin): check out the description [here](https://github.com/the-lambda-church/merlin/wiki/project-configuration). We're writing a small `.merlin` file in this step. Read through the comments in the file; they're helpful.

- Reason has [editor support](http://facebook.github.io/reason/tools.html#merlin) for Atom, Vim, Emacs, etc. using Merlin. They're very nice-to-haves.

- Ultimately, Reason will provide you an opinionated, but optional build system that takes care of generating everything you're learning here. The point of an opinionated build system is to:
  - Enable a hassle-free onboarding experience, so that people don't have to fit the whole ecosystem & tooling & workflow in their head before starting their first `.re` file.
  - Enable nice features that are otherwise hard to have in an agnostic build & tooling ecosystem. For example, if your directory structure abides by some format we prefer, then we can make the documentation, repl bootstraping, merlin and the rest work together.
