waiting_time(earliest_t, bus_ID) = (earliest_t÷bus_ID+1)*bus_ID - earliest_t

data = readlines("13.input")
earliest_t = parse(Int64, data[1])
bus_schedule = split(data[2], ',')
buses = parse.(Int64, bus_schedule[bus_schedule.!="x"])
waiting_t = waiting_time.(earliest_t, buses)
min_t, i_bus = findmin(waiting_t)
min_t * buses[i_bus]