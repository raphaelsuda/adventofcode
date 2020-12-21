function parse_tile(tile_lines)
    num = parse(Int, match(r"^Tile (\d+):$", tile_lines[1]).captures[1])
    pixels = reduce(vcat, permutedims(collect(t_l)) for t_l in tile_lines[2:end])
    return num => pixels
end

function get_boarders(pixels)
    return [pixels[1, 1:end],
            pixels[1:end, end],
            pixels[end, end:-1:1],
            pixels[end:-1:1, 1]]
end

function get_all_boarders(tiles)
    all_boarders = Tuple{Int, String}[]
    for n in keys(tiles)
        boarders = join.(get_boarders(tiles[n]))
        for b in boarders
            push!(all_boarders, (n, b))
        end
    end
    return all_boarders
end

function compare_boarders(b, boarders)
    for b2 in boarders
        b == b2 && return true
        b == reverse(b2) && return true
    end
    return false
end

function compare_all_boarders(tiles)
    all_boarders = get_all_boarders(tiles)
    connections = Dict(k => 0 for k in keys(tiles))
    for i in 1:length(all_boarders) - 1
        n1, b1 = all_boarders[i]
        for j in i+1:length(all_boarders)
            n2, b2 = all_boarders[j]
            if b1 == b2 || b1 == reverse(b2)
                connections[n1] += 1
                connections[n2] += 1
                break
            end
        end
    end
    return connections
end

data = map(split(join(readlines("20.input"), ';'), ";;")) do t
    return split(t, ';')
end

tiles = Dict(parse_tile(d) for d in data)
connections = compare_all_boarders(tiles)
reduce(*, i for i in keys(connections) if connections[i] == 2)