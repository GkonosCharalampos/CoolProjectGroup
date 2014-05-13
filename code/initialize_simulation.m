% we initialize all the data structures needed for the simulation and we
% generate the routes for every car
function initialize_simulation(numcars)
    % graph: this variable is a cell array containing a map for every 
    % vertex u in the graph; every map contains an entry for every adjacent 
    % v of u, and each of this maps contains the indices of the cars 
    % currently on (u,v)
    % cars: it is an array of triples where cars(i,:) is (x,y,i) where 
    % (x,y) are the current coordinates of the car, and i means that the
    % car is at i-th position of its path (so it will always start at 1)
    % nodes: for every i, nodes(:,i) are the coordinates of node i
    % paths: for every car i, paths(:,i) is the sequence of nodes the car
    % will follow
    % millis: this is the length of a time step
    % travel_times: in the end this will contain the total time a car has
    % travelled
    % safetydist: the safety distance in kilometers a car needs to keep
    % from the following one
    % max_speeds: this is a cell array of maps and max_speeds{u}(v) is just
    % the maximum speed allowed on edge (u,v).
    global graph cars nodes paths millis travel_times safetydist max_speeds;
    
    millis = 2000;
    safetydist = 0.04;
    
    travel_times = zeros(numcars, 1);

    % we extract the graph from a textual representation of it
    [nodes,edges] = read_graph(...
        '../data/Graph.txt');

    numnodes = size(nodes,2);

    % we generate the starting and ending position of a journey for every car
    [sources,sinks] = generate_routes(numcars);

    % we compute the shortest path between the two endpoints for every
    % journey
    paths = a_star(nodes,edges,sources',sinks');

    graph = cell(numnodes,1);
    max_speeds = cell(numnodes, 1);

    % we build graph and max_speeds
    for i = 1:numnodes
        graph{i} = containers.Map('KeyType','double','ValueType','any');
        max_speeds{i} = containers.Map('KeyType','double','ValueType','double');
    end

    numedges = size(edges,2);
    for i = 1:numedges
    	u = edges(1, i);
    	v = edges(2, i);
    	spd = edges(3, i);

        u_graph = graph{u};
        u_graph(v) = containers.Map('KeyType','double','ValueType','logical');
        v_graph = graph{v};
        v_graph(u) = containers.Map('KeyType','double','ValueType','logical');

        u_speed = max_speeds{u};
        v_speed = max_speeds{v};

        u_speed(v) = spd;
        v_speed(u) = spd;
    end

    nodes = nodes(2:3,:);

    cars = zeros(numcars,3);
    cars = [nodes(:,int32(sources(:,:)))', ones(numcars, 1)];    
    
    % we insert every car i in the edge it start from, that is
    % (paths(1,i),paths(2,i))
    for i = 1:numcars
        t = graph{paths(1,i)};
        
        if paths(2,i) == 0
            continue
        end

        t = t(paths(2,i));
        t(i) = 1;
    end
end
