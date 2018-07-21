# TODO add convert method
# TODO switch to SVector
include("Geometry.jl")
include("Point.jl")

struct Line{T} <: Geometry{T}
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
Line(data1::Array{T}, data2::Array{T}) where {T<:Real} = Line{T}([data1 data2])
Line(x::T, y::T, dx::T, dy::T) where {T<:Real} = Line{T}([x y dx dy])
Line(p1::Point, p2::Point) = Line([p1.data p2.data])
Line(θ::T) where {T<:Real} = Line([0 0 cos(θ) sin(θ)])
Line(p::Point, θ::T) where {T<:Real} = Line([p.data [cos(θ) sin(θ)] + p.data])

Base.show(io::IO, a::Line) = print(io, "Line:\n", a.data)

# Draw on an image
function draw(img::Array{UInt8,2}, line::Line)
	nimg = copy(img);

	X::Array{Float64} = line[1:2];
	Y::Array{Float64} = line[3:4];

	d::Array{Float64} = Y - X;
	d = d ./ maximum(abs.(d));

	P = copy(X);
	nimg[round(UInt, X[1]), round(UInt, X[2])] = 255;
	while (sum(abs.(P - Y)) > 1)
		P = P + d;
		nimg[round(UInt, P[1]), round(UInt, P[2])] = 255;
	end
	nimg[round(UInt, Y[1]), round(UInt, Y[2])] = 255;
	return nimg;
end
