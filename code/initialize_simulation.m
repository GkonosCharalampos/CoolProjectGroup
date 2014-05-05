function [nodes,sources,sinks,paths,delay] = initialize_simulation()

    numcars = 1000;
    delay = 1000;

    [nodes, edges] = read_graph('../data/Zurich_Residential_Roads+_Simplified_Ways_Single_Component_Graph.txt');

    numnodes = size(nodes,2);

    sources = floor(rand(numcars,1)*numnodes + 1);
    sinks = floor(rand(numcars,1)*numnodes + 1);    
    paths = dijkstra_mx(nodes,edges,sources',sinks');  
end

