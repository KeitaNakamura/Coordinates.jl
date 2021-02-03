module Coordinates

using Base: @_propagate_inbounds_meta

export AbstractCoordinate, Coordinate, coordinateaxes

abstract type AbstractCoordinate{N, T} <: AbstractArray{NTuple{N, T}, N} end

Base.size(A::AbstractCoordinate) = map(length, coordinateaxes(A))

# getindex
@inline function Base.getindex(A::AbstractCoordinate{N}, i::Vararg{Int, N}) where {N}
    @boundscheck checkbounds(A, i...)
    @inbounds broadcast(getindex, coordinateaxes(A), i)
end
@inline function Base.getindex(A::AbstractCoordinate{N}, I::Vararg{Union{AbstractUnitRange, Colon}, N}) where {N}
    @boundscheck checkbounds(A, I...)
    @inbounds typeof(A)(map(getindex, coordinateaxes(A), I))
end
@inline function Base.getindex(A::AbstractCoordinate{N}, I::CartesianIndices) where {N}
    @boundscheck checkbounds(A, I)
    @inbounds A[I.indices...]
end

"""
    Coordinate(axes::AbstractVector...)
    Coordinate{N}(axis::AbstractVector)

Construct `Coordinate` from `axes`.
If only single `axis` is given with specified number of dimensions `N`,
the `axis` is used for all dimensions.

# Examples
```jldoctest
julia> Coordinate(1:3, 2:4)
3×3 Coordinate{2,Int64,UnitRange{Int64}}:
 (1, 2)  (1, 3)  (1, 4)
 (2, 2)  (2, 3)  (2, 4)
 (3, 2)  (3, 3)  (3, 4)

julia> Coordinate{2}(0.0:3.0)
4×4 Coordinate{2,Float64,StepRangeLen{Float64,Base.TwicePrecision{Float64},Base.TwicePrecision{Float64}}}:
 (0.0, 0.0)  (0.0, 1.0)  (0.0, 2.0)  (0.0, 3.0)
 (1.0, 0.0)  (1.0, 1.0)  (1.0, 2.0)  (1.0, 3.0)
 (2.0, 0.0)  (2.0, 1.0)  (2.0, 2.0)  (2.0, 3.0)
 (3.0, 0.0)  (3.0, 1.0)  (3.0, 2.0)  (3.0, 3.0)
```
"""
struct Coordinate{N, T, Axis <: AbstractVector{T}} <: AbstractCoordinate{N, T}
    axes::NTuple{N, Axis}
end

Coordinate(axes::AbstractVector...) = Coordinate(axes)
Coordinate{N}(ax::AbstractVector) where {N} = Coordinate(ntuple(i -> ax, Val(N)))

coordinateaxes(C::Coordinate) = C.axes
coordinateaxes(C::Coordinate, i::Int) = (@_propagate_inbounds_meta; coordinateaxes(C)[i])

end # module
