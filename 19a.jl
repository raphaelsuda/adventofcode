function parse_rule(::Val{:assign}, num, rule)
    return (num=num, op=:assign, val=rule[2:end-1])
end

function parse_rule(::Val{:sub}, num, rule)
    if occursin('|', rule)
        val = map(split.(split(rule, " | "), ' ')) do v
            parse.(Int, v)
        end
    else
        val = [parse.(Int, split(rule, ' '))]
    end
    return (num=num, op=:sub, val=val)
end

function parse_rule(s)
    num, rule = split(s, ": ")
    occursin('"', rule) && return parse_rule(Val(:assign), parse(Int, num), rule)
    return parse_rule(Val(:sub), parse(Int, num), rule)
end

function get_signals(sub_rules, checked_rules)
    signals = checked_rules[sub_rules[1]]
    length(sub_rules) == 1 && return signals
    new_signals = Set{String}()
    for s in signals
        for t in get_signals(sub_rules[2:end], checked_rules)
            push!(new_signals, s*t)
        end
    end
    return new_signals
end

function check_status(rule, checked_rules)
    rule.op == :assign && return true
    needed_rules = reduce(∪, Set(v) for v in rule.val)
    for nr in needed_rules
        nr ∈ keys(checked_rules) || return false
    end
    return true
end

evaluate(rule, checked_rules) = evaluate(rule.num, Val(rule.op), rule.val, checked_rules)
function evaluate(num, ::Val{:assign}, val, checked_rules)
    checked_rules[num] = Set([val])
    return checked_rules
end

function evaluate(num, ::Val{:sub}, val, checked_rules)
    signals = Set{String}()
    for v in val
        signals = signals ∪ get_signals(v, checked_rules)
    end
    checked_rules[num] = signals
    return checked_rules
end

function solve19a(rules, signals, check_rule=0)
    checked_rules = Dict{Int, Set{String}}()
    while length(checked_rules) < length(rules)
        for r in rules
            check_status(r, checked_rules) || continue
            checked_rules = evaluate(r, checked_rules)
        end
    end
    return count(s ∈ checked_rules[0] for s in signals)
end

rule_lines, signal_lines = split.(split(join(readlines("19.input"), ';'), ";;"), ';')
rules = parse_rule.(rule_lines)
solve19a(rules, signal_lines)