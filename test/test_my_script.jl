# @testset "Workflow" begin
#     include("test_my_script.jl")
# end

module TestMyScript

using Test
using DataAnalyzer
using DataFrames

@testset "DataAnalyzer.jl" begin
    @testset "Configuration" begin
        # Test valid config
        config = AnalysisConfig(variability_threshold=2.5)
        @test config.variability_threshold == 2.5

        # Test invalid config
        @test_throws ArgumentError AnalysisConfig(variability_threshold=-1)
    end

    @testset "Data Processing" begin
        # Create test data
        test_data = DataFrame(
            category=["A", "B", "A"],
            value=[1.0, 2.0, 3.0]
        )

        # Test processing
        result = process_data(test_data)
        @test nrow(result) == 2  # Two unique categories
        @test :avg_value in propertynames(result)

        # Test missing columns
        bad_data = DataFrame(x=[1, 2, 3])
        @test_throws ArgumentError process_data(bad_data)
    end

    # Add more test sets...
end
end # module TestMyScript