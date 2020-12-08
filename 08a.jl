function parse_instruction(s)
    i = split(s,' ')
    return i[1], parse(Int64, i[2])
end

function solve08a(instructions)
    i = 1
    acc = 0
    lines_run = Set{Int64}()
    while !(i in lines_run) && i ≤ length(instructions)
        push!(lines_run, i)
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