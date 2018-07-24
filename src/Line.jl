# TODO add convert method
# TODO switch to SVector
include("Geometry.jl")
include("Point.jl")
import Base.convert

struct Line{T} <: Geometry{T}
    data::Array{T,1}

    function Line{T}(data::Array{T,1}) where {T<:AbstractFloat}
        if size(data, 1) != 4
            error("Lines have the form [x, y, dx, dy]")
        else
            new(data)
        end
    end
end

Line(data::Array{T,1}) where {T<:AbstractFloat} = Line{T}(data)
Line(data1::Array{T,1}, data2::Array{T}) where {T<:AbstractFloat} = Line{T}(vcat(data1, data2))
Line(x::T, y::T, dx::T, dy::T) where {T<:AbstractFloat} = Line{T}([x, y, dx, dy])
Line(p1::Point, p2::Point) = Line(vcat(p1.data, p2.data))
Line(θ::T) where {T<:AbstractFloat} = Line([0, 0, cos(θ), sin(θ)])
Line(p::Point, θ::T) where {T<:AbstractFloat} = Line([p.data, [cos(θ), sin(θ)] + p.data])

convert(::Type{Line}, P::Array) = Line(P)

Base.show(io::IO, a::Line) = print(io, "Line:\n", a.data)

# Draw a line on an image
function draw(image::Array{UInt8,2}, line::Line; enable_warnings=false)
	X::Array{Float64} = round.(line[1:2]);
	Y::Array{Float64} = round.(line[3:4]);
	#info(X,Y)

	d::Array{Float64} = Y - X;
	length = maximum(abs.(d));
	d = d ./ length;
	image_size = collect(size(image));

	for i = 0:length
		P = round.(Int, X + d*i);
		if (!(minimum(P) < 1) && !(minimum(image_size - P) < 0))
			image[P[1], P[2]] = 255;
		else
			if (enable_warnings)
				warn("Part of the line was specified out of bounds: ", P);
			end
		end
	end
	return image;
end

function draw(image::Array{UInt8,2}, line::Line, width::Real; enable_warnings=false)
	X::Array{Float64} = line[1:2];
	Y::Array{Float64} = line[3:4];
	d::Array{Float64} = Y - X;
	r::Array{Float64} = [d[2], -d[1]];
	r = r ./ maximum(abs.(r)) ./ 2.0;

	for i = -width/2.0:width/2.0
		#info(line + vcat(i*r, i*r))
		for j = -1.0:1.0
			draw(image, line + vcat(i*r, i*r) + [j, 0.0, j, 0.0], enable_warnings=enable_warnings)
			draw(image, line + vcat(i*r, i*r) + [0.0, j, 0.0, j], enable_warnings=enable_warnings)
		end
	end
	return image;
end
