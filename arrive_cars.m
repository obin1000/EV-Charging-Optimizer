function cars = arrive_cars(t, average, capacity)
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