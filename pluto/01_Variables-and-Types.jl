### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# ╔═╡ 2122c0dc-abd8-e6a7-3bdf-f329a7200b3c
md"""
# Variables and Types

The content material is taken from https://techytok.com/from-zero-to-julia/ 

**Table of Contents**
 - [Variables](#Variables)
 - [Types](#Types)
 - [Conclusion](#Conclusion)

In this lesson you will learn what are variables and how to perform simple mathematical operations. Furthermore, we will deal with the concept of “types” and their role in Julia as `typing` (in the Python sense) and `type-safety` are parts of the language.

## Variables

Julia is not very different from other language for simple variables, just assign data to a variable.
A few important things:

1. Julia doesn't support member functions: **Never** `variable.function() will appear`, but always `function(variable)` just like in C or Fortran.
2. Variables can be strings, numbers, multidimensional arrays, and higher-level constructs: dictionaries, structs.
3. Understand default types for your system if you're not assigning types explicitly (see [Types](#Types)).

In Julia, variables can be global or local scope. **Note: avoid global variables when working in shared code (even with yourself). Why? Name conflicts and types can't be assigned.**

"""

# ╔═╡ 71613150-bfad-9bed-99d5-71d28eaab59e
begin
	# Use # for comments
	# I'm a global variable...don't use global variables unless it's necessary (e.g. library)
	globalVariable = "Don't use me"
	
	function run()
	    # local variables  
	    name = "William F Godoy"
	    napples = 10
	    weight = 167.5
	    kids = ( "Mark"=> 4, "Emily"=> 0) 
	    years = [ 2017, 2020 ]
	  
	    # Unlike Python print doesn't add a newline \n by default. 
	    # Julia uses print and println
	    # It understands higher-level objects (e.g. dictionary)
	    println(name)
	    println(napples)
	    println(weight)
	    println(kids)
	    println(years)
	    return
	end 
	
	# run your local function
	run()
end

# ╔═╡ 7c72b738-be7e-5f56-b3a3-f8af99257bc8
md"""
## Types

In Julia every element has a type. The type system is a hierarchical structure: at the top of the tree there is the type `Any`, which means that every element belongs to it, then there are many other sub-types, for example `Number` which includes `Real` and `Complex`, and `Real` contains for example `Int` (integer) numbers and `Float64` numbers.

<img src="../images/types.jpg" alt="Drawing" width="500" height="700"/>

Julia enables out-of-the-box type safety as types can be explicitly assigned using the `::` notation, this is preferred for high-performance code as the compiler would actually provide checks and optimizations. In Python, the [typing module](https://docs.python.org/3/library/typing.html) was added in v3.5 for type hints.

Types can be retrieved using the `typeof` function. It's good practtice to be aware of default types on your system:
"""

# ╔═╡ e3c865cf-fcea-dd86-a807-e2713de2594a
begin
	println("Default types:")
	function runWithoutTypes()
	    name = "William F Godoy"
	    napples = 10
	    weight = 167.5
	    kids = ( "Mark"=> 4, "Emily"=> 0)
	    years = [ 2017, 2020 ]
	  
	    println("name: ", name, " type: ", typeof(name) )
	    println("napples: ", napples, " type: ", typeof(napples))
	    println("weight: ", weight, " type: ", typeof(weight))
	    printstyled(kids, " type: ", typeof(kids), "\n" ; color = :red)
	    println("years: ", years, " type: ", typeof(years))
	    return
	end 
	
	println()
	runWithoutTypes()
	
	println("")
	println("")
	println("Assigned types:")
	function runWithTypes()
	    name::String = "William"
	    napples::Int32 = 10
	    weight::Float32 = 167.5
	    kids::Dict{String,Int32} = Dict( "Mark"=> 4, "Emily"=> 0 )
	    years::Array{Int32,1} = [ 2017, 2020 ]  
	    
	    println("name: ", name, " type: ", typeof(name) )
	    println("napples: ", napples, " type: ", typeof(napples))
	    println("weight: ", weight, " type: ", typeof(weight))
	    printstyled(kids, " type: ", typeof(kids), "\n" ; color = :red)
	    println("years: ", years, " type: ", typeof(years))
	    return
	end
	
	println()
	runWithTypes()
end

# ╔═╡ 9039894d-c27f-6c98-b39b-535e96b55165
md"""
**NOTE: the dictionary type Dict must be typed at least on the right-side of =, otherwise Julia assings a Tuple** 

Although it is possible to change the value of a variable inside a program (it is a variable, after all) it is good programming practice and is also critical for performance that inside a program a variable is “type stable”. This means that if we have assigned `a = 42` it is better not to assign a new value to a which cannot be converted into an Int without losing information, like a `Float64` `a = 0.42` (if we convert a `Float64` to an `Int`, the decimal part gets truncated).

If we know that a variable (such as a) will have to contain values of type `Float64` it is better to initialise it with a value that is already of that type.
"""

# ╔═╡ 98c5294b-e703-3caf-c05b-58bd5e1e5f05
begin
	function run()
	  a = 2 # if we need to operate with ints
	  println("Type of a: ", typeof(a))
	  b = 2.0 # if we need to operate with floats
	  println("Type of a: ", typeof(b))
	    
	  # a = 2.0  # not a good practice, type is Float64 by default
	  # a = convert(Float32, a) # only is required, we aware of truncation
	  println("Type of a: ", typeof(a))
	
	  return
	end
	
	run()
end

# ╔═╡ 05085c9f-c50f-b8d7-9196-f5159aa29983
md"""
# Conclusion
We have learned what variables are, how to perform basic operations and we have dealt about types.
"""

# ╔═╡ bf90751a-a161-3f45-8d37-3e92281eb3d3
md"""
Questions:

1. Does Julia support unsigned integers?
2. Does Julia support member functions?
3. What's the abstraction for any type?
"""

# ╔═╡ Cell order:
# ╠═2122c0dc-abd8-e6a7-3bdf-f329a7200b3c
# ╠═71613150-bfad-9bed-99d5-71d28eaab59e
# ╠═7c72b738-be7e-5f56-b3a3-f8af99257bc8
# ╠═e3c865cf-fcea-dd86-a807-e2713de2594a
# ╠═9039894d-c27f-6c98-b39b-535e96b55165
# ╠═98c5294b-e703-3caf-c05b-58bd5e1e5f05
# ╠═05085c9f-c50f-b8d7-9196-f5159aa29983
# ╠═bf90751a-a161-3f45-8d37-3e92281eb3d3
