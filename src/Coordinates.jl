module Coordinates

using Base: @_propagate_inbounds_meta, @_inline_meta
using Base.Cartesian: @ntuple

export Coordinate, coordinateaxes

"""
    Coordinate(axes...)
    Coordinate{N}(axis)

Construct `Coordinate` from `axes`.
If only single `axis` is given with number of dimensions `N`,
the `axis` is used for all dimensions.

# Examples
```jldoctest
julia> Coordinate(1:3, 2:4)
3×3 Coordinate{2,Tuple{Int64,Int64},Tuple{UnitRange{Int64},UnitRange{Int64}}}:
 (1, 2)  (1, 3)  (1, 4)
 (2, 2)  (2, 3)  (2, 4)
 (3, 2)  (3, 3)  (3, 4)

julia> Coordinate(1:2, [3.0,4.0], "abc")
2×2×3 Coordinate{3,Tuple{Int64,Float64,Char},Tuple{UnitRange{Int64},Array{Float64,1},String}}:
[:, :, 1] =
 (1, 3.0, 'a')  (1, 4.0, 'a')
 (2, 3.0, 'a')  (2, 4.0, 'a')

[:, :, 2] =
 (1, 3.0, 'b')  (1, 4.0, 'b')
 (2, 3.0, 'b')  (2, 4.0, 'b')

[:, :, 3] =
 (1, 3.0, 'c')  (1, 4.0, 'c')
 (2, 3.0, 'c')  (2, 4.0, 'c')

julia> Coordinate{2}(0:3)
4×4 Coordinate{2,Tuple{Int64,Int64},Tuple{UnitRange{Int64},UnitRange{Int64}}}:
 (0, 0)  (0, 1)  (0, 2)  (0, 3)
 (1, 0)  (1, 1)  (1, 2)  (1, 3)
 (2, 0)  (2, 1)  (2, 2)  (2, 3)
 (3, 0)  (3, 1)  (3, 2)  (3, 3)
```
"""
struct Coordinate{N, ElType, Axes <: Tuple{Vararg{Any, N}}} <: AbstractArray{ElType, N}
    axes::Axes
    function Coordinate{N, ElType, Axes}(axes::Axes) where {N, ElType, Axes}
        check_coordinate_parameter(Val(N), ElType, Axes)
        new{N, ElType, Axes}(axes)
    end
end

@generated function check_coordinate_parameter(::Val{N}, ::Type{ElType}, ::Type{Axes}) where {N, ElType, Axes}
    if Tuple{map(eltype, Axes.parameters)...} != ElType
        return :(throw(ArgumentError("`ElType` and `eltype`s of given axes must match.")))
    end
end

# constructors
@generated function Coordinate(axes::Tuple{Vararg{Any, N}}) where {N}
    ElType = Tuple{map(eltype, axes.parameters)...}
    quote
        Coordinate{N, $ElType, $axes}(axes)
    end
end
Coordinate(axes...) = Coordinate(axes)
Coordinate{N}(ax) where {N} = Coordinate(ntuple(i -> ax, Val(N)))

coordinateaxes(C::Coordinate) = C.axes
coordinateaxes(C::Coordinate, i::Int) = (@_propagate_inbounds_meta; coordinateaxes(C)[i])

Base.size(A::Coordinate) = map(length, coordinateaxes(A))

_eachindex(x) = firstindex(x):lastindex(x)
_eachindex(x::AbstractArray) = eachindex(x)
Base.axes(A::Coordinate) = map(_eachindex, coordinateaxes(A))

# getindex
@generated function Base.getindex(A::Coordinate{N}, I::Vararg{Int, N}) where {N}
    quote
        @_inline_meta
        @boundscheck checkbounds(A, I...)
        @inbounds @ntuple $N i -> coordinateaxes(A, i)[I[i]]
    end
end
@generated function Base.getindex(A::Coordinate{N}, I::Vararg{Union{Int, AbstractUnitRange, Colon}, N}) where {N}
    quote
        @_inline_meta
        @boundscheck checkbounds(A, I...)
        @inbounds Coordinate(@ntuple $N i -> coordinateaxes(A, i)[I[i]])
    end
end
@inline function Base.getindex(A::Coordinate{N}, I::CartesianIndices{N}) where {N}
    @boundscheck checkbounds(A, I)
    @inbounds A[I.indices...]
end

Base.transpose(c::Coordinate{2}) = Coordinate(coordinateaxes(c, 2), coordinateaxes(c, 1))
Base.adjoint(c::Coordinate{2}) = transpose(c)

end # module
