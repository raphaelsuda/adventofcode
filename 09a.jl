function number_valid(number, preamble)
    for i in 1:length(preamble)
        for j in i:length(preamble)
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

data = parse.(Int64, readlines("09.input"))
solve09a(data)