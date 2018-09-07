# TODO add convert method
# TODO switch to SVector

include("Geometry.jl")
include("Point.jl")
import Base.convert, StaticArrays

struct Line <: Geometry
    data::SVector{4,Float64}
end

Line(x1,y1,x2,y2) = Line(SVector{4,Float64}(x1, y1, x2, y2))
Line(P1::SVector{2,Float64}, P2::SVector{2,Float64}) = Line(P1[1], P1[2], P2[1], P2[2])
Line(p1::Point, p2::Point) = Line(p1[1], p1[2], p2[1], p2[2])
Line(data::Array) = Line(data[1], data[2], data[3], data[4])
Line(data1::Array, data2::Array) = Line(data1[1], data1[2], data2[1], data2[2])

convert(::Type{Line}, P::Array) = Line(P)

Base.show(io::IO, a::Line) = print(io, "Line:\n", a.data)

# TODO combine line implementations
function draw!(image::Array{T,2}, line::Line; value=0) where {T<:Union{Real,Color}}
	X = SVector{2,Float64}(line[1], line[2]);
	Y = SVector{2,Float64}(line[3], line[4]);

	d::SVector{2,Float64} = Y - X;
	length::Float64 = maximum(abs.(d));
	if (length <= 0)
		return
	end
	d = d ./ length;
	image_size = collect(size(image));

	for i = 0:length
		#info("i: ", i, " X: ", X, " d: ", d, " F: ", X + d*i)
		P = round.(Int, X + d*i);
		if (!(minimum(P) < 1) && !(minimum(image_size - P) < 0))
			image[P[1], P[2]] = value;
		end
	end
end

function draw!(image::Array{T,2}, line::Line, width::Real; value=0) where {T<:Union{Real,Color}}
	X::SVector{2,Float64} = line[1:2];
	Y::SVector{2,Float64} = line[3:4];
	d::SVector{2,Float64} = Y - X;
	r::SVector{2,Float64} = [d[2], -d[1]];
	r = r ./ maximum(abs.(r)) ./ 2.0;

	for i = -width/2.0:width/2.0
		shift = line + Line(i*r, i*r);
		for j = -1.0:1.0
			draw!(image, shift + Line(j, 0.0, j, 0.0), value=value)
			draw!(image, shift + Line(0.0, j, 0.0, j), value=value)
		end
	end
end
