# julia-basics

Tutorial material for Julia basic training using [from zero to Julia](https://techytok.com/from-zero-to-julia/) content as Jupyter Notebooks to distribute reproducible code.

Run locally:

Requirements:

1. Julia latest version (1.11+)
   - [Download Julia](https://julialang.org/downloads/)
2. VS Code
3. IJulia (already included in the project, no need to install separately)


## Quick start

```
$ git clone https://github.com/ornl-training/julia-basics.git
$ cd julia-basics
$ julia --project -e "import Pkg; Pkg.instantiate()"
```

1. Open the project directory in VS Code 
2. Open a notebook in the `notebooks` directory.
3. Select the Julia kernel in the top right corner of the notebook interface.
4. Run the cells in the notebook.

## Additional information

See `Project.toml` for required Julia packages

Run on mybinder.org (might be outdated, not recommended):

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/ornl-training/julia-basics.git/main?labpath=notebooks)
