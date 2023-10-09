classdef ChargeStation
    properties
        Chargers = Charger.empty(); % List of chargers
        CarQueue = Car.empty(); % List of waiting cars
    end
    
    methods
        function obj = ChargeStation(number_of_ports, power_rating)
            obj.CarQueue = Car.empty();
            obj.Chargers = Charger.empty(number_of_ports,0);
            for i=1:number_of_ports
                obj.Chargers(i) = Charger(power_rating);
            end
        end

        function total_power = getTotalPower(obj)
            total_power = sum([obj.Chargers.TotalPowerCharged]);
        end
        
        function total_cars = getCompletedCars(obj)
            total_cars = 0;
            for charger_num=1:numel(obj.Chargers)
                total_cars = total_cars + numel(obj.Chargers(charger_num).CompletedCars);
            end
        end

        function total_wait = getWaitingTime(obj)
            total_wait = 0;
            for charger_num=1:numel(obj.Chargers)
                total_wait = total_wait + obj.Chargers(charger_num).getWaitingTime();
            end
        end

        function total_cost = getCost(obj)
            total_cost = sum([obj.Chargers.TotalCost]);
        end

        function obj = addCars(obj, cars)
            % Add cars to the queue that arrive at the charge station
            obj.CarQueue = [obj.CarQueue, cars];
        end
        
        function obj = update(obj, time)
            % Increase the time at the charge station by 1 minute
            % Assign cars to empty chargers
            for charger_num=1:numel(obj.Chargers)
                if not(isempty(obj.CarQueue))
                    if obj.Chargers(charger_num).isFree()
                        % Remove the first car from the queue and assign it to
                        % the free charger
                        selected_car = obj.CarQueue(1);
                        obj.CarQueue = obj.CarQueue(2:end);
                        selected_car.AssignedTime = time;
                        obj.Chargers(charger_num) = obj.Chargers(charger_num).assignCar(selected_car);
                    end
                end
            end

            % Increase the charge on the cars at the chargers
            for charger_num=1:numel(obj.Chargers)
                obj.Chargers(charger_num) = obj.Chargers(charger_num).increaseCharge(time);
            end
        end
    end
end

