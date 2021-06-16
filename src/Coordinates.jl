module Coordinates

using Base: @_propagate_inbounds_meta, @_inline_meta
using Base.Cartesian: @ntuple

export
    Coordinate,
    coordinateaxes,
    DashedRange,
    dash

include("Coordinate.jl")
include("DashedRange.jl")

end # module
