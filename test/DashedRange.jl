@testset "DashedRange" begin
    @test (@inferred DashedRange(1:11, 2, 3)) == [1,2,6,7,11]
    @test (@inferred DashedRange(1:14, 2, 3)) == [1,2,6,7,11,12]
    @test (@inferred DashedRange(DashedRange(1:14, 2, 3), 3, 2)) == [1,2,6,12]
    @test (@inferred DashedRange(1:10, 0, 2)) == []
    @test (@inferred DashedRange(1:10, 2, 0)) == 1:10

    x = DashedRange(1:11, 2, 3)
    @test (@inferred dash(x, 1)) == 1:2
    @test (@inferred dash(x, 2)) == 6:7
    @test (@inferred dash(x, 3)) == 11:11
end
