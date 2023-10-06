%Simulation
% Input variables
N_ports = 4; % Number of charging ports
P_ports = 11; % Power rating of the charging ports [kW]
C_bat = 40; % Battery capacity in kWh

%Other variables
N_cars = 5*24; %total number of cars in a day

%Distributions
p_el1 = importdata("electricity_price.mat"); %electricity price over the day
p_el = table2array(p_el1(:,2));

arr_time_10 = sort(10*rand(1,N_cars/3));
arr_time_10_19 = sort(10+9*rand(1,N_cars*2/5));
arr_time_19_24 = sort(19+5*rand(1,N_cars*2/5));
arr_time = [arr_time_10 arr_time_10_19 arr_time_19_24];% EV arrival times over the day
                                                        % higher intensity
                                                        % between 19 and 10
                                                        % but can be
                                                        % changed

bat_lvl = rand(N_cars,1);% battery level [%]

%Intermediate calculations
t_tot = C_bat*bat_lvl/P_ports; % total charging time of each car
ch_hour_start = ceil(arr_time);%determines in which round hour the car starts being charged
p_paid = zeros(N_cars,1);

for n = 1:N_cars %for all cars
    t_rem = t_tot(n);
    t_paid = zeros(24,1);
    check = 0;
    for k = 1:24 %for all hours of the day
        if k ~= ch_hour_start(n) &&  check ~=1 %if the car has not started to be charged
            t_paid(k) = 0;
        elseif k == ch_hour_start(n) % if the car starts to be charged
            t_paid(k) = ch_hour_start(n) - arr_time(n);
            check = 1;
        elseif k>1 && t_rem >= 1 %the full hours of being charged
            t_paid(k) = 1;
        elseif k>1 && t_rem < 1 && t_rem >= 0 %the last hour the car is being charged
            t_paid(k) = t_rem;
        else
            t_paid(k) = 0; % the remainder of the hours
        end
        t_rem = t_rem - t_paid(k);
    end
    p_paid(n) = sum(t_paid.*p_el); % total money paid by each car for charging
end
%PC = 20*12+40*12; %personnel costs


%Output variables

E = sum(P_ports.*t_tot);%total energy transfered in kwh per car
VC = sum(p_paid); %total variable costs (operation costs) per day
r = VC*1.1; % assuming that the station sells for higher price than they buy it for




