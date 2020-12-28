read_cards(s) = parse.(Int, split(s, ';')[2:end])

function draw!(deck1, deck2, round, game=1)
    if length(deck1) > deck1[1] && length(deck2) > deck2[1]
        sub_winner, _ = play(copy(deck1[2:deck1[1]+1]), copy(deck2[2:deck2[1]+1]))
        sub_winner == 1 && append!(deck1, [popfirst!(deck1), popfirst!(deck2)])
        sub_winner == 2 && append!(deck2, [popfirst!(deck2), popfirst!(deck1)])
        return deck1, deck2
    end
    if deck1[1] > deck2[1]
        append!(deck1, [popfirst!(deck1), popfirst!(deck2)])
        return deck1, deck2
    else
        append!(deck2, [popfirst!(deck2), popfirst!(deck1)])
        return deck1, deck2
    end
end

score(deck) = reduce(+, deck[i] * (length(deck)-i+1) for i in 1:length(deck))

function play(deck1, deck2, game=1)
    deck_history = Set{Tuple{Vector{Int}, Vector{Int}}}()
    round = 1
    sub_game = 1
    while !(isempty(deck1)) && !(isempty(deck2))
        (deck1, deck2) ∈ deck_history && return 1, score(deck1)
        push!(deck_history, (copy(deck1), copy(deck2)))

        draw!(deck1, deck2, round, game)
        round += 1
    end
    isempty(deck2) && return 1, score(deck1)
    isempty(deck1) && return 2, score(deck2)
end

deck1, deck2 = read_cards.(split(join(readlines("22.input"), ';'), ";;"))
play(deck1, deck2)