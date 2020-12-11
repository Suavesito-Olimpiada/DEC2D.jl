using SparseArrays

export boundary1
function boundary1(mesh::DECMesh)
    δ = spzeros(length(mesh.tri.edges), length(mesh.tri.vertices))
    edges = mesh.tri.edges
    for i = 1:length(edges)
        e = edges[i]
        δ[i, e[1]] = -1
        δ[i, e[2]] = 1
    end
    return δ
end

export boundary2d
function boundary2d(mesh::DECMesh)
    polyns = mesh.dtri.dvertices
    edges = mesh.dtri.dedges
    δ = spzeros(length(polyns), length(edges))
    for i = 1:length(polyns)
        p = polyns[i]
        e = vcat([[p[i - 1], p[i]] for i = 2:length(p)], [[p[end], p[begin]]])
        for j = 1:length(e)
            if e[j] in edges
                k = findfirst(isequal(e[j]), edges)
                δ[i, k] = 1
            elseif reverse!(e[j]) in edges
                k = findfirst(isequal(e[j]), edges)
                δ[i, k] = -1
            end
        end
    end
    return δ
end

export hodgestar1
function hodgestar1(mesh::DECMesh)
    vertices = mesh.tri.vertices
    edges = mesh.tri.edges
    dtriangles = mesh.dtri.dtriangles
    dedges = mesh.dtri.dedges
    star = spzeros(length(edges), length(edges))
    for i = 1:length(edges)
        edge = edges[i]
        dedge = dedges[i]
        star[i, i] = longitude(dtriangles[dedge]...) / longitude(vertices[edge]...)
    end
    return star
end

export hodgestar2
function hodgestar2(mesh::DECMesh)
    dtriangles = mesh.dtri.dtriangles
    dvertices = mesh.dtri.dvertices
    star = spzeros(length(mesh.tri.vertices), length(mesh.tri.vertices))
    for i = 1:length(mesh.tri.vertices)
        star[i, i] = 1 / area(dtriangles[dvertices[i]])
    end
    return star
end

export laplacian
function laplacian(mesh::DECMesh)
    d₀ = boundary1(mesh)
    d₁ = boundary2d(mesh)
    *₁ = hodgestar1(mesh)
    *₂ = hodgestar2(mesh)

    Δf =  *₂  * d₁ *  *₁  * d₀
end
