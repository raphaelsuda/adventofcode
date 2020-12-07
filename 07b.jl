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

function count_bags(rule, factor)
    content = Dict{String, Int64}()
    for k in keys(rule) content[k] = rule[k] * factor end
    return content
end

function solve07b(rules, start_bag="shiny gold")
    check_bags = count_bags(rules[start_bag], 1)
    bag_counter = 0
    while !(isempty(check_bags))
        @show bag_counter += sum(values(check_bags))
        c = Dict{String, Int64}()
        for b in keys(check_bags)
            content = count_bags(rules[b], check_bags[b])
            for i in keys(content)
                i in keys(c) ? c[i] += content[i] : c[i] = content[i]
            end
        end
        @show c
        check_bags = c
    end
    return bag_counter
end

data = split.(readlines("07.input"), " bags contain ")
rules = Dict(i[1]=>parse_content(split.(i[2], ',')) for i in data)
solve07a(rules)
solve07b(rules)