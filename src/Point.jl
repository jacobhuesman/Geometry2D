# TODO add convert method
# TODO switch to SVector
# TODO switch to one dimensional array
include("Geometry.jl")

using StaticArrays

struct Point <: Geometry
    data::SVector{3,Float64}
end

Point(x::T, y::T) where {T<:Real} = Point(SVector{3,Float64}(x, y))
Point(data::Array{Float64,1}) = Point(data[1], data[2], data[3])

Base.show(io::IO, a::Point) = print(io, "Point:\n", a.data)
