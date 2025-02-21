```@meta
CurrentModule = DataAnalyzer
```

# DataAnalyzer

Documentation for [DataAnalyzer](https://github.com/lbonaldo/DataAnalyzer.jl).

## Installation
```julia
using Pkg
Pkg.add("DataAnalyzer")
```

## Usage
```julia
# Import the package
using DataAnalyzer

# Create configuration
config = AnalysisConfig(
    variability_threshold = 2.0,
    output_path = "results.png"
)

# Process data
data = get_data("data.csv")
processed = process_data(data)
results = analyze_results(processed, config)
plot_analysis(results, config)
```

```@index
```

## API Reference

### Types
```@docs
AnalysisConfig
AnalysisResults
```

### Functions
```@docs
get_data
process_data
analyze_results
plot_analysis
```
