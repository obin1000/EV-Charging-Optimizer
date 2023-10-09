function [E_transf_hour, p_paid_hour] = charging_price_func(N_cars,t_tot,arr_time)

ch_hour_start = ceil(arr_time);%determines in which round hour the car starts being charged
p_paid = zeros(N_cars,1);
t_paid_all = zeros(N_cars,24);

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
    t_paid_all(n,:) = t_paid;
end



t_paid_hour = zeros(24,1);
for p = 1:24
    t_paid_hour(p) = sum(t_paid_all(:,p));
end
p_paid_hour = t_paid_hour.*p_el;  %total variable costs every hour
E_transf_hour = t_paid_hour.*P_ports;

end