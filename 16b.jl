function parse_rule(s)
    m = match(r"(^\w+\s?\w*): (\d+)-(\d+) or (\d+)-(\d+)", s).captures
    return m[1]=>Set(parse.(Int, m[2]):parse.(Int, m[3])) ∪ Set(parse.(Int, m[4]):parse.(Int, m[5]))
end

parse_ticket(s) = parse.(Int, split(s, ','))

function rm_invalid!(tickets, rules)
    invalid_tickets = Int[]
    all_rules = reduce(∪, values(rules))
    for i in 1:length(tickets)
        for n in tickets[i]
            n ∈ all_rules || push!(invalid_tickets, i)
        end
    end
    counter = 0
    for i in invalid_tickets
        deleteat!(tickets, i - counter)
        counter += 1
    end
end

function valid_rules(n, rules)
    valid = Set{String}()
    for r in rules
        n ∈ r[2] && push!(valid, r[1])
    end
    return valid
end

function solve16b(my_ticket, nearby_tickets, rules)
    valid = map(nearby_tickets) do t
        return map(t) do n
            return valid_rules(n, rules)
        end
    end
    field_index = Dict{String, Int}()
    while length(keys(field_index)) < length(my_ticket)
        for i in 1:length(my_ticket)
            i in values(field_index) && continue
            fields = collect(setdiff(reduce(∩, t[i] for t in valid), keys(field_index)))
            length(fields) == 1 && (field_index[fields[1]] = i)
        end
    end
    i_departure = collect(values(field_index))[startswith.(collect(keys(field_index)), "departure")]
    return prod(my_ticket[i_departure])
end

rule_lines, myticket_lines, nearby_lines = map(split(join(readlines("16.input"), ';'),";;")) do l
    return split(l, ';')
end
myticket = parse_ticket(myticket_lines[2])
nearby_tickets = parse_ticket.(nearby_lines[2:end])
rules = Dict(parse_rule.(rule_lines))
rm_invalid!(nearby_tickets, rules)
solve16b(myticket, nearby_tickets, rules)