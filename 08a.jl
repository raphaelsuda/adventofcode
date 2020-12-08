function parse_instruction(s)
    i = split(s,' ')
    return i[1], parse(Int64, i[2])
end

function solve08a(instructions)
    i = 1
    acc = 0
    check_inst = falses(length(instructions))
    while !(check_inst[i])
        check_inst[i] = true
        inst = instructions[i]
        if inst[1] == "acc"
            acc += inst[2]
            i += 1
        elseif inst[1] == "jmp"
            i += inst[2]
        else
            i += 1
        end
    end
    return acc
end

instructions = parse_instruction.(readlines("08.input"))
solve08a(instructions)