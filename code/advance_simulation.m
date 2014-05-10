function advance_simulation()
    global graph cars nodes paths millis tottime safetydist defaultspeed over;

    speed = defaultspeed;

    numcars = size(paths,2);

    perm = randperm(numcars);

    over = 1;

    for h = 1:numcars
        i = perm(h);

        j = cars(i,3);
        curr = cars(i,1:2);

        if j == 0
            cars(i,:) = [0 0 0];
            continue;
        end
        over = 0;

        dist = speed*millis/3600000;
        dist2 = 0;

        flag = 1;
        while flag && j+1 <= size(paths,1) && paths(j+1,i) ~= 0

            dist2 = dist2 + distance(curr,nodes(:,paths(j+1,i)));
            closestcar = closest_car(i,curr,paths(j,i),paths(j+1,i));
            curr = nodes(:,paths(j+1,i));
            j = j+1;

            if dist2 > dist || closestcar < inf
                flag = 0;
            end
        end

        dist = max(0,min(dist,closestcar-safetydist));

        j = cars(i,3);
        while j+1 <= size(paths,1) && paths(j+1,i) ~= 0 && ...
                distance(cars(i,1:2),nodes(:,paths(j+1,i))) <= dist
            dist = dist - distance(cars(i,1:2),nodes(:,paths(j+1,i)));
            move_car(i);
            j = cars(i,3);
        end

        if j >= size(paths,1) || paths(j+1,i) == 0
            cars(i,:) = [0 0 0];
            continue;
        end

        tottime = tottime + millis;

        curr = cars(i,1:2);
        next = nodes(:,paths(j+1,i));

        off = dist/distance(curr,next);

        cars(i,1) = cars(i,1) + off * (next(1)-curr(1));
        cars(i,2) = cars(i,2) + off * (next(2)-curr(2));
    end

    if over

    end
end
