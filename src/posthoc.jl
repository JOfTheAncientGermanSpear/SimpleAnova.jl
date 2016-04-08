using DataFrames

include("anova.jl")

harmonicmean{T <: Real}(ns::AbstractVector{T}) = length(ns)/sum(1./ns)

#http://web.mst.edu/~psyworld/anovaexample.htm
#http://web.mst.edu/~psyworld/tukeysexample.htm#1
function tukey(df::Int64,
               sumSqrs::Float64,
               means::AbstractVector{Float64},
               ns::AbstractVector{Int64})
  ms_within::Float64 = sumSqrs / df
  n::Float64 = harmonicmean(ns)
  mean_error::Float64 = sqrt(ms_within/n)

  num_mns::Int64 = length(means)
  qs = Float64[]
  ps = Float64[]
  lefts = Int64[]
  rights = Int64[]
  for ix in 1:(num_mns - 1)
    for ix2 in (ix+1):num_mns
      ((right_ix, right_mean), (left_ix, left_mean)) = sort(
        [(i, means[i]) for i in [ix, ix2]], by=im -> im[2])

      q::Float64 = (left_mean - right_mean)/mean_error
      qs = [qs; q]
      ps = [ps; ccdf(TDist(df), q)]

      lefts = [lefts; left_ix]
      rights = [rights; right_ix]
    end
  end

  DataFrame(left=lefts, right=rights, q=qs, pval=ps)
end


function tukey(ai::AnovaInfo)
  ns::AbstractVector{Int64} = ai.groupsInfo[:n]
  means::AbstractVector{Float64} = ai.groupsInfo[:mean]

  wg::AbstractVector{Bool} = ai.resultsInfo[:source] .== "Within Group"
  df::Int64 = ai.resultsInfo[wg, :df][1]
  sumSqrs::Float64 = ai.resultsInfo[wg, :sumSquares][1]

  tukey(df, sumSqrs, means, ns)
end
