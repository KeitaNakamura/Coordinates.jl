module Coordinates

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

struct Coordinate{N, T, Axis <: AbstractVector{T}} <: AbstractCoordinate{N, T}
    axes::NTuple{N, Axis}
end

Coordinate(axes::AbstractVector...) = Coordinate(axes)
Coordinate{N}(ax::AbstractVector) where {N} = Coordinate(ntuple(i -> ax, Val(N)))

coordinateaxes(C::Coordinate) = C.axes

end # module
