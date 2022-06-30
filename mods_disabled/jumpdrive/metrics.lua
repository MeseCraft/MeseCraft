local metric = monitoring.counter("jumpdrive_move_calls", "number of jumpdrive.move calls")
local metric_time = monitoring.counter("jumpdrive_move_time", "time usage in microseconds for jumpdrive.move calls")

jumpdrive.move = metric.wrap(metric_time.wrap(jumpdrive.move))
