# TODO add convert method
# TODO switch to SVector
# TODO switch to one dimensional array
include("Geometry.jl")
using Colors

using StaticArrays

struct Point <: Geometry
    data::SVector{2,Float64}
end

Point(x::T, y::T) where {T<:Real} = Point(SVector{2,Float64}(x, y))
Point(data::Array{Float64,1}) = Point(data[1], data[2])

Base.show(io::IO, a::Point) = print(io, "Point:\n", a.data)

@enum PointType dot=1 cross=2
function draw(image::Array{T,2}, point::Point; value=0, pointtype::PointType=cross, size::Float64=4.0, width::Float64=1.0) where {T<:Union{Real,Color}}
	if (pointtype == dot)
		return draw(image, Circle(point.data, size), value, true);
	else
		p = point.data;
		s = size / 2;
		draw(image, Line(p[1]-s, p[2]-s, p[1]+s, p[2]+s), width, value=value)
		draw(image, Line(p[1]-s, p[2]+s, p[1]+s, p[2]-s), width, value=value)
	end
end
