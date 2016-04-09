using Base
using DataFrames
using Distributions
using HypothesisTests
using Lazy

immutable DataGroup
  data::Vector
  sampleSize::Int64
  sampleMean::Float64
  sampleStd::Float64
  sampleStde::Float64
  weightedMean::Float64
  sumSquares::Float64
  label::Union{Symbol, AbstractString}
end

function DataGroup(data::Vector, label::Union{AbstractString, Symbol})
  sampleSize::Int64 = length(data)
  sampleMean::Float64 = mean(data)
  sampleStd::Float64 = std(data)
  sampleStde::Float64 = sampleStd/sqrt(sampleSize)
  weightedMean::Float64 = sampleSize * sampleMean
  sumSquares::Float64 = sampleStd^2 * (sampleSize - 1)

  DataGroup(data, sampleSize, sampleMean, sampleStd, sampleStde, weightedMean, sumSquares, label)
end


mapGen{T}(datagroups::Vector{T}) = fn::Function -> map(fn, datagroups)

pluckGen{T}(datagroups::Vector{T}) = begin
  map = mapGen(datagroups)
  field::Symbol-> @> d->d.(field) map
end

sumOverGen{T}(datagroups::Vector{T}) = begin
  pluck = pluckGen(datagroups)
  field::Symbol -> @> field pluck sum
end


immutable AnovaInfo
  groupsInfo::DataFrame
  resultsInfo::DataFrame
end

function AnovaInfo(datagroups::Vector{DataGroup},
                   dfWithin::Int64, ssWithin::Float64, msWithin::Float64,
                   dfBetween::Int64, ssBetween::Float64, msBetween::Float64,
                   dfTotal::Int64, ssTotal::Float64,
                   fStat::Float64)
  pluck = pluckGen(datagroups)

  groupsInfo = DataFrame(label=pluck(:label),
                         n=pluck(:sampleSize),
                         mean=pluck(:sampleMean),
                         stdError=pluck(:sampleStde))

  pv::Float64 = ccdf(FDist(dfBetween, dfWithin), fStat)
  resultsInfo = DataFrame(source=["Within Group", "Between Group", "Total"],
                          df=[dfWithin, dfBetween, dfTotal],
                          sumSquares=[ssWithin, ssBetween, ssTotal],
                          FStat=@data([fStat, NA, NA]),
                          PValue=@data([pv, NA, NA])
                          )
  AnovaInfo(groupsInfo, resultsInfo)
end

Base.show(io::IO, ai::AnovaInfo) = begin
  print(io, "Groups Info\n")
  print(io, ai.groupsInfo)
  print(io, "\n")
  print(io, "Results Info\n")
  print(io, ai.resultsInfo)
end

function calcanova(datagroups::AbstractVector{DataGroup})
  map = mapGen(datagroups)
  pluck = pluckGen(datagroups)
  sumOver = sumOverGen(datagroups)

  groupCount::Int64 = length(datagroups)
  dataCount::Int64 = @> :sampleSize sumOver

  ssWithin::Float64 = @> :sumSquares sumOver
  dfWithin::Int64 = dataCount - groupCount
  msWithin::Float64 = ssWithin/dfWithin

  dataMean::Float64 = (@> :weightedMean sumOver)/dataCount
  ssBetween::Float64 = @> d->d.sampleSize*(d.sampleMean - dataMean)^2 map sum
  dfBetween::Int64 = groupCount - 1
  msBetween::Float64 = ssBetween/dfBetween

  ssTotal::Float64 = @> d->sum((d.data - dataMean).^2) map sum
  dfTotal::Int64 = dataCount - 1
  msTotal::Float64 = ssTotal/dfTotal

  Fs::Float64 = msBetween/msWithin

  AnovaInfo(datagroups,
            dfWithin, ssWithin, msWithin,
            dfBetween, ssBetween, msBetween,
            dfTotal, ssTotal,
            Fs)
end

calcanova(datagroups...) = calcanova(DataGroup[d for d in datagroups])
