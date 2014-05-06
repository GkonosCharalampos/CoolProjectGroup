function [nodes1,sources1,sinks1,paths1,delay1] = ... 
    advance_simulation(nodes,sources,sinks,paths,delay)
    
    paths = paths(2:end,:);
    sources = paths(1,:)';
        
    nodes1 = nodes;
    sources1 = sources;
    sinks1 = sinks;
    paths1 = paths; 
    delay1 = delay;
end

