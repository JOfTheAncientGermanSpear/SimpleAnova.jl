using Base.Test
using DataFrames
include("../src/anova.jl")


x = [1, 2, 3]
mapX = mapGen(x)
@test mapX(i -> i + 2) == x + 2
@test mapX(i -> i * 3) == x * 3

immutable Point
  x::Int64
  y::Int64
end

pts = [Point(1, 2), Point(3, 4)]

pluck = pluckGen(pts)
@test pluck(:x) == [1, 3]
@test pluck(:y) == [2, 4]

sumOver = sumOverGen(pts)
@test sumOver(:x) == 1 + 3
@test sumOver(:y) == 2 + 4



#Will test with Below Introduction Data
#http://people.stat.sc.edu/hendrixl/stat205/Lecture%20Notes/ANOVA%20S12.pdf

diet1 = [8, 16, 9]
diet2 = [9, 16, 21, 11, 18]
diet3 = [15, 10, 17, 6]
anovaInfo = calcanova(diet1, diet2, diet3)

expectedGroupsInfo = DataFrame(n=[3, 5, 4],
                               mean=[11, 15, 12.],
                               stdError=[2.517, 2.214, 2.483])

isFloatCol(d::AbstractArray) = isa(d, AbstractArray{Float64, 1})

for n in names(expectedGroupsInfo)
  if isFloatCol(anovaInfo.groupsInfo[n])
    @test all((anovaInfo.groupsInfo[n] - expectedGroupsInfo[n]) .< .001 )
  else
    @test anovaInfo.groupsInfo[n] == expectedGroupsInfo[n]
  end
end

expectedResultsInfo = DataFrame(source=["Groups", "Error", "Total"],
                                df=[9, 2, 11],
                                sumSquares = [210., 36., 246.],
                                FStat = @data([.771429, NA, NA]),
                                PValue = @data([.490658, NA, NA]))

for n in names(expectedResultsInfo)
  actual = anovaInfo.resultsInfo[n]
  expected = expectedResultsInfo[n]

  @test length(actual) == length(expected)

  actual = dropna(actual)
  expected = dropna(expected)

  @test length(actual) == length(expected)
  if isFloatCol(actual)
    @test all( (actual - expected) .< .00001)
  else
    @test actual == expected
  end
end
