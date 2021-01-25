using Coordinates
using Test

function check_coordinate(coord::Coordinate{N, T}, axes::Tuple) where {N, T}
    @test all(CartesianIndices(coord)) do I
        (@inferred coord[I])::NTuple{N, T} == getindex.(axes, Tuple(I))
    end
    @test size(coord) == length.(axes)
    @test coordinateaxes(coord) == axes
end
check_coordinate(coord::Coordinate{N}, ax) where {N} = check_coordinate(coord, ntuple(i -> ax, Val(N)))

@testset "Constructors" begin
    for T in (Float32, Float64), N in (1,2,3)
        # from tuple
        for axs in (ntuple(i -> 1:rand(T(1):10), N),
                    ntuple(i -> 1:rand(T):rand(2:10), N),
                    ntuple(i -> rand(T, rand(1:10)), N),)
            C = (@inferred Coordinate(axs))::Coordinate{N, T, eltype(axs)}
            C = (@inferred Coordinate(axs...))::Coordinate{N, T, eltype(axs)}
            check_coordinate(C, axs)
        end
        # from axis
        for axis in (1:rand(T(1):10),
                     1:rand(T):rand(2:10),
                     rand(T, rand(1:10)),)
            C = (@inferred Coordinate{N}(axis))::Coordinate{N, T, typeof(axis)}
            check_coordinate(C, axis)
        end
    end
end
