import YAML

function get_sim_params(ARGS)

    path = ARGS[1]
    data = YAML.load(open(path))

    key = "grid"
    Nx = data[key]["nx"]
    Ny = data[key]["ny"]

    key = "numerics"
    NPROCX = data[key]["nprocx"]
    NPROCY = data[key]["nprocy"]
    MAX_STEPS = data[key]["max_steps"]
    Dt = data[key]["dt"]
    TOL = data[key]["tol"]

    key = "output"
    filename = data[key]["filename"]
    workdir = dirname(path)
    output_path = joinpath(workdir, basename(filename))

    println()
    println("Loading: ", path)
    println("Output: ", output_path)

    return Int64[Nx, Ny, NPROCX, NPROCY, MAX_STEPS], Float64[Dt, TOL], output_path

end
