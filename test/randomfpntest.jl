using HypothesisTests
using Test

include("randomfpn.jl")

@testset "Uniformity test" begin
    function Uniformity(a, b)
        x = [γsectionCC(a, b) for _ in 1:100]
        H = OneSampleADTest(x, Uniform(a, b))
        pvalue(H) > 0.05
    end

    pairs = [(0, 1), (-100, 100), (1, 1000)]

    for p in pairs
        @test Uniformity(p[1], p[2])
    end
end
