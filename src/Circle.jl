# Starting with the definition found in the Octave Geometry package
# I think there is a better representation though

include("Geometry.jl")

struct Circle{T} <: Geometry{T}
    data::Array{T,1}

    function Circle{T}(data::Array{T}) where {T<:AbstractFloat}
        if size(data, 1) != 3
            error("Circles have the form [x, y, r]")
        else
            new(data)
        end
    end
end

Circle(data::Array{T,1}) where {T<:AbstractFloat} = Circle{T}(data)
Circle(x::T, y::T, r::T) where {T<:AbstractFloat} = Circle{T}([x, y, r])
Circle(p::Point{T}, r::T) where {T<:AbstractFloat} = Circle{T}(vcat(p.data, r))

Base.show(io::IO, a::Point) = print(io, "Circle:\n", a.data)

function draw(image::Array{UInt8,2}, circle::Circle; enable_warnings=false)
	P::Array{Float64} = circle.data[1:2];
	r::Float64 = circle.data[3];

	i = (0:1/(r*pi):2*pi)' # TODO figure out what this actually should be
	X = round.(Int, r.*[cos.(i); sin.(i)] .+ P);

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
		P = round.(Int, circle[1:2]);
		for i = 1:round(circle.data[3])
			image = draw(image, Circle(vcat(P, i)))
			image[P[1], P[2]] = 255;
		end
	else
		image = draw(image, circle);
	end
	return image;
end
