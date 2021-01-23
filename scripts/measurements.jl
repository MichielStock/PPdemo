#=
Created on 21/01/2021 14:32:00
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Several scientists perform a measurement, though they do not all have the same precision!
=#


using DrWatson
@quickactivate "PPdemo"
using Turing, Plots, StatsPlots, StatsBase

@model function measurement(x)
    n = length(x)
    σ²_μ ~ InverseGamma(10, 0.1)
    μ ~ Normal(0.0, √(σ²_μ))
    σ² = Vector(undef, n)
    for i in 1:n
        σ²[i] ~ InverseGamma(10, 0.1)
        x[i] ~ Normal(μ, √(σ²[i]))
    end
end

x = [-27.020,
    3.70,
    8.191,
    9.898,
    9.603,
    9.945,
    10.056
    ]


chain = sample(measurement(x), NUTS(), 1000, drop_warmup=true)
plot(chain)
savefig(plotsdir("measurements/chain.png"))

fig = scatter('A':'G', x, ylims = [-50, 20], label="x", legend=:bottomright)
ylabel!("measured values")
xlabel!("scientists")
title!("Seven noisy hetroscedastic measurements")

savefig(fig, plotsdir("measurements/measurements.png"))

# posterior mean (average value)
μ = chain[:μ] |> mean

# posterior std of measurements
σ = get(chain, :σ²).:σ² .|> mean .|> sqrt |> x->[x...]

scatter('A':'G', x, ylims = [-50, 20], label="x +- 3std", yerror=3σ, legend=:bottomright)
ylabel!("measured values")
xlabel!("scientists")
title!("Seven noisy hetroscedastic measurements")
hline!([μ], color="red", label="posterior mean")
savefig(plotsdir("measurements/measurements_post.png"))