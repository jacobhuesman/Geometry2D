__precompile__()
module Geometry2D

    using StaticArrays
    using Colors

    import Base: getindex, convert

    include("Geometry.jl")
    include("Point.jl")
    include("Line.jl")
    include("Circle.jl")

    export Geometry,
           Point,
           PointType,
           Line,
           Circle,
           draw!

end # module
