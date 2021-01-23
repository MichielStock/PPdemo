#=
Created on 22/01/2021 11:29:31
Last update: -

@author: Michiel Stock
michielfmstock@gmail.com

Classical example of finding the posterior distribution
of the probability one treatment is better than another.
=#

using DrWatson
@quickactivate "PPdemo"
using Turing, Plots, StatsPlots, StatsBase

@model function treatment(N_A₊, N_A₋, N_B₊, N_B₋)
    # prior distributions of probability of success
    p_A ~ Uniform(0, 1)  # probability that A is effective
    p_B ~ Uniform(0, 1)  # probability that B is effective
    # number of cases for each treatment
    N_A = N_A₊ + N_A₋
    N_B = N_B₊ + N_B₋
    # sample successes
    N_A₊ ~ Binomial(N_A, p_A)
    N_B₊ ~ Binomial(N_B, p_B)
end

N_A₊ = 29
N_A₋ = 1
N_B₊ = 17
N_B₋ = 3

chain = sample(treatment(N_A₊, N_A₋, N_B₊, N_B₋), NUTS(), 1000, drop_warmup=true)

plot(chain)
savefig(plotsdir("treatment/chain.png"))

p_A_better_than_B = mean(chain[:p_A] .> chain[:p_B])

p_A_much_better_than_B = mean(chain[:p_A] .> 2chain[:p_B])