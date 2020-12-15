waiting_time(earliest_t, bus_ID) = (earliest_t÷bus_ID+1)*bus_ID - earliest_t

function valid_t(buses, i)
    t1 = buses[1][1] * i
    for b in buses[2:end]
        (t1 + b[2])%b[1] == 0 || return false
    end
    return true
end

function get_period(ID_1, ID_2, offset)
    i = 1
    while !(valid_t([(ID_1, 0), (ID_2, offset)], i))
        i += 1
    end
    return i, ID_2
end

function merge_periods((o1, p1), (o2, p2))
    i1 = 0
    i2 = 0
    o = 0
    found_start = false
    while true
        n1 = o1 + i1*p1
        n2 = o2 + i2*p2
        if n1 < n2
            i1 = (n2 - o1)÷p1
            (n2 - o1)%p1 != 0 && (i1 += 1)
            continue
        end
        if n2 < n1
            i2 = (n1 - o2)÷p2
            (n1 - o2)%p2 != 0 && (i2 += 1)
            continue
        end
        n1 == n2 && found_start == true && return (o, n1-o) 
        if n1 == n2
            o = n1
            found_start = true
            i1 += 1
        end
    end
end

function solve13b(buses)
    periods = Tuple{Int64, Int64}[]
    for b in buses[2:end]
        push!(periods, get_period(buses[1][1], b[1], b[2]))
    end
    new_period = periods[1]
    for p in periods[2:end]
        new_period = merge_periods(new_period, p)
    end
    return new_period[1] * buses[1][1]
end

data = readlines("13.input")
bus_schedule = split(data[2], ',')
buses = Tuple{Int64, Int64}[]
for i in 1:length(bus_schedule)
    bus_schedule[i] != "x" && push!(buses, (parse(Int64, bus_schedule[i]), i-1))
end

periods = Tuple{Int64, Int64}[]
for b in buses[2:end]
    push!(periods, get_period(buses[1][1], b[1], b[2]))
end
solve13b(buses)