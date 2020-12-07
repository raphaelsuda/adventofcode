using Formatting

for i in 1:24
    dirname = format("{1:02d}", i)
    if isdir(dirname)
        continue
    end
    mkdir(dirname)
    touch(joinpath(dirname, "$(dirname).input"))
    touch(joinpath(dirname, "$(dirname)a.jl"))
    touch(joinpath(dirname, "$(dirname)b.jl"))
end