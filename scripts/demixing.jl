#=
Created on 11/01/2021 16:24:12
Last update: 19 Feb 2021

@author: Michiel Stock
michielfmstock@gmail.com

Demixing example: NOT FINISHED!
=#

using DrWatson
@quickactivate "PPdemo"
using Turing, Plots, StatsPlots, StatsBase

using LinearAlgebra: ⋅

@model function demix(y, X; σ=0.1)
    n, p = size(X)  # components, attributes
    α ~ Dirichlet(n, 1.0)  # composition prior
    for i in 1:p
        for 1 in 1:n

        y[i] ~ Normal(X[:,i] ⋅ )

end



chain = sample(demix(1.0, [0.8, 1.8, 50.9]), NUTS(), 1000, drop_warmup=true)

corner(chain)