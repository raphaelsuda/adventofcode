read_cards(s) = parse.(Int, split(s, ';')[2:end])

function draw!(deck1, deck2)
    if deck1[1] > deck2[1]
        append!(deck1, [popfirst!(deck1), popfirst!(deck2)])
        return deck1, deck2
    else
        append!(deck2, [popfirst!(deck2), popfirst!(deck1)])
        return deck1, deck2
    end
end

score(deck) = reduce(+, deck[i] * (length(deck)-i+1) for i in 1:length(deck))

function play(deck1, deck2)
    while !(isempty(deck1)) && !(isempty(deck2))
        draw!(deck1, deck2)
    end
    isempty(deck2) && return score(deck1)
    isempty(deck1) && return score(deck2)
end

deck1, deck2 = read_cards.(split(join(readlines("22.input"), ';'), ";;"))
play(deck1, deck2)