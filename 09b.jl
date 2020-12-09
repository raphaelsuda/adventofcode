function number_valid(number, preamble)
    for i in 1:length(preamble)
        for j in i+1:length(preamble)
            number == preamble[i] + preamble[j] && return true
        end
    end
    return false
end

function solve09a(numbers)
    for i in 26:length(numbers)
        preamble = numbers[i-25:i-1]
        number_valid(numbers[i], preamble) || return numbers[i]
    end
end

function solve09b(numbers, invalid_number)
    for i in 1:length(numbers)
        for j in i+1:length(numbers)
            rng = numbers[i:j]
            sum(rng) == invalid_number && return minimum(rng) + maximum(rng)
        end
    end
end

data = parse.(Int64, readlines("09.input"))
invalid_number = solve09a(data)
solve09b(data, invalid_number)