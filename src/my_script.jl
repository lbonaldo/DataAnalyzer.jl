# using CSV, DataFrames, Plots, Statistics
# include("my_script.jl")
# export AnalysisConfig, AnalysisResults, get_data, process_data, analyze_results, plot_analysis

"""
    struct AnalysisConfig

Configuration for data analysis.

# Fields
- `variability_threshold::Float64`: Threshold for variability, must be positive.
- `output_path::String`: Path to save the analysis results.

# Constructor
- `AnalysisConfig(; variability_threshold=2.0, output_path="analysis_results.png")`
    - `variability_threshold`: Threshold for variability, default is 2.0.
    - `output_path`: Path to save the analysis results, default is "analysis_results.png".
"""
struct AnalysisConfig
    variability_threshold::Float64
    output_path::String

    # Constructor with validation and defaults
    function AnalysisConfig(;
        variability_threshold = .53,
        output_path = "analysis_results.png"
    )
        variability_threshold > 0 || throw(ArgumentError("Threshold must be positive"))
        return new(variability_threshold, output_path)
    end
end

"""
    struct AnalysisResults

Results of the data analysis.

# Fields
- `high_variance_categories::DataFrame`: DataFrame containing categories with high variance.
- `total_samples::Int`: Total number of samples analyzed.
- `anomaly_rate::Float64`: Rate of anomalies detected in the data.

# Constructor
- `AnalysisResults(high_variance_categories::DataFrame, total_samples::Int, anomaly_rate::Float64)`
    - `high_variance_categories`: DataFrame containing categories with high variance.
    - `total_samples`: Total number of samples analyzed.
    - `anomaly_rate`: Rate of anomalies detected in the data.
"""
struct AnalysisResults
    high_variance_categories::DataFrame
    total_samples::Int
    anomaly_rate::Float64
end

"""
    get_data(path::AbstractString) -> DataFrame

Reads data from a CSV file and returns it as a DataFrame.

# Arguments
- `path::AbstractString`: The path to the CSV file.

# Returns
- `DataFrame`: The data read from the CSV file.

# Throws
- `ArgumentError`: If the file does not exist.
- `ErrorException`: If there is an error reading the data.
"""
function get_data(path::AbstractString)
    if !isfile(path)
        throw(ArgumentError("File not found: $path"))
    end

    try
        return CSV.read(path, DataFrame)
    catch e
        throw(ErrorException("Failed to read data: $(e.msg)"))
    end
end

"""
    process_data(data::DataFrame) -> DataFrame

Processes the input DataFrame by validating required columns, removing missing values, 
and calculating statistics for each category.

# Arguments
- `data::DataFrame`: The input data containing at least 'category' and 'value' columns.

# Returns
- `DataFrame`: A DataFrame with calculated statistics including average value, 
  standard deviation, and count for each category.

# Throws
- `ArgumentError`: If required columns are missing.
- `ErrorException`: If there is an error in computing statistics.
"""
function process_data(data::DataFrame)
    # Input validation
    required_cols = [:category, :value]
    if !all(col -> col in propertynames(data), required_cols)
        missing_cols = filter(col -> !(col in propertynames(data)), required_cols)
        throw(ArgumentError("Missing required columns: $missing_cols"))
    end

    # Remove missing values with logging
    n_before = nrow(data)
    clean_data = dropmissing(data)
    n_removed = n_before - nrow(clean_data)
    @info "Removed $n_removed rows with missing values"

    # Calculate statistics with error handling
    try
        stats = combine(
            groupby(clean_data, :category),
            :value => mean => :avg_value,
            :value => std => :std_value,
            nrow => :count
        )
        return stats
    catch e
        throw(ErrorException("Failed to compute statistics: $(e.msg)"))
    end
end

"""
    analyze_results(processed_data::DataFrame, config::AnalysisConfig=AnalysisConfig()) -> AnalysisResults

Analyzes the processed data to identify categories with high variability and calculates metrics.

# Arguments
- `processed_data::DataFrame`: The DataFrame containing processed data with statistics.
- `config::AnalysisConfig`: Configuration for the analysis, including variability threshold.

# Returns
- `AnalysisResults`: An object containing high variability categories, total samples, and anomaly rate.

# Throws
- `ErrorException`: If there is an error during the analysis.
"""
function analyze_results(
    processed_data::DataFrame,
    config::AnalysisConfig=AnalysisConfig()
)
    # Find categories with high variability
    high_var = filter(
        row -> row.std_value > config.variability_threshold * row.avg_value,
        processed_data
    )

    # Calculate metrics
    total_samples = sum(processed_data.count)
    anomaly_rate = nrow(high_var) / nrow(processed_data)

    return AnalysisResults(high_var, total_samples, anomaly_rate)
end

"""
    plot_analysis(results::AnalysisResults, config::AnalysisConfig=AnalysisConfig()) -> Plot

Generates a bar plot for categories with high variability and saves it to a file.

# Arguments
- `results::AnalysisResults`: The results of the analysis containing high variability categories.
- `config::AnalysisConfig`: Configuration for the analysis, including output path for the plot.

# Returns
- `Plot`: The generated bar plot.

# Throws
- `ErrorException`: If there is an error during the plotting process.
"""
function plot_analysis(results::AnalysisResults, config::AnalysisConfig=AnalysisConfig())
    p = bar(
        results.high_variance_categories.category,
        results.high_variance_categories.std_value,
        title="Categories with High Variability",
        xlabel="Category",
        ylabel="Standard Deviation",
        rotation=45
    )

    savefig(p, config.output_path)
    return p
end


# data = get_data(joinpath("..", "data", "data.csv"))
# processed = process_data(data)
# results = analyze_results(processed)
# plot = plot_analysis(results)
# savefig(plot, joinpath("..", "results", "analysis_results.png"))

# # Maybe add some print statements
# println("Analysis complete!")
# println("Total samples processed: $(results.total_samples)")
# println("Anomaly rate: $(round(results.anomaly_rate * 100, digits=2))%")