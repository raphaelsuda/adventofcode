function get_rows(i, (r1, r2))
    i == 'F' && return (r1, (r1 + r2 - 1)/2)
    i == 'B' && return ((r1 + r2 + 1)/2, r2)
end

function get_cols(i, (s1, s2))
    i == 'L' && return (s1, (s1 + s2 - 1)/2)
    i == 'R' && return ((s1 + s2 + 1)/2, s2)
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

boarding_passes = readlines("05.input")
maximum(get_seat.(boarding_passes))