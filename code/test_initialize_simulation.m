function test_initialize_simulation()       
    global graph cars nodes paths millis tottime safetydist defaultspeed;
    
    defaultspeed = 30000;
    tottime = 0;
    safetydist = 5;    
    millis = 1000;
    
    numcars = 2;       
    numnodes = 4;
    numedges = 3;
    
    nodes = [
        [0;0]... % 1
        [0;1]... % 2
        [0;2]... % 3
        [1;1]... % 4
    ];    

    edges = [
        [1;2]...
        [2;3]...
        [2;4]...
    ];

    paths = [
        [1;2;3]...
        [4;2;3]...                
    ];    
        
    graph = cell(numnodes,1);
    
    for i = 1:numnodes
        graph{i} = containers.Map('KeyType','double','ValueType','any');
    end    
        
    for i = 1:numedges
        v = graph{edges(1,i)};
        v(edges(2,i)) = containers.Map('KeyType','double','ValueType','any');
        v = graph{edges(2,i)};
        v(edges(1,i)) = containers.Map('KeyType','double','ValueType','any');
    end            
    
    cars = zeros(numcars,3);
    for i = 1:numcars
        cars(i,1:2) = nodes(:,paths(1,i));
        cars(i,3) = 1;                
        t = graph{paths(1,i)};        
        t = t(paths(2,i));
        t(i) = 1;
    end                      
end