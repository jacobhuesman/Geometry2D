abstract type Geometry{T<:AbstractFloat} end

#Geometry(data::Array{T}) where {T<:Real} = Geometry{T}(data)

Base.:+(a::T,     b::T)     where {T<:Geometry} = T(a.data + b.data)
Base.:+(a::Array, b::T)     where {T<:Geometry} = T(a      + b.data)
Base.:+(a::T,     b::Array) where {T<:Geometry} = T(a.data + b)
Base.:-(a::T,     b::T)     where {T<:Geometry} = T(a.data - b.data)
Base.:-(a::Array, b::T)     where {T<:Geometry} = T(a      - b.data)
Base.:-(a::T,     b::Array) where {T<:Geometry} = T(a.data - b)

Base.getindex(a::Geometry, i) = a.data[i]
function Base.setindex!(a::Geometry{T}, d::T, i::Int) where {T<:AbstractFloat}
    a.data[i] = d;
    return a;
end
Array(a::Geometry) = a.data
Base.show(io::IO, a::Geometry) = print(io, "Geometry:\n", a.data)
