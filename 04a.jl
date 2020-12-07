data = readlines("04.input")
passports = split(join(data,';'),";;")
req_fields = ["byr" ,"iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

function is_valid(p)
    v = true
    for f in req_fields
        v *= occursin("$(f):", p)
    end
    return v
end

count(is_valid.(passports))