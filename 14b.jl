function permutations(n)
    p = map(0:2^n-1) do i
        bitstring(i)[end-n+1:end]
    end
    return p
end

function mask_index(d, mask)
    l = length(mask)
    floating_indices = findall(==('X'),mask)
    b = collect(bitstring(d)[end-l+1:end])
    n = length(floating_indices)
    perm = permutations(n)
    indices = String[]
    for p in perm
        new_b = copy(b)
        j = 1 
        for i in 1:l
            mask[i] == '1' && (new_b[i] = '1')
            if i ∈ floating_indices
                new_b[i] = p[j]
                j += 1
            end
        end
        push!(indices, join(new_b))
    end
    return parse.(Int, indices; base=2)
end


function run_line(l, mask, mem)
    var, val = split(l, " = ")
    var[1:2] == "ma" && (mask = val)
    if var[1:2] == "me"
        i = parse(Int64, match(r"\d+", var).match)
        indices = mask_index(i, mask)
        for j in indices
            mem[j] = parse(Int, val)
        end
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