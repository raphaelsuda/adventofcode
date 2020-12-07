req_fields = ["byr" ,"iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
valid_colors = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

r = Dict("byr" => r"^(\d{4})$",
         "iyr" => r"^(\d{4})$",
         "eyr" => r"^(\d{4})$",
         "hgt" => r"^(\d+)(cm|in)$",
         "hcl" => r"^(#[0-9a-f]{6})$",
         "ecl" => r"^(\w{3})$",
         "pid" => r"^(\d{9})$")

function read_passport(s)
    s_split = split(s, [';', ' '])
    p = Dict{String, String}()
    for i in s_split
        field = split(i, ':')
        p[field[1]] = field[2]
    end
    return p
end

function check_rules(p)
    val = Dict()
    for f in keys(r)
        m = match(r[f], p[f])
        m == nothing && return false
        val[f] = m.captures 
    end
    1920 <= parse(Int, val["byr"][1]) <= 2002 || return false
    2010 <= parse(Int, val["iyr"][1]) <= 2020 || return false
    2020 <= parse(Int, val["eyr"][1]) <= 2030 || return false
    if val["hgt"][2] == "cm"
        150 <= parse(Int, val["hgt"][1]) <= 193 || return false
    else
        59 <= parse(Int, val["hgt"][1]) <= 76 || return false
    end
    val["ecl"][1] in valid_colors || return false
    return true
end

function is_valid(p)
    for f in req_fields
        f in keys(p) || return false
    end
    return check_rules(p)
end

data = readlines("04.input")
passports = split(join(data,';'),";;")
count(is_valid.(read_passport.(passports)))