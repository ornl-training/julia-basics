# Julia Distinctions Tutorial

1. Julia latest version (1.11+)
   - [Download Julia](https://julialang.org/downloads/)
2. VS Code
3. IJulia (already included in the project, no need to install separately)

## Quick Start

```
$ git clone https://github.com/ornl-training/julia-basics.git
$ cd julia-basics/distinctions
$ julia --project -e "import Pkg; Pkg.instantiate()"
```

<details>
  <summary><b>VS Code</b> (click to expand)</summary>

1. Open the project directory in VS Code
2. Open a notebook in the `distinctions` directory
3. Select the Julia kernel in the top right corner of the notebook interface
4. Run the cells in the notebook

</details>

<details>
  <summary><b>Directly in Browser</b> (click to expand)</summary>

1. Launch julia with "distinctions" environment
   ```sh
   cd julia-basics/distinctions
   julia --project=.
   ```
2. Launch notebook from Julia REPL
   ```julia
   using IJulia
   notebook(dir=".") # this might ask to install jupyter via conda
   ```
   This will launch a local jupyter instance in your default browser.

3. Open notebook(s) from browser.

</details>
