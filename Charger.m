classdef Charger
   % A charger adds charge to its assigned car for each timestamp
   properties
      PowerRating {mustBeNumeric} % [kW] Power rating of charger
      ChargingCar Car % Car that is currently charging at this charger, empty if no car is charging
      TotalPowerCharged % [kWh] Total amount of power charged
      TotalCost % [Euro] Total cost charged
      CompletedCars % List of cars that have completed charging at this charger
   end

   properties (Constant)
       p_el1 = importdata("electricity_price.mat"); %electricity price over the day
       price_per_minute = table2array(Charger.p_el1(:,2))/60;
   end

   methods
       function obj = Charger(power_rating)
         obj.PowerRating = power_rating;
         obj.ChargingCar = Car.empty;
         obj.TotalPowerCharged = 0;
         obj.TotalCost = 0;
       end
       
       function obj = assignCar(obj, car)
          % Assign a car to charge at this charging station
          if obj.isFree()
              obj.ChargingCar = car;
          else
              disp("This charger is already occupied!")
          end
       end

       function total_wait = getWaitingTime(obj)
          total_wait = 0;
          for car_num=1:numel(obj.CompletedCars)
              car_wait = obj.CompletedCars(car_num).DepartureTime - obj.CompletedCars(car_num).ArrivalTime;
              total_wait = total_wait + car_wait;
          end
       end
       
       function obj = increaseCharge(obj, time)
          % Increase the charge of the car that is currently charging at
          % this charger
          if not(obj.isFree())
              charging_power = obj.PowerRating*(1/60);
              [obj.ChargingCar, power_added] = obj.ChargingCar.addCharge(charging_power);
              obj.TotalPowerCharged = obj.TotalPowerCharged + power_added;

              power_cost = Charger.getPowerPrice(power_added, time);

              obj.TotalCost = obj.TotalCost + power_cost;
              obj.ChargingCar.Cost = obj.ChargingCar.Cost + power_cost;

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
   methods(Static)
       function price = getPowerPrice(power_amount, time)
           time_hour = min(floor(time/60), 23);
           price = Charger.price_per_minute(time_hour + 1)*power_amount;
           % disp(power_amount + " kWh of power at " +time_hour+" hour costs " + price + " euro")
       end
   end
end

