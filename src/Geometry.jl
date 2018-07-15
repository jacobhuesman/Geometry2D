abstract type Geometry{T} end

#Geometry(data::Array{T}) where {T<:Real} = Geometry{T}(data)

Base.:+(a::Geometry, b::Geometry) = Geometry(a.data + b.data)
Base.:+(a::Array,    b::Geometry) = Geometry(a      + b.data)
Base.:+(a::Geometry, b::Array)    = Geometry(a.data + b)
Base.:-(a::Geometry, b::Geometry) = Geometry(a.data - b.data)
Base.:-(a::Array,    b::Geometry) = Geometry(a      - b.data)
Base.:-(a::Geometry, b::Array)    = Geometry(a.data - b)

Base.getindex(a::Geometry, i) = a.data[i]
Array(a::Geometry) = a.data
Base.show(io::IO, a::Geometry) = print(io, "Geometry:\n", a.data)
