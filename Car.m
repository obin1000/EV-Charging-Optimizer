classdef Car
   properties
      Capacity double % [kWh] Total capacity of the car
      Charge double   % [kWh] Current capacity of the car
      Cost double % [Euro] Amount to pay for the electricity 
      ArrivalTime double
      AssignedTime double % Time when assigned to a charger
      DepartureTime double
   end
   methods
      function obj = Car(capacity, charge, arrival_time)
         obj.Capacity = capacity;
         obj.Charge= charge;
         obj.ArrivalTime = arrival_time;
         obj.Cost = 0;
         obj.AssignedTime = -1;
         obj.DepartureTime = -1;
      end
      function [obj, power_added] = addCharge(obj, power)
           % Adds charge to this car, while checking for maximum capacity
          charge_missing = obj.Capacity - obj.Charge;
          power_added = min(charge_missing, power);
          obj.Charge = obj.Charge + power_added;
      end 
      
      function percentage = getPercentage(obj)
          % Returns the charge percentage of the car
          percentage = obj.Charge/obj.Capacity;
      end
      
      function full = isFull(obj)
          % Returns if the car is fully charged
          full = obj.Charge >= obj.Capacity;
      end 
   end
   methods(Static)
      function cars = arriveCars(t, average, capacity)
        % Returns a list of new arriving cars
        cars = [];
        % Use exponential distribution for arriving cars
        % TODO: Do this based on the time (t)
        for car=1:round(exprnd(average, 1, 1))
            % Calculate a random charge for the car
            car_charge = min(exprnd(0.2)*capacity, capacity);
            cars = [cars, Car(capacity, car_charge, t)];
        end
      end
   end
end


