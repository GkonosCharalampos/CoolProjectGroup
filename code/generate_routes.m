function [sources,sinks] = generate_routes(numcars)    
    global nodes;

    pop = csvread('../data/Population/population.csv');
    com = csvread('../data/Companies/companies.csv');    
    
    sources_i = rand(numcars,1)*100;
    sinks_i = rand(numcars,1)*100;        
    
    sources_c = zeros(numcars,2);
    sinks_c = zeros(numcars,2);    
    
    sources = zeros(numcars,1);
    sinks = zeros(numcars,1);
    
    for i = 1:numcars
        for j = 1:size(pop,1)            
            if sources_i(i) <= pop(j,3)
                sources_c(i,:) = pop(j,1:2) + (rand(1,2)*0.01);
                break;
            end
            sources_i(i) = sources_i(i) - pop(j,3);
        end
        for j = 1:size(com,1)            
            if sinks_i(i) <= com(j,3)
                sinks_c(i,:) = com(j,1:2) + (rand(1,2)*0.01);
                break;
            end
            sinks_i(i) = sinks_i(i) - com(j,3);
        end        
        
        sources_mind = inf;
        sinks_mind = inf;
        for j = 1:size(nodes,2)
            a = nodes(2:3,j); b = sources_c(i,:);
            dist = ((a(1)-b(1))^2)+((a(2)-b(2))^2);
            if dist < sources_mind
                sources_mind = dist;
                sources(i) = j;
            end
            a = nodes(2:3,j); b = sinks_c(i,:);
            dist = ((a(1)-b(1))^2)+((a(2)-b(2))^2);
            if dist < sinks_mind
                sinks_mind = dist;
                sinks(i) = j;
            end            
        end            
    end                   
end

