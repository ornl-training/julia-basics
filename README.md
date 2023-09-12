# julia-basics

Tutorial material for Julia basic training using [from zero to Julia](https://techytok.com/from-zero-to-julia/) content as Jupyter Notebooks to distribute reproducible code.

Run on mybinder.org:

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/ornl-training/julia-basics.git/main?labpath=notebooks)

Run locally:

Requirements:

1. Julia > v1.6
2. IJulia
3. conda
4. Jupyter Lab

```
$ git clone https://github.com/ornl-training/julia-basics.git
$ cd julia-basics
$ julia --project -e "import Pkg; Pkg.instantiate()"
$ conda activate
(base) $ cd notebooks
(base) $ jupyter-lab
```

See `Project.toml` for required Julia packages
