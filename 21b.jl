function parse_line(s)
    ingredients, allergens = split(s, " (contains ")
    ingredients = split(ingredients, ' ')
    allergens = split(allergens[1:end-1], ", ")
    return (ingredients=Set(ingredients), allergens=Set(allergens))
end

function possible_candidates(food)
    allergens = Dict{String, Set{String}}()
    for f in food
        for a in f.allergens
            if a ∈ keys(allergens)
                allergens[a] = Set(f.ingredients) ∩ allergens[a]
            else
                allergens[a] = Set(f.ingredients)
            end
        end
    end
    return allergens
end

function solve21b(food)
    allergen_candidates = possible_candidates(food)
    found_allergens = Dict{String, String}()
    counter = 0
    while length(found_allergens) < length(allergen_candidates)
        for a1 in keys(allergen_candidates)
            a1 in keys(found_allergens) && continue
            candidates = setdiff(allergen_candidates[a1], values(found_allergens))
            for a2 in setdiff(keys(allergen_candidates), Set([a1]) ∪ keys(found_allergens))
                candidates = setdiff(candidates, allergen_candidates[a2])
            end
            if length(candidates) == 1
                found_allergens[a1] = collect(candidates)[1]
            end
        end
    end
    all_ingredients = reduce(∪, f.ingredients for f in food)
    ordered_ingredients = map(sort(collect(keys(found_allergens)))) do a
        return found_allergens[a]
    end
    return join(ordered_ingredients,',')
end

data = readlines("21.input")
food = parse_line.(data)
solve21b(food)