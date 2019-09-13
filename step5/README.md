# 5 - Preparation for Third-Party Dependencies

In preparation for the next step (third-party dependencies!), it'd be nice to
have a unified folder for the built artifacts, so that we:
- don't pollute third-party with intermediate compilation artifacts alongside
their source code
- can easily remove all artifacts by deleting a single folder

Additionally, we'll expand the naive compilation in `run.sh` into something slightly more sophisticated, and make the corresponding changes in `.merlin`.
