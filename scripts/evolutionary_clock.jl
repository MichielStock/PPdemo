#=
Created on 13/01/2021 10:16:24
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Illustration of inference in a simple evolutionary
clock model.
=#

using DrWatson
@quickactivate "PPdemo"
using Turing, Plots, StatsPlots, StatsBase


@model function evolutionary_clock(xs, ts, xn=nothing)
    #logα ~ Uniform(-2, 4)
    α ~ LogNormal(0, 8)
    for (i, t) in enumerate(ts)
        xs[i] ~ Poisson(α * t)
    end
    if !isnothing(xn)
        tn ~ Uniform(0, 15)
        xn ~ Poisson(α * tn)
    end
end

xs = [12, 19, 23, 67, 81]
ts = [1.0, 2.0, 3.0, 6.0, 7.9]

scatter(ts, xs, xlabel="time (myr)", ylabel="number of mutations", label="")
hline!([43], label="")
savefig(plotsdir("evol_clock/scatter"))

chain1 = sample(evolutionary_clock(xs, ts), NUTS(), 1000, drop_warmup=true)

plot(chain1)


chain2 = sample(evolutionary_clock(xs, ts, 43), NUTS(), 1000, drop_warmup=true)

plot(chain2)
savefig(plotsdir("evol_clock/chain"))
