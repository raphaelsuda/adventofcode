function valid_pos(seats, pos)
    return pos[1] ≥ 1 && pos[2] ≥ 1 && pos[1] ≤ size(seats,1) && pos[2] ≤ size(seats,2)
end

function first_to_see(seats, pos, Δpos)
    new_pos = pos + Δpos
    valid_pos(seats, new_pos) ? (return seats[new_pos]) : (return "")
end

function check_seat(seats, pos)
    seats[pos] == "." && return "."
    seats_in_range = String[]
    for d in CartesianIndex.([1,1,0,-1,-1,-1,0,1],[0,1,1,1,0,-1,-1,-1])
        push!(seats_in_range, first_to_see(seats, pos, d))
    end
    seats[pos] == "L" && count(==("#"), seats_in_range) == 0 && return "#"
    seats[pos] == "#" && count(==("#"), seats_in_range) ≥ 4 && return "L"
    return seats[pos]
end

function change_seats(seats)
    new_seats = similar(seats)
    for i in 1:size(seats,1)
        for j in 1:size(seats,2)
            pos = CartesianIndex(i,j)
            new_seats[pos] = check_seat(seats, pos)
        end
    end
    return new_seats
end

function solve11a(seats)
    new_seats = change_seats(seats)
    i = 0
    while seats != new_seats
        i += 1
        seats = copy(new_seats)
        new_seats = change_seats(seats)
    end
    return count(==("#"), new_seats)
end

seats = reduce(vcat, permutedims.(split.(readlines("11.input"), "")))
solve11a(seats)