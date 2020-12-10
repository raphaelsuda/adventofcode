adapters = [0; sort(parse.(Int64, readlines("10.input")))]
joltage_diff = adapters[2:end] .- adapters[1:end-1]
solution_a = count(i->(i==1), joltage_diff) * (count(i->(i==3), joltage_diff) + 1)