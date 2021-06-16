struct DashedRange{T, V <: AbstractVector{T}} <: AbstractVector{T}
    parent::V
    on::Int
    off::Int
end

Base.parent(dashed::DashedRange) = dashed.parent
function Base.size(dashed::DashedRange)
    d, r = divrem(length(parent(dashed))-1, (dashed.on + dashed.off))
    (d * dashed.on + min(r+1, dashed.on),)
end

@inline function Base.getindex(dashed::DashedRange, i::Int)
    @boundscheck checkbounds(dashed, i)
    d, r = divrem(i-1, dashed.on)
    startinds = dashedstartinds(dashed)
    @inbounds parent(dashed)[startinds[d+1] + r]
end

function dashedstartinds(dashed)
    p = parent(dashed)
    firstindex(p):dashed.on+dashed.off:lastindex(p)
end

function dash(dashed::DashedRange, i::Int)
    startinds = dashedstartinds(dashed)
    @boundscheck checkbounds(startinds, i)
    @inbounds begin
        start = startinds[i]
        p = parent(dashed)
        p[start:min(start+dashed.on-1, lastindex(p))]
    end
end
