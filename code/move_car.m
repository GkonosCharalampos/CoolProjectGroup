function move_car(i)
    % the meaning of these variables is explained in initialize simulation
    global graph cars nodes paths millis tottime;

    % car i is currently on edge (u,v)
    u = paths(cars(i,3),i);
    v = paths(cars(i,3)+1,i);
    
    % we remove the car from the edge
    t = graph{u};
    t(v).remove(i);

    % we increase the index of the car position along its route
    cars(i,3) = cars(i,3) + 1;

    % if the path has ended we return
    if cars(i,3) + 1 > size(paths,1) || paths(cars(i,3)+1,i) == 0
        return;
    end

    % we move car i to the next edge, which will now be (u,v)
    u = paths(cars(i,3),i);
    v = paths(cars(i,3)+1,i);
    
    % we add the car to the edge
    t = graph{u};
    t = t(v);
    t(i) = 1;
    
    % cars(i,1:2) = nodes(:,paths(cars(i,3),i));
end
