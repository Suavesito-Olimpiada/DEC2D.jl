using LinearAlgebra

@enum Orientation::Int8 Colinear = 0 Clockwise = -1 CounterClockwise = 1

function mid_point(p1, p2)
    return (p1 .+ p2) ./ 2
end

function orientation(p1, p2, p3) # orientation
    val = (p2[2] - p1[2]) * (p3[1] - p2[1]) - (p2[1] - p1[1]) * (p3[2] - p2[2])
    return val == 0.0 ? Colinear : (val < 0 ? CounterClockwise : Clockwise)
end

# make edges and dual edges always be in CounterClockwise orientation
function rectify_orientation!(de, dv, v)
    p1 = [0, 0]
    p2 = v[2] .- v[1]
    p3 = dv[2] .- dv[1]
    or = orientation(p1, p2, p3)
    if or == Clockwise
        reverse!(de)
    elseif or == Colinear
        error("Found three colinear vertices trying to sneak as a triangle! 😠")
    end
end

function rectify_orientation!(triangles, vertices)
    for tri in triangles
        or = orientation(vertices[tri[1:3]]...)
        if or == Clockwise
            reverse!(tri)
        elseif or == Colinear
            error("Found three colinear vertices trying to sneak as a triangle! 😠")
        end
    end
end

function circumcenter(p1, p2, p3) # circumcenter
    mat = SMatrix{2}((p1[1] - p2[1]), (p1[1] - p3[1]), (p1[2] - p2[2]), (p1[2] - p3[2]))
    b = -SVector((p2' * p2 - p1' * p1) / 2, (p3' * p3 - p1' * p1) / 2)
    x = mat \ b
end

function longitude(p1, p2) # measure of a line
    return norm(p1 .- p2)
end

function area(p) # measure of a polygon
    A = 0.0
    for i = 2:length(p)
        A += p[i - 1][1] * p[i][2] - p[i - 1][2] * p[i][1]
    end
    A += p[end][1] * p[1][2] - p[end][2] * p[1][1]
    return abs(A) / 2
end
