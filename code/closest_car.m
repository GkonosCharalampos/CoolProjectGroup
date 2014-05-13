% For car i having current position curr_car_pos and located at edge u,v
% we find the distance to the closest next car on edge (u,v)
function [min_dist] = closest_car(i, curr_car_pos, u, v)

    global graph cars nodes;

    edge = graph{u}(v);
    
    min_dist = inf;
    
    % if the car is the only one on the edge then return
    if size(edge) <= 1
        return
    end

    dista = distance(nodes(:,u), curr_car_pos);
    % find the closest next car on edge (u,v)
    for car_id = edge.keys()
        if car_id{1} == i
            continue
        end

        distb = distance(nodes(:,u), cars(car_id{1}, 1:2));

        if distb > dista
            min_dist = min(min_dist, distb - dista);
        end
    end
end