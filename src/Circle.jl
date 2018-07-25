# Starting with the definition found in the Octave Geometry package
# I think there is a better representation though
#---
using StaticArrays

include("Geometry.jl")

struct Circle <: Geometry
    data::SVector{3,Float64}
end

Circle(x, y, r) = Circle(SVector{3,Float64}(x, y, r))
Circle(P::SVector{2,Float64}, r::T) where {T<:Real}= Circle(P, r)
Circle(data::Array) = Circle(data[1], data[2], data[3])
#Circle(p::Point{T}, r::T) where {T<:AbstractFloat} = Circle{T}(vcat(p.data, r))
Base.show(io::IO, a::Circle) = print(io, "Circle:\n", a.data)
#---

function draw(image::Array{UInt8,2}, circle::Circle; enable_warnings=false)
	P = SVector{2,Float64}(circle[1], circle[2]);
	r::Float64 = circle[3];

	i = (0:1/(pi*r):2*pi)' # TODO figure out what this actually should be
	X = round.(Int, r.*[cos.(i); sin.(i)] .+ P); # TODO try rotating a vector instead of calculating sine and cosine constantly

	image_size = collect(size(image));
	for i = 1:size(X,2)
		if (!(minimum(X[:,i]) < 1) && !(minimum(image_size - X[:,i]) < 0))
			image[X[1,i], X[2,i]] = 255;
		else
			if (enable_warnings)
				warn("Part of the circle was specified out of bounds: ", P);
			end
		end
	end
	return image;
end

function draw(image::Array{UInt8,2}, circle::Circle, fill::Bool; enable_warnings=false)
	if (fill)
		for i = 1:round(circle.data[3])
			image = draw(image, Circle(circle[1], circle[2], i))
		end
		image[round(Int, circle[1]), round(Int, circle[2])] = 255;
	else
		image = draw(image, circle);
	end
	return image;
end

# Original runtime: ~0.024748 seconds
# Runtime after moving image[P[1], P[2]] outside of loop: 0.023427
