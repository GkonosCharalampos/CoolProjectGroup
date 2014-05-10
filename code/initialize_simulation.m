function initialize_simulation()
    global graph cars nodes paths millis tottime safetydist defaultspeed;

    tottime = 0;
    defaultspeed = 100;
    millis = 2000;
    safetydist = 0.04;

    numcars = 100;

    [nodes,edges] = read_graph(...
        '../data/Zurich_Residential_Roads+_Simplified_Ways_Single_Component_Graph.txt');

    numnodes = size(nodes,2);

    sources = floor(rand(numcars,1)*numnodes + 1);
    sinks = floor(rand(numcars,1)*numnodes + 1);

    paths = dijkstra_mx(nodes,edges,sources',sinks');

    graph = cell(numnodes,1);

    for i = 1:numnodes
        graph{i} = containers.Map('KeyType','double','ValueType','any');
    end

    numedges = size(edges,2);
    for i = 1:numedges
        v = graph{edges(1,i)};
        v(edges(2,i)) = containers.Map('KeyType','double','ValueType','any');
        v = graph{edges(2,i)};
        v(edges(1,i)) = containers.Map('KeyType','double','ValueType','any');
    end

    nodes = nodes(2:3,:);

    cars = zeros(numcars,3);
    for i = 1:numcars
        cars(i,1:2) = nodes(:,int32(sources(i,:)));
        cars(i,3) = 1;
        t = graph{paths(1,i)};
        t = t(paths(2,i));
        t(i) = 1;
    end
end
