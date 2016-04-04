###Simple ANOVA In Julia

_Why_

Could not find a Julia-only package to perform ANOVA.

Though [scipy.stats.f\_oneway][2] can be used with [PyCall][1] to  perform ANOVA in Julia, it requires having Python & Scipy installed.

__Warning: Not Optimized__

If you find bugs or have optimization suggestions, please feel free to let us know/contribute a fix!


Below example is from an [ANOVA tutorial] [3]

```julia
>> diet1 = [8, 16, 9]
>> diet2 = [9, 16, 21, 11, 18]
>> diet3 = [15, 10, 17, 6]
>> calcanova(diet1, diet2, diet3) 
Groups Info
3x3 DataFrames.DataFrame
│ Row │ n │ mean │ stdError │
┝━━━━━┿━━━┿━━━━━━┿━━━━━━━━━━┥
│ 1   │ 3 │ 11.0 │ 2.51661  │
│ 2   │ 5 │ 15.0 │ 2.21359  │
│ 3   │ 4 │ 12.0 │ 2.48328  │
Results Info
3x5 DataFrames.DataFrame
│ Row │ source   │ df │ sumSquares │ FStat    │ PValue   │
┝━━━━━┿━━━━━━━━━━┿━━━━┿━━━━━━━━━━━━┿━━━━━━━━━━┿━━━━━━━━━━┥
│ 1   │ "Groups" │ 9  │ 210.0      │ 0.771429 │ 0.490658 │
│ 2   │ "Error"  │ 2  │ 36.0       │ NA       │ NA       │
│ 3   │ "Total"  │ 11 │ 246.0      │ NA       │ NA

```


[1]: https://github.com/stevengj/PyCall.jl
[2]: http://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.f_oneway.html
[3]: http://people.stat.sc.edu/hendrixl/stat205/Lecture%20Notes/ANOVA%20S12.pdf
