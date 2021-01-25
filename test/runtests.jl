using Coordinates
using Test

function check_coordinate(axs::NTuple{N, AT}) where {N, T, AT <: AbstractVector{T}}
    A = (@inferred Coordinate(axs))::Coordinate{N, T, AT}
    @test all(CartesianIndices(A)) do I
        (@inferred A[I])::NTuple{N, T} == getindex.(axs, Tuple(I))
    end
    @test size(A) == length.(axs)
    @test coordinateaxes(A) == axs
end

@testset "Coordinate" begin
    @testset "UnitRange" begin
        for N in (1, 2)
            axs = ntuple(i -> 1:rand(1:10), N)
            check_coordinate(axs)
        end
    end
    @testset "StepRange" begin
        for T in (Float32, Float64)
            for N in (1, 2)
                step = rand(T)
                axs = ntuple(i -> 1:step:rand(2:10), N)
                check_coordinate(axs)
            end
        end
    end
    @testset "Vector" begin
        for T in (Float32, Float64)
            for N in (1, 2)
                axs = ntuple(i -> rand(T, rand(1:10)), N)
                check_coordinate(axs)
            end
        end
    end
end
