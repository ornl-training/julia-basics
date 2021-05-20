function init_values(x0::Array{Float64,2}, size_total_x::Int, size_total_y::Int,
                    temp1_init::Float64, temp2_init::Float64)

   #Setup temp1_init on borders
   for i = 1:size_total_x - 1
     x0[i,1] = temp1_init
     x0[i,size_total_y] = temp1_init
   end

   for j = 1:size_total_y
     x0[1,j] = temp1_init
     x0[size_total_x, j] = temp1_init
   end

   for i = 2:size_total_x-1
     x0[i,2] = temp1_init
     x0[i,size_total_y-1] = temp1_init
   end

   for j = 2:size_total_y-1
     x0[2,j] = temp1_init
     x0[size_total_x-1,j] = temp1_init
   end

   #Setup temp2_init inside
   for i = 3:size_total_x-2
     for j = 3:size_total_y-2
       x0[i,j] = temp2_init
     end
   end

   return
end

function neighbors(my_id::Int, nproc::Int, nx_domains::Int, ny_domains::Int)
    #find all processes that are my neighbors
    id_pos = Array{Int,2}(undef, nx_domains, ny_domains)
    for id = 0:nproc-1
        n_row = (id+1) % nx_domains > 0 ? (id+1) % nx_domains : nx_domains
        n_col = ceil(Int, (id + 1) / nx_domains)
        if (id == my_id)
            global my_row = n_row
            global my_col = n_col
        end
        id_pos[n_row, n_col] = id
    end

    neighbor_N = my_row + 1 <= nx_domains ? my_row + 1 : -1
    neighbor_S = my_row - 1 > 0 ? my_row - 1 : -1
    neighbor_E = my_col + 1 <= ny_domains ? my_col + 1 : -1
    neighbor_W = my_col - 1 > 0 ? my_col - 1 : -1

    neighbors = Dict{String,Int}()
    neighbors["N"] = neighbor_N >= 0 ? id_pos[neighbor_N, my_col] : -1
    neighbors["S"] = neighbor_S >= 0 ? id_pos[neighbor_S, my_col] : -1
    neighbors["E"] = neighbor_E >= 0 ? id_pos[my_row, neighbor_E] : -1
    neighbors["W"] = neighbor_W >= 0 ? id_pos[my_row, neighbor_W] : -1

    return neighbors
end

function process_coordinates!(xs::Array{Int}, ys::Array{Int}, xe::Array{Int},
    ye::Array{Int}, xcell::Int, ycell::Int, nx_domains::Int, ny_domains::Int, nproc::Int)

    #Computation of starting ys,ye on (Ox) standard axis
    #for the first column of global domain,
    #Convention x(i,j) with i row and j column
    ys[1:nx_domains] .= 3
    #Here, ye[1:x_domains] = 3 + ycell-1
    ye[1:nx_domains] = ys[1:nx_domains] .+ ycell .- 1

    #Computation of ys,ye on (Ox) standard axis
    #for all other cells of global domain
    for i = 1:ny_domains-1
        ys[i*nx_domains+1:(i+1)*nx_domains] = ys[(i-1)*nx_domains+1:i*nx_domains] .+ ycell .+ 2
        ye[i*nx_domains+1:(i+1)*nx_domains] = ys[i*nx_domains+1:(i+1)*nx_domains] .+ ycell .- 1
    end

    #Computation of starting xs,xe on (Oy) standard axis
    #for the first row of global domain,
    #Convention x(i,j) with i row and j column
    for i = 1:ny_domains
        xs[(i-1)*nx_domains+1] = 3
        #Here, xe(i*x_domains) = 2+xcell-1
        xe[(i-1)*nx_domains+1] = xs[(i-1)*nx_domains+1] + xcell - 1
    end

    #Computation of xs,xe on (Oy) standard axis
    #for all other cells of global domain
    for i = 1:ny_domains
        for j = 2:nx_domains
            xs[(i-1)*nx_domains+j] = xs[(i-1)*nx_domains+(j-1)] + xcell + 2
            xe[(i-1)*nx_domains+j] = xs[(i-1)*nx_domains+j] + xcell - 1
        end
    end

    return xs, xe, ys, ye
end