#   TODO add convert method

struct Point{T}
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

Base.:+(a::Point, b::Point) = Point(a.data + b.data)
Base.:+(a::Array, b::Point) = Point(a      + b.data)
Base.:+(a::Point, b::Array) = Point(a.data + b)
Base.:-(a::Point, b::Point) = Point(a.data - b.data)
Base.:-(a::Array, b::Point) = Point(a      - b.data)
Base.:-(a::Point, b::Array) = Point(a.data - b)

Base.getindex(a::Point, i) = a.data[i]
Array(a::Point) = a.data

Base.show(io::IO, a::Point) = print(io, "Point:\n", a.data)
