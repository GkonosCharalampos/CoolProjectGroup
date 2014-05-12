function advance_simulation()
    global graph cars nodes paths millis tottime safetydist defaultspeed over max_speeds;


    num_cars = size(paths, 2);

    perm = randperm(num_cars);

    over = 1;

    for h = 1:num_cars
        i = perm(h);

        path_idx = cars(i,3);
        curr_coords = cars(i,1:2);

        if path_idx == 0
            cars(i,:) = [0 0 0];
            continue;
        end
        over = 0;

        % convert time to hours
        time = millis / 3600000;

        dist = 0;

        flag = 1;


        while flag && path_idx + 1 <= size(paths, 1) && paths(path_idx + 1, i) ~= 0

            u = paths(path_idx, i);
            v = paths(path_idx + 1, i);

            u_speeds = max_speeds{u};
            max_speed = u_speeds(v);
            % max_speed = 100;

            edge_len = distance(curr_coords, nodes(:, v));

            dist = dist + min(time * max_speed, edge_len);

            time = time - edge_len / max_speed;

            closestcar = closest_car(i,curr_coords,u, v);
            curr_coords = nodes(:,v);
            path_idx = path_idx+1;

            if time <= 0 || closestcar < inf
                flag = 0;
            end
        end

        dist = max(0, min(dist, closestcar-safetydist));

        path_idx = cars(i,3);
        while path_idx+1 <= size(paths,1) && paths(path_idx+1,i) ~= 0 && ...
                distance(cars(i,1:2),nodes(:,paths(path_idx+1,i))) <= dist
            dist = dist - distance(cars(i,1:2),nodes(:,paths(path_idx+1,i)));
            move_car(i);
            path_idx = cars(i,3);
        end

        if path_idx >= size(paths,1) || paths(path_idx+1,i) == 0
            cars(i,:) = [0 0 0];
            continue;
        end

        tottime = tottime + millis;

        curr_coords = cars(i,1:2);
        next = nodes(:,paths(path_idx+1,i));

        off = dist/distance(curr_coords,next);

        cars(i,1) = cars(i,1) + off * (next(1)-curr_coords(1));
        cars(i,2) = cars(i,2) + off * (next(2)-curr_coords(2));
    end

    if over

    end
end
