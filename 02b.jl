mutable struct Policy
    char::String
    p1::Int
    p2::Int
end

r = r"(\d+)-(\d+)\s(\w):\s(\w+)"

mutable struct Password
    policy::Policy
    pw::String

    function Password(s::String)
        p1, p2, c, pw = match(r, s).captures
        return new(Policy(c, parse(Int64, p1), parse(Int64, p2)), pw)
    end
end

function pw_valid_b(pw::Password)
    c = pw.policy.char
    p1 = pw.policy.p1
    p2 = pw.policy.p2
    return (pw.pw[p1] == c[1]) ⊻ (pw.pw[p2] == c[1])
end


function count_pw_b(pw_db::Array{Password,1})
    valid = pw_valid_b.(pw_db)
    return count(valid)
end

data = readlines("02.input")
pw_db = Password.(data)
count_pw_b(pw_db)