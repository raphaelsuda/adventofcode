const directions = Dict("E"=>0, "N"=>90, "W"=>180, "S"=>270)

function rotate(Δ, ang)
    ang_r = deg2rad(ang)
    return convert.(Int64, round.([cos(ang_r) -sin(ang_r);sin(ang_r) cos(ang_r)] * Δ))
end

function parse_instruction(s)
    m = match(r"(\w)(\d+)", s).captures
    return m[1], parse(Int64, m[2])
end

function run_instruction(pos_ship, pos_wp, (action, value))
    action ∈ keys(directions) && return (pos_ship, pos_wp + rotate([value,0], directions[action]))
    action == "L" && return (pos_ship, rotate(pos_wp, value))
    action == "R" && return (pos_ship, rotate(pos_wp,-value))
    action == "F" && return (pos_ship + value*pos_wp, pos_wp)
end

function solve12a(instructions, pos_ship=[0,0], pos_wp=[10,1])
    for i in instructions
        pos_ship, pos_wp = run_instruction(pos_ship, pos_wp, i)
    end
    return sum(abs.(pos_ship))
end

instructions = parse_instruction.(readlines("12.input"))
solve12a(instructions)