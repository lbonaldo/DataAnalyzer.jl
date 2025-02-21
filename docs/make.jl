using DataAnalyzer
using Documenter

DocMeta.setdocmeta!(DataAnalyzer, :DocTestSetup, :(using DataAnalyzer); recursive=true)

makedocs(;
    modules=[DataAnalyzer],
    authors="lbonaldo <bonaldo.luca12@gmail.com> and contributors",
    sitename="DataAnalyzer.jl",
    format=Documenter.HTML(;
        canonical="https://lbonaldo.github.io/DataAnalyzer.jl",
        edit_link="main",
        assets=[
            "assets/style.css",
        ],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/lbonaldo/DataAnalyzer.jl",
    devbranch="main",
)
