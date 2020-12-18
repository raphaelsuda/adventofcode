-(x,y) = x * y
×(x,y) = x + y

function evaluate(s,rep)
    for k in keys(rep)
        s = replace(s, k=>rep[k])
    end
    return eval(Meta.parse(s))
end

replace_characters = Dict("*"=>"-", "+"=>"×")
reduce(+,evaluate(l, replace_characters) for l in readlines("18.input"))