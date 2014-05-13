function advance_simulation()
    % the meaning of this variables is explained in initialize simulation
    global graph cars nodes paths millis travel_times safetydist over max_speeds;

    num_cars = size(paths, 2);

    % we will use perm to iterate on the cars in a random order
    perm = randperm(num_cars);

    % this will stay set to 1 if every car has reached its final
    % destination
    over = 1;

    % for every car we update its position
    for h = 1:num_cars
        i = perm(h);

        % the position of the car on its path
        path_idx = cars(i,3);
        % the current coordinates of the car
        curr_coords = cars(i,1:2);

        % if path_idx has been set to 0 then the car has reached its final
        % destination and we don't consider it anymore
        if path_idx == 0
            cars(i,:) = [0 0 0];
            continue;
        end
        over = 0;

        % convert millis to hours
        time = millis / 3600000;
        
        dist = 0;
        flag = 1;

        % we find the maximum distance a car can travel in the allotted
        % time, depending on the speeds of the roads and on the next
        % closest car on the same edges
        while flag && path_idx + 1 <= size(paths, 1) && paths(path_idx + 1, i) ~= 0

            % car i is on edge (u,v)
            u = paths(path_idx, i);
            v = paths(path_idx + 1, i);
            
            % max speed on edge (u,v)
            u_speeds = max_speeds{u};
            max_speed = u_speeds(v);            

            % length of edge (u,v)
            edge_len = distance(curr_coords, nodes(:, v));

            % this is the max distance car i can travel on edge (u,v) 
            % in <time> milliseconds
            dist = dist + min(time * max_speed, edge_len);
            % we update the remaining time for this car            
            time = time - edge_len / max_speed;

            % we find the distance to the next closest car on the edge
            closestcar = closest_car(i,curr_coords,u,v);
                       
            % if time elapsed or there is another car on the edge we stop
            if time <= 0 || closestcar < inf
                flag = 0;
            end
            
            % we go to the next edge on the path
            curr_coords = nodes(:,v);
            path_idx = path_idx + 1;
        end
    
        % we compute the actual maximum distance the car can travel, taking
        % into account the next closest car and the safety distance
        dist = max(0, min(dist, closestcar-safetydist));

        % We now actually move the car along the path at most by the
        % distance dist we just computed
        path_idx = cars(i,3);
        while path_idx+1 <= size(paths,1) && paths(path_idx+1,i) ~= 0 && ...
                distance(cars(i,1:2),nodes(:,paths(path_idx+1,i))) <= dist
            dist = dist - distance(cars(i,1:2),nodes(:,paths(path_idx+1,i)));
            % we move the car edge by edge
            move_car(i);
            path_idx = cars(i,3);
        end

        % if the path has ended we go to the next car
        if path_idx >= size(paths,1) || paths(path_idx+1,i) == 0
            cars(i,:) = [0 0 0];
            continue;
        end

        % we update the travel times for every car
        travel_times(h) = travel_times(h) + millis;

        % we compute the new coordinates of the car on the edge the car has
        % finaly landed on
        curr_coords = cars(i,1:2);
        next = nodes(:,paths(path_idx+1,i));

        off = dist/distance(curr_coords,next);

        cars(i,1) = cars(i,1) + off * (next(1)-curr_coords(1));
        cars(i,2) = cars(i,2) + off * (next(2)-curr_coords(2));
    end    
end
