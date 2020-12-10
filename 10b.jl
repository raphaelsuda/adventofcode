function valid_adapters(a::Int64, adapters::Set{Int64})
    return length(Set(a.+[1,2,3]) ∩ adapters)
end

function valid_adapters(adapters::Set{Int64})
    push!(adapters, 0)
    push!(adapters, maximum(adapters)+3)
    n_valid_a = Int64[]
    for a in sort(collect(adapters))
        push!(n_valid_a, valid_adapters(a, adapters))
    end
    n_valid_a[end] = 1
    return n_valid_a
end

# new possibilities if the joltage of n consecutive adapters
# allows 3 possible next adapters
function poss_3(n)
    n < 0 && return 1
    n == 0 && return 2
    return sum(poss_3.(collect(n-3:n-1)))
end

# count how many consecutive adapters allow three adapters
# starting at position pos
function count_threes(pos, n_valid_a)
    n = 1
    while n_valid_a[pos+n] == 3
        n +=1
    end
    return n, pos + n + 1
end

function solve10b(n_valid_a)
    possibilities = 1
    pos = 1
    while pos < length(n_valid_a)
        if n_valid_a[pos] == 3
            n, pos = count_threes(pos, n_valid_a)
            possibilities *= poss_3(n)
            continue
        end
        possibilities *= n_valid_a[pos]
        pos += 1
    end
    return possibilities
end

n_valid_a = valid_adapters(Set(parse.(Int64, readlines("10.input"))))
solve10b(n_valid_a)