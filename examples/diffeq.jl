using LinearAlgebra

using GLMakie; GLMakie.activate!()
using AbstractPlotting

using Delaunay
using DEC2D

# convert vector of vectors into a matrix
vv2m(vv) = reduce(vcat, transpose.(vv))

# Simples case
begin
    vertices = vcat([[0, 0]], [[cos(2π * i / 6), sin(2π * i / 6)] for i = 1:6])
    edges = [
        [1, 2],
        [1, 3],
        [1, 4],
        [1, 5],
        [1, 6],
        [1, 7],
        [2, 3],
        [3, 4],
        [4, 5],
        [5, 6],
        [6, 7],
        [7, 2],
    ]
    triangles = [[1, 2, 3], [1, 3, 4], [1, 4, 5], [1, 5, 6], [1, 6, 7], [1, 7, 2]]

    # return the mesh and the indices of the interior vertices
    vint, mesh = DECMesh(vertices, edges, triangles)
    vext = setdiff(1:length(vertices), vint)

    # d₀ = boundary1(mesh)
    # d₁ = boundary2d(mesh)
    # *₁ = hodgestar1(mesh)
    # *₂ = hodgestar2(mesh)
    # Δ = *₂ * d₁ * *₁ * d₀
    Δ = laplacian(mesh) # calculate the laplacian operator

    b = [-1 - 10 * sum(Δ[i, vext]) for i = 1:length(vint)]

    # numerical solution
    zf = Δ[vint, vint] \ b

    x = vv2m(vertices)[:, 1]
    y = vv2m(vertices)[:, 2]
    zn = similar(vertices, Float64)
    zn[vint] = zf
    zn[vext] .= 10

    # exact solution
    f(x, y) = (1 - x^2 - y^2) / 4 + 10
    z = [f(v...) for v in vertices]

    println(
        "La norma de la diferencia entre la solución numérica y la exacta es ",
        norm(zn - z),
    )

    #   ____  _       _   _   _
    #  |  _ \| | ___ | |_| |_(_)_ __   __ _
    #  | |_) | |/ _ \| __| __| | '_ \ / _` |
    #  |  __/| | (_) | |_| |_| | | | | (_| |
    #  |_|   |_|\___/ \__|\__|_|_| |_|\__, |
    #                                 |___/

    # plot numerical solution
    scene = Scene()
    mesh!(
        scene,
        hcat(x, y, zn),
        vv2m(mesh.tri.triangles),
        color = zn,
        scale_plot = false,
    )
    xlims!(scene, -1, 1)
    ylims!(scene, -1, 1)
    zlims!(scene, 10, 10.25)
    wireframe!(scene[end][1], color = (:black, 0.6), linewidth = 2)
    display(scene)
    sleep(5.0)
end

# Caso medio
begin
    # we get the vertices of a more fine mesh
    vertices = [
        [cos(2π * i / (50 * r + 1)), sin(2π * i / (50 * r + 1))] .* r for r = 0:0.1:1
        for i = 1:round(Int, 50 * r + 1, RoundDown)
    ]

    # get thetriangulation using Delaunay algorithm
    meshd = delaunay(vv2m(vertices))
    triangles = [meshd.simplices[i, :] for i = 1:size(meshd.simplices, 1)]
    edges = reduce(
        union,
        [[sort([t[1], t[2]]), sort([t[2], t[3]]), sort([t[3], t[1]])] for t in triangles],
    )

    vint, mesh = DECMesh(vertices, edges, triangles)
    vext = setdiff(1:length(vertices), vint)

    Δ = laplacian(mesh)

    b = [-1 - 10 * sum(Δ[i, vext]) for i = 1:length(vint)]
    zf = Δ[vint, vint] \ b

    x = vv2m(vertices)[:, 1]
    y = vv2m(vertices)[:, 2]
    zn = similar(vertices, Float64)
    zn[vint] = zf
    zn[vext] .= 10

    f(x, y) = (1 - x^2 - y^2) / 4 + 10
    z = [f(v...) for v in vertices]

    println(
        "La norma de la diferencia entre la solución numérica y la exacta es ",
        norm(zn - z),
    )

    scene = Scene()
    mesh!(
        scene,
        hcat(x, y, zn),
        vv2m(mesh.tri.triangles),
        color = zn,
        scale_plot = false,
    )
    xlims!(scene, -1, 1)
    ylims!(scene, -1, 1)
    zlims!(scene, 10, 10.25)
    wireframe!(scene[end][1], color = (:black, 0.6), linewidth = 2)
    display(scene)
    sleep(5.0)
end

# Caso denso
begin
    # we get the vertices of a more fine mesh
    vertices = [
        [cos(2π * i / (200 * r + 1)), sin(2π * i / (200 * r + 1))] .* r for r = 0:0.025:1 for i = 1:round(Int, 200 * r + 1, RoundDown)
    ]

    # get thetriangulation using Delaunay algorithm
    meshd = delaunay(vv2m(vertices))
    triangles = [meshd.simplices[i, :] for i = 1:size(meshd.simplices, 1)]
    edges = reduce(
        union,
        [[sort([t[1], t[2]]), sort([t[2], t[3]]), sort([t[3], t[1]])] for t in triangles],
    )

    vint, mesh = DECMesh(vertices, edges, triangles)
    vext = setdiff(1:length(vertices), vint)

    Δ = laplacian(mesh)

    b = [-1 - 10 * sum(Δ[i, vext]) for i = 1:length(vint)]
    zf = Δ[vint, vint] \ b

    x = vv2m(vertices)[:, 1]
    y = vv2m(vertices)[:, 2]
    zn = similar(vertices, Float64)
    zn[vint] = zf
    zn[vext] .= 10

    f(x, y) = (1 - x^2 - y^2) / 4 + 10
    z = [f(v...) for v in vertices]

    println(
        "La norma de la diferencia entre la solución numérica y la exacta es ",
        norm(zn - z),
    )

    scene = Scene()
    mesh!(
        scene,
        hcat(x, y, zn),
        vv2m(mesh.tri.triangles),
        color = zn,
        scale_plot = false,
    )
    xlims!(scene, -1, 1)
    ylims!(scene, -1, 1)
    zlims!(scene, 10, 10.25)
    wireframe!(scene[end][1], color = (:black, 0.6), linewidth = 2)
    display(scene)
end
