# TODO add convert method
# TODO switch to SVector
include("Geometry.jl")
include("Point.jl")

struct Line{T}
    data::Array{T,2}

    function Line{T}(data::Array{T}) where {T<:Real}
        if size(data, 1) != 1 || size(data, 2) != 4
            error("Lines have the form [x y dx dy]")
        else
            new(data)
        end
    end
end

Line(data::Array{T}) where {T<:Real} = Line{T}(data)
Line(x::T, y::T, dx::T, dy::T) where {T<:Real} = Line{T}([x y dx dy])
Line(p1::Point, p2::Point) = Line([p1.data p2.data])
Line(θ::T) where {T<:Real} = Line([0 0 cos(θ) sin(θ)])
Line(p::Point, θ::T) where {T<:Real} = Line([p.data [cos(θ) sin(θ)] + p.data])

Base.show(io::IO, a::Line) = print(io, "Line:\n", a.data)
