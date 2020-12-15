function next_number(n, i, numbers)
    n ∉ keys(numbers) && (new_n = 0)
    n ∈ keys(numbers) && (new_n = i - numbers[n])
    numbers[n] = i
    return new_n, i+1, numbers
end

function start_numbers(numbers)
    return numbers[end], length(numbers), Dict(numbers[i]=>i for i in 1:length(numbers)-1)
end

function solve15a(start_num, n_goal=2020)
    n, i, numbers = start_numbers(start_num)
    while i < n_goal
        n, i, numbers = next_number(n, i, numbers)
    end
    return n
end

start_num = parse.(Int, split(readline("15.input"), ','))
@show solve15a(start_num)
@show solve15a(start_num, 30000000)