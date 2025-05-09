using DataAnalyzer
using Test
using Aqua
using JET

@testset "DataAnalyzer.jl" begin
    @testset "DataAnalyzer.jl" begin
        include("test_my_script.jl")
    end
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(DataAnalyzer)
    end
    @testset "Code linting (JET.jl)" begin
        JET.test_package(DataAnalyzer; target_defined_modules = true)
    end
    # Write your tests here.
end
