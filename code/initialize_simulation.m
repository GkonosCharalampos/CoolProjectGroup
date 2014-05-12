function initialize_simulation(numcars)
    global graph cars nodes paths millis travel_times safetydist defaultspeed max_speeds;

    % numcars = 1000;
    defaultspeed = 100;
    millis = 2000;
    safetydist = 0.04;

    travel_times = zeros(numcars, 1);


    [nodes,edges] = read_graph(...
        '../data/Zurich_Residential_Roads+_Simplified_Ways_Single_Component_Graph_Speeds.txt');

    numnodes = size(nodes,2);

    % [sources,sinks] = generate_routes(numcars);

    % sources = floor(rand(numcars,1)*numnodes + 1);
    % sinks = floor(rand(numcars,1)*numnodes + 1);

    % sources = repmat(floor(rand()*numnodes + 1), numcars, 1);
    % sinks = repmat(floor(rand()*numnodes + 1), numcars, 1);

    paths = a_star(nodes,edges,sources',sinks');

    graph = cell(numnodes,1);
    max_speeds = cell(numnodes, 1);

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
    % cars(i,3) = 1;

    for i = 1:numcars
        t = graph{paths(1,i)};
        % paths(2,i);
        if paths(2,i) == 0
            continue
        end

        t = t(paths(2,i));
        t(i) = 1;
    end
end
