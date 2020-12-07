function get_rows(i, (r1, r2))
    i == 'F' && return Int.((r1, (r1 + r2 - 1)/2))
    i == 'B' && return Int.(((r1 + r2 + 1)/2, r2))
end

function get_cols(i, (s1, s2))
    i == 'L' && return Int.((s1, (s1 + s2 - 1)/2))
    i == 'R' && return Int.(((s1 + s2 + 1)/2, s2))
end

function get_seat(bp; rows=(0, 127), cols=(0, 7))
    for i in bp[1:7]
        rows = get_rows(i, rows)
    end
    for i in bp[8:10]
        cols = get_cols(i,cols)
    end
    return rows[1]*8 + cols[1]
end

function seats_taken(bp; rows=(0, 127), cols=(0, 7))
    taken = falses((rows[2]+1-rows[1])*(cols[2]+1-cols[1]))
    for i in bp
        taken[get_seat(i; rows=rows, cols=cols)] = true
    end
    return taken
end 

function find_my_seat(bp; rows=(0, 127), cols=(0, 7))
    taken = seats_taken(bp; rows=rows, cols=cols)
    empty_seats = collect(1:length(taken))[.!taken]
    for i in empty_seats
        (i-1 in empty_seats || i+1 in empty_seats) || return i
    end
end

boarding_passes = readlines("05.input")
find_my_seat(boarding_passes)