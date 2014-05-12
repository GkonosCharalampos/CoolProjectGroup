function [min_dist] = closest_car(i, curr_car_pos, u, v)

    global graph cars nodes paths;

    edge = graph{u}(v);
    % edge = edge(v);

    % keyset = edge.keys();

    min_dist = inf;

    % size(keyset)

    if size(edge) < 2
        return
    end

    dista = distance(nodes(:,u), curr_car_pos);

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


function dist = euclid_squared(u, v)
    dist = sum((u - v) .^ 2);
end
