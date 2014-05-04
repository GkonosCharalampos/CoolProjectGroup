function [nodes,sources,sinks,paths,delay] = initialize_simulation()

    numcars = 1000;
    delay = 1000;

    [nodes,edges] = read_graph('/Users/simone/Desktop/primary_roads.txt');
    
    numnodes = size(nodes,2);
    
    sources = rand(numcars,1)*numnodes + 1;
    sinks = rand(numcars,1)*numnodes + 1;
    
    paths = dijkstra_mx(nodes,edges,sources',sinks');
end

