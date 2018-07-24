# TODO add convert method
# TODO switch to SVector
# TODO switch to one dimensional array
include("Geometry.jl")

struct Point{T} <: Geometry{T}
    data::Array{T,2}

    function Point{T}(data::Array{T}) where {T<:Real}
        if size(data, 1) != 1 || size(data, 2) != 2
            error("Points have the form [x y]")
        else
            new(data)
        end
    end
end

Point(data::Array{T}) where {T<:Real} = Point{T}(data)
Point(x::T, y::T) where {T<:Real} = Point{T}([x y])

Base.show(io::IO, a::Point) = print(io, "Point:\n", a.data)
