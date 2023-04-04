# Project templates for [Nixie]

## DISCLAIMER

This documentation, and the templates specifications, are currently a work in progress and are subject to change.

---

## How do I use this?

These templates are automatically retrieved by [Nixie] when initializing a new project. This repository **does not** contain code intended to be used on its own.

## Structure of a template

Templates use a very hands-off process to initialize a repository for use with Nix flakes.

A template derivation must contain these directories:


### The `lib` directory

This directory is expected to contain a single executable: `lib/predicate`. This executable will be merged into the `.#predicates` flake to identify the project type in a repository.

The predicate will be run with the repository Nixie is being run in as the work directory, and no arguments.

The predicate **must** exit with code `0` if the repository contains files matching the template's build system (e.g. the `python` template looks for `pyproject.toml`).
The predicate **must** exit with a non-zero code otherwise.

The predicate **must not** create, delete or modify files in its work directory.


### The `bin` directory

This contains executables to be run when applying the template:

#### `bin/scan` - the dependency resolver
This executable will be run in one of two situations:

##### The `skel/flake.nix` contains references to `nixie-env` other than `nixie-env.tools`
In that case, `scan` will be run for each unique field of `nixie-env` referenced in `skel/flake.nix`, with the name of the field passed as a unique argument.

The executable is expected to scan the repository for potential dependencies, then return file paths (one per line) to be fed to [`nix-index`] . (e.g. `project.dependencies = [ "flit" ]` might cause the `python` template's `scan` to return `/lib/python3.10/site-packages/flit`).

##### The `skel/flake.nix` does not contain references to `nixie-env` other than `nixie-env.tools`
In that case, `scan` will be run **once** with no arguments, and is expected to run a flake-aware dependency resolver, and not return anything. (e.g. the `rust` template will run `nix run github:cargo2nix/cargo2nix/unstable`).


#### `bin/create` - the first-run initializer
This executable will be run **iff** the repository is being initialized from a template, **and** the predicate for that template is false. (e.g. when `nixie for python` is run and `pyproject.toml` does not exist)

This executable should perform interactive tasks to initialize the project (e.g. the `rust` template would run `cargo init`).

### The `skel` directory

This directory is expected to contain at least `flake.nix`, which **must** match certain properties.

Any other file or directory in `skel` will be copied as-is into the repository **iff** they do not already exist.



[Nixie]: https://github.com/nixie-dev/nixie
[`nix-index`]: https://github.com/bennofs/nix-index
