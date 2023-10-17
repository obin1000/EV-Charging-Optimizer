%Optimization: Simulation for all values for number of ports

%P_ports, C_bat, AverageCarsPerMinute  should be adaptable in the app
P_ports = 50; % Power rating of the charging ports [kW]
C_bat = 40; % Battery capacity in kWh
AverageCarsPerMinute = 0.5;

%Optimization_attribute has to be set in the GUI

%fixed within the app
VC_m_per_port = 10;
minutes_in_day = 24*60;

%initialize optimal values
n_ports_optimal = 0;
revenue_optimal = 0;
waiting_optimal = 100000000000; %very high number cause the shorter the better

%list for creating graphs after optimization (with information from all 50 simulations)
n_ports_rev_wait = {};

if Optimization_attribute == "Revenue"
    for N_ports=1:50
        station1 = ChargeStation(N_ports, P_ports);

        % Start simulation
        for minute=1:minutes_in_day
            new_cars = arrive_cars(minute, AverageCarsPerMinute, C_bat);
            station1 = station1.addCars(new_cars);
            station1 = station1.update(minute);
        end

        revenue = revenue_function(ChargeStation, N_ports, VC_m_per_port)
        waitingtime = station1.getWaitingTime(); % calculates average waiting time
        
        n_ports_rev_wait{N_ports} = [N_ports, revenue, waitingtime]

        if revenue > revenue_optimal
            revenue_optimal = revenue;
            n_ports_optimal = N_ports;
            waiting_optimal = waitingtime;
        end
    end

    disp("Optimization Completed ")
    disp("Optimal number of ports: " + n_ports_optimal)
    disp("Optimal Revenue: " + revenue_optimal)
    disp("Respective Waiting time: " + waiting_optimal)

elseif  Optimization_attribute == "Waiting time"

    for N_ports=1:50
        station1 = ChargeStation(N_ports, P_ports);

        % Start simulation
        for minute=1:minutes_in_day
            new_cars = arrive_cars(minute, AverageCarsPerMinute, C_bat);
            station1 = station1.addCars(new_cars);
            station1 = station1.update(minute);
        end

        revenue = revenue_function(ChargeStation, N_ports, VC_m_per_port)
        waiting_time = station1.getWaitingTime();
        n_ports_rev_wait{N_ports} = [N_ports, revenue, waitingtime]

        if waiting_time < waiting_optimal
            revenue_optimal = revenue;
            n_ports_optimal = N_ports;
            waiting_optimal = waiting_time;
        end
    end

    disp("Optimization Completed ")
    disp("Optimal number of ports: " + n_ports_optimal)
    disp("Optimal Waiting time: " + waiting_optimal)
    disp("Respective Revenue: " + revenue_optimal)
end