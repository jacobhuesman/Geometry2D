#   A point is defined by its two cartesian coordinate, put into a row
#   vector of 2 elements:
#   P = [x y];
#
#   Several points are stores in a matrix with two columns, one for the
#   x-coordinate, one for the y-coordinate.
#   PTS = [x1 y1 ; x2 y2 ; x3 y3];
#
#   Example
#   P = [5 6];

struct Point{T<:Real}
    A::Array{T,2}

    function Point{T}(A::Array{T}) where {T<:Real}
        if size(A, 1) != 1 || size(A, 2) != 2
            error("Points have the form [x y]")
        else
            new(A)
        end
    end
end

Point(A::Array{T}) where {T<:Real} = Point{T}(A)
Point(x::T, y::T) where {T<:Real} = Point{T}([x y])

Base.:+(a::Point, b::Point) = Point(a.A + b.A)
Base.:+(a::Array, b::Point) = Point(a   + b.A)
Base.:+(a::Point, b::Array) = Point(a.A + b)
Base.:-(a::Point, b::Point) = Point(a.A - b.A)
Base.:-(a::Array, b::Point) = Point(a   - b.A)
Base.:-(a::Point, b::Array) = Point(a.A - b)

Base.getindex(a::Point, i) = a.A[i]
Array(a::Point) = a.A

Base.show(io::IO, a::Point) = print(io, a.A, " (Point)")
