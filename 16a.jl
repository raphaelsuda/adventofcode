function parse_rule(s)
    m = match(r"(^\w+\s?\w*): (\d+)-(\d+) or (\d+)-(\d+)", s).captures
    return Set(parse.(Int, m[2]):parse.(Int, m[3])) ∪ Set(parse.(Int, m[4]):parse.(Int, m[5]))
end

parse_ticket(s) = Set(parse.(Int, split(s, ',')))

function solve16a(tickets, rules)
    invalid_numbers = Int[]
    for t in tickets
        for n in t
            n ∈ rules || push!(invalid_numbers, n)
        end
    end
    return sum(invalid_numbers)
end

rule_lines, myticket_lines, nearby_lines = map(split(join(readlines("16.input"), ';'),";;")) do l
    return split(l, ';')
end
myticket = parse_ticket(myticket_lines[2])
nearby_tickets = parse_ticket.(nearby_lines[2:end])
rules = reduce(∪, parse_rule.(rule_lines))
solve16a(nearby_tickets, rules)