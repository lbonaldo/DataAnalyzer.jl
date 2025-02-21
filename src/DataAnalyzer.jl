module DataAnalyzer

using CSV, DataFrames, Plots, Statistics
include("my_script.jl")
export AnalysisConfig, AnalysisResults, get_data, process_data, analyze_results, plot_analysis

end
