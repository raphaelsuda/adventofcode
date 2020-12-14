function bitmask(d, mask)
    l = length(mask)
    b = collect(bitstring(d)[end-l+1:end])
    for i in 1:l
        mask[i] != 'X' && (b[i] = mask[i])
    end
    return parse(Int, join(b); base=2)
end

function run_line(l, mask, mem)
    var, val = split(l, " = ")
    var[1:2] == "ma" && (mask = val)
    if var[1:2] == "me"
        i = parse(Int64, match(r"\d+", var).match)
        mem[i] = bitmask(parse(Int64, val), mask)
    end
    return mask, mem
end

function run_program(program)
    mask = ""
    mem = Dict{Int64, Int64}()
    for l in program
        mask, mem = run_line(l, mask, mem)
    end
    return mask, mem
end

program = readlines("14.input")
mask, mem = run_program(program)
sum(values(mem))