function solve01a(r)
    _r = sort(r)
    for i in 1:length(_r)
        a = _r[i]
        for j in i:length(_r)
            b = _r[j]
            a+b > 2020 && break
            a+b == 2020 && return a*b
        end
    end
end

r = parse.(Int, readlines("01.input"))
@btime solve01a(r)