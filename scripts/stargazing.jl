#=
Created on 08/01/2021 19:28:29
Last update: Monday 11 Jan 2021

@author: Michiel Stock
michielfmstock@gmail.com

Two prisoners are sittingin the dark.
One it watching the stars through the window.
The other is trying to infer the boundaries of the window.
=#

using DrWatson
@quickactivate "PPdemo"
using Turing, Plots, StatsPlots, StatsBase

n_stars = 10

xmin, xmax = 9.5, 14
ymin, ymax = 2.5, 7.3

xs = rand(n_stars) .* (xmax - xmin) .+ xmin
ys = rand(n_stars) .* (ymax - ymin) .+ ymin


@model function infer_window(xs, ys)
    n = length(xs)
    xmin ~ Uniform(0.0, minimum(xs))
    ymin ~ Uniform(0.0, minimum(ys))
    xmax ~ Uniform(maximum(xs), 20)
    ymax ~ Uniform(maximum(ys), 20)
    for i in 1:n
        xs[i] ~ Uniform(xmin, xmax)
        ys[i] ~ Uniform(ymin, ymax)
    end
end

chain = sample(infer_window(xs, ys), HMC(0.1, 10), 1000, drop_warmup=true)

plot(chain)


fig_stars = scatter(xs, ys, m=:star, xlims=[0, 20], ylims=[0, 10], bgcolor=:black,
            color=:yellow, label="stars")

savefig(fig_stars, plotsdir("stargazing/stars.png"))

for i in 1:10:length(chain)
    xmin = chain[:xmin][i]
    xmax = chain[:xmax][i]
    ymin = chain[:ymin][i]
    ymax = chain[:ymax][i]
    plot!(fig_stars, [xmax, xmin, xmin, xmax, xmax], [ymax, ymax, ymin, ymin, ymax], alpha=0.2, label="", lw=0.5,
            color=:orange)
end

xminest = chain[:xmin] |> mean
xmaxest = chain[:xmax] |> mean
yminest = chain[:ymin] |> mean
ymaxest = chain[:ymax] |> mean

plot!(fig_stars, [xmaxest, xminest, xminest, xmaxest, xmaxest],
                    [ymaxest, ymaxest, yminest, yminest, ymaxest], label="post boundary", lw=2,
            color=:blue)

plot!(fig_stars, [xmax, xmin, xmin, xmax, xmax],
                [ymax, ymax, ymin, ymin, ymax], label="true boundary", lw=2, color=:green)

savefig(fig_stars, plotsdir("stargazing/stars_and_border.png"))
fig_stars
