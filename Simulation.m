% Initialize
% Input variables
N_ports = 28; % Number of charging ports
P_ports = 50; % Power rating of the charging ports [kW]
C_bat = 40; % Battery capacity in kWh
AverageCarsPerMinute = 0.5;

minutes_in_day = 24*60;

station1 = ChargeStation(N_ports, P_ports);

% Start simulation
for minute=1:minutes_in_day
    new_cars = Car.arriveCars(minute, AverageCarsPerMinute, C_bat);
    station1 = station1.addCars(new_cars);
    station1 = station1.update(minute);
end


% Results
totalPower = station1.getTotalPower();
totalCars = station1.getCompletedCars();
totalWait = station1.getWaitingTime();
totalCost = station1.getCost();

disp("Simulation Completed ")
disp("Total cars charged:  " + totalCars)
disp("Total power charged: " + totalPower + " kWh")
disp("Total cost: " + totalCost + " Euro")
disp("Total waiting time: " + totalWait + " minutes ")
disp("Average waiting time: " + totalWait/totalCars + " minutes ")
