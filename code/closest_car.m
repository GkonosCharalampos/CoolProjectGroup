function [mindist] = closest_car(i,car,u,v)    

    global graph cars nodes paths millis tottime;
    
    t = graph{u};    
    t = t(v);

    keyset = t.keys();
    
    mindist = inf;
    
    dista = distance(nodes(:,u),car);
    for h = 1:size(keyset,2)
        distb = distance(nodes(:,u),cars(keyset{h},1:2));         
        if keyset{h} ~= i && distb > dista            
            mindist = min(mindist,distb-dista);
        end
    end                    
end