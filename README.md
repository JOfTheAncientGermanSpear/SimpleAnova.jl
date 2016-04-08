###Simple ANOVA In Julia

_Why_

Could not find a pure Julia ANOVA implementation.

_Note: ANOVA can also be performed in Julia by interoping with Python's [scipy.stats.f\_oneway][2] through [PyCall][1]. However, this requires installing Python & Scipy._


__Warning: Not Optimized__

* This code is not a registered package
  * Install command: 
  * Pkg.clone("https://github.com/JOfTheAncientGermanSpear/SimpleAnova.jl.git")
* If you find bugs or have optimization suggestions, please feel free to contribute a fix or let us know.


Below example is from an [ANOVA tutorial] [3]

```julia
>> Pkg.clone("https://github.com/JOfTheAncientGermanSpear/SimpleAnova.jl.git")
>> using SimpleAnova
>> diet1 = [8, 16, 9]
>> diet2 = [9, 16, 21, 11, 18]
>> diet3 = [15, 10, 17, 6]
>> dg(a, l) = DataGroup(a, l)
>> ai = calcanova(dg(diet1, :diet1), dg(diet2, :diet2), dg(diet3, :diet3)) 
Groups Info
3x3 DataFrames.DataFrame
│ Row │ n │ mean │ stdError │
┝━━━━┿━━━┿━━━━━━┿━━━━━━━━━━┥
│ 1   │ 3 │ 11.0 │ 2.51661  │
│ 2   │ 5 │ 15.0 │ 2.21359  │
│ 3   │ 4 │ 12.0 │ 2.48328  │
Results Info
3x5 DataFrames.DataFrame
│ Row │ source   │ df │ sumSquares │ FStat    │ PValue   │
┝━━━━┿━━━━━━━━━━┿━━━━┿━━━━━━━━━━━━┿━━━━━━━━━━┿━━━━━━━━━━┥
│ 1   │ "Groups" │ 9  │ 210.0      │ 0.771429 │ 0.490658 │
│ 2   │ "Error"  │ 2  │ 36.0       │ NA       │ NA       │
│ 3   │ "Total"  │ 11 │ 246.0      │ NA       │ NA
>> tukey(ai)
3x4 DataFrames.DataFrame
│ Row │ left │ right │ q        │ pval      │
┝━━━━┿━━━━━━┿━━━━━━━┿━━━━━━━━━━┿━━━━━━━━━━━┥
│ 1   │ 2    │ 1     │ 1.62054  │ 0.0697841 │
│ 2   │ 3    │ 1     │ 0.405134 │ 0.34742   │
│ 3   │ 2    │ 3     │ 1.2154   │ 0.127566  │
```


##Required Packages

* [DataFrames][4]
* [Distributions][5]
* [HypothesisTests][6]
* [Lazy][7]


[1]: https://github.com/stevengj/PyCall.jl
[2]: http://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.f_oneway.html
[3]: http://people.stat.sc.edu/hendrixl/stat205/Lecture%20Notes/ANOVA%20S12.pdf
[4]: https://github.com/JuliaStats/DataFrames.jl
[5]: https://github.com/JuliaStats/Distributions.jl
[6]: https://github.com/JuliaStats/HypothesisTests.jl
[7]: https://github.com/MikeInnes/Lazy.jl
