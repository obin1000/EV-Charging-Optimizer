% Initialize
% Input variables
N_ports = 5; % Number of charging ports
P_ports = 11; % Power rating of the charging ports [kW]
C_bat = 40; % Battery capacity in kWh

minutes_in_day = 24*60;

station1 = ChargeStation(N_ports, P_ports);

% Start simulation
for minute=1:minutes_in_day
    new_cars = Car.arriveCars(minute, C_bat);
    station1 = station1.addCars(new_cars);
    station1 = station1.update(minute);
end


% Results
totalPower = station1.getTotalPower();
totalCars = station1.getCompletedCars();
disp("Simulation charged " + totalCars + " cars with " + totalPower + " kWh of power")


