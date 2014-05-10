function move_car(i)    
    global graph cars nodes paths millis tottime;
    
    u = paths(cars(i,3),i);
    v = paths(cars(i,3)+1,i);
    
    t = graph{u};    
    t(v).remove(i);
    
    cars(i,3) = cars(i,3) + 1;
    
    if cars(i,3) + 1 > size(paths,1) || paths(cars(i,3)+1,i) == 0
        return;
    end
    
    u = paths(cars(i,3),i);
    v = paths(cars(i,3)+1,i);
    
    t = graph{u};
    t = t(v);
    t(i) = 1;
    
    cars(i,1:2) = nodes(:,paths(cars(i,3),i));
end

