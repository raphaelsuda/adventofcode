initial_config(data) = Set((x, y, 0) for x in 1:size(data, 2), y in 1: size(data, 1) if data[y,x] == '#')

get_neighbors((x, y, z)) = Set((i, j, k) for i in x-1:x+1, j in y-1:y+1, k in z-1:z+1 if (i, j, k) != (x, y, z))

function check_candidate(coords, active_cubes)
    n_active = count(n ∈ active_cubes for n in get_neighbors(coords))
    (coords ∈ active_cubes && n_active ∈ Set([2,3])) && return true
    (coords ∉ active_cubes && n_active == 3) && return true
    return false
end

function solve17a(data, cycles=6)
    active_cubes = initial_config(data)
    new_active_cubes = Set()
    candidates = reduce(∪, get_neighbors(c) for c in active_cubes) ∪ active_cubes
    for i in 1:cycles
        new_active_cubes = Set(c for c in candidates if check_candidate(c, active_cubes))
        active_cubes = new_active_cubes
        candidates = reduce(∪, get_neighbors(c) for c in active_cubes) ∪ active_cubes
    end
    return length(new_active_cubes)
end

data = reduce(vcat, permutedims.(collect.(readlines("17.input"))))
solve17a(data)