module DEC2D

using StaticArrays

struct Triangulation
    vertices::Vector{SVector{2,Float64}}
    edges::Vector{SVector{2,Int}}
    triangles::Vector{SVector{3,Int}}
end

struct DualTriangulation
    n::Tuple{Int,Int,Int} # #{dual triangles} , #{midpoints}, #{exterior vertices}
    dtriangles::Vector{SVector{2,Float64}} # dual triangles (vertices)
    dedges::Vector{SVector{2,Int}} # dual edges (edges)
    dvertices::Vector{Vector{Int}} # dual vertices (polygons)
end

export DECMesh
struct DECMesh
    tri::Triangulation
    dtri::DualTriangulation
end

include("geometry.jl")
include("triangulation.jl")
include("diffop.jl")

end # module
