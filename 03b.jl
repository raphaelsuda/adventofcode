input = readlines("03.input")

function check_slope(m, sr, sc, dr, dc)
    mw = length(m[1])
    ml = length(m)
    is_tree = falses(length(m))
    while sr <= ml
        sc > mw ? sc %= mw : nothing
        is_tree[sr] = m[sr][sc] == '#'
        sr += dr
        sc += dc
    end
    return count(is_tree)
end

slopes = [(1,1), (1,3), (1,5), (1,7), (2,1)]
trees = map(slopes) do s
    check_slope(input, 1, 1, s[1], s[2])
end

prod(trees)