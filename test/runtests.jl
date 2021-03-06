using Coordinates
using Test

function check_coordinate(coord::Coordinate{N, ElType}, axes::Tuple) where {N, ElType}
    @test all(CartesianIndices(coord)) do I
        (@inferred coord[I])::ElType == getindex.(axes, Tuple(I))
    end
    @test size(coord) == length.(axes)
    @test coordinateaxes(coord) == axes
end
check_coordinate(coord::Coordinate{N}, ax) where {N} = check_coordinate(coord, ntuple(i -> ax, Val(N)))

@testset "Constructors" begin
    @test (@inferred Coordinate{2, Tuple{Int, Float64}, Tuple{UnitRange{Int}, Vector{Float64}}}((1:2, [2.0,3.0]))).axes == (1:2, [2.0,3.0])
    @test (@inferred Coordinate{2, Tuple{Int, Char}, Tuple{UnitRange{Int}, String}}((1:2, "abc"))).axes == (1:2, "abc")
    @test_throws ArgumentError Coordinate{2, Tuple{Float64, Float64}, Tuple{UnitRange{Int}, Vector{Float64}}}((1:2, [2.0,3.0]))
    # from axes
    for axes in ((1:3,),
                (1:3, 2:4),
                (1:3, 2:4, 5:8),
                (1:3, 2:2.0:4, "abcd"),
                (1:3, [1,2,3.0], "abcd"))
        N = length(axes)
        ElType = Tuple{map(eltype, axes)...}
        C = (@inferred Coordinate(axes))::Coordinate{N, ElType, typeof(axes)}
        C = (@inferred Coordinate(axes...))::Coordinate{N, ElType, typeof(axes)}
        check_coordinate(C, axes)
    end
    # from axis
    for axis in (1:3, [2,4,4.0], "abcd")
        for N in 1:3
            axes = ntuple(i -> axis, Val(N))
            ElType = Tuple{map(eltype, axes)...}
            C = (@inferred Coordinate{N}(axis))::Coordinate{N, ElType, typeof(axes)}
            check_coordinate(C, axis)
        end
    end
end

@testset "Operations" begin
    @testset "subarray" begin
        x = Coordinate(1:4, [2,3,4])
        sub = Coordinate(2:3, [2,3])
        vec = Coordinate(1:4, 3)
        rowvec = Coordinate(3, [3,4])
        @test (@inferred x[2:3, 1:2])::typeof(sub) == sub
        @test (@inferred x[CartesianIndices((2:3, 1:2))])::typeof(sub) == sub
        @test (@inferred x[:, 2])::typeof(vec) == vec
        @test (@inferred x[3, 2:3])::typeof(rowvec) == rowvec
    end
    @testset "transpose" begin
        x = Coordinate(1:2, [1,2,3])
        xᵀ = Coordinate([1,2,3], 1:2)
        @test (@inferred adjoint(x))::typeof(xᵀ) == xᵀ
        @test (@inferred transpose(x))::typeof(xᵀ) == xᵀ
    end
end
