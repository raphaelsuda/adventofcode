function solve01b(r)
    s = copy(r)
    sort!(s)
    for i in 1:length(s)
        a = s[i]
        for j in 2:length(s)
            b = s[j]
            a+b >= 2020 && break
            for k in 3:length(s)
                c = s[k]
                a+b+c > 2020 && break
                a+b+c == 2020 && return a*b*c
            end
        end
    end
end

r = parse.(Int, readlines("01.input"))
@btime solve01b(r)

# Lösung von Sebi
# first(a*b*c for a in report, b in report, c in report if a + b + c == 2020)