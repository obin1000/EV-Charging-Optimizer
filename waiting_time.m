function [average_delay] = waiting_time(arrival_rate, charging_rate)
utilization = arrival_rate / charging_rate;
average_delay = arrival_rate*(charging_rate^(-2))*((utilization^2)/(2*(1-utilization)));
end