function cars = arrive_cars(t, average, capacity)
    % Returns a list of new arriving cars
    % Results are based on time of day and average provided
    cars = [];

    % Calculate the fraction of the day represented by the input time
    fractionOfDay = t / 1440;  % 1440 minutes in a day
    
    % Map the fraction to the desired range (0 to 1)
    time_scaler = 1.5 - abs(fractionOfDay - 0.5) * 2;
    
    % Use exponential distribution for arriving cars
    for car=1:round(time_scaler*exprnd(average, 1, 1))
        % Calculate a random charge for the car
        car_charge = min(exprnd(0.2)*capacity, capacity);
        cars = [cars, Car(capacity, car_charge, t)];
    end
end