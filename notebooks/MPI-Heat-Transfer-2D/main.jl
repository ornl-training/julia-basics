import MPI

include("types.jl")
include("init.jl")
include("get_sim_params.jl")
include("update.jl")
include("io.jl")
include("get_sim_params.jl")


function main()
    #MPI Initialization
    MPI.Init()
    comm = MPI.COMM_WORLD
    my_id = MPI.Comm_rank(comm)
    nproc = MPI.Comm_size(comm)
    println("Number of MPI processes: ", nproc)
    
    #temp1_init: temperature init on borders
    temp1_init = 10.0
    #temp2_init: temperature init inside domain
    temp2_init = -10.0
    #diffusion coefficient
    k0 = Float64(1)

    #define rank of root process
    root = 0

    #simulation parameters
    params_int = Array{Int64}(undef, 5)
    params_double = Array{Float64}(undef, 2)
    if (my_id == root)
        params_int, params_double, output_path = get_sim_params(ARGS)
    end

    MPI.Barrier(comm)
    MPI.Bcast!(params_int, 5, 0, comm)
    MPI.Bcast!(params_double, 2, 0, comm)

    size_x    = params_int[1]
    size_y    = params_int[2]
    nx_domains = params_int[3]
    ny_domains = params_int[4]
    maxStep   = params_int[5]
    dt1       = params_double[1]
    epsilon   = params_double[2]

    #Warning message if dimensions and number of processes don't match
    if ((my_id == root) && (nproc != (nx_domains * ny_domains)))
        println("ERROR - Number of processes not equal to number of subdomains")
        println("nprocs: ", nproc, " domains: ",  nx_domains * ny_domains )
    end

    #Various other variables
    size_global_x = size_x + 2
    size_global_y = size_y + 2
    hx = Float64(1.0 / size_global_x)
    hy = Float64(1.0 / size_global_y)
    dt2 = 0.25 * min(hx, hy)^2 / k0 #fraction of CFL condition
    size_total_x = size_x + 2 * nx_domains + 2 #including ghost cells
    size_total_y = size_y + 2 * ny_domains + 2 #including ghost cells

    #Take a right time step for convergence
    if (dt1 >= dt2)
        if (my_id == 0)
            println()
            println("Time step too large ==> Taking convergence criterion")
        end
        dt = dt2
    else
        dt = dt1
    end

    #2D solution including ghost cells
    u0 = twoDArray(Float64, size_total_x, size_total_y)
    u = twoDArray(Float64, size_total_x, size_total_y)

    #Allocate coordinates of processes (start cell, end cell)
    xs = oneDArray(Int, nproc)
    xe = oneDArray(Int, nproc)
    ys = oneDArray(Int, nproc)
    ye = oneDArray(Int, nproc)

    #Size of each physical domain
    xcell = Int(size_x / nx_domains)
    ycell = Int(size_y / ny_domains)

    #allocate flattened (1D) local physical solution (i.e., relative to sub-domain)
    u_local = oneDArray(Float64, xcell * ycell)
    #allocate flattened (1D) global physical solution
    u_global = oneDArray(Float64, size_x * size_y)

    #find processes surrounding mine (if they exist)
    my_neighbors = neighbors(my_id, nproc, nx_domains, ny_domains)

    #compute coordinates of processes for each sub-domain
    process_coordinates!(xs, ys, xe, ye, xcell, ycell, nx_domains, ny_domains, nproc)

    #initialize domain
    init_values(u0, size_total_x, size_total_y, temp1_init, temp2_init)

    #update ghost cells
    updateBound!(u0, size_total_x, size_total_y, my_neighbors, comm,
                my_id, xs, ys, xe, ye, xcell, ycell, nproc)

    #Initialize step, time and convergence boolean
    step = 0
    t = 0.0
    converged = false

    #Starting time
    if (my_id==0)
        time_init = time()
    end

    #Main loop : until convergence
    while (!converged)
        #increment step and time
        step += 1
        t += dt
        #perform one step of the explicit scheme
        local_diff = computeNext!(u0, u, size_total_x, size_total_y, dt, hx, hy,
            my_id, xs, ys, xe, ye, nproc, k0)

        #update ghost cells
        updateBound!(u0, size_total_x, size_total_y, my_neighbors, comm,
            my_id, xs, ys, xe, ye, xcell, ycell, nproc)

        MPI.Barrier(comm)

        #sum local_diff to get global difference
        global_diff = MPI.Allreduce(local_diff, MPI.SUM, comm)
        global_diff = sqrt(global_diff)
        #break if convergence reached or step greater than maxStep
        if ((global_diff <= epsilon) || (step >= maxStep))
            converged = true
        end
    end

    #get ending time
    if (my_id == 0)
        time_final = time()
        #elapsed time
        elapsed_time = time_final - time_init
        println("Elapsed time = ", elapsed_time)
        println("Steps = ", step)
    end

    #find solution on my sub-domain (as a 1-dimensional array)
    i = 1
    for j = ys[my_id+1]:ye[my_id+1]
        u_local[(i-1)*xcell+1:i*xcell] = u0[xs[my_id+1]:xe[my_id+1],j]
        i = i+1
    end

    #gather local solution to global solution (as a 1-dimensional array)
    u_global = MPI.Gather(u_local, root, comm)

    #write to disk
    if (my_id == 0)
        write_to_disk(u_global, nx_domains, ny_domains, xcell, ycell, temp1_init, output_path)
    end

    MPI.Finalize()

end


main()