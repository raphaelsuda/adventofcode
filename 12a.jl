const directions = Dict("E"=>0, "N"=>90, "W"=>180, "S"=>270)

function rotate(Δ, ang)
    ang_r = deg2rad(ang)
    return convert.(Int64, round.([cos(ang_r) -sin(ang_r);sin(ang_r) cos(ang_r)] * Δ))
end

function parse_instruction(s)
    m = match(r"(\w)(\d+)", s).captures
    return m[1], parse(Int64, m[2])
end

function run_instruction(pos, dir, (action, value))
    action ∈ keys(directions) && return (pos + rotate([value,0], directions[action]), dir)
    action == "L" && return (pos, dir + value)
    action == "R" && return (pos, dir - value)
    action == "F" && return (pos + rotate([value,0], dir), dir)
end

function solve12a(instructions, pos=[0,0], dir=0)
    for i in instructions
        pos, dir = run_instruction(pos, dir, i)
    end
    return sum(abs.(pos))
end

instructions = parse_instruction.(readlines("12.input"))
solve12a(instructions)