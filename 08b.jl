
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
        i > length(instructions) && break
    end
    return acc, check_inst[end]
end

function solve08b(instructions)
    for i in 1:length(instructions)
        new_instructions = copy(instructions)
        if new_instructions[i][1] == "jmp"
            new_instructions[i] = ("nop", new_instructions[i][2])
        elseif new_instructions[i][1] == "nop"
            new_instructions[i] = ("jmp", new_instructions[i][2])
        else
            i += 1
            continue
        end
        acc, check = solve08a(new_instructions)
        check && return acc
    end
end

instructions = parse_instruction.(readlines("08.input"))
solve08a(instructions)
solve08b(instructions)