% We generates the ending and starting point for the journey of every car
% according to a probability distribution depending on population data and
% on companies distribution
function [sources,sinks] = generate_routes(numcars)
    global nodes;

    % we read the csv files with the data in percentages
    pop = csvread('../data/Population/population.csv');
    com = csvread('../data/Companies/companies.csv');

    % we generate a number between in [0,100] for the sources; this will be
    % needed to generate randomly according to the percentages in pop and com
    sources_i = rand(numcars,1)*100;
    sinks_i = rand(numcars,1)*100;

    sources_c = zeros(numcars,2);
    sinks_c = zeros(numcars,2);

    sources = zeros(numcars,1);
    sinks = zeros(numcars,1);

    % for every car we generate the ending points of the journey
    for i = 1:numcars
        % we generate a random coordinate for the source; we first pick
        % the area center and then we add a random shift        
        for j = 1:size(pop,1)
            if sources_i(i) <= pop(j,3)
                sources_c(i,:) = pop(j,1:2) + (rand(1,2)*0.01);
                break;
            end
            sources_i(i) = sources_i(i) - pop(j,3);
        end
        % we generate a random coordinate for the sink
        for j = 1:size(com,1)
            if sinks_i(i) <= com(j,3)
                sinks_c(i,:) = com(j,1:2) + (rand(1,2)*0.01);
                break;
            end
            sinks_i(i) = sinks_i(i) - com(j,3);
        end
    
        % for source and sink we find the nearest node to the coordinates
        % we generated and we set them as the start for the journey.
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

