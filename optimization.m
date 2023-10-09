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

% Define the objective function
fun = @(number_ports) sum(number_ports * VC_m_per_port - (Price_charging_hourly - VC_elec_per_port) .* min(D, number_ports));

% Initial guess for number of ports
ports_0 = 1;  

% Lower and Upper bounds (non-negative)
lb_ports = 1 %minimum number of ports
ub_ports = 20 %maximum number of ports (due to space restrictions)

% Define any additional constraints if needed
A = [];
b = [];
Aeq = [];
beq = [];

% Perform the minimization
options = optimoptions('fmincon', 'Display', 'iter');  % You can adjust the display option as needed
ports_opt = fmincon(fun, ports_0, A, b, Aeq, beq, lb_ports, ub_ports, [], options);

% Display the minimum value of the function and the corresponding x
max_revenue = - fun(ports_opt);
fprintf('Maximal Daily revenue: %f\n', max_revenue);
fprintf('Optimal number of ports: %f\n', ports_opt);