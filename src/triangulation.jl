function DECMesh(vertices, edges, triangles)
    tri = make_tri(vertices, edges, triangles)
    vint, dtri = make_dual(tri)
    vint, DECMesh(tri, dtri)
end

function make_tri(vertices, edges, triangles)
    vertices = convert(Vector{SVector{2,Float64}}, vertices)
    edges = convert(Vector{SVector{2,Int}}, edges)
    rectify_orientation!(triangles, vertices)
    triangles = convert(Vector{SVector{3,Int}}, triangles)
    return Triangulation(vertices, edges, triangles)
end

function make_dual(tri)
    vertices = tri.vertices
    edges = tri.edges
    triangles = tri.triangles

    edges_neighbors =
        [[i for i in 1:length(triangles) if edge ⊆ triangles[i]] for edge in edges]
    vertices_neighbors = [findall(x -> (i in x), edges) for i = 1:length(vertices)]

    edges_ext = findall(x -> length(x) == 1, edges_neighbors)
    edges_int = setdiff(1:length(edges), edges_ext)
    vertices_ext = findall(x -> !isempty(intersect(x, edges_ext)), vertices_neighbors)
    vertices_int = setdiff(1:length(vertices), vertices_ext)

    nvertices_ext = length(vertices_ext)

    mid_points = [mid_point(vertices[edges[edge]]...) for edge in edges_ext]
    nmid_points = length(mid_points)

    dtriangles = [circumcenter(vertices[triangle]...) for triangle in triangles]
    ndtriangles = length(dtriangles)

    append!(dtriangles, mid_points)
    append!(dtriangles, vertices[vertices_ext])

    dedges = fill([0, 0], length(edges))
    for i in edges_int
        d = edges_neighbors[i]
        rectify_orientation!(d, dtriangles[d], vertices[edges[i]])
        dedges[i] = d
    end
    j = 1
    for i in edges_ext
        d = [edges_neighbors[i][1], ndtriangles + j]
        rectify_orientation!(d, dtriangles[d], vertices[edges[i]])
        dedges[i] = d
        j += 1
    end

    dvertices = fill(Int[], length(vertices))
    for i in vertices_int
        dvertices[i] = catsort(dedges[vertices_neighbors[i]])
    end
    j = 1
    for i in vertices_ext
        dvertices[i] = catsort(dedges[vertices_neighbors[i]], ndtriangles + nmid_points + j)
        j += 1
    end
    rectify_orientation!(dvertices, dtriangles)

    return vertices_int,
    DualTriangulation(
        (ndtriangles, nmid_points, nvertices_ext),
        dtriangles,
        dedges,
        dvertices,
    )
end

function catsort(dedges, last = 0)
    vsorted = if last == 0
        fill(0, length(dedges))
    else
        fill(0, length(dedges) + 2)
    end

    uniques = reduce(union, dedges)
    graph = Dict(
        [i =>
            dedges |>
            y ->
                filter(x -> (i in x), y) |>
                x -> reduce(union, x) |> x -> setdiff(x, [i]) |> sort for i in uniques],
    )

    if last == 0
        vsorted[begin] = uniques[1]
    else
        vsorted[begin] = findfirst(v -> (length(v) == 1), graph)
        vsorted[end] = last
    end

    i = 2
    len = if last == 0
        length(uniques) - 1
    else
        length(uniques)
    end
    for _ = 1:len
        for n in graph[vsorted[i - 1]]
            if n ∉ vsorted
                vsorted[i] = n
                i += 1
                break
            end
        end
    end

    return vsorted
end
