using Pkg
#Pkg.add("JSON")
using JSON


plutoversion = filter(x-> x.second.name == "Pluto", Pkg.dependencies()) |> x -> first(x)[2].version
header = """### A Pluto.jl notebook ###
# v$plutoversion

using Markdown
using InteractiveUtils

"""
section_prefix = "# ╔═╡ "
subsection_prefix = "# ╠═"

cell_order = []

if length(ARGS) != 1
	print("usage: julia " * PROGRAM_FILE * " filename.ipynb")
	exit()
end


f = open(ARGS[1], "r")
d = JSON.parse(f)

# name of translated pluto notebook .jl file
new_filename = split(last(split(ARGS[1], "/")), ".ipynb")[1] * ".jl"
jlversion = open(new_filename, "w")
write(jlversion, header)

for cell in d["cells"]
	uuid = string(Base.UUID(rand(UInt128)))
	push!(cell_order, uuid)
	write(jlversion, section_prefix*uuid*"\n")
	if cmp("markdown", cell["cell_type"]) == 0
		write(jlversion, "md\"\"\"\n")
		write(jlversion, join(cell["source"]))
		write(jlversion, "\n\"\"\"")
	elseif cmp("code", cell["cell_type"]) == 0
		write(jlversion, "begin\n")
		for line in cell["source"]
			write(jlversion, "\t"*"$line")
		end
		write(jlversion, "\nend")
	end
	write(jlversion, "\n\n")
end

write(jlversion, section_prefix*"Cell order:\n")
for uuid in cell_order
	write(jlversion, subsection_prefix*"$uuid"*"\n")
end

close(jlversion)