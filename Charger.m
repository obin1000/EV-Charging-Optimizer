classdef Charger
   % A charger adds charge to its assigned car for each timestamp
   properties
      PowerRating {mustBeNumeric} % [kW] Power rating of charger
      ChargingCar Car % Car that is currently charging at this charger, empty if no car is charging
      TotalPowerCharged % [kWh] Total amount of power charged
      CompletedCars % List of cars that have completed charging at this charger
   end
   methods
       function obj = Charger(power_rating)
         obj.PowerRating = power_rating;
         obj.ChargingCar = Car.empty;
         obj.TotalPowerCharged = 0;
       end
       
       function obj = assignCar(obj, car)
          % Assign a car to charge at this charging station
          if obj.isFree()
              obj.ChargingCar = car;
          else
              disp("This charger is already occupied!")
          end
       end
       
       function obj = increaseCharge(obj, time)
          % Increase the charge of the car that is currently charging at
          % this charger
          if not(obj.isFree())
              charging_power = obj.PowerRating*(1/60);
              [obj.ChargingCar, power_added] = obj.ChargingCar.addCharge(charging_power);
              obj.TotalPowerCharged = obj.TotalPowerCharged + power_added;
              % If the car is full, add it to the completed list and 
              % the charger becomes available
              if obj.ChargingCar.isFull()
                obj.ChargingCar.DepartureTime = time;
                obj.CompletedCars = [obj.CompletedCars, obj.ChargingCar];
                obj.ChargingCar = Car.empty;
              end
          end
       end

       function free = isFree(obj)
           % Returns if this charger is free
          free = isempty(obj.ChargingCar);
       end
   end
end

