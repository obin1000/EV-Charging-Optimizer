power_ports = 100; %kW lower to mid end of DC fast charging (50-350)

load('electricity_price.mat');
% variable costs = price for electricity (hourly) 
VC_elec_per_port = Netherlands.PriceEURMWhe


% variable maintenance cost per hour per port -> independently if used to
% charge or not always 10
VC_m_per_port = repmat(10, 24, 1)

%change to actual demand vector
D = repmat(5, 24, 1)

% Price calculation based on costs 
Price_charging_hourly = 1.2 * (VC_elec_per_port + VC_m_per_port)


revenue_max = 0
number_ports_opt = 0
% between 1-
for number_ports = 1:20
    revenue = sum(- number_ports * VC_m_per_port + (Price_charging_hourly - VC_elec_per_port) .* min(D, number_ports));
    if revenue > revenue_max
        revenue_max = revenue
        number_ports_opt = number_ports
    end

end



fprintf('Maximal Daily revenue: %f\n', revenue_max);
fprintf('Optimal number of ports: %f\n', number_ports_opt);