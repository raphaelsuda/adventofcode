function parse_content(s)
    content = map(s) do s_i
        m = match(r"(\d+)\s(\w+\s\w+)", s_i)
        isnothing(m) && return String[]
        return m.captures
    end
    isempty(content[1]) && return Dict{String, Int64}()
    return Dict(c[2] => parse(Int64, c[1]) for c in content)
end

function contains_bag(rules; bag="shiny gold")
    bag_container = Set{String}()
    for k in keys(rules)
        bag ∈ keys(rules[k]) && push!(bag_container, k)
    end
    return bag_container
end

function contains_bag(rules, bags::Set{String})
    bag_container = Set{String}()
    for k in keys(rules)
        for b in bags
            b ∈ keys(rules[k]) && push!(bag_container, k)
        end
    end
    return bag_container
end

function solve07a(rules, start_bag="shiny gold")
    c = contains_bag(rules; bag=start_bag)
    bag_container = Set{String}()
    while !(isempty(c))
        for b in c
            push!(bag_container, b)
        end
        c = contains_bag(rules, c)
    end 
    return length(bag_container)
end

data = split.(readlines("07.input"), " bags contain ")
rules = Dict(i[1]=>parse_content(split.(i[2], ',')) for i in data)
solve07a(rules)