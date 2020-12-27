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

function split_signal(signal, l)
    parts = String[]
    for i in 1:convert(Int, length(signal)/l)
        i_start = (i-1)*l + 1
        i_end = i * l
        push!(parts, signal[i_start:i_end])
    end
    return parts
end

function check_new_rules(signal, checked_rules)
    _signal = split_signal(signal, 8)
    _signal[1] ∉ checked_rules[42] && return false
    _signal[2] ∉ checked_rules[42] && return false
    _signal[end] ∉ checked_rules[31] && return false
    if length(_signal) > 3
        c42 = 2
        c31 = 1
        phase = 1
        for s in _signal[3:end-1]
            if phase == 1
                s ∈ checked_rules[42] && (c42 += 1)
                s ∉ checked_rules[42] && (phase = 2)
            end
            if phase == 2
                s ∈ checked_rules[31] && (c31 += 1)
                s ∉ checked_rules[31] && return false
            end
        end
        c31 >= c42 && return false
    end
    return true
end

function solve19b(rules, signals, check_rule=0)
    checked_rules = Dict{Int, Set{String}}()
    while length(checked_rules) < length(rules)
        for r in rules
            check_status(r, checked_rules) || continue
            checked_rules = evaluate(r, checked_rules)
        end
    end
    valid = Set{String}()
    for s in signals
        check_new_rules(s, checked_rules) && push!(valid, s)
    end
    return length(valid)
end

rule_lines, signal_lines = split.(split(join(readlines("19.input"), ';'), ";;"), ';')
rules = parse_rule.(rule_lines)
solve19b(rules, signal_lines)