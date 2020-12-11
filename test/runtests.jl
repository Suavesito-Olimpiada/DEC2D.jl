using Test

using DEC2D
using LinearAlgebra

@testset "Geometry algorithms" begin
    @testset "Mid vertices" begin
        @test DEC2D.mid_point([2,2], [4,4]) == [3,3]
        @test DEC2D.mid_point([-2,-2], [4,4]) == [1,1]
    end

    @testset "Orientation" begin
        @test DEC2D.orientation([-1,0], [0,1], [1,0]) == DEC2D.Clockwise
        @test DEC2D.orientation([1,0], [0,1], [-1,0]) == DEC2D.CounterClockwise
        @test DEC2D.orientation([1,0], [0,0], [-1,0]) == DEC2D.Colinear
        @test DEC2D.orientation([0,0], [0,0], [-1,0]) == DEC2D.Colinear
    end

    @testset "Circumcenter" begin
        @test DEC2D.circumcenter([0,0], [0,3], [4,0]) ≈ [2.0, 1.5]
        @test DEC2D.circumcenter([0,0], [0,-3], [-4,0]) ≈ -[2.0, 1.5]
        @test DEC2D.circumcenter([0,1], [-cos(π/3),-sin(π/3)], [cos(π/3),-sin(π/3)]) ≈ [0.0, 0.0]
    end

    @testset "Length" begin
        @test DEC2D.length([0,0], [0, 1.0]) ≈ 1.0
        @test DEC2D.length([0,0], [1, 1.0]) ≈ √2.0
    end

    @testset "Area" begin
        @test DEC2D.area([[0,0], [0,1], [1, 0]]) ≈ 0.5
        @test DEC2D.area([[0,0], [0,1], [1, 1], [1, 0]]) ≈ 1.0

        areapolyn(n) = n * sin(π/n) * cos(π/n)
        polyn(n) = [[cos(i * 2π / n), sin(i * 2π / n)] for i in 1:n]
        @test DEC2D.area(polyn(3)) ≈ areapolyn(3)
        @test DEC2D.area(polyn(4)) ≈ areapolyn(4)
        @test DEC2D.area(polyn(7)) ≈ areapolyn(7)

        @test DEC2D.area([p .+ 1 for p in polyn(3)]) ≈ areapolyn(3)
        @test DEC2D.area([p .+ 1 for p in polyn(4)]) ≈ areapolyn(4)
        @test DEC2D.area([p .+ 1 for p in polyn(7)]) ≈ areapolyn(7)
    end
end

@testset "Triangulation and Dual" begin
    @testset "Parted triangle" begin
        vertices = vcat([[0,0]], [[cos(i * 2π/3), sin(i * 2π/3)] for i in 0:2])
        edges = [[3, 4], [1, 3], [2, 4], [2, 3], [1, 4], [1, 2]]
        triangles = [[1, 2, 3], [1, 3, 4], [1, 4, 2]]

        mesh = DEC2D.DECMesh(vertices, edges, triangles)

        @show mesh.tri.vertices
        @show mesh.tri.edges
        @show mesh.tri.triangles

        println("")

        @show mesh.dtri.n
        @show mesh.dtri.dtriangles
        @show mesh.dtri.dedges
        @show mesh.dtri.dvertices
    end
end
